vim9script

if exists('b:did_ftplugin_scheme')
  finish
endif
const b:did_ftplugin_scheme = 1

setlocal foldmethod=indent
setlocal sw=2
setlocal makeprg=racket
