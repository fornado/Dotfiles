unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
packadd! matchit

let $MYRTPPath = $HOME . '/Documents/Dotfiles/vimfiles/.vim/pack/vendor/start'
let $FUGITVIE = $MYRTPPath . '/vim-fugitive'
let $VIMCDOC = $MYRTPPath . '/vimcdoc'
let $FZFVIM = $MYRTPPath . '/fzf.vim'
let $FZF = $MYRTPPath . '/fzf'
set runtimepath=$FUGITVIE,$VIMCDOC,$FZFVIM,$FZF,$VIMRUNTIME

" Basic {{{1
let mapleader = ","

" options {{{2
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
set fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936,utf-16,big5,euc-jp,latin1

set autoread
set noexpandtab
set nobackup
set noswapfile
set nowritebackup
set noundofile
set novisualbell
set noerrorbells
set vb t_vb=

set diffopt+=vertical
set list lcs=tab:\¦\\u0020
set clipboard=unnamed

setlocal foldmethod=marker

" comments
set formatoptions+=ro
"set comments=://

" mappings {{{2
" basic {{{3
inoremap jk <esc>
nnoremap <leader>w :<c-u>update %<cr>
nnoremap <leader>q :<c-u>quit<cr>
nnoremap <silent> <c-l> :<c-u>nohls<cr><c-l>

inoremap <c-l> <right>

nnoremap <silent> <space>so :<c-u>so %<cr>
"nnoremap <silent> <space>sm :<c-u>so $MYVIMRC<cr>
nnoremap <space>e :<c-u>vs ~/Documents/Dotfiles/vimfiles/.vim/simple.vim<cr>

nnoremap g. `.
nnoremap g^ `^

nnoremap <space>i migg=G`i
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:h') . '/' : '%%'
if has("win32unix")
	nnoremap <silent> <leader>tf :!start<space><c-r>=expand("%:p:h")<cr>/<cr>
endif

cnoremap <c-l> <right>
cnoremap <c-h> <bs>

command! BufOnly execute '%bdelete|edit#|bdelete#'

" exe last :s cmd with same params again
nnoremap & :&&<cr>
xnoremap & :&&<cr>

"nnoremap g* *N

" common {{{3
" window
" move around
nnoremap <space>wj <c-w>j
nnoremap <space>wk <c-w>k
nnoremap <space>wh <c-w>h
nnoremap <space>wl <c-w>l
nnoremap <space>wt <c-w>t
nnoremap <space>wb <c-w>b
nnoremap <space>wp <c-w>p
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

nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

" line
nnoremap <space>ll <c-d>
nnoremap <space>lh <c-u>

nnoremap [<space> O<esc>j
nnoremap [<space>d kdd
nnoremap ]<space> o<esc>k
nnoremap ]<space>d jddk

" functionality {{{3
" select last paste in visual mode
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
tnoremap yot <c-w>q
nnoremap yop :<c-u>set paste!<cr>
nnoremap yog :<c-u>Git<cr>

" Netrw
nnoremap yon :<c-u>Lexplore .<cr>

" quickfix
nnoremap yoq :<c-u>cwindow<cr>
nnoremap <space>cc :<c-u>cclose<cr>

" add all filenames of qf to args list
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

" autocmd {{{2
":autocmd [group] {events} {file-pattern} [++nested] {command}
":augroup updateDate
":  autocmd!
":  autocmd BufWritePre *  call DateInsert()
":augroup END

" Custom {{{1
" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

" buffer
nnoremap ]b :<c-u>bnext<cr>
nnoremap [b :<c-u>bprevious<cr>

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
