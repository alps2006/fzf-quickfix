scriptencoding utf-8

" Copyright (c) 2018-2019 Filip Szymański. All rights reserved.
" Use of this source code is governed by an MIT license that can be
" found in the LICENSE file.

let s:keep_cpo = &cpoptions
set cpoptions&vim

function! s:error_type(type, nr) abort
  if a:type ==? 'W'
    let l:msg = ' warning'
  elseif a:type ==? 'I'
    let l:msg = ' info'
  elseif a:type ==? 'E' || (a:type ==# "\0" && a:nr > 0)
    let l:msg = ' error'
  elseif a:type ==# "\0" || a:type ==# "\1"
    let l:msg = ''
  else
    let l:msg = ' ' . a:type
  endif

  if a:nr <= 0
    return l:msg
  endif

  return printf('%s %3d', l:msg, a:nr)
endfunction

function! s:format_error(item) abort
  return (a:item.bufnr ? bufname(a:item.bufnr) : '')
        \ . ':' . (a:item.lnum  ? a:item.lnum : '')
        \ . ':' . (a:item.col ? a:item.col : '0')
        \ . s:error_type(a:item.type, a:item.nr)
        \ . ':' . substitute(a:item.text, '\v^\s*', ' ', '')
endfunction

function! s:error_handler(err) abort
  let l:match = matchlist(a:err, '\v^([^:]*):(\d+)?%(:(\d+))?.*:')[1:3]
  if empty(l:match) || empty(l:match[0])
    return
  endif

  if empty(l:match[1]) && (bufnr(l:match[0]) == bufnr('%'))
    return
  endif

  let l:path = l:match[0] 
  let l:bnum = bufnr(l:path)
  let l:lnum = empty(l:match[1]) ? 1 : str2nr(l:match[1])
  let l:col = empty(l:match[2]) ? 1 : str2nr(l:match[2])

  if l:bnum == -1
    execute 'e ' . l:path
  elseif l:bnum != bufnr()
    execute 'e#' . l:bnum
  endif
  call cursor(l:lnum, l:col)
  normal! zvzz
endfunction

function! s:syntax() abort
  if has('syntax') && exists('g:syntax_on')
    syntax match fzfQfFileName '^[^|]*' nextgroup=fzfQfSeparator
    syntax match fzfQfSeparator '|' nextgroup=fzfQfLineNr contained
    syntax match fzfQfLineNr '[^|]*' contained contains=fzfQfError
    syntax match fzfQfError 'error' contained

    highlight default link fzfQfFileName Directory
    highlight default link fzfQfLineNr LineNr
    highlight default link fzfQfError Error
  endif
endfunction

function! fzf_quickfix#run(...) abort
  let l:opts = {
        \ 'source': map(a:1 ? getloclist(0) : getqflist(), 's:format_error(v:val)'),
        \ 'column': 1,
        \ 'sink*': function('s:error_handler'),
        \ 'options': fzf#vim#with_preview({'options': '--ansi --preview-window +{2}-/2 ' . printf('--prompt="%s> "', (a:1 ? 'LocList' : 'QfList')) . ' --color hl:4,hl+:12 --delimiter ":" --nth 1,4.. --no-sort --layout=reverse-list --bind alt-j:preview-down,alt-k:preview-up,alt-d:preview-half-page-down,alt-u:preview-half-page-up'}, 'up:wrap:60%', '?')['options']
        \ }
  call fzf#run(fzf#wrap('quickfix', l:opts, 1))
  if g:fzf_quickfix_syntax_on
    call s:syntax()
  endif
endfunction

let &cpoptions = s:keep_cpo
unlet s:keep_cpo

" vim: et sw=2 ts=2
