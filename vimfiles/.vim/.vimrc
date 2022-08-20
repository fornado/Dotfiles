
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" Basic
let mapleader = ","

set number
set relativenumber
set helplang=cn
set cmdheight=1
set hidden
set fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936,utf-16,big5,euc-jp,latin1

set smartindent
set autoindent

set tabstop=4
set softtabstop=4
set shiftwidth=4

set noexpandtab
set nobackup
set noswapfile
set nowritebackup
set noundofile
set novisualbell
set nocursorline
set noerrorbells
set vb t_vb=

set autoread
set splitbelow
set splitright

set hlsearch
set incsearch
set ignorecase
set smartcase

set diffopt+=vertical


" system paste board
inoremap <c-v> <c-r>+
inoremap <c-l> <right>

inoremap jk <esc>
nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>

nnoremap <silent> <F2> :vs $MYVIMRC<cr>
nnoremap <silent> <F3> :vs ~/Documents/projects/Dotfiles/vimfiles/.vim/.vimrc<cr>
nnoremap <silent> <F4> :!cp ~/Documents/projects/Dotfiles/vimfiles/.vim/.vimrc ~/.vim/vimrc<cr>
nnoremap <silent> <F6> :source $MYVIMRC<cr>

nnoremap <c-l> :<c-u>nohls<cr><c-l>

nnoremap <leader>tn :<c-u>tabnew<cr>
nnoremap <leader>tc :<c-u>tabclose<cr>
nnoremap [t :<c-u>tabprevious<cr>
nnoremap ]t :<c-u>tabnext<cr>

nnoremap <leader>cc :<c-u>cclose<cr>

" tags
set tags=./.tags;,.tags

" " auto-pairs
" inoremap ' ''<esc>i
" inoremap " ""<esc>i

" inoremap ( ()<esc>i
" inoremap ) <c-r>=ClosePair(')')<cr>

" inoremap { {<cr>}<esc>O
" " inoremap { {}<esc>i
" " inoremap } <c-r>=ClosePair('}')<cr>

" inoremap [ []<esc>i
" inoremap ] <c-r>=ClosePair(']')<cr>

" inoremap < <><esc>i
" inoremap > <c-r>=ClosePair('>')<cr>

" function! ClosePair(char)
"   if getline('.')[col('.') - 1] == a:char
"     return "\<right>"
"   else
"     return a:char
"   endif
" endfunction

" function! SkipPair()
"   if getline('.')[col('.') - 1] == '<' || getline('.')[col('.') - 1] == ')' || getline('.')[col('.') - 1] == ']' || getline('.')[col('.') -1] == '"' || getline('.')[col('.') - 1] == "'" || getline('.')[col('.') - 1] == '}'
"     return "\<esc>la"
"   else
"     return "\t"
"   endif
" endfunction

" inoremap <tab> <c-r>=SkipPair()<cr>

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'yianwillis/vimcdoc'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-endwise'

Plug 'sheerun/vim-polyglot'
Plug 'dense-analysis/ale'

Plug 'posva/vim-vue'
Plug 'mattn/emmet-vim'
Plug 'jiangmiao/auto-pairs'

Plug 'ludovicchabant/vim-gutentags'

call plug#end()

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1

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

" ale.vim
" let g:ale_sign_column_always = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1
let g:ale_completion_enabled = 1

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 1

let g:ale_linter_aliases = {'vue': ['vue', 'javascript']}
let g:ale_linters = {
\ 'vue': ['eslint', 'vls'],
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'vue': ['prettier','remove_trailing_lines', 'trim_whitespace'],
\}

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

""" vue
au BufNewFile,BufRead *.html,*.js,*.vue set tabstop=2
au BufNewFile,BufRead *.html,*.js,*.vue set softtabstop=2
au BufNewFile,BufRead *.html,*.js,*.vue set shiftwidth=2
au BufNewFile,BufRead *.html,*.js,*.vue set expandtab
au BufNewFile,BufRead *.html,*.js,*.vue set autoindent
au BufNewFile,BufRead *.html,*.js,*.vue set fileformat=dos
au FileType vue syntax sync fromstart

" emmet-vim
" usage in html
" trigger: <c-y>,
" {element}.classname#id{trigger}
" {element}>{subelement}{content}*count
" {element}+{element}
"
" in css
" w300px+h300px+bgc{trigger}
" lw{trigger} for line-height

" gutentags
" 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
   endif

silent! helptags ALL
