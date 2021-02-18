" https://github.com/lotabout/skim.vim
Plug 'lotabout/skim.vim'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

nnoremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-f> :Rg<CR>

command! -bang ConfigFiles call fzf#vim#files('~/.config', <bang>0)
command! -bang ScriptFiles call fzf#vim#files('~/.local/scripts', <bang>0)
