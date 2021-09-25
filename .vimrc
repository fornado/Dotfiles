" Author：@Huawei
" 首次使用，加载plug.vim
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

""""""""""""""""""
"Base
""""""""""
set nocompatible

let mapleader=","
syntax on
syntax enable

set number
set relativenumber
set showmode
set showcmd
set mouse=a
set encoding=utf8
set background=dark

filetype plugin indent on

""""""""""""""""""
"Indent
""""""""""

set autoindent
set tabstop=2
set expandtab
set softtabstop=4
set shiftwidth=4

""""""""""""""""""
"Appearence
""""""""""
"set number
"set relativenumber
set cursorline
set textwidth=80
set wrap
set linebreak
set wrapmargin=2
set scrolloff=5
set sidescrolloff=15
set laststatus=2
set ruler

""""""""""""""""""
"Search
""""""""""
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase

nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

""""""""""""""""""
"Edit
""""""""""
"set spell spelllang=en_us
"set undofile
"set backupdir=~/.vim/.backup//
"set directory=~/.vim/.swp//
"set undodir=~/.vim/.undo//

set autochdir
set history=1000

set wildmenu
set wildmode=longest:list,full

""""""""""""""""""
"Custom Map
""""""""""
nnoremap <leader>q :q<CR>
nnoremap <leader>e :vs $MYVIMRC<CR>
nnoremap <leader>m :source $MYVIMRC<CR>
nnoremap <silent> <leader>lf :lfirst<CR>

inoremap <C-f>  <ESC>2la
inoremap <C-b>  <ESC>i
inoremap jk <ESC>

""""""""""""""""""
"runtimepath
""""""""""
"set rtp+=~/.fzf
set rtp+=/usr/local/opt/fzf

""""""""""""""""""
"Plug.vim
""""""""""
call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-surround'
""" vim-surround, see :h surround
""" ds{target}
""" c{s|S}{target}{replacement}
""" y{s|S}{target}{wrapper} // add surround
""" ySS{wrapper}, line surround
""" in visual, S{wrapper}
""" surround-targets:
""" (, ), {, }, [, ], <, and > aliases b, B, r, and a.
""" other vim-objects

Plug 'tpope/vim-unimpaired'
""" see `:h unimpaired`
""" jump: [{a, A, b, B, l, L, <C-L>, q, Q, <C-Q>, t, T, <C-T>}
"""     Upcase one represent `first or last` node.
""" add space line: [<Space>, add [count] blank lines above or below the cursor;
""" exchange lines: {[|]}e, exchange the current line with [count] lines above it;
""" Pasting: >p or <p to paste after linewise, increasing or decreasing indent; >P or <P paste before linewise, increasing or decreasing indent;

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
" gc{motion}
" {Visual}gc
" gcgc or gcu, to Uncomment the current and adjacent commented lines.
" :[range]Commentary, Comment or uncomment [range] lines;

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-easymotion.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'vimwiki/vimwiki'
Plug 'itchyny/calendar.vim'
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mhinz/vim-startify'
Plug 'https://github.com/vim-scripts/fcitx.vim.git'
Plug 'liuchengxu/graphviz.vim'

Plug 'rust-lang/rust.vim'

Plug 'vim-syntastic/syntastic'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'landaire/deoplete-swift'
"Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'kristijanhusak/defx-icons'

call plug#end()

""""""""""""""""""
"fugitive.vim 
""""""""""
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

""""""""""""""""""
"rust.vim
""""""""""
nnoremap <leader>rb :Cargo build<CR>
nnoremap <leader>rc :Cargo check<CR>
nnoremap <leader>rr :Cargo run<CR>
nnoremap <leader>rf :RustFmt<CR>

let g:rustfmt_autosave=1

""""""""""""""""""
"nerdtree.vim
""""""""""
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"
nnoremap <leader>ne :NERDTreeToggle<CR>
"autocmd vimenter * NERDTree
"
" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

"call NERDTreeHighlightFile('swift', 'blue', 'none', '#3366FF', '#151515')

