" buffer maps
nnoremap <buffer> <leader>b :<c-u>call <SID>JumpBlocks(1)<cr>
nnoremap <buffer> <leader>e :<c-u>call <SID>JumpBlocks(0)<cr>
vnoremap <buffer> am :<c-u>call <SID>AddMethod()<cr>

if exists('g:load_ft_vue_vim')
  finish
endif

let g:load_ft_vue_vim = 1

" options
setlocal scrolloff=2
setlocal tabstop=2

" tags
let s:method_tag = 'methods:'
let s:computed_tag = 'computed:'

" pattern
let s:func_patern = '\s\+[A-Za-z0-9]\+\s\?(.*)\s\?{'

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
" jump between blocks:
" nnoremap <buffer> <leader>b :<c-u>call <SID>JumpBlocks(1)<cr>
" nnoremap <buffer> <leader>e :<c-u>call <SID>JumpBlocks(0)<cr>

function! s:JumpBlocks(start)
	let char = nr2char(getchar())
	if char == 'm'
		call <SID>LocateMethod(a:start)
	elseif char == 'f'
		call <SID>LocateFunc(a:start)
	else
		echo 'char ' . char . ' not support'
	endif
endfunction


" textobj =================================================
"
" methods
" m: methods obj
" bm: begin of methods
" nnoremap bm :<c-u>call <SID>LocateMethod(1)<cr>
" nnoremap em :<c-u>call <SID>LocateMethod(0)<cr>

" add a method, type am then `a` or other to choice location
" vnoremap am :<c-u>call <SID>AddMethod()<cr>

" add a method at the end of methods block
function! s:AddMethod()
	let mdsign = <SID>GetVisualSelection()
	let char = nr2char(getchar())
	let start = char == 'a' ? 0 : 1

	call <SID>LocateMethod(start)
	execute 'normal! ' . (char == 'a' ? 'o' : 'O') . mdsign . ' {},'
	execute 'normal! h'
endfunction

function! s:LocateMethod(start)
	call search('\<' . s:method_tag, 'c')
	execute 'normal! ' . (a:start ? 'j^' : '$%kg_')
endfunction

" em: end of methods
" im: inner of methods
" am: around of methods
" bmi: begin of methods, then into insert mode
" ema: end of methods, then into insert mode


" function ==========================================
" f: function obj
nnoremap daf :<c-u>call <SID>DeleteCurFunc()<cr>
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
