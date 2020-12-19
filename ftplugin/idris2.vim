if exists("b:did_ftplugin")
  finish
endif

setlocal shiftwidth=2
setlocal tabstop=2
if !exists("g:idris_allow_tabchar") || g:idris_allow_tabchar == 0
	setlocal expandtab
endif

setlocal comments=s1:{-,mb:-,ex:-},:\|\|\|,:--
setlocal commentstring=--\ %s
setlocal iskeyword+=?
setlocal wildignore+=*.ibc

let b:did_ftplugin = 1


nnoremap <buffer> <silent> <LocalLeader>t :call idris2#showType()<ENTER>
nnoremap <buffer> <silent> <LocalLeader>r :call idris2#reload(0)<ENTER>
nnoremap <buffer> <silent> <LocalLeader>c :call idris2#caseSplit()<ENTER>
nnoremap <buffer> <silent> <LocalLeader>a 0:call search(":")<ENTER>b:call idris2#addClause(0)<ENTER>w
nnoremap <buffer> <silent> <LocalLeader>d 0:call search(":")<ENTER>b:call idris2#addClause(0)<ENTER>w
nnoremap <buffer> <silent> <LocalLeader>b 0:call idris2#addClause(0)<ENTER>
nnoremap <buffer> <silent> <LocalLeader>m :call idris2#addMissing()<ENTER>
nnoremap <buffer> <silent> <LocalLeader>md 0:call search(":")<ENTER>b:call idris2#addClause(1)<ENTER>w
nnoremap <buffer> <silent> <LocalLeader>f :call idris2#refine()<ENTER>
nnoremap <buffer> <silent> <LocalLeader>o :call idris2#proofSearch(0)<ENTER>
nnoremap <buffer> <silent> <LocalLeader>s :call idris2#proofSearch(0)<ENTER>
nnoremap <buffer> <silent> <LocalLeader>g :call idris2#generateDef()<ENTER>
nnoremap <buffer> <silent> <LocalLeader>p :call idris2#proofSearch(1)<ENTER>
nnoremap <buffer> <silent> <LocalLeader>l :call idris2#makeLemma()<ENTER>
nnoremap <buffer> <silent> <LocalLeader>e :call idris2#eval()<ENTER>
nnoremap <buffer> <silent> <LocalLeader>w 0:call idris2#makeWith()<ENTER>
nnoremap <buffer> <silent> <LocalLeader>mc :call idris2#makeCase()<ENTER>
nnoremap <buffer> <silent> <LocalLeader>i 0:call idris2#responseWin()<ENTER>
nnoremap <buffer> <silent> <LocalLeader>h :call idris2#showDoc()<ENTER>

menu Idris.Reload <LocalLeader>r
menu Idris.Show\ Type <LocalLeader>t
menu Idris.Evaluate <LocalLeader>e
menu Idris.-SEP0- :
menu Idris.Add\ Clause <LocalLeader>a
menu Idris.Generate\ Definition <LocalLeader>g
menu Idris.Add\ with <LocalLeader>w
menu Idris.Case\ Split <LocalLeader>c
menu Idris.Add\ missing\ cases <LocalLeader>m
menu Idris.Proof\ Search <LocalLeader>s
menu Idris.Proof\ Search\ with\ hints <LocalLeader>p

augroup idris_responsewin
  autocmd!
  au BufHidden idris-response call idris2#onHideResponseWin()
augroup end
