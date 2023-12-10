vim9script noclear

if exists('b:vuetest_ftplugin')
	finish
endif
b:vuetest_ftplugin = 1

source $VIMRUNTIME/ftplugin/javascript.vim

import autoload $LIB .. "/terminal.vim" as term
import autoload $LIB .. "/buffer.vim" as buffer

setlocal sw=2
setlocal tabstop=2
setlocal nonumber
setlocal foldmethod=indent
setlocal makeprg=yarn\ test

nnoremap <buffer> <leader>m :call <SID>Make()<cr>
nnoremap <buffer> <leader>tc :call <SID>CloseTermWindow()<cr>


if exists('s:load_ft_vuetest_vim')
	finish
endif
const load_ft_vuetest_vim = 1

const term_bufnr = 'vt_t_bufnr'
const term_job = 'vt_t_job'

# term variables
def GetTerminalBufnr(): number
	const bufnr = get(t:, term_bufnr, -1)
	echomsg 'GetTerminalBufnr, bufnr: ' .. bufnr
	return bufnr
enddef

def GetTerminalBufJob(bufnr: number): job
	const job = getbufvar(bufnr, term_job)
	return job
enddef

# make
def Make()
	const cwid = win_getid()
	var bufnr = GetTerminalBufnr()
	const active = buffer.IsActive(bufnr)
	if !active
		const res = term.TerminalOpen(bufnr)
		settabvar(0, term_bufnr, res.bufnr)

		if has_key(res, 'job') && type(res.job) == v:t_job
			echomsg 'update t: job: ' .. string(res.job) .. ", for bufnr: " .. res.bufnr
			setbufvar(res.bufnr, term_job, res.job)
		endif
		call win_gotoid(cwid)
	endif

	bufnr = GetTerminalBufnr()
	const cmd = &makeprg .. " " .. expand("%:p") .. "\<CR>"
	call term_sendkeys(bufnr, cmd)
enddef

# close term widow, and stop job when dead
def CloseTermWindow()
	const bufnr = GetTerminalBufnr()
	term.TerminalClose(bufnr, GetTerminalBufJob)
enddef
