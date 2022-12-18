unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
packadd! matchit

set rtp+=~/.vim/plugged/vimcdoc/

" Basic {{{1
" leader {{{2
let mapleader = ","

" options {{{2
setlocal foldmethod=marker

set helplang=cn

set textwidth=80
set tabstop=4
set softtabstop=4
set shiftwidth=4

set number
set relativenumber
set hlsearch
set incsearch
set ignorecase
set smartcase
set hidden

" comments
set formatoptions+=ro
"set comments=://

" mappings {{{2
nnoremap <leader>w :<c-u>update %<cr>
nnoremap <leader>q :<c-u>quit<cr>

nnoremap <space>e :<c-u>vs ~/Documents/projects/Dotfiles/vimfiles/.vim/simple.vim<cr>
nnoremap <space>w :<c-u>update <Bar> source %<cr>

nnoremap <silent> <c-l> :<c-u>nohls<cr><c-l>
cnoremap <c-l> <right>
cnoremap <c-h> <bs>
nnoremap <space>i gg=G

"inoremap jk <esc>

" add blank
"nnoremap ]<space> o<esc>k
nnoremap [<space> O<esc>j

" text-obj
" onoremap <f7> a{
"
"
" toggle
" prefix by yo in normal mode
"
" close preview window
nnoremap <space>pq :<c-u>pclose<cr>

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
