if exists("b:vlog_plugin")
   finish
endif
let b:vlog_plugin = 1

" iabbrev <= <= #1

command! Aheader :call  AddHeader()
command! Allpn :call AddAlways("posedge", "negedge")
command! Allcom :call AddAlways("", "")
command! Acontent :call  AddContent()
command! Avlogauto :call  AddVlogAuto()


"===============================================================
"        Add File Header
"===============================================================
function! AddHeader()
  call append(0,  "//================================================================================")
  call append(1,  "// Created by         : Weiwei")
  call append(2,  "// Filename           : ".expand("%"))
  call append(3,  "// Author             : Weiwei Zhong")
  call append(4,  "// Author(Original)   : Weiwei Zhong")
  call append(5,  "// Created On         : ".strftime("%Y-%m-%d %H:%M"))
  call append(6,  "// Last Modified      : ")
  " call append(6,  "// Update Count       : ".strftime("%Y-%m-%d %H:%M"))
  call append(7,  "// Description        : ")
  call append(8,  "// ")
  call append(9, "//================================================================================")
endfunction
"===============================================================
"
"===============================================================
function! AddContent()
  let curr_line = line(".")
  call append(curr_line,   "//================================================================================")
  call append(curr_line+1, "//Function  : ")
  "call append(curr_line+2, "//            ")
  call append(curr_line+2, "//Arguments : ")
  "call append(curr_line+4, "//            ")
  call append(curr_line+3, "//================================================================================")
endfunction
"===============================================================
"        Add an always statement
"===============================================================
function! AddAlways(clk_edge, rst_edge)
   for line in getline(1, line("$"))
      if line =~ '^\s*\<input\>.*//\s*\<clock\>\s*$'
         let line = substitute(line, '^\s*\<input\>\s*', "", "")
         let clk = substitute(line, '\s*;.*$', "", "")
      elseif line =~ '^\s*\<input\>.*//\s*\<reset\>\s*$'
         let line = substitute(line, '^\s*\<input\>\s*', "", "")
         let rst = substitute(line, '\s*;.*$', "", "")
      elseif line =~ '^\s*\<reg\>.*//\s*\<clock\>\s*$'
         let line = substitute(line, '^\s*\<reg\>\s*', "", "")
         let clk = substitute(line, '\s*;.*$', "", "")
      elseif line =~ '^\s*\<reg\>.*//\s*\<reset\>\s*$'
         let line = substitute(line, '^\s*\<reg\>\s*', "", "")
         let rst = substitute(line, '\s*;.*$', "", "")
      endif
   endfor
   let curr_line = line(".")
   if a:clk_edge == "posedge" && a:rst_edge == "posedge"
      call append(curr_line,   "always @(posedge ".clk." or posedge ".rst.")")
      call append(curr_line+1, "begin")
      call append(curr_line+2, "  if (".rst.") begin")
      call append(curr_line+3, "  end")
      call append(curr_line+4, "  else begin")
      call append(curr_line+5, "  end")
      call append(curr_line+6, "end")
   elseif a:clk_edge == "negedge" && a:rst_edge == "posedge"
      call append(curr_line,   "always @(negedge ".clk." or posedge ".rst.")")
      call append(curr_line+1, "begin")
      call append(curr_line+2, "  if (".rst.") begin")
      call append(curr_line+3, "  end")
      call append(curr_line+4, "  else begin")
      call append(curr_line+5, "  end")
      call append(curr_line+6, "end")
   elseif a:clk_edge == "posedge" && a:rst_edge == "negedge"
      call append(curr_line,   "always @(posedge ".clk." or negedge ".rst.")")
      call append(curr_line+1, "begin")
      call append(curr_line+2, "  if (!".rst.") begin")
      call append(curr_line+3, "  end")
      call append(curr_line+4, "  else begin")
      call append(curr_line+5, "  end")
      call append(curr_line+6, "end")
   elseif a:clk_edge == "negedge" && a:rst_edge == "negedge"
      call append(curr_line,   "always @(negedge ".clk." or negedge ".rst.")")
      call append(curr_line+1, "begin")
      call append(curr_line+2, "  if (!".rst.") begin")
      call append(curr_line+3, "  end")
      call append(curr_line+4, "  else begin")
      call append(curr_line+5, "  end")
      call append(curr_line+6, "end")
   elseif a:clk_edge == "posedge" && a:rst_edge == ""
      call append(curr_line,   "always @(posedge ".clk.")")
      call append(curr_line+1, "begin")
      call append(curr_line+2, "end")
   elseif a:clk_edge == "negedge" && a:rst_edge == ""
      call append(curr_line,   "always @(negedge ".clk.")")
      call append(curr_line+1, "begin")
      call append(curr_line+2, "end")
   else
      call append(curr_line,   "always @(*)")
      call append(curr_line+1, "begin")
      call append(curr_line+2, "end")
   endif
endfunction

"===============================================================
"        Add verilog-mode auto cfg
"===============================================================
function! AddVlogAuto()
  call append(line('$'),  "///////////////////////////////////////////////////////////////////////////")
  call append(line('$'),  "// Local Variables:")
  call append(line('$'),  "// verilog-library-flags:\(\"-y ./ \"\)")
  call append(line('$'),  "// verilog-auto-inst-param-value:t")
  call append(line('$'),  "// verilog-auto-star-save: f")
  " call append(line('$'),  "// eval:(verilog-read-defines)")
  " call append(line('$'),  "// eval:(verilog-read-includes)")
  call append(line('$'),  "// End:")
  call append(line('$'),  "///////////////////////////////////////////////////////////////////////////")
endfunction

"===============================================================

" autocmd BufWritePre,FileWritePre *.v,*.sv,*.vh,*.svh   ks|silent call LastModified()|'s
"
autocmd BufWritePre,FileWritePre *   ks|silent call LastModified()|'s
function! LastModified()
    let l = line("$")
    exe "1," . l . "g/Last Modified      :/s/Last Modified      :.*/Last Modified      : " .
        \ strftime("%Y-%m-%d %H:%M")
endfun


