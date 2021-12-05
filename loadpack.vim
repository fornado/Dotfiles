" plugin lists to load
" ctrlp.vim
packadd ctrlp

set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

packadd neo_basic

packadd nerdtree

packadd vim-lsp
packadd vim-lsp-settings

augroup filetype
    au! BufRead,BufNewFile *.swift set ft=swift
augroup END

packadd asyncomplete
packadd asyncomplete-lsp
