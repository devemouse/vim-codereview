" Vim plugin file for inserting review comments - functions
"
" Maintainer:  Dariusz (devemouse) Synowiec <devemouse@gmail.com>
" Last change: 2011-02-04
" Version:     0.3.0


function! codereviewer#InsertComment() 
   "save positin
   let g:CodeReviewer_fileName = expand( "%" )
   let g:CodeReviewer_lineNumber = line( "." ) 

   " Need this option for the above function to work properly
   set switchbuf=useopen

   "open/switch to review file
   let openingCommand = "sb" 
   if ( bufwinnr( g:CodeReviewer_reviewFile ) < 0 ) 
      let openingCommand = "sp" 
   endif 
   execute openingCommand . " " . g:CodeReviewer_reviewFile

   let commentLine = g:CodeReviewer_fileName . ":" 
   let commentLine = commentLine . g:CodeReviewer_lineNumber . ": " 
   if exists("g:CodeReviewer_reviewer")
      let commentLine = " " . commentLine . g:CodeReviewer_reviewer . " - " 
   endif
   let commentLine = commentLine . g:CodeReviewer_defaultDefect . " "

   $put=commentLine 
endfunction 


function! codereviewer#SortReviewFile()
  " For handling multi-line comments, club them with ctrl-A...
  "   first, search for lines to be joined with the next
  vglobal/\n^[a-zA-Z0-9\.\\\/_]\+:[0-9]\+:/ substitute /\(.*$\)/\1/
  "   if the last char is the line continuation character, insert ctrl-A
  if exists("g:CodeReviewer_lineContinuation")
     exe 'silent! %s/\(' . g:CodeReviewer_lineContinuation . '\)$/\1'
  endif
  "   next, join them
  silent! %s/\n//
  "   ..corner case - remove trailing ctrl-As
  silent! %s/$//
  " Sort all lines
  silent call SortR(0, line("$"), "codereviewer#DefectCmp")

  if exists("g:CodeReviewer_sortDefects") && g:CodeReviewer_sortDefects == 1
     " This script uses registers D, Q, and R, so save register values
     let d=@d 
     let q=@q
     let r=@r
     let @d=""  " Clear contents of register d
     silent! g/\[Defect\]/ delete D  " Transfer all defects to register D
     let @q="" 
     silent! g/\[Question\]/ delete Q
     let @r="" 
     silent! g/\[Remark\]/ delete R
     " Remove rest of the lines too - should be none really
     silent! g/^/ delete _
     " Start putting stuff back
     " Put major comments first, then questions, then minor comments, then nits
     silent! normal G"dPG"qPG"rP
     " Remove blank lines if any
     silent! g/^$/ d

     " Restore register values
     let d=@d 
     let q=@q
     let r=@r
  endif

  "   ..replace ctrl-As with newline characters
  silent! %s///g
endfunction

" Function for use with SortR()
func! codereviewer#DefectCmp(str1, str2)
  let fname1 = matchstr(a:str1, "[^:]*")
  let line_num1 = matchstr(a:str1, "[^:]*", strlen(fname1) + 1)
  let author1 = matchstr(a:str1, "[^-]*", strlen(fname1) + 1 + strlen(line_num1) + 1)
  let fname2 = matchstr(a:str2, "[^:]*")
  let line_num2 = matchstr(a:str2, "[^:]*", strlen(fname2) + 1)
  let author2 = matchstr(a:str2, "[^-]*", strlen(fname2) + 1 + strlen(line_num2) + 1)
  if (fname1 < fname2)
	return -1
  elseif (fname1 > fname2)
	return 1
  elseif (line_num1 + 0 < line_num2 + 0 )
	return -1
  elseif (line_num1 + 0 > line_num2 + 0)
	return 1
  elseif (author1 < author2)
	return -1
  elseif (author1 > author2)
	return 1
  else
	return 0
  endif
endfunction
