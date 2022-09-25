" if exists('g:load_ft_vue_vim')
"   finish
" endif
"
" let g:load_ft_vue_vim = 1

" options
setlocal scrolloff=2
setlocal tabstop=2

" tags
let s:tag_prefix = '^\s\+\<'
let s:tag_sufix = '\s\+{'
let s:tag_method = 'methods:'
let s:tag_computed = 'computed:'
let s:tag_data = '\(\(data:\s\+function\s\?()\)\|\(data()\)\)'

" pattern
let s:func_patern = '^\s\+[A-Za-z0-9]\+\s\?(.*)\s\?{'

" buffer maps
nnoremap <buffer> <leader>b :<c-u>call <SID>JumpBlocks(1)<cr>
nnoremap <buffer> <leader>e :<c-u>call <SID>JumpBlocks(0)<cr>
vnoremap <buffer> ap :<c-u>call <SID>AddProperty()<cr>


" get text of selected
function! s:GetVisualSelection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

" map input char to tag name
function! Mapper(char)
	let l:char = a:char
	if char == 'm'
		return s:tag_method
	elseif char == 'f'
		return s:func_patern
	elseif char == 'c'
		return s:tag_computed
	elseif char == 'd'
		return s:tag_data
	else
		echo 'char ' . char . ' not support mapper'
	endif
endfunction

" jump =====================================================
function! s:JumpBlocks(start)
	let char = nr2char(getchar())
  let tag = Mapper(char)
  if tag == s:func_patern
		call <SID>LocateFunc(a:start)
  else
		call <SID>LocateTag(tag, a:start)
  endif
endfunction


" add a method at the end of methods block
function! s:AddProperty()
	let mdsign = <SID>GetVisualSelection()
	let char = nr2char(getchar())
	let start = char == 'i' ? 1 : 0

	let tag = nr2char(getchar())
	let tag = Mapper(tag)

	let cmd = (char == 'i' ? 'O' : 'o')
	if tag == s:tag_data
		let cmd = (char == 'i' ? 'o' : 'O')
	endif

	let suffix = ' {},'
	if tag == s:tag_data
		let suffix = ': '
	endif

	call <SID>LocateTag(tag, start)
	execute 'normal! ' . cmd . mdsign . suffix
	execute 'normal! h'
endfunction


function! s:LocateTag(tag, start)
	" call search('\<' . a:tag, 'c')
  call search(s:tag_prefix . a:tag . s:tag_sufix)
	execute 'normal! ' . (a:start ? 'j^' : '$%kg_')
endfunction


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
