" """"""""""""""""""""""""""""""""""""""""""""""""""""" Figlet -w 80 -c -f block
"                                                                              "
"           _|      _|    _|_|    _|_|_|    _|_|_|_|  _|      _|               "
"             _|  _|    _|    _|  _|    _|  _|          _|  _|                 "
"               _|      _|_|_|_|  _|_|_|    _|_|_|        _|                   "
"               _|      _|    _|  _|    _|  _|          _|  _|                 "
"               _|      _|    _|  _|_|_|    _|_|_|_|  _|      _|               "
"                                                                              "
" _|          _|  _|_|_|  _|      _|           _|_|_|    _|    _|  _|_|_|_|    "
" _|          _|    _|    _|_|    _|           _|    _|  _|    _|  _|          "
" _|    _|    _|    _|    _|  _|  _|  |_|_|_|  _|_|_|    _|    _|  _|_|_|      "
"   _|  _|  _|      _|    _|    _|_|           _|    _|  _|    _|  _|          "
"     _|  _|      _|_|_|  _|      _|           _|_|_|      _|_|    _|          "
"                                                                              "
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" To use DUMP, LLOG etc see:
" https://github.com/Termplexed/deblog
"
" for c in g:Deblog2.boot([], ['LLOG2']) | exe c | endfor
" for c in g:Deblog2.boot() | exe c | endfor
" call g:Deblog2.mute(['LLOG2'])
" call g:Deblog2.mute()
" for c in g:Deblog2.unmute(['LLOG2']) | exe c | endfor

if exists('s:state')
	let s:bak = copy(s:state)
endif

" NOTE: mybufnr can not be zero as bufexists(0) is alternate buffer
" XXX: Same for curwinnr? Check.
let s:state = {
	\ 'mybufnr': get(s:, 'state.mybufnr', -1),
	\ 'oldwinid': -1,
	\ 'oldbufnr': 0,
	\ 'curwinnr': 0,
	\ 'curbufnr': 0,
	\ 'buflen': 0,
	\ 'mywinnr': -1,
	\ 'curwinid': -1,
	\ 'mywinwidth': 25
	\ }

if exists('s:bak')
	let s:state.mybufnr = s:bak.mybufnr
	unlet s:bak
endif

let s:cnf = {  }

"function! s:keep_patterns(s, q)
"	" q = "silent") neovim hickup
"	if exists(':keeppatterns')
"		call execute('keeppatterns ' . a:s, a:q)
"	else
"		let kept = @/
"		call execute(a:q . " " . a:s)
"		silent call histdel('/', -1)
"		let @/ = kept
"	endif
"endfunction
fun! s:exec_noev(cmd)
	let old_eventignore = &eventignore
	set eventignore=all
	call execute(a:cmd)
	let &eventignore = old_eventignore
endfun
fun! s:is_visible()
	return s:state.mybufnr != -1 && bufwinnr(s:state.mybufnr) != -1
endfun
fun! s:get_cursor_state()
	let wid = bufwinid(s:state.mybufnr)
	return getcurpos(wid)
	return [col('.'), line('.', wid), line('w0', wid)]
endfun
" Set cursor to given possition from list [x, y, off]
" Restore window scroll.
fun! s:set_cursor_state(c)
	if v:version >= 601
		"call cursor(a:cursXY[1], a:cursXY[0])
		let old_so = &scrolloff
		let &scrolloff = 0
		call cursor(a:c[2], 1)
		normal! zt
		call cursor(a:c[1], a:c[0])
		let &scrolloff = old_so
	else
		exe a:c[1]
		exe 'normal! ' . a:c[0] . '|'
	endif
endfun

" """"""""""""""""""""""""""""""""""""""""""""""""""""" Figlet -w 80 -c -f block
"                                                                              "
"                    _|          _|  _|_|_|  _|      _|                        "
"                    _|          _|    _|    _|_|    _|                        "
"                    _|    _|    _|    _|    _|  _|  _|                        "
"                      _|  _|  _|      _|    _|    _|_|                        "
"                        _|  _|      _|_|_|  _|      _|                        "
"                                                                              "
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let s:cnf.win = yabex#options#get_win()
let s:cnf.win = yabex#options#get('win')

" ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯0
fun! s:win_gutter_update(w, hl)
	let s = sign_getdefined('YABEXW' . a:w)
	if len(s)
		let s = s[0]
		let s.texthl = s:cnf.win.winnr_hl[a:hl]
		call sign_define(s.name, s)
	endif
endfun
" Add winnr in gutter
fun! s:win_gutter_add(l, w)
	if ! s:cnf.win.winnr_show
		return
	endif
	let w = a:w > 999 ? win_id2win(a:w) : a:w + 0
	let gl = a:l
	let gr = 'YABEX'
	let name = gr . 'W' . w
	" XXX Remove if not debugging
	if len(sign_getdefined(name))
		call sign_undefine(name)
	endif
	if w == bufwinnr(s:state.mybufnr)
		let gl = 1
	endif
	if ! len(sign_getdefined(name))
		let state = winnr() == w ? 'cur' : (winnr('#') == w ? 'alt' :  'oth')
		call sign_define(name, {
				\ 'text': w,
				\ 'texthl': s:cnf.win.winnr_hl[state] })
	endif

	call sign_place(w, gr, name, s:state.mybufnr, {'lnum': gl})
