vim9script

setlocal foldmethod=indent
setlocal sw=2

nnoremap <buffer> <leader>r :<c-u>call <SID>Run()<cr>
nnoremap <buffer> <leader><c-l> :<c-u>call <SID>Clear()<cr>

def Run()
	const cmd = "racket " .. expand("%:p") .. "\<CR>"
	call term_sendkeys(2, cmd)
enddef

def Clear()
	call term_sendkeys(2, "clear\<CR>")
enddef
