" Vim plugin file for inserting review comments
"
" Maintainer:	Karthick Gururaj <karthickgururaj at yahoo dot com>
" Last change:	Oct 20 2005
" Version:     0.2.0


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

