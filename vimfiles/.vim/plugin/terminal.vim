"======================================================================
"
" terminal.vim
"
" Created by Neo on 2022/08/27
" Refered from skywind
"
" Last Modified: 2022/08/27 16:33
"
"======================================================================

"----------------------------------------------------------------------
" check compatible
"----------------------------------------------------------------------
if has('patch-8.1.1') == 0
	finish
endif

"----------------------------------------------------------------------
" configuration
"----------------------------------------------------------------------

" key toggle terminal
if !exists('g:terminal_key')
	let g:terminal_key = '<c-w>'
endif

" close when terminal job stops
if !exists('g:terminal_close')
	let g:terminal_close = 1
endif

" postion
if !exists('g:terminal_pos')
	let g:terminal_pos = 'rightbelow'
endif

" height
if !exists('g:terminal_height')
	let g:terminal_height = 10
endif

" shell
if !exists('g:terminal_shell')
	let g:terminal_shell = ''
endif

" whether auto insert when jump2 term
if !exists('g:terminal_auto_insert')
	let g:terminal_auto_insert = 0
endif

" how when job stop
if !exists('g:terminal_kill')
	let g:terminal_kill = 'term'
endif

" how when job stop
if !exists('g:terminal_list')
	let g:terminal_list = 1
endif

" if fixheight
if !exists('g:terminal_fixheight')
	let g:terminal_fixheight = 1
endif


" initialize shell directory
" 0: vim's current working directory (which :pwd returns)
" 1: file path of current file.
" 2: project root of current file.
if !exists('g:terminal_cwd')
	let g:terminal_cwd = 1
endif

" root markers to identify the project root
if !exists('g:terminal_rootmarkers')
	let g:terminal_rootmarkers = ['.git', '.svn', '.project', '.root', '.hg']
endif

nnoremap yot :<c-u>call TerminalToggle()<cr>
tnoremap yot <c-w>:<c-u>call TerminalToggle()<cr>

"----------------------------------------------------------------------
" internal utils
"----------------------------------------------------------------------

