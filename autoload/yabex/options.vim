" """"""""""""""""""""""""""""""""""""""""""""""""""""" Figlet -w 80 -c -f block
"                                                                              "
"           _|      _|    _|_|    _|_|_|    _|_|_|_|  _|      _|               "
"             _|  _|    _|    _|  _|    _|  _|          _|  _|                 "
"               _|      _|_|_|_|  _|_|_|    _|_|_|        _|                   "
"               _|      _|    _|  _|    _|  _|          _|  _|                 "
"               _|      _|    _|  _|_|_|    _|_|_|_|  _|      _|               "
"                                                                              "
"    _|_|    _|_|_|    _|_|_|_|_|  _|_|_|    _|_|    _|      _|    _|_|_|      "
"  _|    _|  _|    _|      _|        _|    _|    _|  _|_|    _|  _|            "
"  _|    _|  _|_|_|        _|        _|    _|    _|  _|  _|  _|    _|_|        "
"  _|    _|  _|            _|        _|    _|    _|  _|    _|_|        _|      "
"    _|_|    _|            _|      _|_|_|    _|_|    _|      _|  _|_|_|        "
"                                                                              "
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CNF WINDOW                                                                {{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"
"
"                              C N F   W I N D O W
"
"                            The Yabex Window options
"
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
let s:cnf_win = {
	\ 'pos'			: 'W',
	\ 'focus_on_toggle'	: 1,
	\ 'exit_alone'		: 0,
	\ 'vertical'		: 1,
	\ 'size'		: 25,
	\ 'winnr_show'		: 1,
	\ 'single_click_open' 	: 1,
	\ 'winnr_hl' : { 'cur' 	: 'YabexWinActive',
			\ 'oth'	: 'YabexWinVisible',
			\ 'alta': 'YabexWinAltAct',
			\ 'alt'	: 'YabexWinAltern' }
	\ }
fun! s:win_init()
	"# Default Config:      ----------------------------------------------
	"   Yabex_pos               - N,E,S,W
	"   Yabex_focus_on_toggle   - Set focus on toggle
	"   Yabex_exit_alone        - Close VIM if alone
	"   Yabex_size              - Columns / Lines
	"   Yabex_winnr_show        - Window number in gutter
	"   Todo:
	"   This is used in ft. Find a way to fix.
	"   See bottom of this file.
	"   Yabex_single_click_open - Open buffers by single click
	"
	"
	for [k, v] in items(s:cnf_win)
		if exists('g:Yabex_' . k)
			let n = str2nr(g:Yabex_{k})
			if n =~'^[01]$'
				let s:cnf_win[k] = n
			else
				call yabex#echo#warn(
					\ 'Yabex: "' . n .
					\ '", not valid value for ' . k,
					\ 1)
			endif
		endif
	endfor
	if exists('g:Yabex_size')
		let n = str2nr(g:Yabex_size)
		if n > 2
			let s:cnf_win.size = n
		else
			call yabex#echo#warn(
				\ 'Yabex: "' . n . '", not valid value for Size',
				\ 1)
		endif
	endif
	" Non-configurable configuration:
	let s:cnf_win.vertical = s:cnf_win.pos == 'E' || s:cnf_win.pos == 'W'
	return s:cnf_win
endfun
" }}}
" CNF BUFFER                                                                {{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"
"
"                           C N F   B U F F E R
"
"                         The Yabex Buffer options
"
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
let s:cnf_buf = {
	\ 'name': '[_-::YABEX::-_]',
	\ 'hi_whole_line'  : 1,
	\ 'reset_on_close' : 1,
	\ }
fun! s:buf_init()
	return s:cnf_buf
endfun
" }}}
" CNF BUF-LIST                                                              {{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"
"
"                        C N F  B U F F E R - L I S T
"
"                       The Yabex Buffer list options
"
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" Used to validate List Options
function! s:validate_list_option(key, pat)
	if s:buf_list[a:key] !~ a:pat
		call yabex#echo#warn(
			\ 'Yabex: "' . s:buf_list[a:key]
			\  . '", not valid value for ' . a:key,
			\ 1)
		let s:buf_list[a:key] = s:default_list_options[a:key]
	endif
endfunction
let s:ereg = {
	\ 'LOStitle'    : '^[tpshr]$',
	\ 'LOSsort'     : '^\([DI][tdpb]\|[tdpb][DI]\|[tdpb]\)$',
	\ 'LOSsortFlag' : '^\(I\|D\|DI\|ID\)$',
	\ 'LOShview'    : '^[gmh]$',
	\ 'Buftype'     : '^[nhw]$',
	\ 'Bufvar'      : '^[nhw]$' }
" Note: norm_sort and hidd_sort are dictified in init()
let s:buf_list = {
	\ 'name'     : { 'norm':   't', 'hidd': 't' },
	\ 'sort'     : { 'norm': 'tIE', 'hidd': 'p' },
	\ 'fold'     : { 'norm':     0, 'hidd':  0  },
	\ 'visible'  : { 'norm':     1, 'hidd':  1  },
	\ 'order'    : [ 'norm', 'hidd' ],
	\ 'grouping' : 'g' }
fun! s:buf_list_init() abort
	" XXX: Changed
	"# Default List Options:    ------------------------------------------
	" NEW name { }
	"   normName, hiddName    : 't' = only name (title)
	"                           'p' = full path
	"                           's' = path shorten
	"                           'h' = rel to home
	"                           'r' = rel to home or current
	" NEW: sort {}
	"   normSort, hiddSort    : ''  = no sort
	"                           't' = sort by name
	"                           'd' = sort by path ("directory")
	"                           'p' = sort by path+name
	"                           'b' = sort by buffer number
	" ADD: from getbufinifo()['variables']
	"      U (lastused)
	"      X (changedtick)
	"      L (linecount)
	"      l (loaded)
	"                           Additionally:
	"                            I  = don't ignore case
	"                            E  = extension first
	"                            D  = descending
	"                            -  If hidden files are mixed with the
	"                               rest of the sorting is performed
	"                               according to normSort
	"                            nope: use hiddView instead
	" NEW: fold {}
	"   normFold, hiddFold    :  0  = not folded
	"                            1  = folded
	" NEW: grouping
	" XX  hiddView              : 'g' = group at bottom
	" XX                          'm' = mix all,
	" XX                          'h' = do not show

	" Check / set from global Dictionary
	if exists('g:Yabex_ListOptions')
		for [k, v] in items(s:buf_list)
			let s:buf_list[k] = get(g:Yabex_ListOptions, k , v)
		endfor
	endif
	" Check / set from individual's
	for [k, v] in items(s:buf_list)
		if exists('g:Yabex_LOS_' . k)
			let s:buf_list[k] =
				\ substitute(g:Yabex_LOS_{k}, ' ', '', 'g')
		endif
	endfor
	" TODO: This should be integrated in previous for loop
"	call s:validate_list_option('norm_name', s:ereg.LOStitle)
"	call s:validate_list_option('hidd_name', s:ereg.LOStitle)
"	call s:validate_list_option('norm_sort', s:ereg.LOSsort)
"	call s:validate_list_option('hidd_sort', s:ereg.LOSsort)
"	call s:validate_list_option('norm_fold', '^[01]$')
"	call s:validate_list_option('hidd_fold', '^[01]$')
	" call s:validate_list_option('hidd_view', s:ereg.LOShview)

	" Extract combination flags from sort conf
	let l:re_flags = '\%(\([bdtp]\)\|\(I\)\|\(D\)\|\(E\)\)*'
	let ns = matchlist(s:buf_list.sort.norm, l:re_flags)
	let hs = matchlist(s:buf_list.sort.hidd, l:re_flags)

	" call g:Deblog2.objdump('NS', ns)

	let s:buf_list.sort.norm = {
		\ 'order': len(ns) ? ns[1] : '',
		\ 'case' : len(ns) && ns[2] !=# 'I',
		\ 'asc'  : len(ns) && ns[3] !=# 'D',
		\ 'ext'  : len(ns) && ns[4] ==# 'E'
		\}
	let s:buf_list.sort.hidd = {
		\ 'order': len(hs) ? hs[1] : '',
		\ 'case' : len(hs) && hs[2] !=# 'I',
		\ 'asc'  : len(hs) && hs[3] !=# 'D',
		\ 'ext'  : len(ns) && ns[4] ==# 'E'
		\}

	" call g:Deblog2.objdump('SB', s:buf_list)

	return s:buf_list
endfun
" }}}
" CNF FILTER                                                                {{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"
"
"                         C N F   F I L T E R
"
"              Filter: What to classify as hidden buffers
"
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
let s:filter = { }
fun! s:filter_init()
	"# What buffers to consider hidden PRI#1: ----------------------------
	" XXX: XXX:X XXX: BUF_NAME Have to be begotten before this ...
	let s:filter.bufnames = [
		\ s:cnf_buf.name,
		\ '__Tag_List__',
		\ '__MRU_Files__'
		\ ]
	if exists('g:Yabex_filter_bufnames')
		let tmp = split(g:Yabex_filter_bufnames, '\s*[,:; ]\s*')
		call extend(s:filter.bufnames, tmp)
		unlet tmp
	endif
	"# What buffers to consider hidden PRI#2: ----------------------------
	" See :help buftype
	" '', 'nofile', 'nowrite', 'acwrite', 'quickfix', 'help'
	" User option let g:Yabex_HideBuftype = 'nofile:n help:w'
	let s:filter.buftypes    = {
		\ 'nofile'  : 'h',
		\ 'nowrite' : 'h',
		\ 'quickfix': 'h',
		\ 'help'    : 'h',
		\ 'terminal': 't',
		\ 'prompt'  : 'h',
		\ 'popup'   : 'h'
		\ }
	if exists('g:Yabex_filter_buftypes')
		let tmp = split(g:Yabex_filter_buftypes, '\s*[,; ]\s*')
		for itm in tmp
			let kv = split(itm, '\s*[:]\s*')
			if len(kv)!=2 || kv[1]!~#s:ereg.Buftype
				call yabex#echo#warn(
					\ 'Yabex: Ignore Buftype => "' . itm .
					\ '", has wrong format',
					\ 1)
			else
				call extend(s:filter.buftypes, {kv[0] : kv[1]})
			endif
		endfor
		unlet tmp
	endif
	"# What buffers to consider hidden PRI#3: ----------------------------
	" 'bufvar' : hidden if has val
	" ie 'foo':0 -> hidden if getbufvar(i, '&foo') == 0
	let s:filter.bufvar    = {
		\ 'modifiable'  :'n',
		\ 'buflisted'   :'n',
		\ 'nomodifiable':'h',
		\ 'nobuflisted' :'h'
	\ }
	if exists('g:Yabex_filter_bufvar')
		let tmp = split(g:Yabex_filter_bufvar, '\s*[,; ]\s*')
		for itm in tmp
			let kv = split(itm, '\s*[:]\s*')
			if len(kv)!=2 || kv[1]!~#s:ereg.Bufvar
				call yabex#echo#warn(
					\ 'Yabex: Ignore Bufvar => "' . itm .
					\ '", has wrong format',
					\ 1)
			else
				call extend(s:filter.bufvar, {kv[0] : kv[1]})
			endif
		endfor
		unlet tmp
	endif
	return s:filter
endfun
" }}}
" CNF GLOBAL                                                                {{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"
"
"                     C N F   G L O B A L   A C C E S S
"
"
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fun! yabex#options#get(o)
	return s:{a:o}_init()
endfun

" Todo: Fix this
" Options: Global for
" 	ft : ftplugin/yabex-ft.vim
let yabex#win#cnf = {
	\ 'ft': {
		\ 'single_click_open': 1
	\ }
\ }


" XXX FINE
" XXX FINE
" XXX FINE
finish
" XXX NOOP
" XXX NOOP
" XXX NOOP

" Global AP
"
let yabex#options#get = {
	\ 'win' : function('s:win_init'),
	\ 'buf' : function('s:buf_init'),
	\ 'list' : function('s:buf_list_init'),
	\ 'filter' : function('s:filter_init')
	\ }
" }}}
" vim:foldmethod=marker
