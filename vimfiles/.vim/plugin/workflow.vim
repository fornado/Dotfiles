vim9script

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
nnoremap <leader>m :call <SID>Compile()<cr>
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
