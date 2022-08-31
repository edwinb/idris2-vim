Idris 2 mode for vim
====================

This is an [Idris2][] mode for vim which features interactive editing,
syntax highlighting, indentation and optional syntax checking via
[Syntastic][]. If you need a REPL I recommend using [Vimshell][].
It is mostly cloned from the original [idris-mode][]. Unlike the Idris 1
mode, there is no need to have an Idris REPL running - it invokes Idris 2
directly.

If there is a `.ipkg` file in any of the parent directories, the mode will
use that as the root of the source tree, and process any options declared
in it (for example, to load packages).

Not all of the commands work yet. Note that the keyboard shortcuts have
been updated since Idris 1 to be consistent with the Atom mode (e.g.
`<LocalLeader>a` to add definition, rather than `<LocalLeader>d`) although
the old shortcuts still work.

![Screenshot](http://raichoo.github.io/images/vim.png)

## Installation

I recommend using [Pathogen][] for installation. Simply clone
this repo into your `~/.vim/bundle` directory and you are ready to go.

    cd ~/.vim/bundle
    git clone https://github.com/edwinb/idris2-vim.git

### Manual Installation

Copy content into your `~/.vim` directory.

Be sure that the following lines are in your
`.vimrc`


    syntax on
    filetype on
    filetype plugin indent on
    

### Installation on Vim 8 (or later)  

If you are using Vim 8 or the later you don't need a plugin manager, just follow this steps, 

        
    mkdir ~/.vim/pack/plugins
    cd ~/.vim/pack/plugins
    git clone https://github.com/edwinb/idris2-vim.git
                    
Add this lines to your
 `.vimrc` 
        
       
    packloadall
    let maplocalleader = ","        "Choose whatever symbol for localleader.

## Features

Apart from syntax highlighting, indentation, and unicode character concealing,
idris-vim offers some neat interactive editing features. For more information on
how to use it, read this blog article by Edwin Brady on [Interactive Idris editing with vim][].

## Interactive Editing Commands

[Idris2][] mode for vim offers interactive editing capabilities, the following
commands are supported.

`<LocalLeader>r` reload file

`<LocalLeader>t` show type

`<LocalLeader>a` Create an initial clause for a type declaration.

`<LocalLeader>c` case split

`<LocalLeader>mc` make case

`<LocalLeader>w` add with clause

`<LocalLeader>e` evaluate expression

`<LocalLeader>l` make lemma

`<LocalLeader>m` add missing clause

`<LocalLeader>f` refine item

`<LocalLeader>o` obvious proof search

`<LocalLeader>s` proof search

`<LocalLeader>i` open idris response window

`<LocalLeader>d` show documentation

## Configuration

### Indentation

To configure indentation in `idris-vim` you can use the following variables:

* `let g:idris_indent_if = 3`

        if bool
        >>>then ...
        >>>else ...

* `let g:idris_indent_case = 5`

        case xs of
        >>>>>[]      => ...
        >>>>>(y::ys) => ...

* `let g:idris_indent_let = 4`

        let x = 0 in
        >>>>x

* `let g:idris_indent_where = 6`

        where f : Int -> Int
        >>>>>>f x = x

* `let g:idris_indent_do = 3`

        do x <- a
        >>>y <- b

* `let g:idris_indent_rewrite = 8`

        rewrite prf in expr
        >>>>>>>>x

### Concealing

Concealing with unicode characters is off by default, but `let g:idris_conceal = 1` turns it on.

### Tab Characters

If you simply must use tab characters, and would prefer that the ftplugin not set expandtab add `let g:idris_allow_tabchar = 1`.


[Idris2]: https://github.com/edwinb/Idris2
[Syntastic]: https://github.com/scrooloose/syntastic
[Vimshell]: https://github.com/Shougo/vimshell.vim
[Pathogen]: https://github.com/tpope/vim-pathogen
[idris-mode]: https://github.com/idris-hackers/idris-vim
[Interactive Idris editing with vim]: http://edwinb.wordpress.com/2013/10/28/interactive-idris-editing-with-vim/