endfun
" Add winnr in gutter - by bufnr
fun! s:win_gutter_buffer(b)
	if ! has_key(s:buf_map, a:b) | return | endif
	let bl = s:buf_map[a:b].l
	let w = bufwinnr(a:b)
	if bl && w > -1
		call s:win_gutter_add(bl, w)
	endif
endfun
" Add winnr in gutter - by current buffer
fun! s:win_gutter_current()
	let b = bufnr('%')
	if ! has_key(s:buf_map, b) | return | endif
	let bl = s:buf_map[b].l
	if bl
		call s:win_gutter_add(bl, winnr())
	endif
endfun
" let s:win_meta = { 'a': 0, 'b': 0, 'c': 0, 'd': 0}
let s:state.altwinnr = -1
fun! s:au_win_enter()
	let l:yabex = winnr() == s:state.mywinnr
	call s:win_gutter_update(s:state.curwinnr, l:yabex ? 'alta' : 'alt')
	if s:state.altwinnr > -1 && s:state.curwinnr != s:state.altwinnr
		call s:win_gutter_update(s:state.altwinnr, 'oth')
	endif
	call s:win_gutter_current()
	let s:state.altwinnr = winnr('#')
	let s:state.curwinnr = winnr()
	let s:state.curbufnr = bufnr('%')
	let s:state.curwinid = win_getid()
	if winnr() == s:state.mywinnr
		" Todo: Find a solution for this
		"
		"if len(s:bak_cpos)
		"	call setpos('.', s:bak_cpos)
		"	let s:bak_cpos = []
		"endif
		return
	endif
	call s:check_yabex_win_width()
	call s:buf_syn_update(s:state.curbufnr)
endfun
fun! s:au_win_new()
	" let b = bufwinnr(expand('<afile>'))
	if winnr() != s:state.curwinnr
		call s:au_win_enter()
	else
		call s:check_yabex_win_width()
		call s:win_gutter_current()
		call s:buf_syn_update(s:state.curbufnr)
	endif
endfun
fun! s:exit_if_alone()
	if winbufnr(2) == -1
		if tabpagenr('$') == 1
			" bdelete
			quit
		else
			" More than one tab page is present
			" Close only the current tab page

			""""""""""""""""""""""""""""close
			"""" ADDED:
			bdelete
		endif
	endif
endfunction
fun! s:win_set_focus(new, old)
	let s:state.oldwinid = a:old > -1 ? a:old : win_getid()
	call win_gotoid(a:new)
	return s:state.oldwinid
endfun
fun! s:win_self_has_focus()
	return s:state.mybufnr != -1 && bufwinid(s:state.mybufnr) == win_getid()
endfun
fun! s:win_focus_self()
	let l:self = bufwinid(s:state.mybufnr)
	if l:self != -1
		if win_getid() != l:self
			call s:win_set_focus(l:self, -1)
		endif
		return l:self
	else
		return -1
	endif
endfun
fun! s:win_close_self()
	let s:bak_cpos = getcurpos(s:state.mywinnr)
	let wid = bufwinnr(s:state.mybufnr)
	if wid != -1
		exe wid . 'close'
	endif
	call s:autocmd_deactivate()
endfun
" modes:
" 	0: split + no focus
" 	1: split + focus
" 	2: current window  (XXX: NOT IMPLEMENTED :XXX)
fun! yabex#win_buf#toggle(mode)
	if a:mode == 2
		" call s:buf_create(1)
		echom "Yabex This Window: Not available yet"
	elseif s:is_visible()
		call s:win_close_self()
	else
		call s:win_create_self(a:mode)

		" Todo: Idea here is perhaps to have a popup with
		" detailed file information positioned at the
		" bottom ...
		"
		"call yabex#popup#load('foo', bufwinid(s:state.mybufnr))
	endif
endfun

fun! s:get_bufentry_focused()
	let bl = getline('.')
	if bl[0] < "A" || bl[0] > "F"
		return {'state': 1}
	endif
	let lv = split('x'.bl, ' \+')
	if len(lv) > 1 && lv[1] =~ '^\d\+$'
		return {'line': bl, 'bufnr': str2nr(lv[1]), 'name': lv[2], 'state': 0}
	else
		return {'state': 1}
	endif
endfun
let s:mapev = { }
fun! s:open_explore(dir)
	exec ":Explore " . a:dir
endfun
fun! s:open_term(dir)
	let cwd = getcwd()
	let s_acd = &acd
	set noacd
	call chdir(a:dir)
	noautocmd terminal
	doautocmd BufAdd
	doautocmd WinEnter
	call chdir(cwd)
	let &acd = s_acd
