;https://www.autohotkey.com/docs/Tutorial.htm
;http://ahkcn.sourceforge.net/docs/Hotkeys.htm
;https://blog.csdn.net/u013332124/article/details/80680038

;{CapsLock}e::^e
!m::
WinMinimize,A
return

;!{space}::#q

!b::
Send ^c
sleep,100
run https://www.baidu.com/s?wd=%clipboard%&rsv_spt=1&rsv_iqid=0x84bc1e1400076d64&issp=1&f=8&rsv_bp=1&rsv_idx=2&ie=utf-8&tn=baiduhome_pg&rsv_enter=1&rsv_dl=tb&rsv_sug3=6&rsv_sug1=4&rsv_sug7=101&rsv_sug2=0&rsv_btype=i&prefixsug=%clipboard%&rsp=7&inputT=1210&rsv_sug4=3228
return

!d::
Send {Home}
Send +{End}
Send {delete}
return

!y::
Send {Home}
Send +{End}
Send ^c
return

!p::
Send {End}
Send {Enter}
Send %clipboard%
return

!f::
run f:
return

;CapsLock::Ctrl

tmp_path=f:
typora_path=F:\downloads\Typora\Typora.exe
!c::
  inputBox,command,enter command
  if ErrorLevel
	return
  else
	if (command=="typora")
		run %typora_path%
	else
		run https://www.baidu.com
  return
