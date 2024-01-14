vim9script noclear

# if exists('b:did_ftplugin_scheme')
# 	echomsg 'scheme exists, finish...'
#   # finish
# endif
# # const b:did_ftplugin_scheme = 1

import autoload $LIB .. "/terminal.vim" as Term
import autoload $LIB .. "/buffer.vim" as Buffer

setlocal foldmethod=indent
setlocal sw=2
setlocal makeprg=racket

nnoremap <buffer> <leader>r :<c-u>call <SID>Run()<cr>
nnoremap <buffer> <leader>tc :call <SID>CloseTermWindow()<cr>

# if exists('g:did_ftplugin_scheme')
#   finish
# endif
# const g:did_ftplugin_scheme = 1
# echomsg 'load scheme.vim...'

const term_bufnr = 'vt_t_bufnr'

# make
def Make()
  const cwid = win_getid()
  var bufnr = get(t:, term_bufnr, -1)
  const active = Buffer.IsActive(bufnr)
  if !active
	bufnr = Term.Open()
	settabvar(0, term_bufnr, bufnr)
	call win_gotoid(cwid)
  endif

  const cmd = &makeprg .. " " .. expand("%:p") .. "\<CR>"
  call term_sendkeys(bufnr, cmd)
enddef

# close term widow, and stop job when dead
def CloseTermWindow()
  echomsg 'call CloseTermWindow...'
  Term.Close(get(t:, term_bufnr, -1))
enddef
