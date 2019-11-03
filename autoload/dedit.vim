scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! dedit#edit(fpath)
  let sp_fpath = split(a:fpath, "/")
  let fname = sp_fpath[len(sp_fpath)-1]
  let dst_file = $TMPDIR . fname

  let resp = system(dedit#make_dcp_cmd(a:fpath, dst_file)) " todo: handle error
  if !empty(resp)
    echo resp
    return
  endif
  execute ":e " . dst_file

  call dedit#upload_when_save(a:fpath, dst_file)
endfunction

function! dedit#upload_when_save(fpath, bufname)
  let cmd = dedit#make_dcp_cmd(a:bufname, a:fpath)
  let aucmd = dedit#make_upload_when_save_autocmd(a:bufname, cmd)
  execute(aucmd)
endfunction

function! dedit#make_dcp_cmd(src, dst)
  return join(["docker", "cp", a:src, a:dst], " ")
endfunction

function! dedit#make_upload_when_save_autocmd(bufname, cmd)
  return join(["autocmd!", "BufWritePost", a:bufname, "echo system(\"" . a:cmd . "\")"], " ")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
