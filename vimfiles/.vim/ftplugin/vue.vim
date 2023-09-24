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
			\  's': { 'name': '<script>', 'end': '}k$', 'range': { 'start': '<script\%(\s.*\)\?>', 'end': '</script>', 'cf': '// %s'} },
			\  'l': { 'name': '<template>', 'end': '}k$', 'range': { 'start': '<template>', 'end': '</template>', 'cf': '<!-- %s -->'} },
			\  'y': { 'name': '<style>', 'end': '}k$', 'range': { 'start': '<style\%(\s.*\)\?>', 'end': '</style>', 'cf': '// %s'} }
			\ }

" pattern
let s:func_pattern = '^\s\+[A-Za-z0-9]\+\s\?(.*)\s\?{'

" buffer maps
nnoremap <buffer> <leader>b :<c-u>call <SID>Jump2Tag(1)<cr>
nnoremap <buffer> <leader>e :<c-u>call <SID>Jump2Tag(0)<cr>
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
		if (cur =~# s:func_pattern)
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

nnoremap <buffer> [m :<c-u>call LocateFunc(1)<cr>
nnoremap <buffer> ]m :<c-u>call LocateFunc(0)<cr>
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

" commentary
nnoremap <buffer> <expr> gc <SID>Commentary()
nnoremap <buffer> <expr> gcc <SID>Commentary() . '_'
onoremap <buffer> <expr> gc <SID>Commentary()
xnoremap <buffer> <expr> gc <SID>Commentary()
function! s:getCommentaryFormat()
	let commentary_format = ''
	let pairs = filter(copy(s:tags), "v:key == 's' || v:key == 'l' || v:key == 'y'")
	let pairs = values(pairs)
	let pairs = map(pairs, "v:val['range']")

	for pair in pairs
		let matchrow = searchpair(pair['start'], '', pair['end'], 'rn')
		if matchrow != 0
			let commentary_format = pair['cf']
			break
		endif
	endfor
	echomsg 'getCommentaryFormat:' .commentary_format
	return commentary_format
endfunction

function! s:Commentary(...) abort
	if !a:0
		let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
		return 'g@'
	elseif a:0 > 1
		let [lnum1, lnum2] = [a:1, a:2]
	else
		let [lnum1, lnum2] = [line("'["), line("']")]
	endif

	let temp = get(b:, 'commentary_format')
	let format = s:getCommentaryFormat()
	if !empty(format)
		let b:commentary_format = format
	endif

	let cmd = ''. lnum1 . ',' . lnum2 . 'Commentary'
	echomsg 'cmd:' . cmd
	silent execute cmd

	if !empty(format)
		let b:commentary_format = temp
	endif
	return ''
endfunction
