vim9script

# if exists("g:loaded_workflow")
# 	finish
# endif
# g:loaded_workflow = 1

au! BufNewFile,BufRead */tests/*.spec.js execute SetVuetestFile()
def SetVuetestFile(): string
	setlocal ft=vuetest
	return ''
enddef

# quickfix {{{1
# oldfiles {{{2
command! -nargs=0 -bar QO call setqflist([], ' ', {'lines': v:oldfiles, 'efm': '%f', 'quickfixtextfunc': 'QfOldFiles'})
def QfOldFiles(info: dict<any>): list<string>
	const items = getqflist({'id': info.id, 'items': 1}).items
	var l = []
	for idx in range(info.start_idx - 1, info.end_idx - 1)
		call add(l, fnamemodify(bufname(items[idx].bufnr), ':p:.'))
	endfor
	return l
enddef

# compile {{{2
# var name
def TerminalToggle()
	const active = TerminalIsActive()
	if !active
		TerminalOpen()
	else
		TerminalClose()
	endif
enddef

def TerminalIsActive(): bool
	const bid = GetTerminalBid()
	echomsg 'is active, bid: ' .. bid

	var active = false
	if bid > 0 && bufname(bid) != ''
		echomsg 'is active, name: ' .. bufname(bid)
		echomsg 'is active, bufwinnr: ' .. bufwinnr(bid)
		active = bufwinnr(bid) > 0
	endif
	echomsg 'is active, active: ' .. active
	return active
enddef

# get term bid
def GetTerminalBid(): number
	const bname = get(b:, 'terminal_bid_name', 'terminal_default_bid')
	const bid = get(t:, bname, -1)
	echomsg 'GetTerminalBid, bid: ' .. bid
	return bid
enddef

def TerminalOpen()
	const bid = GetTerminalBid()
	const isCreated = CheckBufIsCreated(bid)
	echomsg 'buf isCreated: ' .. isCreated
	if !isCreated
		call CreateTerminalWindow()
	endif
enddef

def CheckBufIsCreated(bid: number): bool
	const name = bufname(bid)
	echomsg 'CheckBufIsCreated, name: ' .. name

	var isCreated = false
	if name != ''
		const wid = bufwinnr(bid)
		echomsg 'CheckBufIsCreated, wid: ' .. wid
		if wid < 0
			CreateAWindow()
			echomsg 'change b to ' .. bid
			execute 'b ' .. bid
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

def CreateTerminalWindow()
	const cd = haslocaldir() ? ((haslocaldir() == 1) ? 'lcd' : 'tcd') : 'cd'
	const savedir = getcwd()
	const workdir = (expand('%') == '') ? getcwd() : expand('%:p:h')
	echomsg 'CreateTerminalWindow, cd: ' .. cd
	echomsg 'CreateTerminalWindow, savedir: ' .. savedir
	echomsg 'CreateTerminalWindow, workdir: ' .. workdir
	silent execute cd .. ' ' .. fnameescape(workdir)

	CreateAWindow()

	const bid = CreateAJob()
	const bidname = get(b:, 'terminal_bid_name', 'terminal_default_bid')
	settabvar(0, bidname, bid)
	echomsg 'set bidname: ' .. bidname .. ', bid: ' .. bid

	silent execute cd .. ' ' .. fnameescape(savedir)
enddef

def CreateAJob(): number
	const opts = {'curwin': 1, 'norestore': 1, 'term_finish': 'open'}
	echomsg 'CreateAJob, shell: ' .. &shell
	const bid = term_start(&shell, opts)
	const jid = term_getjob(bid)
	const jidname = get(b:, 'terminal_jid_name', 'terminal_default_jid')
	setbufvar(bid, jidname, jid)
	echomsg 'set bufvar jidname: ' .. jidname .. ', to jid: '
	echo jid

	# b:__terminal_jid__ = jid
	echomsg 'CreateAJob, job status: ' .. job_status(jid)

	return bid
enddef

def TerminalClose()
	const bidname = get(b:, 'terminal_bid_name', 'terminal_default_bid')
	const bid = get(t:, bidname, -1)
	echomsg 'TerminalClose, bid: ' .. bid
	if bid < 0
		return
	endif
	const name = bufname(bid)
	echomsg 'TerminalClose, name: ' .. name
	if name == ''
		return
	endif
	const wid = bufwinnr(bid)
	echomsg 'TerminalClose, wid: ' .. wid
	if wid < 0
		return
	endif

	if wid != winnr()
		const uid = win_getid()
		echomsg 'TerminalClose, not cur win, cur winid: ' .. uid
		execute "normal! " .. wid .. "\<c-w>w"
		echomsg 'TerminalClose, change window: ' .. wid
		close
		echomsg 'TerminalClose, back window: ' .. uid
		call win_gotoid(uid)
	else
		echomsg 'TerminalClose, is window, close'
		close
	endif

	const jidname = get(b:, 'terminal_jid_name', 'terminal_default_jid')
	const jid = getbufvar(bid, jidname, -1)
	echomsg 'TerminalClose, job_status: ' .. job_status(jid)

	var dead = false
	if type(jid) == v:t_job
		dead = job_status(jid) == 'dead'
	endif
	if dead
		execute 'bdelete! ' .. bid
	endif
enddef

# nnoremap <leader>m :call <SID>Compile()<cr>
# nnoremap <leader>m :call <SID>TerminalIsActive()<cr>
nnoremap <leader>m :call <SID>TerminalToggle()<cr>
def AppendGitRoot(key: number, path: string): string
	const root = split(system('git rev-parse --show-toplevel'), '\n')[0]
	return root .. '/' .. path
enddef

def Compile()
	var modified = split(system('git ls-files -m'), '\n')
	map(modified, function('AppendGitRoot'))
	map(modified, "join(split(v:val, '/'), '\\\\')")

	const curfiles = join(modified)
	if empty(curfiles)
		return
	endif

	# const temp = &makeprg
	# &makeprg = 'npm run lint $*'
	# execute 'make' curfiles
	# &makeprg = temp

	const cmd = '/g/study/vue/demo/vue-project/abc.sh'
	# echomsg 'cmd: '
	# echomsg cmd
	# const job = job_start(cmd)
	const job = job_start(cmd, {'out_io': 'buffer', 'out_name': 'log'})
	#
	# # job = job_start('npm run lint')
	# echomsg 'job status: ' .. job_status(job)
enddef

# RunTermJob
nnoremap <leader>r :<c-u>call <SID>RunTermJob()<cr>
def RunTermJob()
	const runcmd = &makeprg
	const cmd = runcmd .. " " .. expand("%:p") .. "\<CR>"
	call term_sendkeys(2, cmd)
enddef

# ClearTerm
nnoremap <leader><c-l> :<c-u>call <SID>ClearTerm()<cr>
def ClearTerm()
	call term_sendkeys(2, "clear\<CR>")
enddef
