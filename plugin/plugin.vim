" """"""""""""""""""""""""""""""""""""""""""""""""""""" Figlet -w 80 -c -f block
"                                                                              "
"           _|      _|    _|_|    _|_|_|    _|_|_|_|  _|      _|               "
"             _|  _|    _|    _|  _|    _|  _|          _|  _|                 "
"               _|      _|_|_|_|  _|_|_|    _|_|_|        _|                   "
"               _|      _|    _|  _|    _|  _|          _|  _|                 "
"               _|      _|    _|  _|_|_|    _|_|_|_|  _|      _|               "
"                                                                              "
"        _|_|_|    _|        _|    _|    _|_|_|  _|_|_|  _|      _|            "
"        _|    _|  _|        _|    _|  _|          _|    _|_|    _|            "
"        _|_|_|    _|        _|    _|  _|  _|_|    _|    _|  _|  _|            "
"        _|        _|        _|    _|  _|    _|    _|    _|    _|_|            "
"        _|        _|_|_|_|    _|_|      _|_|_|  _|_|_|  _|      _|            "
"                                                                              "
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:cpo_bak = &cpo
set cpo&vim

let g:Yabex_version = "0.0.7"

fun! s:def_commands()
	command! -nargs=? -bar YabexToggle :call yabex#win_buf#toggle(<q-args>)

	" Todo:
	"command! -nargs=0 -bar YabexHere :call yabex#win_buf#toggle(2)
endfun
fun! s:set_maps()
	" Todo: Implement
	" map     <S-left>      <ESC>:YabexHere<CR>

	map     <left>      <ESC>:YabexToggle<CR>
endfun

call s:def_commands()
" call s:set_maps()

let &cpo= s:cpo_bak
unlet s:cpo_bak
