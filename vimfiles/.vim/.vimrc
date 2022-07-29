
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

let mapleader = ","

"inoremap jk <esc>
nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>

nnoremap <silent> <F2> :vs $MYVIMRC<cr>
nnoremap <silent> <F3> :vs ~/Documents/repo/Dotfiles/vimfiles/.vim/.vimrc<cr>
nnoremap <silent> <F4> :!cp ~/Documents/repo/Dotfiles/vimfiles/.vim/.vimrc ~/.vim/vimrc<cr>  
nnoremap <silent> <F6> :source $MYVIMRC<cr>

nnoremap <silent> [b :bprevious<cr>
nnoremap <silent> ]b :bnext<cr>

nnoremap <silent> [t :tabprevious<cr>
nnoremap <silent> ]t :tabnext<cr>


set fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936,utf-16,big5,euc-jp,latin1

set smartindent
set autoindent

set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

set number
set helplang=cn
set cmdheight=2
set hidden
set nobackup
set cursorline
set autoread
set splitbelow
set splitright

set hlsearch
set incsearch
"set runtimepath+=~/.vim_runtime

"source ~/.vim_runtime/vimrcs/basic.vim
"source ~/.vim_runtime/vimrcs/filetypes.vim
"source ~/.vim_runtime/vimrcs/plugins_config.vim
"source ~/.vim_runtime/vimrcs/extended.vim

"try
"source ~/.vim_runtime/my_configs.vim
"catch
"endtry
"
"nnoremap <F5> :update<CR>:source %<CR>

