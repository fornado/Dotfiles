
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

let g:iswindows = 0
if(has("win32") || has("win64") || has("win95") || has("win16") || has("win32unix"))
  let g:iswindows = 1
endif

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
"inoremap <c-v> <c-r>+
inoremap <c-l> <right>
inoremap jk <esc>

nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:h') . '/' : '%%'

nnoremap <silent> <space>e :vs ~/Documents/projects/Dotfiles/vimfiles/.vim/.vimrc<cr>
nnoremap <silent> <space>t :vs ~/.ctags.d/vue.ctags<cr>
nnoremap <silent> <space>w :<c-u>call <SID>SaveConfig()<cr>
nnoremap <silent> <space>so :<c-u>so %<cr>
nnoremap <silent> <space>sm :<c-u>so $MYVIMRC<cr>

function! s:SaveConfig()
  :!cp ~/Documents/projects/Dotfiles/vimfiles/.vim/.vimrc ~/.vim/vimrc
  :!cp ~/Documents/projects/Dotfiles/vimfiles/.vim/ftplugin/vue.vim ~/.vim/ftplugin/vue.vim
  :!cp ~/.ctags.d/vue.ctags ~/Documents/projects/Dotfiles/ctags/
endfunction

" changes
" jump 2 last change
nnoremap g. `.
" jump 2 last insert place
nnoremap g^ `^

" buffer {{{
command! BufOnly execute '%bdelete|edit#|bdelete#'

" file
if has("win32unix")
  nnoremap <silent> <leader>tf :!start<space><c-r>=expand("%:p:h")<cr>/<cr>
endif

nnoremap <silent> <c-l> :<c-u>nohls<cr><c-l>
nnoremap <leader>tn :<c-u>tabnew<cr>
nnoremap <leader>tc :<c-u>tabclose<cr>
nnoremap [t :<c-u>tabprevious<cr>
nnoremap ]t :<c-u>tabnext<cr>

nnoremap <leader>cc :<c-u>cclose<cr>

" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'
xnoremap * :<c-u>call <SID>VSetSearch()<cr>/<c-r>=@/<cr><cr>
xnoremap # :<c-u>call <SID>VSetSearch()<cr>?<c-r>=@/<cr><cr>

function! s:VSetSearch()
  let temp = @s
  normal! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

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
Plug 'kana/vim-textobj-user'
Plug 'tomtom/tcomment_vim'
Plug 'kana/vim-textobj-lastpat'

call plug#end()

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1

" vim-airline-themes
let g:airline_theme='onedark'

" Nerdtree
nnoremap yon :<c-u>NERDTreeToggle<cr>

" onedark.vim
if (empty($TMUX))
	if (has("nvim"))
		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	endif
	if (has("termguicolors"))
		set termguicolors
	endif
endif

" fzf.vim {{{
" command! -bang Files call fzf#run(fzf#wrap({'source': 'ls'}, <bang>0))
" command! -bang Tags call fzf#run(fzf#wrap({'source': ['c|1','m|2','f|3','c|4']}, <bang>0))
" command! -bang Tags call fzf#run(fzf#wrap({'source': TagsList(), 'sink': 'tabedit'}, <bang>0))
" command! -bang Tags call fzf#run(fzf#wrap({'source': TagsList(), 'sink': SinkSingle()}, <bang>0))
command! -bang Tags call fzf#run(fzf#wrap({'source': TagsList(), 'sink': function('SinkSingle')}, <bang>0))
" command! -bang Tags call fzf#run(fzf#wrap({'source': 'ls'}, <bang>0))

nnoremap <leader>ff :<c-u>Files<cr>
nnoremap <leader>fgf :<c-u>GFiles<cr>
nnoremap <leader>fgs :<c-u>GFiles?<cr>
nnoremap <leader>fag :<c-u>Ag<cr>
nnoremap <leader>fb :<c-u>Buffers<cr>
nnoremap <leader>fl :<c-u>Lines<cr>
nnoremap <leader>fbl :<c-u>BLines<cr>
nnoremap <leader>ft :<c-u>Tags<cr>
nnoremap <leader>fbt :<c-u>BTags<cr>

