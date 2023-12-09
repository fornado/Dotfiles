vim9script noclear

if exists('b:vuetest_ftplugin')
	# finish
endif
b:vuetest_ftplugin = 1

source $VIMRUNTIME/ftplugin/javascript.vim

setlocal sw=2
setlocal tabstop=2
setlocal nonumber
setlocal foldmethod=indent
setlocal makeprg=yarn\ test

nnoremap <buffer> <leader>m :call <SID>Make()<cr>

b:terminal_bid_name = 'terminal_vuetest_bid'
b:terminal_jid_name = 'terminal_vuetest_jid'

if exists('s:load_ft_vuetest_vim')
	# finish
endif
const load_ft_vuetest_vim = 1

# make
var job: any = null
def Make()
	# terminal is open
	job = job_start("ls", { "out_cb": "MyHandler" })
	echomsg 'start job: '
	echo job
	echomsg 'status: '
	echomsg job_status(job)
enddef

def MyHandler(channel: any, msg: string)
	echomsg 'call MyHandler...'
	echomsg 'channe: '
	echomsg string(channel)
	echomsg ', msg: ' .. msg
enddef
