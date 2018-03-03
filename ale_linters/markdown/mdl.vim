" Author: Steve Dignam <steve@dignam.xyz>, Josh Leeb-du Toit <joshleeb.com>
" Description: Support for mdl, a markdown linter.

call ale#Set('markdown_mdl_executable', 'mdl')
call ale#Set('markdown_mdl_options', '')

function! ale_linters#markdown#mdl#Handle(buffer, lines) abort
    " matches: '(stdin):173: MD004 Unordered list style'
    let l:pattern = ':\(\d*\): \(.*\)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \   'lnum': l:match[1] + 0,
        \   'text': l:match[2],
        \   'type': 'W',
        \})
    endfor

    return l:output
endfunction

function! ale_linters#markdown#mdl#GetCommand(buffer) abort
    let l:executable = ale#Var(a:buffer, 'markdown_mdl_executable')
    let l:options = ale#Var(a:buffer, 'markdown_mdl_options')

    return l:executable . (!empty(l:options) ? ' ' . l:options : '')
endfunction


call ale#linter#Define('markdown', {
\   'name': 'mdl',
\   'executable': 'mdl',
\   'command_callback': 'ale_linters#markdown#mdl#GetCommand',
\   'callback': 'ale_linters#markdown#mdl#Handle'
\})
