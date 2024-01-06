vim9script noclear

if exists('b:vuetest_ftplugin')
	finish
endif
b:vuetest_ftplugin = 1

source $VIMRUNTIME/ftplugin/javascript.vim

import autoload $LIB .. "/terminal.vim" as Term
import autoload $LIB .. "/buffer.vim" as Buffer

setlocal sw=2
setlocal tabstop=2
setlocal nonumber
setlocal foldmethod=indent
setlocal makeprg=yarn\ test

# nnoremap <buffer> <leader>m :call <SID>Make()<cr>
nnoremap <buffer> <leader>r :call <SID>Make()<cr>
nnoremap <buffer> <leader>tc :call <SID>CloseTermWindow()<cr>

if exists('s:load_ft_vuetest_vim')
	finish
endif
const load_ft_vuetest_vim = 1

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
	Term.Close(get(t:, term_bufnr, -1))
enddef
