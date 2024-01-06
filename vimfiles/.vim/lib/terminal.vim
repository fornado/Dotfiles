vim9script noclear

import autoload $LIB .. "/window.vim" as Window
import autoload $LIB .. "/buffer.vim" as Buffer
import autoload $LIB .. "/job.vim" as Job

# toggle terminal window
export def Toggle(bufnr: number = -1): number
	const isActive = Buffer.IsActive(bufnr)
	if !isActive
		return Open(bufnr)
	else
		return Close(bufnr)
	endif
enddef

# open a terminal window
export def Open(bufnr: number = -1): number
	var nr = bufnr
	const wid = bufwinnr(nr)
	if nr < 0
		nr = CreateBufWindow()
	elseif wid < 0
		Window.Create()
		execute 'b ' .. nr
	else
		execute "normal! " .. wid .. "\<c-w>w"
	endif
	return nr
enddef

def CreateBufWindow(): number
	const cd = haslocaldir() ? ((haslocaldir() == 1) ? 'lcd' : 'tcd') : 'cd'
	const savedir = getcwd()
	const workdir = (expand('%') == '') ? getcwd() : expand('%:p:h')
	silent execute cd .. ' ' .. fnameescape(workdir)

	Window.Create()
	const bufnr = Job.Create()

	silent execute cd .. ' ' .. fnameescape(savedir)
	return bufnr
enddef

export def Close(bufnr: number = -1)
	Window.Close(bufnr)

	const job = Job.Get(bufnr)
 	var dead = false
 	if type(job) == v:t_job
 		dead = job_status(job) == 'dead'
 	endif

 	if dead
 		execute 'bdelete! ' .. bufnr
 	endif
enddef