" returns nearest parent directory contains one of the markers
function! s:find_root(name, markers, strict)
	let name = fnamemodify((a:name != '')? a:name : bufname('%'), ':p')
	let finding = ''
	" iterate all markers
	for marker in a:markers
		if marker != ''
			" search as a file
			let x = findfile(marker, name . '/;')
			let x = (x == '')? '' : fnamemodify(x, ':p:h')
			" search as a directory
			let y = finddir(marker, name . '/;')
			let y = (y == '')? '' : fnamemodify(y, ':p:h:h')
			" which one is the nearest directory ?
			let z = (strchars(x) > strchars(y))? x : y
			" keep the nearest one in finding
			let finding = (strchars(z) > strchars(finding))? z : finding
		endif
	endfor
	if finding == ''
		let path = (a:strict == 0)? fnamemodify(name, ':h') : ''
	else
		let path = fnamemodify(finding, ':p')
	endif
	if has('win32') || has('win16') || has('win64') || has('win95')
		let path = substitute(path, '\/', '\', 'g')
	endif
	if path =~ '[\/\\]$'
		let path = fnamemodify(path, ':h')
	endif
	return path
endfunc

" returns project root of current file
function! s:project_root()
	let name = expand('%:p')
	return s:find_root(name, g:terminal_rootmarkers, 0)
endfunc

" check if has created before, if yes jump2 that window
function! CheckIsCreated(bid)
	let l:bid = a:bid
	let l:name = bufname(l:bid)
	let l:isCreated = 0
	if l:name != ''
		let l:wid = bufwinnr(l:bid)
		if l:wid < 0
			call CreateAWindow()
			exec 'b ' . bid
		else
			exec "normal! ". wid . "\<c-w>w"
		endif
		let isCreated = 1
	endif
	return isCreated
endfunction


" create a terminal job, return bid
function! CreateAJob()
	let shell = get(g:, 'terminal_shell')
	let command = (shell != '')? shell : &shell

	let opts = {'curwin':1, 'norestore':1, 'term_finish':'open'}
	let opts.term_kill = get(g:, 'terminal_kill')
	let opts.exit_cb = function('s:terminal_exit')

	let bid = term_start(command, opts)
	let jid = term_getjob(bid)
	let b:__terminal_jid__ = jid

	return bid
endfunction

" split a window
function! CreateAWindow()
	let l:pos = get(g:, 'terminal_pos')
	let l:height = get(g:, 'terminal_height')
	exec pos . ' ' . height . 'split'

	setlocal nonumber norelativenumber signcolumn=no
	setlocal bufhidden=hide
	if get(g:, 'terminal_list') == 0
		setlocal nobuflisted
	endif
	if get(g:, 'terminal_auto_insert') != 0
		autocmd WinEnter <buffer> exec "normal! i"
	endif
	if get(g:, 'terminal_fixheight', 0)
		setlocal winfixheight
	endif
endfunction


" create a ternimal window
function! CreateTerminalWindow()
	let cd = haslocaldir()? ((haslocaldir() == 1)? 'lcd' : 'tcd') : 'cd'

	" change &cwd and then split a new window
	let savedir = getcwd()
	if &bt == ''
		if g:terminal_cwd == 1
			let workdir = (expand('%') == '')? getcwd() : expand('%:p:h')
			silent execute cd . ' '. fnameescape(workdir)
		elseif g:terminal_cwd == 2
			silent execute cd . ' '. fnameescape(s:project_root())
		endif
	endif

	call CreateAWindow()

	" create a job at current windown
	let bid = CreateAJob()
	let t:__terminal_bid__ = bid

	" restore &cwd
	silent execute cd . ' '. fnameescape(savedir)
endfunction


"----------------------------------------------------------------------
" open a new/previous terminal
"----------------------------------------------------------------------
function! TerminalOpen(...)
	" 当期terminal bufferid
	let bid = get(t:, '__terminal_bid__', -1)
	let pos = get(g:, 'terminal_pos')
	let height = get(g:, 'terminal_height')
	let succeed = 0
	function! s:terminal_view(mode)
		if a:mode == 0
			let w:__terminal_view__ = winsaveview()
		elseif exists('w:__terminal_view__')
			call winrestview(w:__terminal_view__)
			unlet w:__terminal_view__
		endif
	endfunc

	" let uid = win_getid()
	" keepalt noautocmd windo call s:terminal_view(0)
	" keepalt noautocmd call win_gotoid(uid)
	" terminal has created before
	let succeed = CheckIsCreated(bid)

	" new create
	if succeed == 0
		" create a window
		call CreateTerminalWindow()
	endif

	" let x = win_getid()
	" noautocmd windo call s:terminal_view(1)
	" noautocmd call win_gotoid(uid)    " take care of previous window
	" noautocmd call win_gotoid(x)

endfunc


"----------------------------------------------------------------------
" hide terminal
"----------------------------------------------------------------------
function! TerminalClose()
	let bid = get(t:, '__terminal_bid__', -1)
	if bid < 0
		return
	endif
	let name = bufname(bid)
	if name == ''
		return
	endif
	let wid = bufwinnr(bid)
	if wid < 0
		return
	endif
	" let sid = win_getid()
	" noautocmd windo call s:terminal_view(0)
	" call win_gotoid(sid)
	" if cur window not the same with ter window
	if wid != winnr()
		let uid = win_getid()
		exec "normal! ". wid . "\<c-w>w"
		close
		call win_gotoid(uid)
	else
		close
	endif
	" let sid = win_getid()
	" noautocmd windo call s:terminal_view(1)
	" call win_gotoid(sid)
	let jid = getbufvar(bid, '__terminal_jid__', -1)

	let dead = 0
	if type(jid) == v:t_job
		let dead = (job_status(jid) == 'dead')? 1 : 0
	endif
	if dead
		exec 'bdelete! '. bid
	endif
endfunc


"----------------------------------------------------------------------
" toggle open/close
"----------------------------------------------------------------------
function! TerminalToggle()
	let alive = TerminalIsActive()
	if alive == 0
		call TerminalOpen()
	else
		call TerminalClose()
	endif
endfunc


"----------------------------------------------------------------------
" process exit callback
"----------------------------------------------------------------------
function! s:terminal_exit(...)
	let close = get(g:, 'terminal_close', 0)
	if close != 0
		let alive = TerminalIsActive()
		if alive
			call TerminalClose()
		elseif bid > 0
			exec 'bdelete! '.bid
		endif
	endif
endfunc

function! TerminalIsActive()
	let bid = get(t:, '__terminal_bid__', -1)
	let alive = 0
	if bid > 0 && bufname(bid) != ''
		let alive = (bufwinnr(bid) > 0)? 1 : 0
	endif
	return alive
endfunction
