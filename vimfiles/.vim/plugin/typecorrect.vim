vim9script noclear
# vim global plugin for correcting typing mistakes
# Last Change: 2021 Dec 30
# Maintainer:
# License:

if exists("g:loaded_typecorrect")
	finish
endif
g:loaded_typecorrect = 1

iabbrev teh the

var count = 4
if !hasmapto('<Plug>TypecorrAdd;')
	map <unique> <leader>a <Plug>TypecorrAdd
endif
