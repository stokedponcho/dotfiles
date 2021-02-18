" https://github.com/lambdalisue/fern.vim/wiki
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'

let g:fern#drawer_width=30
let g:fern#default_hidden = 1

noremap <silent> <C-n> :Fern . -drawer -toggle -reveal=% <CR>

function! s:init_fern() abort
  nmap <buffer> H <Plug>(fern-action-open:split)
  nmap <buffer> V <Plug>(fern-action-open:vsplit)
  nmap <buffer> R <Plug>(fern-action-rename)
  nmap <buffer> M <Plug>(fern-action-move)
  nmap <buffer> C <Plug>(fern-action-copy)
  nmap <buffer> N <Plug>(fern-action-new-path)
  nmap <buffer> T <Plug>(fern-action-new-file)
  nmap <buffer> D <Plug>(fern-action-new-dir)
  nmap <buffer> S <Plug>(fern-action-hidden-toggle)
  nmap <buffer> dd <Plug>(fern-action-trash)
  nmap <buffer> <leader> <Plug>(fern-action-mark)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

let g:fern#renderer = "nerdfont"

" https://github.com/lambdalisue/fern-hijack.vim
" A plugin for fern.vim to make the fern.vim as a default file explorer instead of Netrw.
"
if exists('g:loaded_fern_hijack') || ( !has('nvim') && v:version < 801 )
  finish
endif
let g:loaded_fern_hijack = 1

function! s:hijack_directory() abort
  let path = s:expand('%:p')
  if !isdirectory(path)
    return
  endif
  keepjumps keepalt bwipeout %
  execute printf('keepjumps keepalt Fern %s', fnameescape(path))
endfunction

function! s:suppress_netrw() abort
  if exists('#FileExplorer')
    autocmd! FileExplorer *
  endif
endfunction

function! s:expand(expr) abort
  try
    return fern#util#expand(a:expr)
  catch /^Vim\%((\a\+)\)\=:E117:/
    return expand(a:expr)
  endtry
endfunction

augroup fern-hijack
  autocmd!
  autocmd VimEnter * call s:suppress_netrw()
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END
