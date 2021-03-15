" General settings
set							encoding=UTF-8
set							title
scriptencoding	utf-16	" allow emojis in vimrc
filetype				plugin indent on

let $RTP=split(&runtimepath, ',')[0]
let $RC=$MYVIMRC

" Behavior Modification ----------------------  {{{

" Enable Elite mode, No ARRRROWWS!!!!
let g:elite_mode=1

set noexpandtab
set backspace=indent,eol,start      " Backspace deletes like most programs in insert mode
set ruler                           " show the cursor position all the time
set showcmd                         " display incomplete commands
set laststatus=2                    " Always display the status line
set autowrite                       " Automatically :write before running commands
set ignorecase                      " ignore case in searches
set smartcase                       " use case sensitive if capital letter present or \C
set showcmd                         " show any commands
set mouse=a                         " enable mouse (selection, resizing windows)
set iskeyword+=-                    " treat dash separated words as a word text object
set shiftwidth=2                    " Number of spaces to use for each step of (auto)indent.
set tabstop=2                       " Softtabs or die! use 2 spaces for tabs.
set softtabstop=4                   " number of spaces that a tab counts for
set autoindent                      " copy indent from current line when starting a new line
set smartindent                     " smarter than autoident
set shiftround                      " Round indent to multiple of 'shiftwidth'
set hidden                          " enable hidden unsaved buffers
set ttyfast                         " should make scrolling faster
set lazyredraw                      " should make scrolling faster
set visualbell                      " visual bell for errors
set number                          " line numbers
set foldmethod=manual               " set folds by syntax of current language
set diffopt+=vertical               " Always use vertical diffs
set noswapfile

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Display all matching files when we tab complete
set path+=**
set wildmenu

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

"  }}}

" Vim Script file settings ------------------------ {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

"  Key Mappings -------------------------------------------------- {{{

" set leader key
"let g:mapleader=","

nnoremap ; :

inoremap jj <Esc>
tnoremap jj <Esc>

" command typo mapping
cnoremap W w
cnoremap WQ wq
cnoremap Wq wq
cnoremap QA qa
cnoremap qA qa
cnoremap Q! q!
cnoremap Q q

if get(g:, 'elite_mode')
  nnoremap <Up>    :resize +2<CR>
  nnoremap <Down>  :resize -2<CR>
  nnoremap <Left>  :vertical resize +2<CR>
  nnoremap <Right> :vertical resize -2<CR>
endif

" Navigate neovim + neovim terminal emulator with alt+direction
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" easily escape terminal
tnoremap <Esc> <C-\><C-n>

" Tab/shift-tab to indent/outdent in visual mode.
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Copy to system clipboard
vnoremap <C-c> "+y

" --------------------- Key Mappings ---------------------------- }}}

"  Plugins -------------------------------------------------- {{{

"
" vim-plug installation
" save https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim as nvim/autoload/plug.vim
"
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(stdpath('data') . '/plugged')

let bundles_path = stdpath('config').'/bundles'
let bundles = split(globpath(bundles_path, '*.vim'), '\n')

for bundle in bundles
  if filereadable(expand(bundle))
    execute 'source' bundle
  endif
endfor

call plug#end()

" }}}

" UI Customisations -------------------------------- {{{

set background=dark
"set termguicolors
"colorscheme solarized
colorscheme wal

function! SwapTheme()
  colorscheme solarized
  set termguicolors
endfunction

command! -nargs=0 SwapTheme :call SwapTheme()

" }}}

" Misceallenous ------------------------------------ {{{

" Automatically deletes all trailing whitespace and newlines at end of file on save.
  autocmd BufWritePre * %s/\s\+$//e
  autocmd BufWritepre * %s/\n\+\%$//e

" }}}

"
" syntax highlighting - needs to be after plugins enabling language
" recognition if any (for example, elixir-lang/vim-elixir)
syntax	on
