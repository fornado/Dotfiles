vim9script noclear

export def IsActive(bufnr: number): bool
	var active = false
	if bufnr > 0 && bufname(bufnr) != ''
		active = bufwinnr(bufnr) > 0
	endif
	return active
enddef
