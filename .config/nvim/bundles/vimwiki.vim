" https://github.com/vimwiki/vimwiki
Plug 'vimwiki/vimwiki'

let g:vimwiki_global_ext = 0
let g:vimwiki_hl_headers = 1
let g:vimwiki_root = "~/Documents/Knowledge/Wiki"
let g:vimwiki_list = [
      \{ 'path': '~/Documents/Knowledge/Wiki/', 'syntax': 'markdown', 'ext': '.md' },
      \{ 'path': '~/Documents/Knowledge/Wiki/Computers', 'syntax': 'markdown', 'ext': '.md' },
      \{ 'auto_diary_index': 1 }
      \]
