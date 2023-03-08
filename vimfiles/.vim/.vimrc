unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
packadd! matchit
source ./simple.vim

set rtp+=~/Documents/projects/Dotfiles/vimfiles/.vim/

" tags
set tags=./.tags;,.tags

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

" fzf.vim
command! -bang Tags call fzf#run(fzf#wrap({'source': TagsList(), 'sink': function('SinkSingle')}, <bang>0))
command! -bang -nargs=? Ag call fzf#run(fzf#wrap({'source': 'ls', 'sink*': function('s:show_in_loc_list'), 'options': '--multi'}, <bang>0))

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
      let name = get(arr, 1, '')
      let src = get(arr, 2, '')
      let kind = get(arr, 3, '')
      let line = kind . '|' . name . ' ' . src
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
    let command = cmd . ' ' . a:str
    echomsg command
    command
  endif
endfunction

nnoremap <silent> <leader>s :<c-u>call FzfSearchCurrent(expand('<cword>'))<cr>
vnoremap <silent> <leader>s y:<c-u>call FzfSearchCurrent(escape(@",'"*?()[]{}.'))<cr>

function! s:show_in_loc_list(lines)
  echomsg 'call show_in_loc_list...'
  echomsg a:lines
  call setloclist(0, map(copy(a:lines), '{ "filename": v:val }'))
  lopen
  lclose
endfunction

" An action can be a reference to a function that processes selected lines
function! s:show_in_quickfix_list(lines)
  echomsg a:lines
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
\ 'ctrl-q': function('s:show_in_quickfix_list'),
\ 'ctrl-l': function('s:show_in_loc_list'),
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

colorscheme oneDark
silent! helptags ALL
