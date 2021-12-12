" plugin lists to load

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => neo_basic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
packadd neo_basic


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDtree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
packadd nerdtree

" open or hide file nav
nnoremap <leader>ne :NERDTreeToggle<CR>

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
"autocmd VimEnter * NERDTree | if argc() > 0 || exists('s:std_in') | wincmd p | endif

" Start NERDTree when Vim starts with a directory argument.
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Exit Vim if NERDTree is the only window ramaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" If another buffer tries to replace  NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-lsp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
packadd vim-lsp
packadd vim-lsp-settings

packadd asyncomplete
packadd asyncomplete-lsp


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-tope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
packadd vim-fugitive
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gl :Git log<CR>
nnoremap <leader>gd :Gvdiffsplit<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gr :Gread<CR>
"nnoremap <leader>gm :Gmove
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P

packadd vim-commentary
packadd vim-unimpaired
packadd vim-surround
packadd vim-repeat


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-fzf
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
packadd fzf
packadd vim-fzf

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fag :Ag<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fbl :BLines<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
packadd vim-airline
packadd vim-airline-themes
