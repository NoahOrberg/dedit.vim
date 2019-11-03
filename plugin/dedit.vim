scriptencoding utf-8

if exists('g:loaded_dedit')
    finish
endif
let g:loaded_dedit = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=1 Dedit call dedit#edit(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
