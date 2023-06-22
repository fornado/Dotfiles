unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
packadd! matchit

set rtp+=~/Documents/projects/Dotfiles/vimfiles/.vim/
set rtp+=~/.vim/plugged/vimcdoc

"let $VENDOR_PATH = $HOME . '/Documents/Dotfiles/vimfiles/.vim/pack/vendor/start'
"let $FUGITVIE = $VENDOR_PATH . '/vim-fugitive'
"let $VIMCDOC = $VENDOR_PATH . '/vimcdoc'
"let $FZFVIM = $VENDOR_PATH . '/fzf.vim'
"let $FZF = $VENDOR_PATH . '/fzf'
"set runtimepath=$FUGITVIE,$VIMRUNTIME

" Basic {{{1
let mapleader = ","

set number
set relativenumber
set hidden
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smartindent
set autoindent
set scrolloff=0

set hlsearch
set incsearch
set ignorecase
set smartcase

set splitbelow
set splitright

set cmdheight=1
set cursorline
set helplang=cn
set fileencodings=utf-8

set autoread
set noswapfile
set nowritebackup
set vb t_vb=

set diffopt+=vertical
set list lcs=tab:\¦\\u0020
set clipboard=unnamed

set foldmethod=marker
set formatoptions+=ro
"set comments=://

" mappings {{{2
nnoremap <leader>w :<c-u>update %<cr>
nnoremap <leader>q :<c-u>quit<cr>
nnoremap <silent> <c-l> :<c-u>nohls<cr><c-l>
nnoremap <silent> <space><space> :<c-u>wa<cr>
nnoremap <silent> <space>so :<c-u>so %<cr>
nnoremap <silent> <space>sm :<c-u>so $MYVIMRC<cr>
nnoremap <space>e :<c-u>vs ~/Documents/projects/Dotfiles/vimfiles/.vim/simple.vim<cr>

inoremap jk <esc>
inoremap <c-l> <right>

cnoremap <c-l> <right>
cnoremap <c-h> <bs>

" back the last modify postion
nnoremap g. `.
" back the last quit insert mode
nnoremap g^ `^

