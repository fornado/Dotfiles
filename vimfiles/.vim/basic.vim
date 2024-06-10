unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
packadd! matchit

" Basic {{{1
let mapleader = ","
inoremap jk <esc>
nnoremap <leader>w :update %<cr>
nnoremap <silent> <space><space> :wa<cr>
nnoremap <leader>q :quit<cr>
tnoremap <leader>q <c-w><c-c>
nnoremap <silent> <c-l> :nohls<cr><c-l>
nnoremap <leader> <c-l> :mes clear<cr>:nohls<cr><c-l>
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

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
set grepprg=rg\ -S\ --vimgrep
set grepformat+=%f
set cursorline
hi cursorline guibg=#2C323C

set helplang=cn
set fileencodings=utf-8
set autoread
set noswapfile
set nowritebackup
set vb t_vb=

set diffopt+=vertical
"hi DiffAdd guifg=#5C6370 guibg=#228B22
hi DiffAdd guifg=#5C6370
hi DiffText guifg=white

set list lcs=tab:\¦\\u0020
set clipboard=unnamed
set formatoptions+=ro
set laststatus=2
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%l,%v]
setlocal foldmethod=marker
" mappings {{{2
" normal {{{3
nnoremap <silent> <space>so :so %<cr>
nnoremap <space>e :vs $MYVIMRC<cr>
nnoremap g. `.
nnoremap g^ `^
nnoremap <space>i migg=G`izz
nnoremap & :&&<cr>

inoremap <c-l> <right>
xnoremap & :&&<cr>

" objs {{{2
" window {{{3
nnoremap <space>wj <c-w>j
nnoremap <space>wk <c-w>k
nnoremap <space>wh <c-w>h
nnoremap <space>wl <c-w>l
nnoremap <space>wt <c-w>t
nnoremap <space>wb <c-w>b
nnoremap <space>wp <c-w>p
nnoremap <space>w- <c-w>_
nnoremap <space>wm <c-w>=
nnoremap <space>w] <c-w>\|
nnoremap <space>w[ <c-w>\|
nnoremap <space>w+ <c-w>_<c-w>\|
nnoremap <space>wo <c-w>o
nnoremap <space>wr <c-w>r
nnoremap <space>wR <c-w>R
nnoremap <space>wx <c-w>x
nnoremap <space>wv <c-w>v
nnoremap <space>ws <c-w>s
nnoremap <space>wJ <c-w>J
nnoremap <space>wK <c-w>K
nnoremap <space>wH <c-w>H
nnoremap <space>wL <c-w>L
nnoremap <space>wT <c-w>T
nnoremap <space>pc <c-w><c-z>
nnoremap <space>pj :wincmd P<cr>

" terminal {{{3
tnoremap <space>wj <c-w>j
tnoremap <space>wk <c-w>k
tnoremap <space>wh <c-w>h
tnoremap <space>wl <c-w>l
tnoremap <space>wt <c-w>t
tnoremap <space>wb <c-w>b
tnoremap <space>wp <c-w>p
tnoremap <space>w- <c-w>_
tnoremap <space>wm <c-w>=
tnoremap <space>w] <c-w>\|
tnoremap <space>w[ <c-w>\|
tnoremap <space>w+ <c-w>_<c-w>\|
tnoremap <space>wo <c-w>o
tnoremap <space>wr <c-w>r
tnoremap <space>wR <c-w>R
tnoremap <space>wx <c-w>x
tnoremap <space>wv <c-w>:vertical terminal<cr>
tnoremap <space>ws <c-w>:terminal<cr>
tnoremap <space>wJ <c-w>J
tnoremap <space>wK <c-w>K
tnoremap <space>wH <c-w>H
tnoremap <space>wL <c-w>L
tnoremap <space>wT <c-w>T
tnoremap ]b <c-w>:bnext<cr>
tnoremap [b <c-w>:bprevious<cr>

" tab {{{3
nnoremap <space>tn :tabnew<cr>
nnoremap <space>tc :tabclose<cr>
nnoremap <space>to :tabonly<cr>
nnoremap <space>tf :tabfirst<cr>
nnoremap <space>tl :tablast<cr>
nnoremap [t :tabprevious<cr>
nnoremap ]t :tabnext<cr>
tnoremap <space>tn <c-w>:tabnew<cr>
tnoremap <space>tc <c-w>:tabclose<cr>
tnoremap <space>to <c-w>:tabonly<cr>
tnoremap <space>tf <c-w>:tabfirst<cr>
tnoremap <space>tl <c-w>:tablast<cr>
tnoremap [t <c-w>gt
tnoremap ]t <c-w>gT

" buffer {{{3
nnoremap ]b :bnext<cr>
nnoremap [b :bprevious<cr>
nnoremap <space>b :b <c-d>
nnoremap <space>bq :b#<cr>
nnoremap <space>bo :BufOnly<cr>
nnoremap <space>bf :bfirst<cr>
nnoremap <space>bl :blast<cr>
command! BufOnly execute '%bdelete|edit#|bdelete#'

" dir {{{3
nnoremap <space>d :pwd<cr>
if has("win32unix")
    nnoremap <silent> <leader>tf :!start<space><c-r>=expand("%:p:h")<cr>/<cr>
endif

" cmdline {{{3
cnoremap <c-l> <right>
cnoremap <c-h> <bs>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:h') . '/' : '%%'
nnoremap <space>; :<c-u>

" line {{{3
nnoremap [<space> O<esc>j
nnoremap [<space>d kdd
nnoremap ]<space> o<esc>k
nnoremap ]<space>d jddk
nnoremap <space>lb _
nnoremap <space>le g_
nnoremap <space>ls :call <SID>stripTrailingWhitespace()<cr>
function! s:stripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        %s/\s\+$//e
        normal 'yz<cr>
        normal 'z
    endif
endfunction

" quickfix {{{3
nnoremap <space>cc :cclose<cr>
nnoremap <space>qc :call setqflist([], 'f')<cr>
nnoremap <space>qo :colder<cr>
nnoremap <space>qn :cnewer<cr>

" location {{{3
nnoremap <space>lc :call setloclist(0, [], 'f')<cr>:lclose<cr>

" functionality {{{2
" toggle {{{3
nnoremap yot :terminal<cr>
tnoremap yot <c-w>:hide<cr>
nnoremap yop :set paste!<cr>
nnoremap yoq :cwindow<cr>
nnoremap yol :lopen<cr>
nnoremap yon <Plug>NetrwShrink
nnoremap yog :Git<cr>
" search {{{3
nnoremap g* *N
vnoremap g* *N
" use [i/I or ]i/I
" nnoremap <leader>i :ilist<space>
xnoremap * :call <SID>VSetSearch()<cr>/<c-r>=@/<cr><cr>
xnoremap # :call <SID>VSetSearch()<cr>?<c-r>=@/<cr><cr>
function! s:VSetSearch()
    let temp = @s
    normal! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
endfunction
" nnoremap <leader>m :make<cr>
" nnoremap <leader>g :grep<space>
" nnoremap <leader>gl :lgrep<space>
" nnoremap <leader>glf :lgrep -g<space>
" add all filenames of qf to args list
" command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
" function! QuickfixFilenames()
"     let buffer_numbers = {}
"     for quickfix_item in getqflist()
"         let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
"     endfor
"     return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
" endfunction

" filetype {{{2
" vue {{{3
au BufNewFile,BufRead *.html,*.javascript,*.vue set tabstop=2 softtabstop=2 shiftwidth=2
au BufNewFile,BufRead *.html,*.javascript,*.vue set expandtab autoindent
au FileType vue syntax sync fromstart
