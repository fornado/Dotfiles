vim9script noclear
# vim global plugin for correcting typing mistakes
# Last Change: 2021 Dec 30
# Maintainer:
# License:

if exists("g:loaded_typecorrect")
	finish
endif
g:loaded_typecorrect = 1

var count = 4
if !hasmapto('<Plug>TypecorrAdd;')
	map <unique> <leader>a <Plug>TypecorrAdd;
endif

def Add(from: string, correct: bool)
	var to = input($"type the correction for {from}: ")
	exe $":iabbrev {from} {to}"

	if correct | exe "normal viws\<c-r>\"" | endif
	count += 1
enddef

# test
# woh
# naem
# nmap <unique> <script> <Plug>TypecorrAdd; <SID>Add
nnoremap <script> <Plug>TypecorrAdd; <SID>Add
nnoremap <SID>Add :call <SID>Add(expand("<cword>"), 1)<CR>

if !exists(":Correct")
	command -nargs=1 Correct :call Add(<q-args>, 0)
endif
