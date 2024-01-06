vim9script noclear

import autoload $LIB .. "/buffer.vim" as Buffer

# create
export def Create(options: dict<string> = {})
  const split = get(options, 'split', 'vs')
  execute split
	setlocal nonumber norelativenumber signcolumn=no
	setlocal bufhidden=hide
enddef

# close window of bufnr, return true or false
export def Close(bufnr: number): bool
  if !Buffer.IsActive
    return false
  endif

	const wid = bufwinnr(bufnr)
	if wid != winnr()
		const cwid = win_getid()
		execute "normal! " .. wid .. "\<c-w>w"
		close
		call win_gotoid(cwid)
	else
		close
	endif
	return true
enddef
