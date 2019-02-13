" Source:
" https://vim-china.org/topic/9/%E5%AD%A6%E4%B9%A0%E5%86%99%E6%8F%92%E4%BB%B6

" Find the project root

if !exists('g:vivid_root_markers')
  if exists('g:ctrlp_root_markers')
    let g:vivid_root_markers = g:ctrlp_root_markers
  else
    let g:vivid_root_markers = ['.design_top', '.prj_top'] 
  endif
endif

function! Vivid_search_root()
  " Get current file path
  let l:root = fnamemodify(".", ":p:h")

  if !empty(g:vivid_root_markers)
    let root_found = 0
    let l:cur_dir = fnamemodify(l:root, ":p:h")
    let l:prev_dir = ""

    while l:cur_dir != l:prev_dir
      for tags_dir in g:vivid_root_markers
        let l:tag_path = l:cur_dir . "/" . tags_dir
        if filereadable(l:tag_path) || isdirectory(l:tag_path)
          let root_found = 1 | break
        endif
      endfor

      " If found, break from while loop
      if root_found
        let l:root = l:cur_dir | break
      endif

      " Otherwise, go to upper level
      let l:prev_dir = l:cur_dir
      let l:cur_dir = fnamemodify(l:cur_dir, ":p:h:h")

    endwhile

    return root_found ? l:root : ""
  endif

  return l:root
endfunction
