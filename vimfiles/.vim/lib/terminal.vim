vim9script

import autoload "./window.vim" as window
import autoload "./buffer.vim" as buffer

# terminal toggle
#	return { type: 'open', bufnr: 1, job: Job }
export def TerminalToggle(bufnr: number, GetJob: func: job): dict<any>
	const active = buffer.IsActive(bufnr)
	if !active
		return TerminalOpen(bufnr)
	else
		return TerminalClose(bufnr, getJob)
	endif
enddef

# open terminal window
export def TerminalOpen(bufnr: number): dict<any>
	const isCreated = bufname(bufnr) != ''

	var res = { type: 'open', bufnr: bufnr }
	const wid = bufwinnr(bufnr)
	if !isCreated
		const data = CreateTerminalWindow()
		res.bufnr = data.bufnr
		res.job = data.job
	elseif wid < 0
		CreateAWindow()
		execute 'b ' .. bufnr
	else
		execute "normal! " .. wid .. "\<c-w>w"
	endif
	return res
enddef

def CreateAWindow()
	execute 'rightbelow split'
	setlocal nonumber norelativenumber signcolumn=no
	setlocal bufhidden=hide
enddef

def CreateTerminalWindow(): dict<any>
	const cd = haslocaldir() ? ((haslocaldir() == 1) ? 'lcd' : 'tcd') : 'cd'
	const savedir = getcwd()
	const workdir = (expand('%') == '') ? getcwd() : expand('%:p:h')
	silent execute cd .. ' ' .. fnameescape(workdir)

	CreateAWindow()
	const data = CreateAJob()

	silent execute cd .. ' ' .. fnameescape(savedir)
	return data
enddef

def CreateAJob(): dict<any>
	const opts = {'curwin': 1, 'norestore': 1, 'term_finish': 'open'}
	const bufnr = term_start(&shell, opts)
	const job = term_getjob(bufnr)

	return { bufnr: bufnr, job: job }
enddef

export def TerminalClose(bufnr: number, GetJob: func: job): dict<any>
	window.Close(bufnr)

	const job = GetJob(bufnr)
 	var dead = false
 	if type(job) == v:t_job
 		dead = job_status(job) == 'dead'
 	endif

 	if dead
 		execute 'bdelete! ' .. bufnr
 	endif
	return { type: 'close', bufnr: bufnr }
enddef
