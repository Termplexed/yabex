" """"""""""""""""""""""""""""""""""""""""""""""""""""" Figlet -w 80 -c -f block
"                                                                              "
"           _|      _|    _|_|    _|_|_|    _|_|_|_|  _|      _|               "
"             _|  _|    _|    _|  _|    _|  _|          _|  _|                 "
"               _|      _|_|_|_|  _|_|_|    _|_|_|        _|                   "
"               _|      _|    _|  _|    _|  _|          _|  _|                 "
"               _|      _|    _|  _|_|_|    _|_|_|_|  _|      _|               "
"                                                                              "
"                           _|_|_|_|  _|_|_|_|_|                               "
"                           _|            _|                                   "
"                           _|_|_|        _|                                   "
"                           _|            _|                                   "
"                           _|            _|                                   "
"                                                                              "
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &filetype != 'yabex'
	finish
endif
if exists("b:did_ftplugin_yabex")
	finish
endif
let b:did_ftplugin_yabex = 1

let s:cpo_save = &cpo
set cpo&vim

fun! Get_fold_text()
	let line = foldtext()
	let sub = substitute(line, '^[^0-9]*\([0-9]\+\)[^:]*lines\?: \w\s*[0-9]\+\s*\(.*\)\s\+',
		\ '\1 <\2', '')
	return v:folddashes . sub
	"let head = 'bufs ' . (v:foldend - v:foldstart + 1)
	"return v:folddashes . head
endfun

setlocal nolist
" call win_execute(winnr(), 'setlocal lcs=trail:x')
" setlocal lcs=trail:x
setlocal linespace=0        " No extra pixels
setlocal statusline=\ YABEX\ \[%l/%L\]%<  " Keep it clean
setlocal nostartofline      " Do not jump
setlocal nocursorcolumn     " No column hi
setlocal noinsertmode       " Do not start in insert mode
setlocal nopaste            " Nopaste mode
setlocal scrolloff=0        " No scrolloff
setlocal sidescrolloff=0    " No side scrolloff, siso
setlocal wrapmargin=0       " No A.I. wrap
" setlocal t_ve=[?25h
" Set lineopt here
" Activate on focus, deactivate on blur
setlocal cursorlineopt=screenline         " But line hi
setlocal foldenable         " We want folds
setlocal foldminlines=0     "
setlocal foldlevel=99     "
setlocal foldcolumn=2
setlocal foldtext=Get_fold_text()
" setlocal foldexpr=getline(v:lnum)[0:1]=~\"\s\\d\"
setlocal foldmethod=expr  "
setlocal foldexpr=getline(v:lnum)[0:8]=~'[\x01-\x07]*\ [0-9]'

setlocal readonly         " If i.e. vimdiff
setlocal nomodifiable           " Shield (and hide)
setlocal buftype=nofile         " Mark as scratch
setlocal noswapfile             " No swap for this please
setlocal nobuflisted        	" X
setlocal nowrap                 " Not here
setlocal nonumber               " Either not here

if get(g:, "no_plugin_maps")
	let &cpo = s:cpo_save
	unlet s:cpo_save
	finish
endif

" Fold toggle
nnoremap <buffer> <silent> <nowait> -  za
nnoremap <buffer> <silent> <nowait> +  za
" Folding
nnoremap <buffer> <silent> <nowait> *  :silent! %foldopen!<CR>
nnoremap <buffer> <silent> <nowait> =  :silent! %foldclose<CR>

" These commands are mainly to make mapping easier
" The <C-U> "magic" is used to get count for maps vs Command
"
command! -buffer -nargs=* YabOpen : call yabex#win_buf#mapev('open', 'buf', 'nofocus', <args>)
command! -buffer -nargs=* YabJopen : call yabex#win_buf#mapev('open', 'buf', 'focus', <args>)
command! -buffer -nargs=* YabExplore : call yabex#win_buf#mapev('open', 'explore', 'focus', <args>)
command! -buffer -nargs=* YabGitdiff : call yabex#win_buf#mapev('open', 'gitdiff', 'nofocus', <args>)
command! -buffer -nargs=* YabTerminal : call yabex#win_buf#mapev('open', 'term', 'focus', <args>)

nnoremap <buffer> <silent> <nowait> <del> :call yabex#win#mapev('bufdel')<CR>

nmap <buffer> <silent> <nowait> <script> o :<C-U>YabOpen<CR>
nmap <buffer> <silent> <nowait> <script> <CR> :<C-U>YabOpen<CR>
nmap <buffer> <silent> <nowait> <script> O :<C-U>YabJopen<CR>
nmap <buffer> <silent> <nowait> <script> <leader><CR> :<C-U>YabJopen<CR>

nmap <buffer> <silent> <nowait> <script> e :<C-U>YabExplore<CR>
nmap <buffer> <silent> <nowait> <script> d :<C-U>YabGitdiff<CR>
nmap <buffer> <silent> <nowait> <script> t :<C-U>YabTerminal<CR>
"nnoremap <buffer> <silent> <expr> w<count>o yabex#win#mapev('testmap', 'wco')
	" NEW name { }
	"   normName, hiddName    : 't' = only name (title)
	"                           'p' = full path
	"                           's' = path shorten
	"                           'h' = rel to home
	"                           'r' = rel to home or current
nnoremap <buffer> <silent> xf :call yabex#win_buf#mapev('name_norm', 't')<CR>
nnoremap <buffer> <silent> xp :call yabex#win_buf#mapev('name_norm', 'p')<CR>
nnoremap <buffer> <silent> xs :call yabex#win_buf#mapev('name_norm', 's')<CR>
nnoremap <buffer> <silent> xh :call yabex#win_buf#mapev('name_norm', 'h')<CR>
nnoremap <buffer> <silent> xr :call yabex#win_buf#mapev('name_norm', 'r')<CR>

command! -buffer -nargs=1 View : call yabex#win_buf#mapev('name_norm', <q-args>)
command! -buffer -nargs=1 Sort : call yabex#win_buf#mapev('sort_norm', <q-args>)

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
	"                            -  If hidden files are mixed with the rest
	"                               the sorting are performed according to
	"                               normSort
	"                            nope: use hiddView instead
"nnoremap <buffer> <silent> sx :call yabex#win#mapev('sort_norm', '')<CR>
nnoremap <buffer> <silent> sf :call yabex#win_buf#mapev('sort_norm', 't')<CR>
nnoremap <buffer> <silent> sd :call yabex#win_buf#mapev('sort_norm', 'd')<CR>
nnoremap <buffer> <silent> sp :call yabex#win_buf#mapev('sort_norm', 'p')<CR>
"nnoremap <buffer> <silent> sb :call yabex#win#mapev('sort_norm', 'b')<CR>
"nnoremap <buffer> <silent> su :call yabex#win#mapev('sort_norm', 'U')<CR>

	" NEW: fold {}
	"   normFold, hiddFold    :  0  = not folded
	"                            1  = folded


	" NEW: grouping
	" XX  hiddView              : 'g' = group at bottom
	" XX                          'm' = mix all,
	" XX                          'h' = do not show
nnoremap <buffer> <silent> hh :call yabex#win_buf#mapev('grouping', 'g')<CR>
nnoremap <buffer> <silent> hm :call yabex#win_buf#mapev('grouping', 'm')<CR>
nnoremap <buffer> <silent> hj :call yabex#win_buf#mapev('grouping', 'h')<CR>

if yabex#win#cnf.ft.single_click_open
	" Todo:
	" 1)
	" NB! We have to do <LeftMouse> in action to propagate the click
	" As it is local to buffer, it wil not be triggered if Yabex get
	" focus by clicking.
	" Could map globally but that has some side effects.
	" How to fix?!
	"
	" v:mouse_win ?!
	"
	" 2)
	" The yabex#win#cnf.ft.single_click_open option is set in options.vim
	" Fix it.
	nnoremap <buffer> <silent> <script> <LeftMouse> <LeftMouse> :call yabex#win_buf#mapev('open', 'buf', 'nofocus')<CR>
else
	nnoremap <buffer> <silent> <script> <2-LeftMouse> :call yabex#win_buf#mapev('open', 'buf', 'nofocus')<CR>
endif

" Todo: Any point in this?
if 0
	exe "autocmd BufLeave * set t_ve=" . &t_ve
	exe "autocmd VimLeave * set t_ve=" . &t_ve
	autocmd BufEnter <buffer> set t_ve=
endif

let &cpo = s:cpo_save
unlet s:cpo_save
