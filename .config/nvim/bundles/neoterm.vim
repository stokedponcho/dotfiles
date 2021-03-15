" https://github.com/kassio/neoterm
" abstraction on top of neovim terminal
Plug 'kassio/neoterm'

" to avoid conflict with <leater>t, as leader is set to ','
"let g:neoterm_automap_keys = ""

" quickly toggle term
nnoremap <silent> <leader>t :botright Ttoggle<cr><C-w>ji
nnoremap <silent> <leader>vt :vertical Ttoggle<cr><C-w>li
" close terminal
tnoremap <silent> <leader>t <C-\><C-n>:Ttoggle<cr><C-w>l
