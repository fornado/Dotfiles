vim9script noclear

export def Create(options: dict<any> = {}): number
  var opts = options
  if empty(opts)
    opts = {'curwin': 1, 'norestore': 1, 'term_finish': 'open'}
  endif
	return term_start(&shell, opts)
enddef

export def Get(bufnr: number): job
  return term_getjob(bufnr)
enddef
