vim9script

if exists('g:load_ft_vuetest_vim')
	finish
endif
g:load_ft_vuetest_vim = 1

setlocal sw=2
setlocal nonumber
setlocal foldmethod=indent
setlocal makeprg=yarn\ test

b:terminal_bid_name = 'terminal_vuetest_bid'
b:terminal_jid_name = 'terminal_vuetest_jid'
