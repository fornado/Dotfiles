" if exists('g:load_ft_vue_vim')
"   finish
" endif
"
" let g:load_ft_vue_vim = 1

" options
setlocal scrolloff=2
setlocal tabstop=2

" tags
let s:tag_prefix = '^\(\s\{0}\|\s\{2}\|\s\{4}\)\zs'
let s:tag_sufix = '\ze\s\{0,2}{\{0,1}'

let s:tag_data = 'data()'

let s:tag_end = '$%k$'
let s:tags = {
      \  'd': { 'name': 'data()', 'end': 'j$%k$' },
      \  'm': { 'name': 'methods:', 'end': s:tag_end },
      \  'c': { 'name': 'computed:', 'end': s:tag_end },
      \  't': { 'name': 'created()', 'end': s:tag_end },
      \  's': { 'name': '<script>', 'end': '}k$'}
      \ }

" pattern
let s:func_patern = '^\s\+[A-Za-z0-9]\+\s\?(.*)\s\?{'

" buffer maps
nnoremap <buffer> <leader>b :<c-u>call <SID>Jump2Tag(1)<cr>
nnoremap <buffer> <leader>e :<c-u>call <SID>Jump2Tag(0)<cr>
" vnoremap <buffer> ap :<c-u>call <SID>AddProperty()<cr>

" get text of selected
function! s:GetVisualSelection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

" jump =====================================================
function! s:Jump2Tag(start)
  let char = getcharstr()
  if !has_key(s:tags, char)
    echomsg 'char ' . char . ' not supported'
    return
  endif
  let taginfo = s:tags[char]
  let tagname = taginfo['name']
  let end = taginfo['end']
  if tagname == s:func_patern
		call <SID>LocateFunc(a:start)
  else
		call s:LocateTag(tagname, a:start, end)
  endif
endfunction

" add a method at the end of methods block
function! s:AddProperty()
	let mdsign = <SID>GetVisualSelection()
	let char = nr2char(getchar())
	let start = char == 'i' ? 1 : 0

	let tagname = nr2char(getchar())
	let tagname = Conver2TagName(tagname)

	let cmd = (char == 'i' ? 'O' : 'o')
	if tagname == s:tag_data
		let cmd = (char == 'i' ? 'o' : 'O')
	endif

	let suffix = ' {},'
	if tagname == s:tag_data
		let suffix = ': '
	endif

	call s:LocateTag(tagname, start, '')
	execute 'normal! ' . cmd . mdsign . suffix
	execute 'normal! h'
endfunction


function! s:LocateTag(tagname, start, endPoint)
  let pattern = s:tag_prefix . a:tagname . s:tag_sufix
  let flag = 'w'
  if !a:start
    let flag = 'bW'
  endif
  let save_cursor = getcurpos()
  normal G$
  let line = search(pattern, flag)
  if line == 0
			call setpos('.', save_cursor)
      return
  endif
  if !a:start
    exe 'normal ' . a:endPoint
  endif
  normal zz
endfunction

" fzf.vim
command! -bang ProjectFiles call fzf#vim#files('~/Documents/projects/', <bang>0)

" function ==========================================
" f: function obj
nnoremap daf :<c-u>call <SID>DeleteCurFunc()<cr>
nnoremap caf :<c-u>call <SID>SelectCurFunc()<cr>

function! s:DeleteCurFunc()
	call s:SelectCurFunc()
	normal! d
endfunction

function! s:SelectCurFunc()
	" let original = getcurpo('.')
	let lastpos = getcurpos('.')

	" search for } at cur line
	if getline('.') =~# ','
		call search('}', 'b', line('.'))
	endif

	let find = 0
	let max = 8
	while find == 0 && max > 0
		let cur = getline('.')
		if (cur =~# s:func_patern)
			let lastpos = getcurpos('.')
			let find = 1
			break
		endif
		normal! [{
		let max -= 1
	endwhile

	call setpos('.', lastpos)

	if find == 0
		return
	endif

	execute 'normal! ' . '^V$%'
endfunction

function! s:LocateFunc(start)
	call s:SelectCurFunc()
	exe 'normal! ' . (a:start ? 'O' : '') . "\<esc>"
endfunction

"
" [f: previous function
" ]f: next function
" bf: begin of function
" ef: end of function
" ]f, or efa{,}: append ',' to then end of function
"
" d: data obj
"
" s: <script> obj
"
" c: style obj
" template
" bt: begin of template
" et: end of template
" im: inner of b
"
" abbreviate
inoreab cl console.log()<Left>
" cl(name, 'name')
" fn: function(`tag`)
" fe: forEach(item => tag)
" append , at the end of function
" [l, add a ',' to the end of next line
" ]l, add a ',' to the end of up line
"
"
" fold
" fold all
" unfold all
" unfold self only
setlocal foldmethod=indent
