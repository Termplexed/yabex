" """"""""""""""""""""""""""""""""""""""""""""""""""""" Figlet -w 80 -c -f block
"                                                                              "
"           _|      _|    _|_|    _|_|_|    _|_|_|_|  _|      _|               "
"             _|  _|    _|    _|  _|    _|  _|          _|  _|                 "
"               _|      _|_|_|_|  _|_|_|    _|_|_|        _|                   "
"               _|      _|    _|  _|    _|  _|          _|  _|                 "
"               _|      _|    _|  _|_|_|    _|_|_|_|  _|      _|               "
"                                                                              "
"                  _|_|_|_|    _|_|_|  _|    _|    _|_|                        "
"                  _|        _|        _|    _|  _|    _|                      "
"                  _|_|_|    _|        _|_|_|_|  _|    _|                      "
"                  _|        _|        _|    _|  _|    _|                      "
"                  _|_|_|_|    _|_|_|  _|    _|    _|_|                        "
"                                                                              "
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:cpo_bak = &cpo
set cpo&vim

fun! s:echo(hi, s, persistent)
	exe "echohl " . a:hi
	if a:persistent
		echom a:s
	else
		echo a:s
	endif
	echohl None
endfun

" NVim does not support optional arguments so we resort to ...
fun! yabex#echo#error(s, ...)
	call s:echo('ErrorMsg', a:s, a:0 ? a:000[0] : 0)
endfun
fun! yabex#echo#warn(s, ...)
	call s:echo('WarningMsg', a:s, a:0 ? a:000[0] : 0)
endfun
fun! yabex#echo#info(s, ...)
	call s:echo('Debug', a:s, a:0 ? a:000[0] : 0)
endfun

let &cpo= s:cpo_bak
unlet s:cpo_bak