""""""""""""""""""
"nerdtree-git-plugin.vim
""""""""""
let g:NERDTreeGitStatusConcealBrackets = 0

""""""""""""""""""
"airline_theme.vim
""""""""""
"let g:airline_powerline_fonts = 1
"let g:airline_theme='solarized'
"let g:airline_solarized_bg='dark'
let g:airline_theme='angr'

""""""""""""""""""
"vim-devicons.vim
""""""""""
set guifont=Hack_Nerd_Font:h11

""""""""""""""""""
"easymotion.vim
""""""""""
"map <leader> <Plug>(easymotion-prefix)

"" <leader>f{char} to move to {char}
""map <leader>f <Plug>(easymotion-bd-f)
"nmap f <Plug>(easymotion-overwin-f)

"" s{char}{char} to move to {char}{char}
""nmap s <Plug>(easymotion-overwin-f2)
""nmap <leader>s <Plug>(easymotion-overwin-f2)
""nmap <leader>s <Plug>(easymotion-overwin-f2)
"nmap <leader>s <Plug>(easymotion-s)


"" Move to line
"map <leader>L <Plug>(easymotion-bd-jk)
""nmap L <Plug>(easymotion-overwin-line>

"" Move to word
"map <leader>w <Plug>(easymotion-bd-w)
""nmap <leader>w <Plug>(easymotion-overwin-w>
""
""nmap s <Plug>(easymotion-s2)
"nmap t <Plug>(easymotion-t2)
"omap t <Plug>(easymotion-bd-tl)

"map / <Plug>(easymotion-sn)
"omap / <Plug>(easymotion-tn)

""map n <Plug>(easymotion-next)
""map N <Plug>(easymotion-prev)

""map <leader>l <Plug>(easymotion-lineforward)
""map <leader>j <Plug>(easymotion-j)
""map <leader>k <Plug>(easymotion-k)
""map <leader>h <Plug>(easymotion-linebackward)
""let g:EasyMotion_startofline = 0
"let g:EasyMotion_user_upper = 1
"let g:EasyMotion_smartcase = 1
"let g:EasyMotion_use_smartsign_us = 1


"""""""""""""""""""
""incsearch.vim or incsearch-easymotion.vim
"""""""""""
"function! s:incsearch_config(...) abort
"  return incsearch#util#deepextend(deepcopy({
"  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
"  \   'keymap': {
"  \     "\<CR>": '<Over>(easymotion)'
"  \   },
"  \   'is_expr': 0
"  \ }), get(a:, 1, {}))
"endfunction

"function! s:config_easyfuzzymotion(...) abort
"  return extend(copy({
"  \   'converters': [incsearch#config#fuzzyword#converter()],
"  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
"  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
"  \   'is_expr': 0,
"  \   'is_stay': 1
"  \ }), get(a:, 1, {}))
"endfunction

"noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
"noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
"noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))

"noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

""""""""""""""""""
"fzf.vim 
""""""""""
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
nnoremap <silent> <Leader>A :Ag<CR>

""""""""""""""""""
"vimwiki.vim 
""""""""""
"let g:vimwiki_list = [{'path': '/Users/lb/Documents/wiki/'},
let g:vimwiki_list = [{'path': '/Users/lb/Documents/wiki/'}]
"let g:vimwiki_hl_cb_checked = 1
"let g:vimwiki_CJK_length = 1
nnoremap <silent> <leader>wha :VimwikiAll2HTML<CR>

""""""""""""""""""
"graphviz.vim 
""""""""""
nnoremap <silent> <leader>gzc :GraphvizCompile<CR>
nnoremap <silent> <leader>gzo :Graphviz<CR>

""""""""""""""""""
"syntastic 
""""""""""
let g:syntastic_enable_signs=1
let g:syntastic_error_symbol = "\u2717"
let g:syntastic_warning_symbol = "\u26A0"
let g:syntastic_quiet_messages={'!level': 'errors'} 

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" let g:syntastic_rust_checkers = ['cargo']
let g:syntastic_rust_checkers = ['rustc']

""""""""""""""""""
"swift
""""""""""
augroup filetype
  au! BufRead,BufNewFile *.swift set ft=swift
augroup END

""""""""""""""""""
" vim-colors-solarized'
""""""""""
let g:solarized_termcolors=256
colorscheme solarized
