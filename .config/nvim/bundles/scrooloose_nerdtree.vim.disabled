Plug 'scrooloose/nerdtree'

nmap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeShowHidden=1

" How can I open a NERDTree automatically when vim starts up?
autocmd vimenter

" NERDTreeHow can I open NERDTree automatically when vim starts up on opening a directory?
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

 "How can I close vim if the only window left open is a NERDTree?
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"How can I make sure vim does not open files and other buffers on NerdTree window?
let g:plug_window = 'noautocmd vertical topleft new'
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
