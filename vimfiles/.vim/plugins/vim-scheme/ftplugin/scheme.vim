vim9script noclear

if exists('b:did_ftplugin_scheme')
	echomsg 'scheme exists, finish...'
  finish
endif
const b:did_ftplugin_scheme = 1

import autoload $LIB .. "/terminal.vim" as Term

setlocal foldmethod=indent
setlocal sw=2
setlocal makeprg=racket

nnoremap <buffer> <leader>r :<c-u>call <SID>Run()<cr>

if exists('g:did_ftplugin_scheme')
  finish
endif
const g:did_ftplugin_scheme = 1
echomsg 'load scheme.vim...'

const scheme_bufnr = 'scheme_bufnr'

# run
def Run()
	echomsg 'call run...'
	var bufnr = gettabvar(0, scheme_bufnr, -1)
	bufnr = Term.Open(bufnr)
	settabvar(0, scheme_bufnr, bufnr)
enddef
