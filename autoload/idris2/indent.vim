function! idris2#indent#getIdrisIndent()
  let prevline = getline(v:lnum - 1)

  if prevline =~ '\s\+(\s*.\+\s\+:\s\+.\+\s*)\s\+->\s*$'
    return match(prevline, '(')
  elseif prevline =~ '\s\+{\s*.\+\s\+:\s\+.\+\s*}\s\+->\s*$'
    return match(prevline, '{')
  endif

  if prevline =~ '[!#$%&*+./<>?@\\^|~-]\s*$'
    let s = match(prevline, '[:=]')
    if s > 0
      return s + 2
    else
      return match(prevline, '\S')
    endif
  endif

  if prevline =~ '[{([][^})\]]\+$'
    return match(prevline, '[{([]')
  endif

  if prevline =~ '\<let\>\s\+.\+\<in\>\s*$'
    return match(prevline, '\<let\>') + g:idris_indent_let
  endif

  if prevline =~ '\<rewrite\>\s\+.\+\<in\>\s*$'
    return match(prevline, '\<rewrite\>') + g:idris_indent_rewrite
  endif

  if prevline !~ '\<else\>'
    let s = match(prevline, '\<if\>.*\&.*\zs\<then\>')
    if s > 0
      return s
    endif

    let s = match(prevline, '\<if\>')
    if s > 0
      return s + g:idris_indent_if
    endif
  endif

  if prevline =~ '\(\<where\>\|\<do\>\|=\|[{([]\)\s*$'
    return match(prevline, '\S') + &shiftwidth
  endif

  if prevline =~ '\<where\>\s\+\S\+.*$'
    return match(prevline, '\<where\>') + g:idris_indent_where
  endif

  if prevline =~ '\<do\>\s\+\S\+.*$'
    return match(prevline, '\<do\>') + g:idris_indent_do
  endif

  if prevline =~ '^\s*\<\(co\)\?data\>\s\+[^=]\+\s\+=\s\+\S\+.*$'
    return match(prevline, '=')
  endif

  if prevline =~ '\<with\>\s\+([^)]*)\s*$'
    return match(prevline, '\S') + &shiftwidth
  endif

  if prevline =~ '\<case\>\s\+.\+\<of\>\s*$'
    return match(prevline, '\<case\>') + g:idris_indent_case
  endif

  if prevline =~ '^\s*\(\<namespace\>\|\<\(co\)\?data\>\)\s\+\S\+\s*$'
    return match(prevline, '\(\<namespace\>\|\<\(co\)\?data\>\)') + &shiftwidth
  endif

  if prevline =~ '^\s*\(\<using\>\|\<parameters\>\)\s*([^(]*)\s*$'
    return match(prevline, '\(\<using\>\|\<parameters\>\)') + &shiftwidth
  endif

  if prevline =~ '^\s*\<mutual\>\s*$'
    return match(prevline, '\<mutual\>') + &shiftwidth
  endif

  let line = getline(v:lnum)

  if (line =~ '^\s*}\s*' && prevline !~ '^\s*;')
    return match(prevline, '\S') - &shiftwidth
  endif

  return match(prevline, '\S')
endfunction