endfun
let s:last_gitdiff_buf = -1
fun! s:open_gitdiff(fn)
	let fn = shellescape(a:fn)
	let gg = system('git ls-files --error-unmatch -- ' . fn)
	if v:shell_error
		call yabex#echo#warn('File does not seem to be tracked', 1)
		return
	endif
	let gg = system('git diff-index --quiet HEAD -- ' . fn)
	if v:shell_error
		if s:last_gitdiff_buf > -1
			exe "b"..s:last_gitdiff_buf
			let ap = append(line('$'), repeat([''], 5))
			call cursor('$', 1)
		else
			new
			let s:last_gitdiff_buf = bufnr('%')
		endif
		setlocal buftype=nofile         " Mark as scratch
		setlocal noswapfile             " No swap for this please
		exe "r !git diff " . a:fn
		setlocal ft=diff
	else
		call yabex#echo#info("Up to date")
	endif
endfun
fun! s:open_buf(bnr)
	exec "b" . a:bnr
endfun
" m[0]  type (buf, explore, ...)
" m[1]  focus | nofocus
" m[2]  winnr - only present when from cmd line
" c     winnr - only when from map
fun! s:mapev.open(m, c) dict
	if bufnr('%') != s:state.mybufnr
		return
	endif
	"if ! s:win_self_has_focus()
	"	return "\<Ignore>"
	"endif
	let which = a:m[0]
	let focus = a:m[1] == 'focus'
	let wnr = a:c > 0 ? a:c : (len(a:m) > 2 ? a:m[2] : winnr('#'))
	let wid = win_getid(str2nr(wnr))
	if wid == 0
		call yabex#echo#warn("Window " . wnr . " does not exist", 1)
	elseif wid == win_getid()
		call yabex#echo#warn("Window " . wnr . " is the Yabex window", 1)
	endif
	let bl = getline('.')
	let vl = split(bl, ' \+')
	let is_bufln = bl =~ '^[A-F]'
	let wid_self = s:win_set_focus(wid, -1)
	if bl[0] == 'X'
		call s:open_explore('')
	elseif is_bufln && (
			\ which == 'explore' ||
			\ which == 'gitdiff' ||
			\ which == 'term')
		let binf = getbufinfo(str2nr(vl[1]))
		if ! len(binf) || empty(binf[0].name)
			call yabex#echo#warn("Buffer " . vl[1] . " does not have a location")
			return
		endif
		let dir = fnamemodify(binf[0].name, ':p:h')
		if which == 'explore'
			call s:open_explore(dir)
		elseif which == 'gitdiff'
			call s:open_gitdiff(binf[0].name)
		else
			call s:open_term(dir)
		endif
	elseif is_bufln
		call s:open_buf(vl[1])
	endif
	if ! focus
		call s:win_set_focus(wid_self, wid)
	endif
endfun
fun! s:mapev.bufdel(...) dict
	let cur = s:get_bufentry_focused()
	if cur.state != 0
		echohl Error
		echomsg "Unable to delete selected entry"
		echohl None
		return
	endif
	let bn = bufnr(cur.bufnr)
	for w in reverse(range(1, winnr('$')))
		if winbufnr(w) != bn
			continue
		endif
		exec w . "wincmd w"

		" Bprevious also wraps around the buffer list, if necessary:
		try
			if bufnr("#") > 0 && buflisted(bufnr("#"))
				buffer #
			else
				bprevious
			endif
		catch /^Vim([^)]*):E85:/ " E85: There is no listed buffer
		endtry

		" If found a new buffer for this window, mission accomplished:
		if bufnr("%") != bn
			continue
		endif
		call bufadd()
	endfor
	call s:win_focus_self()
	exec 'bdelete ' . bn
	" XXX: Let autocommand catch this
	" call s:refresh_buflist()
	" XXX
endfun
fun! s:mapev.name_norm(...) dict
	let s:cnf.buf_list.name.norm = a:1[0]
	call s:refresh_buflist()
	" let norm_name = s:cnf.buf_list.name.norm
endfun
fun! s:mapev.sort_norm(...) dict
	let s:cnf.buf_list.sort.norm.order = a:1[0]
	call s:refresh_buflist()
endfun
fun! s:mapev.grouping(...) dict
	let s:cnf.buf_list.grouping = a:1[0]
	call s:refresh_buflist()
endfun
fun! s:mapev.testmap(...)
	DUMP a:
	DUMP v:count
	DUMP v:count1
	return "\<Ignore>"
endfun
fun! yabex#win_buf#mapev(act, ...)
	call s:mapev[a:act](a:000, v:count)
	return "\<Ignore>"
endfun

let s:split_commands = {
	\ 'N': 'topleft',
	\ 'E': 'botright vertical',
	\ 'S': 'botright',
	\ 'W': 'topleft vertical'
	\}