" tags list
function! TagsList()
  let filename = '/c/Users/tony5/Documents/projects/demo/vuedemo/demo/src/.tags'
  let list = []
  for line in readfile(filename, '')
    if match(line, '^!_TAG') != -1 | continue | endif
    let arr = matchlist(line, '\v^(\w+)\t([a-zA-Z/0-9.@]+)\t.*;"\t(\w)\t?([a-zA-Z:0-9]{0,})')
    if !empty(arr)
      " echomsg 'arr:'
      " echomsg arr
      let name = get(arr, 1, '')
      let src = get(arr, 2, '')
      let kind = get(arr, 3, '')
      " echomsg 'name: ' . name
      " echomsg 'src: ' . src
      " echomsg 'kind: ' . kind
	" let kind = get(extend, 0, '')
      let line = kind . '|' . name . ' ' . src
        " let kind = substitute(line, '\v.*;"\t(\w+)(\t.*)?', '\1', '')
      call add(list, line)
    endif
  endfor
  return list
endfunction

function! SinkSingle(args)
  let index = stridx(a:args, ' ')
  if index != -1
    let filepath = strpart(a:args, index)
    let char = getcharstr()
    let cmd = 'e'
    if char == 'x'
      let cmd = 'sp'
    elseif char == 'v'
      let cmd = 'vs'
    elseif char == 't'
      let cmd = 'tabedit'
    endif
    execute cmd . ' ' . filepath
  endif
endfunction

" map char to command
function! FzfChar2Cmd(char)
	let l:char = a:char
	if char ==# 'f'
		return 'Files'
	elseif char ==# 'g'
		return 'GFiles?'
	elseif char ==# 'a'
		return 'Ag'
	elseif char ==# 'b'
		return 'Buffers'
	elseif char ==# 'l'
		return 'Lines'
	elseif char ==# 'L'
		return 'BLines'
	elseif char ==# 't'
		return 'Tags'
	elseif char ==# 'T'
		return 'BTags'
	else
		return '-1'
		echomsg 'char ' . char . ' not support mapper'
	endif
endfunction

" search cword or @" of word by scope
function! FzfSearchCurrent(str)
  let char = getcharstr()
  let cmd = FzfChar2Cmd(char)
  if cmd !=# '-1'
	execute cmd . ' ' . a:str
  endif
endfunction

nnoremap <silent> <leader>s :<c-u>call FzfSearchCurrent(expand('<cword>'))<cr>
vnoremap <silent> <leader>s y:<c-u>call FzfSearchCurrent(escape(@",'"*?()[]{}.'))<cr>

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
\ 'ctrl-q': function('s:build_quickfix_list'),
\ 'ctrl-t': 'tab split',
\ 'ctrl-x': 'split',
\ 'ctrl-v': 'vsplit' }

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

" Enable per-command history
" - History files will be stored in the specified directory
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" ag{{{
nnoremap <leader>ss :<c-u>Ag<space><c-r>=expand('<cword>')<cr><cr>
vnoremap <leader>ss y:Ag<space><c-r>=escape(@",'"*?()[]{}.')<cr><cr>

" ale.vim
" let g:ale_sign_column_always = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
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
\   'vue': ['prettier'],
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\}

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

""" vue
au BufNewFile,BufRead *.html,*.javascript,*.vue set tabstop=2
au BufNewFile,BufRead *.html,*.javascript,*.vue set softtabstop=2
au BufNewFile,BufRead *.html,*.javascript,*.vue set shiftwidth=2
au BufNewFile,BufRead *.html,*.javascript,*.vue set expandtab
au BufNewFile,BufRead *.html,*.javascript,*.vue set autoindent
" au BufNewFile,BufRead *.html,*.javascript,*.vue set fileformat=dos
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
" let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
let g:gutentags_project_root = ['.root']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" " 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
" let s:vim_tags = expand('~/.cache/tags')
" let g:gutentags_cache_dir = s:vim_tags
"
" " 配置 ctags 的参数
" let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
" let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
" let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
"
" " 检测 ~/.cache/tags 不存在就新建
" if !isdirectory(s:vim_tags)
"    silent! call mkdir(s:vim_tags, 'p')
" endif


" vim-unimpaired'
" use [o to open a option, e.g. [ob to open 'background' option, b is
" 'background'
" use ]o to close a option, e.g. ]ob to close 'background' option

"
" use [ or ] to move backwards or forwards in normal mode
" use {[|]}{a|b|l|q|t} to revious or next obj, the uppercase to first/last
" one;
" use [f
"
" use {>|<|=|[|]}{p|P} to incre/decre/equal indent after paste at under or up line
" use {[|]}{p|P} to preserve matching indent behavior after paste at under or up line
"
" use

colorscheme oneDark
silent! helptags ALL
