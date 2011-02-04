" Vim plugin file for inserting review comments
"
" Maintainer:  Dariusz (devemouse) Synowiec <devemouse@gmail.com>
" Last change: 2011-02-04
" Version:     0.3.0

if exists("g:loaded_CodeReviewer")
   finish
endif
let g:loaded_CodeReviewer = 1 

if !exists("g:CodeReviewer_defects")
   let g:CodeReviewer_defects = '\[\(Defect\|Remark\|Question\)\]'
endif

if !exists("g:CodeReviewer_defaultDefect ")
   let g:CodeReviewer_defaultDefect = "[Defect]"
endif

if !exists("g:CodeReviewer_lineContinuation ")
   let g:CodeReviewer_lineContinuation = '\\'
endif

nmap <leader>cri :call codereviewer#InsertComment()<cr>A 
nmap <leader>crI yy:call codereviewer#InsertComment()<cr>A<BS> <<<Esc>pkJA >>: 

com! SortReviewFile :call codereviewer#SortReviewFile()