fun! s:win_create_self(mode) abort
	let s:state.oldbufnr = bufnr('%')
	let s:state.oldwinid = win_getid()

	let w_pos  = s:cnf.win.pos
	let w_size = s:cnf.win.size

	" Create new buffer | Use existing
	if ! bufexists(s:state.mybufnr)
		" let s:state.mybufnr = bufadd(s:cnf.buf.name)
		let s:state.mybufnr = bufadd('')
		call bufload(s:state.mybufnr)
	endif

	let l:ex_create = a:mode == 0 ? 'keepalt ' : ''
	let l:ex_create .= s:split_commands[w_pos] . ' ' . w_size . ' split '
	let l:ex_create .= '+buffer' . s:state.mybufnr

	let l:ex_fixsize = s:cnf.win.vertical ? 'winfixwidth' : 'winfixheight'

	call s:exec_noev(l:ex_create)
	call execute('set ' . l:ex_fixsize . ' concealcursor=n')

	"setlocal concealcursor=n	" Hide Cursor
	call s:buf_init()
	call s:refresh_buflist()

	call s:autocmd_activate()

	autocmd BufLeave <buffer> let s:bak_cpos = getcurpos(s:state.mywinnr)
	autocmd BufEnter <buffer> if len(s:bak_cpos) | call setpos('.', s:bak_cpos) | endif

	if a:mode == 0
		call s:win_gutter_update(winnr(), 'alt')
		call s:win_set_focus(s:state.oldwinid, -1)
	endif

	let s:state.curbufnr = bufnr('%')
endfun

