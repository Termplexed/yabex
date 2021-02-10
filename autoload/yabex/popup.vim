if v:version < 802 && !has('nvim')
    finish
endif

let s:cpo_bak = &cpo
set cpo&vim

let s:pop = {'wid': -1, 'last': -1, 'buf': 0}

fun! s:pop.on_close(id, res)
	let s:pop.wid = -1
	let s:pop.last = -1
endfun
fun! s:on_key(id, key)
	" DUMP [a:id, string(a:key)]
	if a:key =~ "\033" || a:key == 'x'
		call popup_close(a:id, 1)
		return 1
	endif
	return 1
	"return popup_filter_menu(a:id, a:key)
endfun
fun! s:pop_align_with_qf_window(qf_wid)
	call popup_move(s:pop.wid, {
		\ 'col' : 1,
		\ 'line': 1
	\ })
	let wif = getwininfo(a:qf_wid)
	let pif = popup_getpos(s:pop.wid)
	" DUMP wif
	" DUMP pif
	call popup_move(s:pop.wid, {
		\ 'col' : wif[0].width - pif.width,
		\ 'line': wif[0].winrow - pif.height - 2,
		\ 'maxwidth': wif[0].width - 4
	\ })
endfun
fun! s:nvim_pop_align_with_qf_window(qf_wid, ctx)
	let wif = getwininfo(a:qf_wid)
	call nvim_win_set_config(s:pop.wid, {
		\ 'relative': 'editor',
		\ 'width': 500,
		\ 'col' : 0,
		\ 'row' : wif[0].winrow - len(a:ctx) - 3,
		\ 'height' : len(a:ctx)
	\ })
	call nvim_set_current_win(a:qf_wid)
endfun
fun! s:pop_new(owid)
	let geo = getwininfo(a:owid)[0]
	let s:pop.wid = popup_create([], {
		\ 'zindex': 200,
		\ 'drag': 0,
		\ 'wrap': 1,
		\ 'pos': 'botleft',
		\ 'line': geo.height,
		\ 'col': 1,
		\ 'minwidth': geo.width - 2,
		\ 'fixed': 1,
		\ 'borderchars': ['‾'],
		\ 'cursorline': 1,
		\ 'border' : [1, 0, 0, 0],
		\ 'padding': [0,1,1,1],
		\ 'close': 'none',
		\ 'mapping' : 0,
		\ 'callback': s:pop.on_close
		\})
	let s:pop.buf = winbufnr(s:pop.wid)
	" call setbufvar(winbufnr(s:pop.wid), '&filetype', 'vim')
endfun
fun! s:nvim_pop_new()
	if ! s:pop.buf
		let s:pop.buf = nvim_create_buf(0, 1)
	endif
	call nvim_buf_set_lines(s:pop.buf, 0, -1, 1, ["x"])
	let opts = {
		\ 'relative': 'cursor',
		\ 'width': 10,
		\ 'height': 10,
		\ 'col': 0,
		\ 'row': 1,
		\ 'anchor': 'NW',
		\ 'style': 'minimal'}
	let s:pop.wid = nvim_open_win(s:pop.buf, 0, opts)
endfun
fun! s:finalize()
	if has('nvim')
		call nvim_win_close(s:pop.wid, 0)
		let s:pop.wid = -1
		let s:pop.last = -1
	else
		call popup_close(s:pop.wid, 0)
	endif
endfun
fun! yabex#popup#load(mode, ywid)
	let cur_line = line('.') - 1
	if cur_line == s:pop.last
		if a:mode != 2
			call s:finalize()
		endif
		return
	endif
	let s:pop.last = cur_line

	let ctx = ['Hello', 'there']

	if 0
		let qentry = getqflist({'winid': 1, 'items': 1, 'idx': 0})
		let entry = qentry.items[cur_line]
		if entry.bufnr == 0
			return
		endif

		let fn = fnamemodify(bufname(entry.bufnr), ':p')
		let ctx = vfix#file#ctx_get(fn . ":" . entry.lnum)
		let swp_taken = s:swap_taken(fn)
		let ln = s:def_lines(ctx, entry.lnum, len(ctx))

		let ctx += [hd,
			\ '" Error: ' . entry.text,
			\ '" File:  ' . fnamemodify(fn, ':~:.')]
		if swp_taken
			let ctx += ['" Swap:  Likely open in other Vim instance']
		endif

		let ln.len = len(ctx)
	endif

	if s:pop.wid < 0
		if has('nvim')
			call s:nvim_pop_new()
		else
			call s:pop_new(a:ywid)
		endif
	endif

	if has('nvim')
		" let ctx += [ string(s:pop) ]
		call nvim_buf_set_lines(s:pop.buf, 0, -1, v:true, ctx)
		call s:nvim_pop_align_with_qf_window(qentry.winid, ctx)
		call nvim_win_set_option(s:pop.wid, 'cursorline', v:true)
		call nvim_win_set_cursor(s:pop.wid, [ ln.hi_start, 0 ])
	else
		call popup_settext(s:pop.wid, ctx)
		"call s:pop_align_with_qf_window(qentry.winid)
		"call win_execute(s:pop.wid, 'call cursor('.(ln.hi_start).', 1)')
	endif
	call setbufvar(s:pop.buf, '&filetype', 'vim')
	"call s:pop_highlight(entry.text, ln, swp_taken)
endfun

let &cpo= s:cpo_bak
unlet s:cpo_bak

