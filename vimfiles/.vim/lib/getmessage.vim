vim9script

export def GetMessage(count: string): string
	var nr = str2nr(count)
	var result = $'To {nr} we say '
	result ..= GetReply(nr)
	return result
enddef

def GetReply(nr: number): string
	if nr == 42
		return 'yes'
	elseif nr == 22
		return 'maybe'
	else
		return 'no'
	endif
enddef
