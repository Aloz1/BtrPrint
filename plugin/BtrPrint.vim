" Ensure script is only loaded once
if exists( "g:BtrPrint#_loaded" )
    finish
endif
let g:BtrPrint_loaded = 1

function! SaveColourScheme()
    redir! => s:PrevColour
    silent color
    redir! END
    redir! => s:Highlight
    silent hi!
    redir! END
    let l:highlightList = split( s:Highlight, "\n" )
    unlet l:highlightList[0]
    let s:Highlight = ""
    let s:PrevColour = s:PrevColour[1:-1]
    let s:PrevBackground = &background

    for i in l:highlightList
        let tmpList = split( i )
        let mtch = match( tmpList, 'xxx' )
        if mtch != -1
            unlet tmpList[ mtch ]
        endif
        let s:Highlight = s:Highlight . join( tmpList ) . "\n"
    endfor
endfunction

function! ApplyColourScheme()
    let l:highlightList = split( s:Highlight, "\n" )
    for i in l:highlightList
        let tmpStr = 'highlight clear ' . split( i )[0]
        exe tmpStr
    endfor
    exe "silent! color " . s:colorName
endfunction

function! RestoreOldScheme()
    let l:highlightList = split( s:Highlight, "\n" )
    for i in l:highlightList
        let l:tmpList = split( i )

        let mtch = match( l:tmpList, "cleared" )
        if mtch != -1
            let l:tmpList[mtch] = l:tmpList[mtch - 1]
            let l:tmpList[mtch - 1] = "clear"
        endif

        let mtch = match( l:tmpList, "links" )
        if mtch != -1
            let l:tmpList[mtch] = l:tmpList[mtch - 1]
            let l:tmpList[mtch + 1] = l:tmpList[mtch + 2]
            let l:tmpList[mtch - 1] = "link"
            unlet l:tmpList[mtch + 2]
        endif
        let i = join( l:tmpList )

        exe "highlight " . i
    endfor
    let &background = s:PrevBackground
endfunction

" Main printing function
function! <SID>BtrPrint( line1, line2, bang, args)
    " Setup variables used in function
    let argList = split( a:args )
    let s:colorName = ""

    if exists( "g:BtrPrint_color" )
        let s:colorName = g:BtrPrint_color
    endif

    let mtch = match( argList, "^color" )
    if mtch != -1 
        if match( argList[mtch], "=" ) == "5"
            let s:colorName = argList[mtch][6:-1]
            unlet argList[mtch]
        elseif len( argList ) >= ( mtch + 1 )
            let s:colorName = argList[mtch + 1]
            unlet argList[mtch + 1]
            unlet argList[mtch]
        else
            unlet argList[mtch]
        endif
    endif

    " Save current colour scheme then overwrite it. Later we will restore the
    " colour scheme to its original state.
    call SaveColourScheme()
    call ApplyColourScheme()

    exe a:line1 . "," . a:line2 . "hardcopy" . a:bang . " " . join( argList )

    call RestoreOldScheme()

endfunction

command! -nargs=* -range=% -bang BtrPrint call <SID>BtrPrint("<line1>","<line2>","<bang>","<args>")
