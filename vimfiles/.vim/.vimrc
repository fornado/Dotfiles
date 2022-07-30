
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

let mapleader = ","

inoremap jk <esc>
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

nnoremap <c-l> :<c-u>nohls<cr>

set fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936,utf-16,big5,euc-jp,latin1

set smartindent
set autoindent

set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

set number
set helplang=cn
set cmdheight=1
set hidden

set nobackup
set noswapfile
set nowritebackup
set noundofile
set novisualbell

set cursorline
set autoread
set splitbelow
set splitright

set hlsearch
set incsearch

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'yianwillis/vimcdoc'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do':'./install --all' }
"Plug 'junegunn/fzf'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'

Plug 'sheerun/vim-polyglot'

call plug#end()

" vim-airline
let g:airline#extensions#tabline#enabled = 1

" vim-airline-themes
let g:airline_theme='onedark'

" Nerdtree
nnoremap <leader>ne :<c-u>NERDTreeToggle<cr>

" onedark.vim
if (empty($TMUX))
	if (has("nvim"))
		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	endif
	if (has("termguicolors"))
		set termguicolors
	endif
endif

" fzf.vim
nnoremap <leader>ff :<c-u>Files<cr>
nnoremap <leader>fb :<c-u>Buffers<cr>
nnoremap <leader>fl :<c-u>Lines<cr>
