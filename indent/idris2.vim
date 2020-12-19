" indentation for idris (idris-lang.org)
"
" Based on haskell indentation by motemen <motemen@gmail.com>
"
" author: raichoo (raichoo@googlemail.com)
"
" Modify g:idris_indent_if and g:idris_indent_case to
" change indentation for `if'(default 3) and `case'(default 5).
" Example (in .vimrc):
" > let g:idris_indent_if = 2

if exists('b:did_indent')
  finish
endif

let b:did_indent = 1

if !exists('g:idris_indent_if')
  " if bool
  " >>>then ...
  " >>>else ...
  let g:idris_indent_if = 3
endif

if !exists('g:idris_indent_case')
  " case xs of
  " >>>>>[]      => ...
  " >>>>>(y::ys) => ...
  let g:idris_indent_case = 5
endif

if !exists('g:idris_indent_let')
  " let x : Nat = O in
  " >>>>x
  let g:idris_indent_let = 4
endif

if !exists('g:idris_indent_rewrite')
  " rewrite prf in expr
  " >>>>>>>>x
  let g:idris_indent_rewrite = 8
endif

if !exists('g:idris_indent_where')
  " where f : Nat -> Nat
  " >>>>>>f x = x
  let g:idris_indent_where = 6
endif

if !exists('g:idris_indent_do')
  " do x <- a
  " >>>y <- b
  let g:idris_indent_do = 3
endif

setlocal indentexpr=idris2#indent#getIdrisIndent()
setlocal indentkeys=!^F,o,O,}
