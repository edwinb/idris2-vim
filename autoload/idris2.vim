" Text near cursor position that needs to be passed to a command.
" Refinment of `expand(<cword>)` to accomodate differences between
" a (n)vim word and what Idris requires.
function! s:currentQueryObject()
  let word = expand("<cword>")
  if word =~ '^?'
    " Cut off '?' that introduces a hole identifier.
    let word = strpart(word, 1)
  endif
  return word
endfunction

function! s:idrisCommand(...)
  let idriscmd = shellescape(join(a:000))
  " Vim does not support ANSI escape codes natively, so we need to disable
  " automatic colouring
  return system("idris2 --no-color --find-ipkg " . shellescape(expand('%:p')) . " --client " . idriscmd)
endfunction

function! idris2#docFold(lineNum)
  let line = getline(a:lineNum)

  if line =~ "^\s*|||"
    return "1"
  endif

  return "0"
endfunction

function! idris2#fold(lineNum)
  return idris2#docFold(a:lineNum)
endfunction

setlocal foldmethod=expr
setlocal foldexpr=idris2#fold(v:lnum)

" creates a response window (if doesn't exist) and its scratch buffer (if
" doesn't exist)
function! idris2#responseWin()
  if (!bufexists("idris-response"))
    botright 10new idris-response
    setlocal bufhidden=hide buftype=nofile nobuflisted noswapfile
    let g:idris_respwin = "active"
    wincmd p
  elseif (bufexists("idris-response") && g:idris_respwin == "hidden")
    botright 10new
    keepjumps buffer idris-response
    let g:idris_respwin = "active"
    wincmd p
  endif
endfunction

function! idris2#onHideResponseWin()
  let g:idris_respwin = "hidden"
endfunction

function! IWrite(str)
  let bufname = "idris-response"
  if (bufexists(bufname))
    let nr = bufwinnr(bufname)
    let origin_nr = bufwinnr("%")
    let save_cursor = getcurpos()

    if nr != -1
      " go to open window of response buffer if it exists
      exec "keepjumps " . nr . "wincmd w"
    else
      " open buffer in current window. This assumes the current buffer is not
      " modified
      keepjumps buffer idris-response
    endif

    " set buffer text to argument
    keepjumps %delete
    let resp = split(a:str, '\n')
    call append(1, resp)

    " return to previous file
    if nr != -1
      exec "keepjumps " . origin_nr . "wincmd w"
    else
      keepjumps buffer #
      call setpos('.', save_cursor)
    endif

  else
    " if buffer does not exist, just echo the output
    echo a:str
  endif
endfunction

function! idris2#reload(q)
  write
  let file = expand('%:p')
  let tc = system("idris2 --no-color --find-ipkg " . shellescape(file) . " --client ''")
  if (! (tc is ""))
    call IWrite(tc)
  else
    if (a:q==0)
       call IWrite("Successfully reloaded " . file)
    endif
  endif
  return tc
endfunction

function! idris2#reloadToLine(cline)
  return idris2#reload(1)
  "write
  "let file = expand("%:p")
  "let tc = s:idrisCommand(":lto", a:cline, file)
  "if (! (tc is ""))
  "  call IWrite(tc)
  "endif
  "return tc
endfunction

function! idris2#showType()
  write
  let word = s:currentQueryObject()
  let cline = line(".")
  let ccol = col(".")
    let ty = s:idrisCommand(":t", word)
    call IWrite(ty)
endfunction

function! idris2#showDoc()
  write
  let word = expand("<cword>")
  let ty = s:idrisCommand(":doc", word)
  call IWrite(ty)
endfunction

function! idris2#proofSearch(hint)
  let view = winsaveview()
  write
  let cline = line(".")
  let word = s:currentQueryObject()

  if (a:hint==0)
     let hints = ""
  else
     let hints = input ("Hints: ")
  endif

  let result = s:idrisCommand(":ps!", cline, word, hints)
  if (! (result is ""))
     call IWrite(result)
  else
    e
    call winrestview(view)
  endif
endfunction

function! idris2#generateDef()
  let view = winsaveview()
  write
  let cline = line(".")
  let word = s:currentQueryObject()

  let result = s:idrisCommand(":gd!", cline, word)
  if (! (result is ""))
     call IWrite(result)
  else
    e
    call winrestview(view)
  endif
endfunction

function! idris2#makeLemma()
  let view = winsaveview()
  write
  let cline = line(".")
  let word = s:currentQueryObject()

  let result = s:idrisCommand(":ml!", cline, word)
  if (! (result is ""))
     call IWrite(result)
  else
    e
    call winrestview(view)
    call search(word, "b")
  endif
endfunction

function! idris2#refine()
  let view = winsaveview()
  write
  let cline = line(".")
  let word = expand("<cword>")
  let name = input ("Name: ")

  let result = s:idrisCommand(":ref!", cline, word, name)
  if (! (result is ""))
     call IWrite(result)
  else
    e
    call winrestview(view)
  endif
endfunction

function! idris2#addMissing()
  let view = winsaveview()
  write
  let cline = line(".")
  let word = expand("<cword>")

  let result = s:idrisCommand(":am!", cline, word)
  if (! (result is ""))
     call IWrite(result)
  else
    e
    call winrestview(view)
  endif
endfunction

function! idris2#caseSplit()
  write
  let view = winsaveview()
  let cline = line(".")
  let ccol = col(".")
  let word = expand("<cword>")
  let result = s:idrisCommand(":cs!", cline, ccol, word)
  if (! (result is ""))
     call IWrite(result)
  else
     e
     call winrestview(view)
  endif
endfunction

function! idris2#makeWith()
  let view = winsaveview()
  write
  let cline = line(".")
  let word = s:currentQueryObject()
  let tc = idris2#reload(1)

  let result = s:idrisCommand(":mw!", cline, word)
  if (! (result is ""))
     call IWrite(result)
  else
    e
    call winrestview(view)
    call search("_")
  endif
endfunction

function! idris2#makeCase()
  let view = winsaveview()
  write
  let cline = line(".")
  let word = s:currentQueryObject()

  let result = s:idrisCommand(":mc!", cline, word)
  if (! (result is ""))
     call IWrite(result)
  else
    e
    call winrestview(view)
    call search("_")
  endif
endfunction

function! idris2#addClause(proof)
  let view = winsaveview()
  write
  let cline = line(".")
  let word = expand("<cword>")

  if (a:proof==0)
    let fn = ":ac!"
  else
    let fn = ":apc!"
  endif

  let result = s:idrisCommand(fn, cline, word)
  if (! (result is ""))
     call IWrite(result)
  else
    e
    call winrestview(view)
    call search(word)

  endif
endfunction

function! idris2#eval()
  write
  let expr = input ("Expression: ")
  let result = s:idrisCommand(expr)
  call IWrite(" = " . result)
endfunction