" """"""""""""""""""""""""""""""""""""""""""""""""""""" Figlet -w 80 -c -f block
"                                                                              "
"                       _|_|_|    _|    _|  _|_|_|_|                           "
"                       _|    _|  _|    _|  _|                                 "
"                       _|_|_|    _|    _|  _|_|_|                             "
"                       _|    _|  _|    _|  _|                                 "
"                       _|_|_|      _|_|    _|                                 "
"                                                                              "
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:cnf.buf = yabex#options#get('buf')
let s:cnf.buf_list = yabex#options#get('buf_list')
let s:cnf.filter = yabex#options#get('filter')

" Make own buffer read / write
fun! s:self_make_editable()
	let b = s:state.mybufnr
	"setlocal noreadonly modifiable noswapfile
	call setbufvar(b, '&swapfile', 0)
	call setbufvar(b, '&readonly', 0)
	call setbufvar(b, '&modifiable', 1)
endfun
" Make own buffer read only
fun! s:self_make_uneditable()
	let b = s:state.mybufnr
	call setbufvar(b, '&swapfile', 0)
	call setbufvar(b, '&readonly', 1)
	call setbufvar(b, '&modifiable', 0)
endfun
" Return [current line-number, text]
fun! s:self_get_bline(b)
	if ! s:is_visible()
		return
	endif
	if has_key(s:buf_map, a:b)
		let linenr = s:buf_map[a:b].l
		if linenr > 0
			let l = getbufline(s:state.mybufnr, linenr)[0]
			return [linenr, l]
		endif
	endif
	return []
endfun
fun! s:buf_create(fetch)
	if ! bufexists(s:state.mybufnr)
		let s:state.oldbufnr = bufnr('%')
		" let s:state.mybufnr = bufadd(s:cnf.buf.name)
		let s:state.mybufnr = bufadd('')
		call bufload(s:state.mybufnr)
		call s:buf_init()
		call s:refresh_buflist()
	endif
	" What is going on here?
	" Opened in opener window?
	if a:fetch
		call execute('noswap keepalt b' . s:state.mybufnr)
	endif
endfun

"fun! s:noswapp()
"	LLOG2 "noswap()"
"	setlocal noswapfile
"endfun
"fun! s:buf_self_add_autocmd()
"	augroup YabexAugroupSelf
"		autocmd!
"		exe 'autocmd BufEnter <buffer=' . s:state.mybufnr .
"					\ '> call s:au_on_self_focus()'
"		"autocmd BufLeave   <buffer> call s:au_on_self_blur()
"	augroup end
"endfun
fun! s:dbg_au(t)
	LLOG "\033[33m" . a:t . "\033[0m " . bufname('%')
endfun
let s:auc_bufdel = 0
let s:auc_bufadd = 0
let s:auv_bufwrite = []
let s:auc_counter = 0
"let s:auc_txtchange = 0
fun! s:au_bufadd_refresh(c)
	let s:auc_bufadd -= 1
	if s:auc_bufadd > 0
		return
	endif
	call s:refresh_buflist()
endfun
fun! s:au_bufdel_refresh(c)
	let s:auc_bufdel -= 1
	if s:auc_bufdel > 0
		return
	endif
	" TODO: refresh buffer list should be enough here?!
	call s:refresh_buflist()
	call s:au_win_enter()
endfun
fun! s:au_generic_refresh(...)
	call s:refresh_buflist()
endfun
fun! s:au_safe_refresh(c)
	let s:auc_counter -= 1
	if s:auc_counter > 0
		return
	endif
	call s:refresh_buflist()
	call s:au_win_enter()
endfun
fun! s:au_buf_enter()
"	if s:isClosing
"		YABDT "Yabex::BufEnter() - is closing"
"		return 0
"	endif
	let curbufnr = bufnr('%')
	if curbufnr == s:state.mybufnr
		return
	endif
	if s:state.curbufnr != curbufnr
		let s:state.curbufnr = curbufnr
		if ! s:is_visible()
			return
		endif
		call s:buf_syn_update(curbufnr)
		"call s:win_gutter_buffer(curbufnr)
	endif
endfun
fun! s:au_write_post()
	if ! len(s:auv_bufwrite)
		return
	endif
	let rebuild = 0
	let bv = getbufinfo()
	for bn in s:auv_bufwrite
		let b = bv[bn - 1]
		if ! has_key(s:buf_map, bn)
			let rebuild = 1
			break
		endif
		if s:buf_map[bn].c != b.changed
			let s:buf_map[bn].c = b.changed
			call s:update_bufline_flag(bn, b.changed)
		endif
	endfor
	let s:auv_bufwrite = []
	if rebuild
		call s:refresh_buflist()
	endif
endfun
fun! s:au_text_changed(b)
	if ! s:is_visible() | return | endif
	if ! has_key(s:buf_map, a:b) | return | endif
	let c = getbufinfo(a:b)[0].changed
	if s:buf_map[a:b].c != c
		let s:buf_map[a:b].c = c
		call s:update_bufline_flag(a:b, c)
	endif
endfun
fun! s:autocmd_activate()
	augroup YabexAugroupGlobal
		autocmd!

		"autocmd FileChangedShell  * call s:dbg_au('SHELLCHANGE')
		"autocmd FileChangedShellPost  * call s:dbg_au('SHELLCHANGE POST')
		" after entering a buffer
		" autocmd BufEnter   * call s:dbg_au('BUF ENTER')
		autocmd BufEnter   * call s:au_buf_enter()

		"just after adding a buffer to the buffer list
		" autocmd BufAdd * call s:dbg_au('BUF ADD')
		"autocmd BufAdd * let s:auc_bufadd += 1
		"autocmd BufAdd * autocmd SafeState * ++once call s:au_bufadd_refresh(s:auc_bufadd)
		autocmd BufAdd * let s:auc_counter += 1
		autocmd BufAdd * autocmd SafeState * ++once call s:au_safe_refresh(s:auc_counter)

		" autocmd BufDelete    * call s:au_generic_refresh('BufDelete')
		"autocmd BufDelete * let s:bdeleted = 1

		" after changing the name of the current buffer
		" autocmd BufFilePost  * call s:dbg_au('BUF FILE POST')
		"autocmd BufFilePost  * call s:au_generic_refresh('BufFilePost')
		autocmd BufFilePost  * let s:auc_counter += 1
		autocmd BufFilePost  * autocmd SafeState * ++once call s:au_safe_refresh(s:auc_counter)

		" after writing part of a buffer to a file
		" autocmd BufWritePost * call s:dbg_au('BUF WRITE POST')
		autocmd BufWritePost * let s:auv_bufwrite += [expand('<abuf>')]
		autocmd BufWritePost * autocmd SafeState * ++once call s:au_write_post()

		" Catch :bufdo changes by bufleave
		" TextChanged* is not triggered
		autocmd BufLeave     * call s:au_text_changed(bufnr('%'))
		autocmd TextChanged  * call s:au_text_changed(bufnr('%'))
		autocmd TextChangedI * call s:au_text_changed(bufnr('%'))
		autocmd TextChangedP * call s:au_text_changed(bufnr('%'))
		"autocmd TextChanged  * let s:auc_txtchange += 1
		"autocmd TextChanged  * autocmd SafeState * ++once call s:au_text_changed(bufnr('%'), s:auc_txtchange)
		"autocmd TextChangedI * let s:auc_txtchange += 1
		"autocmd TextChangedI * autocmd SafeState * ++once call s:au_text_changed(bufnr('%'), s:auc_txtchange)
		"autocmd TextChanged  * autocmd SafeState * ++once call s:au_text_changed(bufnr('%'))
		"autocmd TextChangedI * autocmd SafeState * ++once call s:au_text_changed(bufnr('%'))

		"autocmd TextChanged  <buffer> * call s:au_text_changed(bufnr('%'))
		"autocmd TextChangedI <buffer> * call s:au_text_changed(bufnr('%'))

		" after creating a new window
		" autocmd WinNew * call s:dbg_au('WIN NEW')
		autocmd WinNew * call s:au_win_new()
		"autocmd WinNew * let s:auc_counter += 1
		"autocmd WinNew * autocmd SafeState * ++once call s:au_safe_refresh(s:auc_counter)

		" after entering another window
		" autocmd WinEnter * call s:dbg_au('WIN ENTER nr:' . winnr())
		autocmd WinEnter * call s:au_win_enter()
		"autocmd WinEnter * let s:auc_counter += 1
		"autocmd WinEnter * autocmd SafeState * ++once call s:au_safe_refresh(s:auc_counter)

		" before deleting a buffer from the buffer list
		" autocmd BufDelete   * call s:dbg_au('BUF DELETE')
		"autocmd BufDelete * let s:auc_bufdel += 1
		"autocmd BufDelete * autocmd SafeState * ++once call s:au_bufdel_refresh(s:auc_bufdel)
		autocmd BufDelete * let s:auc_counter += 1
		autocmd BufDelete * autocmd SafeState * ++once call s:au_safe_refresh(s:auc_counter)


		"autocmd SafeState * call s:dbg_au('AUA: SafeState')
		"autocmd SafeStateAgain * call s:dbg_au('AUA: SafeStateAgain')

		" runtime ../debug/log_autocmd.vim
	augroup end
endfun
fun! s:autocmd_deactivate()
	augroup YabexAugroupGlobal
		autocmd!
	augroup end
endfun
" Ellipsis is timer-ID if called from timer_start()
" b=bufnr
" c=modified : 0/1
fun! s:update_bufline_flag(b, c, ...)
	if ! s:is_visible()
		return
	endif
	let bl = s:self_get_bline(a:b)
	if empty(bl) | return | endif
	let c = a:c ? '+' : ' '
	call s:self_make_editable()
	let r = substitute(
			\ bl[1],
			\ '\([^0-9]' . a:b . ' \).',
			\ '\=submatch(1) . "' . [' ', '+'][a:c] . '"',
			\ '')
	call setbufline(s:state.mybufnr, bl[0], r)
	call s:self_make_uneditable()
endfun
fun! s:update_bufline_tag(b, t)
	let bl = s:self_get_bline(a:b)
	if empty(bl)
		return
	endif
	let bt = bl[1][0]
	if bt == 'F' || bt == 'E' | return | endif
	let r = substitute(
			\ bl[1],
			\ '^[A-D]',
			\ a:t,
			\ ''
			\ )
	call setbufline(s:state.mybufnr, bl[0], r)
endfun
" Holds history of buffers
" Used to remove highlighting for previous buffer and
" previous alt buffer
let s:syn_meta = { 'a': 0, 'b': 0, 'c': 0, 'd': 0}
" 'line_last_buf': 0, 'last_buffer_view': 0 }
function! s:buf_syn_update(which)
	if s:syn_meta.a == a:which
		" return
	endif
	let bl = s:self_get_bline(a:which)
	if ! has_key(s:state, 'curwinid')
		return
	endif
	call win_execute(s:state.curwinid, "let alt = printf('%d', bufnr('#'))")
	call s:self_make_editable()
	let w_alt = bufwinnr(s:syn_meta.a)
	if w_alt > -1 && w_alt != winnr()
		call s:win_gutter_buffer(s:syn_meta.a)
	endif
	call s:update_bufline_tag(s:syn_meta.a, w_alt > -1 ? "B" : "A")
	call s:update_bufline_tag(s:syn_meta.b, bufwinnr(s:syn_meta.b) > -1 ? "B" : "A")
	call s:update_bufline_tag(alt, "D")
	call s:update_bufline_tag(a:which, "C")
	let s:syn_meta.c = s:syn_meta.b
	let s:syn_meta.a = a:which
	let s:syn_meta.b = alt
	call s:win_gutter_current()
	call s:self_make_uneditable()
endfunction

fun! s:au_on_self_focus()
	if &filetype == 'yabex'
		setlocal noswapfile
		"if self.cnf_win.ExitOnlyWin == 1
		call s:exit_if_alone()
	endif
endfun

fun! s:buf_init() abort
	let b = s:state.mybufnr
	" " Our humble name
	call setbufvar(b, '&filetype', 'yabex')
	call setbufvar(b, '&bufhidden',
				\ s:cnf.buf.reset_on_close ? 'delete' : 'hide')
endfun

	" Buffer List and Dictionary template: ----------------------------------
	" b= buffer number
	" n= name (displayed)
	" c= modified 1, not 0
	" v= visible  1, not 0
	" f= group (normal, hidden or wiped)
	"    wiped (not vim wiped, but Yabex wiped - as in do not show in any
	"    list)
	" o= sort string (order by)
	" let s:bufListCnt     = 0
	" let s:pushw          = -1
	" Line-range each list normal / hidden occupy in yabex buffer
	" let s:bufLineRange   = { 'n': { }, 'h': { } }
	" { 'n': [0, 0], 'h': [0, 0] }
	" let s:beSilent       = 0

let s:buf_template = {
		\ 'b':  0, 'n': '', 'c':  0,
		\ 'f': '', 'v':  0, 'o': '', 'l': 0 }
" c: int changed
" t: int changedtick
" l:
" w:
let s:buf_map = { }
let s:buf_lists = {
	\ 'norm': [],
	\ 'hidd': [] }
let s:buf_ranges = {
	\ 'norm': [0,0],
	\ 'hidd': [0,0]
	\ }
let s:buf_cnt = { 'norm': 0, 'hidd': 0 }
" Generate the buffer lists
" One for normal, and one for hidden buffers
" ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯0
"	'bufnr': 5,
"	'changed': 0,
"	'changedtick': 9902,
"	'hidden': 0,
"	'lastused': 1594931651,
"	'linecount': 812
"	'listed': 1,
"	'lnum': 553,
"	'loaded': 1,
"	'name': '/home/user/.vim/github/yabex/autoload/yabex/win.vim',
"	'popups': [],
"	'windows': [1000],
fun! s:build_buffer_list() abort
	let l:ls = getbufinfo()
	let cc = {'a': len(l:ls), '$': bufnr('$'), 'c': 0}
	let s:state.buflen = len(l:ls)

	" Empty lists
	let s:buf_map = { }
	let s:buf_lists = { 'norm': [], 'hidd': [] }
	let s:buf_cnt = { 'norm': 0, 'hidd': 0 }

	let norm_name = s:cnf.buf_list.name.norm
	let hidd_name = s:cnf.buf_list.name.hidd
	let norm_order = s:cnf.buf_list.sort.norm.order
	let hidd_order = s:cnf.buf_list.sort.hidd.order

	let n_eq_s = norm_name == norm_order
	let h_eq_s = hidd_name == hidd_order

	for b in l:ls
		let cc.c += 1
		let buf = copy(s:buf_template)
		let buf.b = b.bufnr
		let buf.c = b.changed ? 1 : 0
		let buf.v = len(b.windows) > 0 ? 1 : 0
		let buf.w = b.windows
		let buf.f = s:get_list_flag(b)

		" Todo: More groups
		let type = buf.f == 'n' ? 'norm' : 'hidd'
		let buf.n = s:make_list_name(b, {type}_name)
		let buf.o = n_eq_s ? buf.n : s:make_list_name(b, {type}_order)

		if s:cnf.buf_list.grouping == 'm'
			let type = 'norm'
		endif
		call add(s:buf_lists[type], buf)
		let s:buf_cnt[type] += 1
		let s:buf_map[buf.b] = {
			\ 't': b.changedtick,
			\ 'c': buf.c,
			\ 'l': 0
			\ }
	endfor
	call sort(s:buf_lists.norm, {a, b -> s:buf_list_sort('norm', a, b)})
	if s:cnf.buf_list.grouping != 'm'
		call sort(s:buf_lists.hidd,
				\ {a, b -> s:buf_list_sort('hidd', a, b)})
	endif
endfun
" Determine listing flag for buffer
"
" return
"	w = completely hidden
"	h = hidden
"	n = normal
" @param bufNr int The buffer to check
" ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯0
fun! s:get_list_flag(buf) abort
	" getftype()
	" Hide self
	"if a:buf.bufnr == s:state.mybufnr
	"	 return 'w'
	"endif
	" PRI 1 - bufname
	if index(s:cnf.filter.bufnames, fnamemodify(a:buf.name, ':t')) != -1
		return 'w'
	endif
	" PRI 2 - buftype
	let bt = getbufvar(a:buf.bufnr, '&buftype')
	let flag = get(s:cnf.filter.buftypes, bt)
	" XXX: This does not work: if flag != '' && flag != 0
	if ! empty(flag)
		return flag
	endif
	" PRI 3 - custom bufvar
	" flag priority 'w' -> 'h' -> 'n'
	" set to lowest
	let flag = 'n'
	for [bufvar, ff] in items(s:cnf.filter.bufvar)
		if ff != 'n'
			" unable to get "no-" bufvar with getbufvar()
			" if a no-var a 0 from getbufvar() mean 1
			let ack = bufvar !~ '^no'
			let var = ack ? bufvar : strpart(bufvar, 2)
			if getbufvar(a:buf.bufnr, '&' . var) == ack
				let flag = ff
			endif
			if flag == 'w'
				return flag
			endif
		endif
	endfor
	return flag
	"'bufhidden' is buffer specific
	"   <empty>     Use the value of hidden
	"   hide        Hide this buffer
	"   unload      Don't hide but unload
	"   delete      Delete this buffer
	"   wipe        Wipe
	"
	"'buftype'
	"   <empty>     normal
	"   nofile      not related to file, not written
	"   nowrite     will not be written
	"   acwrite     always written with BufWriteCmd
	"   quickfix    ie c:window
	"   help        help
	"
	"getbufvar(i, xxx)
	"
	" &buflisted
	" &modifiable
	" &swapfile
	" &modified
endfun

let s:fname_mods = {
	\ 't': ':t',
	\ 'h': ':p:~',
	\ 'r': ':p:~:.',
	\ 'p': ':p',
	\ 'd': ':p:h' }
fun! s:make_list_name(buf, flag)
	let n = a:buf.name
	if n == ''
		let n = getbufvar(a:buf.bufnr, '&buftype')
		return '[' . (n == '' ? 'No Name' : n) . ']'
	endif
	if !filereadable(n)
		return fnamemodify(n, ':t')
	elseif a:flag == 's'
		let n =  fnamemodify(n, ':p')
		return pathshorten(n)
	elseif has_key(s:fname_mods, a:flag)
		return fnamemodify(n, s:fname_mods[a:flag])
	else
		call yabex#echo#warn('Yabex:: UNKNOWN FLAG: ' . a:flag, 1)
	endif
endfun

" Sort List of normal buffers
" callback function used with :call sort()
" ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯0
fun! s:buf_list_sort(type, d1, d2)
	if s:cnf.buf_list.sort[a:type] == { }
		return 0
	endif

	let asc  = s:cnf.buf_list.sort[a:type].asc ? 1 : -1
	let desc = asc * -1

	if s:cnf.buf_list.sort[a:type].ext
		let e1 = fnamemodify(a:d1.o, ':e')
		let e2 = fnamemodify(a:d2.o, ':e')
		if e1 != e2
			return e1 > e2 ? asc : desc
		endif
	endif

	if s:cnf.buf_list.sort[a:type].order == 'b'
		return a:d1.b > a:d2.b ? asc : desc
	else
		if s:cnf.buf_list.sort[a:type].case
			return a:d1.o ==  a:d2.o ?
					\ 0 : a:d1.o >  a:d2.o ? asc : desc
		else
			return a:d1.o ==# a:d2.o ?
					\ 0 : a:d1.o ># a:d2.o ? asc : desc
		endif
	endif
endfun

fun! s:full_line(width, text, filler)
	let wt = strdisplaywidth(a:text)
	let wf = strdisplaywidth(a:filler)
	let w = a:width - wt
	let f = repeat(a:filler, float2nr(ceil(w / wf)))
	return a:text . f
	let r = (a:text . f)[0 : a:width]
	return r
endfun

fun! s:update_seplines()
	let ww = s:state.mywinwidth
	call s:self_make_editable()
	for e in s:buf_seps
		call setbufline(s:state.mybufnr, e.l, s:full_line(ww, e.t, e.f))
	endfor
	call s:self_make_uneditable()
endfun

fun! s:check_yabex_win_width()
	let w = winwidth(s:state.mywinnr)
	if w != s:state.mywinwidth
		let s:state.mywinwidth = w
		call s:update_seplines()
	endif
endfun

"let s:own_cur_pos = []
let s:bak_cpos = []
fun! s:refresh_buflist()
	if ! s:is_visible()
		return
	endif

	"let s:own_cur_pos = s:get_cursor_state()
	let s:state.mywinnr = bufwinnr(s:state.mybufnr)
	let s:state.mywinwidth = winwidth(s:state.mywinnr)
	let c_save = getcurpos(s:state.mywinnr)

	let ww = s:state.mywinwidth

	call s:self_make_editable()

	call s:build_buffer_list()

	call deletebufline(s:state.mybufnr, 1, '$')

	let s:buf_ranges = {
		\ 'norm': [0, 0],
		\ 'hidd': [0, 0]
		\ }

	let s:buf_seps = []

	let s:buf_seps += [{ 'l': 1, 't': 'H y a b e x _^0_o^__', 'f': ' ' }]
	let s:buf_seps += [{ 'l': 2, 't': 'h', 'f': ':.`~.' }]

	"	\ 'X 📂 :Explore'
	"	\ s:full_line(ww, 'h', ':.`~.'),
	let buf = [
		\ s:full_line(ww, 'H  y a b e x _^0_o^__', ' '),
		\ 'X :  Explore'
		\ ]
	let separator = s:full_line(ww, 'S', ' ☠ ')

	"if s:cnf.buf.hi_whole_line == 1
	"	let separator = repeat(' ☠ ', 80)
	"else
	"	let separator = repeat(' ☠ ', 20)
	"|endif

	" let buf += header
	for list in s:cnf.buf_list.order
		let ent = s:buflist2lines(s:buf_lists[list], len(buf))
		let buf += ent.buf
		let s:buf_ranges[list] = [ent.start, ent.end]
		let buf += [separator]
		let s:buf_seps += [{ 'l': len(buf), 't': 'S', 'f': ' ☠ ' }]
	endfor

	call setbufline(s:state.mybufnr, 1, buf)

	call s:self_make_uneditable()

	" NB! Bufnr has no effect ...
	let c_save[0] = s:state.mybufnr

	if c_save[1] == 1
		let c_save[1] = len(s:bak_cpos) ? s:bak_cpos[1] : 3
	endif
	if s:win_self_has_focus()
		call setpos('.', c_save)
	endif
	let s:bak_cpos = copy(c_save)
	"call s:set_cursor_state(c_save)
	"getbufvar('%', '&buftype') == '' && !&previewwindow
	" buftype:
	"   <empty> normal file
	"   nofile
	"   nowrite
	"   acwrite
	"   quickfix (:cwindow, :lwindow)
	"   help
endfun

" Print a buffer list
" @param bufList    Buffer List to print
" @param doFold     If the list should be folded
" ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯0
fun! s:buflist2lines(bufList, off) abort
	let nw   = len(bufnr('$'))
	let zpad = repeat(' ', nw)
	let fpad = repeat(' ', 50)
	let buf = []
	let j = 0
	let l = a:off

	for o in a:bufList
		if o.f != 'w'
			let l += 1
			let s:buf_map[o.b].l = l
			let s:buf_map[o.b].w = o.w
			if len(o.w)
				call s:win_gutter_add(l, o.w[0])
			endif
			" Todo: Fix the flag "logic"
			"if o.f == 'n'
			let ff = o.v ? 'B' : 'A'
			if o.f == 'h'
				let ff = 'F'
			elseif o.f == 't'
				let ff = 'E'
			endif
			" let line = (o.f == 'h' ? 'F' : (o.v ? 'B' : 'A')) .
			let line = ff .
				\ zpad[0: nw - len(o.b)] . o.b . ' ' .
				\ (o.c ? '+' : ' ') .
				\ (o.f == 't' ? ' ⚃ ' . o.n : o.n)
			if s:cnf.buf.hi_whole_line == 1
				"let line .=  fpad[0:50 - len(line)]
			endif
			let buf += [line]
			" . "\n"
		endif
	endfor
	return {  'buf'   : buf,
		\ 'start' : a:off + 1,
		\ 'end'   : l,
		\ 'len'   : l - a:off }
endfun
