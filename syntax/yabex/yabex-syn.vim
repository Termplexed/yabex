" """"""""""""""""""""""""""""""""""""""""""""""""""""" Figlet -w 80 -c -f block
"                                                                              "
"           _|      _|    _|_|    _|_|_|    _|_|_|_|  _|      _|               "
"             _|  _|    _|    _|  _|    _|  _|          _|  _|                 "
"               _|      _|_|_|_|  _|_|_|    _|_|_|        _|                   "
"               _|      _|    _|  _|    _|  _|          _|  _|                 "
"               _|      _|    _|  _|_|_|    _|_|_|_|  _|      _|               "
"                                                                              "
"                       _|_|_|  _|      _|  _|      _|                         "
"                     _|          _|  _|    _|_|    _|                         "
"                       _|_|        _|      _|  _|  _|                         "
"                           _|      _|      _|    _|_|                         "
"                     _|_|_|        _|      _|      _|                         "
"                                                                              "
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &filetype != 'yabex'
	finish
endif

let s:cpo_save = &cpo
set cpo&vim

" To insert escapes:
"    Ctrl+V NNN
"    001: A	Filler to align columns
"    002: B	Visible buffer
"    003: C	Active buffer
"    004: D	Alternate buffer for current window

" Clear previously selected name
"match none
"syntax clear
"syntax reset

@silent syntax clear YabexHeaderMain
@silent syntax clear YabexHeaderMain2
@silent syntax clear YabexBufNum
@silent syntax clear YabexBufFlag
@silent syntax clear YabexBufName
@silent syntax clear YabexBufNumActive
@silent syntax clear YabexBufFlagActive
@silent syntax clear YabexBufNameActive
@silent syntax clear YabexBufNameAltern

syntax clear
match none

if has("conceal")
	syntax match YabexFlag  containedin=ALL /^./ conceal
	"syntax match YabexFlagLine /^./ conceal
	setlocal conceallevel=3 concealcursor=nvic
	" highlight! link YabexFlagActive Error
else
	syntax match YabexFlag containedin=ALL /^./
	"syntax match YabexFlag /^./
	highlight! link YabexFlag Ignore
endif
syntax match YabexExplorer /^X.*/hs=s+1 contains=YabexFlag
syntax match YabexTerm /^E.*/hs=s+1 contains=YabexFlag

" BUFFER LINES:
" ^<FLAG[.]{1}><SPACE*><BUFNR[0-9]+><SPACE+><FLAG[-:*+]><BUFNAME[.]+>$

" Note: This has to be after the matches above
syntax match YabexBufNum /^A *\d\+/hs=s+1
"syntax match YabexBufFlag /\(^A *\d\+\s\+\)\@<=\zs[+]/ containedin=YabexBufName contains=YabexFlag
syntax match YabexBufFlag /\(^[A-D] *\d\+\s\+\)\@<=\zs[+]/ containedin=YabexBufName contains=YabexFlag
syntax match YabexBufName /\(^A *\d\+\s\+[+]\?\)\@<=\zs.\+\ze/ contains=YabexFlag


syntax match YabexBufNumVisible /^B *\d\+/hs=s+1
"syntax match YabexBufFlagVisible /\(^B *\d\+\s\+\)\@<=[-:+]\ze/ containedin=YabexBufNameActive
syntax match YabexBufNameVisible /\(^B *\d\+\s\+[-:*]\?\)\@<=.\+/

syntax match YabexBufNumActive /^C *\d\+/hs=s+1
"syntax match YabexBufFlagActive /\(^C *\d\+\s\+\)\@<=[-:+]\ze/ containedin=YabexBufNameActive
syntax match YabexBufNameActive /\(^C *\d\+\s\+[-:*]\?\)\@<=.\+/

syntax match YabexBufNumAltern  /^D *\d\+/hs=s+1
"syntax match YabexBufFlagAltern /\(^D *\d\+\s\+\)\@<=[-:+]\ze/ containedin=YabexBufNameAltern
syntax match YabexBufNameAltern /\(^D *\d\+\s\+[-:*]\?\)\@<=.\+/

"syntax match YabexBufNumHid  /^ *\d\+/hs=s+1
"syntax match YabexBufFlagHid /\(^ *\d\+\s\+\)\@<=[-:+]\ze/ containedin=YabexBufNameHid
"syntax match YabexBufNameHid /\(^ *\d\+\s\+[-:*]\?\)\@<=.\+/
syntax match YabexBufHid  /^F.*/hs=s+1

syntax match YabexHeaderMain /\%1lH.*/
syntax match YabexHeaderMain2 /\%2lh.*/
highlight! def link YabexHeaderMain VertSplit
highlight! def link YabexHeaderMain2 Title
"highlight! YabexHeaderMain cterm=bold ctermbg=black gui=bold guibg=black
highlight! YabexHeaderMain2 cterm=italic ctermbg=black gui=italic guibg=black
"highlight! YabexHeaderMain Error

if (has('gui_running') || &t_Co > 2)
	let synPairs = [
		\ ['YabexExplorer',         'LineNr'],
		\ ['YabexBufHid',           'NonText'],
		\ ['YabexTerm',             'Constant'],
		\
		\ ['YabexBufNum',           'Type'],
		\ ['YabexBufFlag',          'WarningMsg'],
		\ ['YabexBufName',          'Comment'],
		\
		\ ['YabexBufNumActive',     'Constant'],
		\ ['YabexBufNameActive',    'Directory'],
		\
		\ ['YabexBufNumVisible',    'Constant'],
		\ ['YabexBufNameVisible',   'Todo'],
		\
		\ ['YabexBufNameAltern',    'Type'],
		\
		\ ['YabexWinActive',        'PmenuSel'],
		\ ['YabexWinAltern',        'Directory'],
		\ ['YabexWinVisible',       'Question'],
		\ ['YabexWinAltAct',        'DiffText']
	\ ]
	for pair in synPairs
		"            highlight clear pair[0]
		if hlexists('My'.pair[0])
			exe 'highlight! link '.pair[0].' My'.pair[0]
		else
			exe 'highlight! link '.pair[0].' '.pair[1]
		endif
	endfor
else
	highlight default YabexBufNameActive term=reverse cterm=reverse
endif

" hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" hi CursorLine   gui=underline

"highlight! def link YabexBufName Error
"highlight! Folded        ctermbg=darkgrey guibg=grey      guifg=blue
"highlight! FoldColumn    ctermbg=red guibg=darkgrey  guifg=white

":hi Folded term=standout ctermfg=245 ctermbg=237 guifg=blue guibg=grey
":hi FoldColumn term=standout ctermfg=245 ctermbg=237 guifg=white guibg=darkgrey
" hi! YabexBufFlag ctermbg=2 guibg=#00aa00 cterm=bold

" let b:current_syntax = "yabex"

let &cpo = s:cpo_save
unlet s:cpo_save
