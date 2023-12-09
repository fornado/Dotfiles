vim9script

# terminal toggle
export def TerminalToggle(buf_key: string = "t_buf_key", job_key: string = "t_job_key" )
	const active = TerminalIsActive(buf_key)
	if !active
		TerminalOpen(buf_key, job_key)
	else
		TerminalClose(buf_key, job_key)
	endif
enddef

#  if active
def TerminalIsActive(buf_key: string): bool
	const bufnr = GetTerminalBid(buf_key)
	echomsg 'call is active, bufnr: ' .. bufnr

	var active = false
	if bufnr > 0 && bufname(bufnr) != ''
		echomsg 'is active, name: ' .. bufname(bufnr)
		echomsg 'is active, bufwinnr: ' .. bufwinnr(bufnr)
		active = bufwinnr(bufnr) > 0
	endif
	echomsg 'is term buf, active: ' .. active
	return active
enddef


# open terminal window
export def TerminalOpen(buf_key: string, job_key: string)
	const bufnr = GetTerminalBid(buf_key)
	echomsg 'call term open, bufnr: ' .. bufnr

	const isCreated = CheckBufIsCreated(bufnr)
	echomsg 'buf isCreated: ' .. isCreated
	if !isCreated
		call CreateTerminalWindow(buf_key, job_key)
	endif
enddef

# get term bufnr
def GetTerminalBid(buf_key: string): number
	const bufnr = get(t:, buf_key, -1)
	echomsg 'GetTerminalBid, bufnr: ' .. bufnr
	return bufnr
enddef

def CheckBufIsCreated(bufnr: number): bool
	const name = bufname(bufnr)
	echomsg 'call CheckBufIsCreated, name: ' .. name

	var isCreated = false
	if name != ''
		const wid = bufwinnr(bufnr)
		if wid < 0
			CreateAWindow()
			echomsg 'change b to ' .. bufnr
			execute 'b ' .. bufnr
		else
			echomsg 'change window to ' .. wid
			execute "normal! " .. wid .. "\<c-w>w"
		endif
		isCreated = true
	endif
	echomsg 'CheckBufIsCreated, return: ' .. isCreated
	return isCreated
enddef

def CreateAWindow()
	echomsg 'CreateAWindow...'
	execute 'rightbelow split'
	setlocal nonumber norelativenumber signcolumn=no
	setlocal bufhidden=hide
enddef

def CreateTerminalWindow(buf_key: string, job_key: string)
	echomsg "call CreateTerminalWindow..."

	const cd = haslocaldir() ? ((haslocaldir() == 1) ? 'lcd' : 'tcd') : 'cd'
	const savedir = getcwd()
	const workdir = (expand('%') == '') ? getcwd() : expand('%:p:h')
	echomsg 'CreateTerminalWindow, cd: ' .. cd
	echomsg 'CreateTerminalWindow, savedir: ' .. savedir
	echomsg 'CreateTerminalWindow, workdir: ' .. workdir
	silent execute cd .. ' ' .. fnameescape(workdir)

	CreateAWindow()

	const bufnr = CreateAJob(job_key)
	settabvar(0, buf_key, bufnr)
	echomsg 'set tabvar buf_key: ' .. buf_key .. ', bufnr: ' .. bufnr

	silent execute cd .. ' ' .. fnameescape(savedir)
enddef

def CreateAJob(job_key: string): number
	echomsg "call CreateAJob..."
	const opts = {'curwin': 1, 'norestore': 1, 'term_finish': 'open'}
	echomsg 'CreateAJob, shell: ' .. &shell
	const bufnr = term_start(&shell, opts)
	const job = term_getjob(bufnr)
	setbufvar(bufnr, job_key, job)
	echomsg 'set bufvar bufnr: ' .. bufnr .. ', with job: '
	echo job

	echomsg 'CreateAJob, job status: ' .. job_status(job)

	return bufnr
enddef

def TerminalClose(buf_key: string, job_key: string)
	const bufnr = get(t:, buf_key, -1)
	echomsg 'call TerminalClose, bufnr: ' .. bufnr
	if bufnr < 0
		return
	endif
	const name = bufname(bufnr)
	echomsg 'TerminalClose, name: ' .. name
	if name == ''
		return
	endif

	const wid = bufwinnr(bufnr)
	echomsg 'TerminalClose, wid: ' .. wid
	if wid < 0
		return
	endif

	if wid != winnr()
		const cwid = win_getid()
		echomsg 'TerminalClose, not cur win, cur winid: ' .. cwid
		execute "normal! " .. wid .. "\<c-w>w"
		echomsg 'TerminalClose, change window: ' .. wid
		close
		echomsg 'TerminalClose, back window: ' .. cwid
		call win_gotoid(cwid)
	else
		echomsg 'TerminalClose, is window, close'
		close
	endif

 	const job = getbufvar(bufnr, job_key, -1)
 	echomsg 'TerminalClose, job_status: ' .. job_status(job)

 	var dead = false
 	if type(job) == v:t_job
 		dead = job_status(job) == 'dead'
 	endif
 	if dead
 		execute 'bdelete! ' .. bufnr
 	endif
enddef
