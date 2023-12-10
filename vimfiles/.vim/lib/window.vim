vim9script noclear

export def Close(bufnr: number): bool
	const name = bufname(bufnr)
	const wid = bufwinnr(bufnr)
	if bufnr < 0 || name == '' || wid < 0
		echomsg 'close failure...'
		return false
	endif

	if wid != winnr()
		echomsg 'not cur win, wid: ' .. wid
		const cwid = win_getid()
		execute "normal! " .. wid .. "\<c-w>w"
		close
		echomsg 'back after close to window: ' .. cwid
		call win_gotoid(cwid)
	else
		echomsg 'is cur win, close'
		close
	endif
	return true
enddef
