vim9script

setlocal foldmethod=indent
setlocal sw=2

nnoremap <buffer> <leader>r :<c-u>call <SID>Run()<cr>
nnoremap <buffer> <leader><c-l> :<c-u>call <SID>Clear()<cr>
nnoremap <buffer> <leader>b :<c-u>call <SID>RunTermJob()<cr>

def Run()
	const cmd = "racket " .. expand("%:p") .. "\<CR>"
	call term_sendkeys(2, cmd)
enddef

def Clear()
	call term_sendkeys(2, "clear\<CR>")
enddef

def RunTermJob()
	const cmd = "racket " .. expand("%:p")
	echomsg 'cmd: ' .. cmd
	const options = { 'term_name': 'test' }
	const bufnr = term_start(cmd, options)
	echomsg 'RunTermJob at bufnr: ' .. bufnr
enddef