nnoremap <space>i migg=G`izz
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:h') . '/' : '%%'

if has("win32unix")
	nnoremap <silent> <leader>tf :!start<space><c-r>=expand("%:p:h")<cr>/<cr>
endif

" exe last :s cmd with same params again
nnoremap & :&&<cr>
xnoremap & :&&<cr>

" Custom {{{1
" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

" common {{{2
" window
" move around
nnoremap <space>wj <c-w>j
nnoremap <space>wk <c-w>k
nnoremap <space>wh <c-w>h
nnoremap <space>wl <c-w>l
nnoremap <space>wt <c-w>t
nnoremap <space>wb <c-w>b
nnoremap <space>wp <c-w>p
" terminal
"tnoremap <space>wj <c-w>j
"tnoremap <space>wk <c-w>k
"tnoremap <space>wh <c-w>h
"tnoremap <space>wl <c-w>l
"tnoremap <space>wt <c-w>t
"tnoremap <space>wb <c-w>b
"tnoremap <space>wp <c-w>p
"tnoremap <space>w- <c-w>_
"tnoremap <space>wm <c-w>=
"tnoremap <space>w] <c-w>\|

" maxium or minium
nnoremap <space>w- <c-w>_
nnoremap <space>wm <c-w>=
nnoremap <space>w] <c-w>\|
" open only
nnoremap <space>wo <c-w>o
" retote
nnoremap <space>wr <c-w>r
nnoremap <space>wR <c-w>R
nnoremap <space>wx <c-w>x
" display
nnoremap <space>wv <c-w>v
nnoremap <space>ws <c-w>s
nnoremap <space>wJ <c-w>J
nnoremap <space>wK <c-w>K
nnoremap <space>wH <c-w>H
nnoremap <space>wL <c-w>L
nnoremap <space>wT <c-w>T
"nnoremap <space>pq :<c-u>pclose<cr>

" tab
nnoremap <space>tn :<c-u>tabnew<cr>
nnoremap <space>tc :<c-u>tabclose<cr>
nnoremap <space>to :<c-u>tabonly<cr>
nnoremap <space>tf :<c-u>tabfirst<cr>
nnoremap <space>tl :<c-u>tablast<cr>
nnoremap [t :<c-u>tabprevious<cr>
nnoremap ]t :<c-u>tabnext<cr>

" buffer
nnoremap ]b :<c-u>bnext<cr>
nnoremap [b :<c-u>bprevious<cr>
nnoremap <space>b :b <c-d>
nnoremap <space>be :e **/
nnoremap <space>bq :b#<cr>
nnoremap <space>bo :BufOnly<cr>
nnoremap <space>bf :bfirst<cr>
nnoremap <space>bl :blast<cr>
nnoremap <space>bn :bnext<cr>
nnoremap <space>bp :bprevious<cr>

command! BufOnly execute '%bdelete|edit#|bdelete#'

" dir
nnoremap <space>d :<c-u>pwd<cr>

" line
" [( [{
nnoremap <space>ll <c-d>
nnoremap <space>lh <c-u>
nnoremap <space>lb _
nnoremap <space>le g_
nnoremap <space>ls :call <SID>stripTrailingWhitespace()<cr>

nnoremap [<space> O<esc>j
nnoremap [<space>d kdd
nnoremap ]<space> o<esc>k
nnoremap ]<space>d jddk

" functionality {{{3
" hl and search
" g. g, g; ge  g_, g0 gm g^ gI
nnoremap g* *N
vnoremap g* *N
" use [i/I or ]i/I
nnoremap <leader>i :ilist<space>
xnoremap * :<c-u>call <SID>VSetSearch()<cr>/<c-r>=@/<cr><cr>
xnoremap # :<c-u>call <SID>VSetSearch()<cr>?<c-r>=@/<cr><cr>

function! s:VSetSearch()
	let temp = @s
	normal! gv"sy
	let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
	let @s = temp
endfunction

" toggle
nnoremap yot :<c-u>terminal<cr>
tnoremap yot <c-w>:q!<cr>

nnoremap yop :<c-u>set paste!<cr>
nnoremap yog :<c-u>Git<cr>
nnoremap yoq :<c-u>cwindow<cr>
"
" tags
"set tags=./.tags;,.tags
"nnoremap <silent> <space>t :vs ~/.ctags.d/vue.ctags<cr>
nnoremap <leader>j :tjump /

" makergp
nnoremap <leader>m :make<cr>

" quickfix
nnoremap <space>cc :<c-u>cclose<cr>

" statusline
set laststatus=2
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%l,%v]

" args
" add all filenames of qf to args list
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
	let buffer_numbers = {}
	for quickfix_item in getqflist()
		let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
	endfor
	return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

" grep
nnoremap <leader>g :grep<space>

" snippets
"
" delete trailing whitespace
function! s:stripTrailingWhitespace()
	if !&binary && &filetype != 'diff'
		normal mz
		normal Hmy
		%s/\s\+$//e
		normal 'yz<cr>
		normal 'z
	endif
endfunction


" autocmd {{{2
":autocmd [group] {events} {file-pattern} [++nested] {command}
":augroup updateDate
":  autocmd!
":  autocmd BufWritePre *  call DateInsert()
":augroup END

" show tag define
"au! CursorHold *.[ch] ++nested call PreviewWord()
"func PreviewWord()
"if &previewwindow			" 不要在预览窗口里执行
"  return
"endif
"let w = expand("<cword>")		" 在当前光标位置抓词
"if w =~ '\a'			" 如果该单词包括一个字母
"
"  " 在显示下一个标签之前，删除所有现存的语法高亮
"  silent! wincmd P			" 跳转至预览窗口
"  if &previewwindow		" 如果确实转到了预览窗口……
"	match none			" 删除语法高亮
"	wincmd p			" 回到原来的窗口
"  endif
"
"  " 试着显示当前光标处匹配的标签
"  try
"	 exe "ptag " .. w
"  catch
"	return
"  endtry
"
"  silent! wincmd P			" 跳转至预览窗口
"  if &previewwindow		" 如果确实转到了预览窗口……
" if has("folding")
"   silent! .foldopen		" 展开折叠的行
" endif
" call search("$", "b")		" 到前一行的行尾
" let w = substitute(w, '\\', '\\\\', "")
" call search('\<\V' .. w .. '\>')	" 定位光标在匹配的单词上
" " 给在此位置的单词加上匹配高亮
"	hi previewWord term=bold ctermbg=green guibg=green
" exe 'match previewWord "\%' .. line(".") .. 'l\%' .. col(".") .. 'c\k*"'
"	wincmd p			" 返回原来的窗口
"  endif
"endif
"
"
" Plugins {{{1
" Netrw {{{2
let g:netrw_usetab = 1
let g:netrw_banner=1
let g:netrw_winsize=25
let g:netrw_liststyle=3
let g:Netrw_altv=1
let g:netrw_browse_split=4
let g:netrw_list_hide = netrw_gitignore#Hide() .. '.*\.swp$'
nnoremap yon <Plug>NetrwShrink

