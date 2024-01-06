vim9script noclear

export def IsActive(bufnr: number): bool
	return bufnr > 0 && bufname(bufnr) != '' && bufwinnr(bufnr) > 0
enddef
