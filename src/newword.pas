{**********************************************************************}
{                                                                      }
{            L      U   U   DDDD   W      W  IIIII   GGGG              }
{            L      U   U   D   D   W    W     I    G                  }
{            L      U   U   D   D   W ww W     I    G   GG             }
{            L      U   U   D   D    W  W      I    G    G             }
{            LLLLL   UUU    DDDD     W  W    IIIII   GGGG              }
{                                                                      }
{**********************************************************************}
{   This source file by:                                               }
{                                                                      }
{       Mark R. Prior (1987);                                          }
{       Tracy Schunke (1989);                                          }
{       Jeff Blows (1989); and                                         }
{       Kelvin B. Nicolle (1989).                                      }
{                                                                      }
{  Copyright  1987, 1989 University of Adelaide                        }
{                                                                      }
{  Permission is hereby granted, free of charge, to any person         }
{  obtaining a copy of this software and associated documentation      }
{  files (the "Software"), to deal in the Software without             }
{  restriction, including without limitation the rights to use, copy,  }
{  modify, merge, publish, distribute, sublicense, and/or sell copies  }
{  of the Software, and to permit persons to whom the Software is      }
{  furnished to do so, subject to the following conditions:            }
{                                                                      }
{  The above copyright notice and this permission notice shall be      }
{  included in all copies or substantial portions of the Software.     }
{                                                                      }
{  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,     }
{  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF  }
{  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND               }
{  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS }
{  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN  }
{  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN   }
{  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE    }
{  SOFTWARE.                                                           }
{**********************************************************************}

{++
! Name:         NEWWORD
!
! Description:  Word Processing Commands for the new Ludwig command set.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/newword.pas,v 4.6 1990/01/18 17:45:17 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: newword.pas,v $
! Revision 4.6  1990/01/18 17:45:17  ludwig
! Entered into RCS at revision level 4.6
!
!
!
! Revision History:
! 4-001 Mark R. Prior                                        ??
!       New code.
! 4-002 Tracy Schunke                                          -Apr-1989
!       Fix bug in DW command, a mark pointer was being copied instead
!       of the mark structure being duplicated.
! 4-003 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-004 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
! 4-005 Kelvin B. Nicolle                                    13-Sep-1989
!       Add includes etc. for Tower version.
! 4-006 Kelvin B. Nicolle                                    25-Oct-1989
!       Correct the includes for the Tower version.
!--}

{#if vms}
{##[ident('4-006'),}
{## overlaid]}
{##module newword (output);}
{#elseif turbop}
unit newword;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'newword.fwd'}
{##%include 'mark.h'}
{##%include 'text.h'}
{##%include 'line.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "newword.h"}
{####include "line.h"}
{####include "mark.h"}
{####include "text.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=newword.h#>}
{###<$F=line.h#>}
{###<$F=mark.h#>}
{###<$F=text.h#>}
{#elseif turbop}
interface
  uses value;
  {$I newword.i}

implementation
  uses line, mark, text;
{#endif}


function newword_advance_word (
		rept      : leadparam;
		count     : integer;
		from_span : boolean)
	: boolean;

  label
    98,99;

  var
    new_dot : mark_ptr;

  function current_word(
		  dot : mark_ptr)
	  : boolean;

    label
      99;

    var
      element : word_set_range;

    begin
    current_word := false;
    with dot^ do
      begin
      if line^.used+2 < col then
	begin
	{ check that we aren't past the last word in the para }
	if line^.flink = nil then { no more lines => end of para }
	  goto 99;
	if line^.flink^.used = 0 then { next line blank => end of para }
	  goto 99;
	{ In the middle of a paragraph so go to end of line }
	col := line^.used;
	end
      else if line^.used < col then
	col := line^.used;
      { But were we in the blank line before a paragraph? }
      if col = 0 then
	goto 99;
      while (col > 1) and (ord(line^.str^[col]) in word_elements[0]) do
	col := col - 1;
      if (ord(line^.str^[col]) in word_elements[0]) then
	{ we must have been somewhere on the line before the first word }
	begin
	if line^.blink = nil then { oops top of the frame reached }
	  goto 99;
	if line^.blink^.used = 0 then { inside a paragraph break }
	  goto 99;
	if not mark_create(line^.blink,line^.blink^.used,dot) then
	  goto 99;
	end;
      { ASSERT: we now have dot sitting on part of a word }
      element := 0;
      while not (ord(line^.str^[col]) in word_elements[element]) do
	element := element + 1;
      { Now find the start of this word }
      while (col > 1) and (ord(line^.str^[col]) in word_elements[element]) do
	col := col - 1;
      if not (ord(line^.str^[col]) in word_elements[element]) then
	col := col + 1;
      current_word :=true;
      end;
  99:
    end; {current_word}

  function next_word(
		  dot : mark_ptr)
	  : boolean;

    label
      99;

    var
      element : word_set_range;

    begin
    next_word := false;
    with dot^ do
      begin
      if col > line^.used then
	begin
	{ check that we aren't on a blank line }
	if line^.used = 0 then
	  goto 99;
	{ All clear so fake it that we were at the end of the last word! }
	col := line^.used;
	end;
      element := 0;
      while not (ord(line^.str^[col]) in word_elements[element]) do
	element := element + 1;
      while     (col < line^.used)
	    and (ord(line^.str^[col]) in word_elements[element]) do
	col := col + 1;
      if ord(line^.str^[col]) in word_elements[element] then
	begin
	if line^.flink = nil then { no more lines }
	  goto 99;
	if line^.flink^.used = 0 then { end of paragraph }
	  goto 99;
	if not mark_create(line^.flink,1,dot) then
	  goto 99;
	end;
      while ord(line^.str^[col]) in word_elements[0] do
	col := col + 1;
      next_word := true;
      end;
  99:
    end; {next_word}

  function previous_word(
		  dot : mark_ptr)
	  : boolean;

    label
      99;

    var
      element : word_set_range;

    begin
    previous_word := false;
    with dot^ do
      begin
      element := 0;
      while not (ord(line^.str^[col]) in word_elements[element]) do
	element := element + 1;
      while (col > 1) and (ord(line^.str^[col]) in word_elements[element]) do
	col := col - 1;
      if ord(line^.str^[col]) in word_elements[element] then
	begin
	if line^.blink = nil then { no more lines }
	  goto 99;
	if line^.blink^.used = 0 then { top of paragraph }
	  goto 99;
	if not mark_create(line^.blink,line^.blink^.used,dot) then
	  goto 99;
	end;
      if not current_word(dot) then
	goto 99;
      previous_word := true;
      end;
  99:
    end; {previous_word}

  begin {newword_advance_word}
  newword_advance_word := false;
  with current_frame^ do
    begin
    new_dot := nil;
    if not mark_create(dot^.line,dot^.col,new_dot) then
      goto 99;
    if rept = marker then
      begin
      if not mark_create(marks[count]^.line,marks[count]^.col,new_dot) then
	goto 98;
      rept := nint;
      count := 0;
      end;
    { If we are doing a 0AW we need to go to the current word, -nAW does this }
    if (rept = pint) and (count = 0) then
      rept := nint;
    case rept of
      none,plus,pint :
	begin
	while count > 0 do
	  begin
	  count := count - 1;
	  if not next_word(new_dot) then
	    goto 98;
	  end;
	if not mark_create(new_dot^.line,new_dot^.col,dot) then
	  goto 98;
	end;
      minus,nint :
	begin
	count := -count;
	if not current_word(new_dot) then
	  goto 98;
	while count > 0 do
	  begin
	  count := count - 1;
	  if not previous_word(new_dot) then
	    goto 98;
	  end;
	if not mark_create(new_dot^.line,new_dot^.col,dot) then
	  goto 98;
	end;
      pindef :
	with new_dot^ do
	  begin
	  if line^.used = 0 then { Fail if we are on a blank line }
	    goto 98;
	  if col > line^.used+2 then
	    begin
	    { check that we aren't past the last word in the para }
	    if line^.flink = nil then { no more lines => end of para }
	      goto 98;
	    if line^.flink^.used = 0 then { next line blank => end of para }
	      goto 98;
	    { In the middle of a paragraph so go it end of line }
	    col := line^.used;
	    end;
	  while next_word(new_dot) do
	   if not mark_create(line,col,dot) then
	     goto 98;
	  { now on last word of paragraph }
	  {*** next statement should be more sophisticated }
	  {    what about the right margin?? }
	  if line^.used+2 > max_strlenp then
	    begin
	    if not mark_create(line,max_strlenp,dot) then
	      goto 98;
	    end
	  else
	    if not mark_create(line,line^.used+2,dot) then
	      goto 98;
	  end;
      nindef :
	begin
	if not current_word(new_dot) then
	  goto 98;
	if not mark_create(new_dot^.line,new_dot^.col,dot) then
	  goto 98;
	while previous_word(new_dot) do
	 if not mark_create(new_dot^.line,new_dot^.col,dot) then
	   goto 98;
	end;
    end;
    newword_advance_word := true;
    end;
98:
  if not mark_destroy(new_dot) then
    ;
99:
  end; {newword_advance_word}


function newword_delete_word (
		rept      : leadparam;
		count     : integer;
		from_span : boolean)
	: boolean;

  { Delete Word deletes the same words as advance word advances over.}
  label 99;
  var
    old_pos,
    here,
    another_mark,
    the_other_mark : mark_ptr;
    old_dot_col,
    line_nr,
    new_line_nr : line_range;

  begin {newword_delete_word}
  newword_delete_word := false;
  with current_frame^ do
    begin
    old_pos := nil;
    here := nil;
    the_other_mark := nil;
    if not mark_create(dot^.line, dot^.col, old_pos) then goto 99;
    {First Step.}
    {  Get to the beginning of the word if we are in the middle of it}
    if not newword_advance_word(pint, 0, from_span) then goto 99;
    {ASSERTION: We are on the beginning of a word}
    if not mark_create(dot^.line, dot^.col, here) then goto 99;
    if not newword_advance_word(rept, count, from_span) then
      begin {Put Dot back and bail out}
      if not mark_create(old_pos^.line, old_pos^.col, dot) then goto 99;
      goto 99;
      end;
    {OK. We now wipe out everything from Dot to here}
    old_dot_col := dot^.col;
    if not mark_create(dot^.line,dot^.col,the_other_mark) then goto 99;
    if not line_to_number(the_other_mark^.line,line_nr) then goto 99;
    if not line_to_number(here^.line,new_line_nr) then goto 99;
    if  (line_nr > new_line_nr)
      or ((line_nr = new_line_nr) and (the_other_mark^.col > here^.col))
    then
      begin     { Reverse mark pointers to get The_Other_Mark first. }
      another_mark   := here;
      here       := the_other_mark;
      the_other_mark := another_mark;
      end;
    if current_frame <> frame_oops then
      begin
      with frame_oops^ do { Make sure oops_span is okay. }
	begin
	  if not mark_create(last_group^.last_line,1,span^.mark_two) then
	    goto 99;
	  newword_delete_word := text_move(false           { Dont copy,transfer}
					  ,1               { One instance of }
					  ,the_other_mark  { starting pos.   }
					  ,here            { ending pos.     }
					  ,span^.mark_two  { destination.    }
					  ,marks[0]        { leave at start. }
					  ,dot             { leave at end.   }
					  );
	end;
      end
    else
      begin
      newword_delete_word := text_remove(the_other_mark   { starting pos.   }
				     ,here         { ending pos.     }
				     );
      end;
    if line_nr <> new_line_nr then
      newword_delete_word := text_split_line(dot, old_dot_col, here);
    end;
99:
  if old_pos <> nil then
    if not mark_destroy(old_pos) then
      ;
  if here <> nil then
    if not mark_destroy(here) then
      ;
  if the_other_mark <> nil then
    if not mark_destroy(the_other_mark) then
      ;
  end; {newword_delete_word}


function newword_advance_paragraph (
		rept      : leadparam;
		count     : integer;
		from_span : boolean)
	: boolean;

  label
    98,99;

  var
    pos      : col_range;
    new_dot  : mark_ptr;
    new_line : line_ptr;

  function current_paragraph(
		  dot : mark_ptr)
	  : boolean;

    label
      99;

    var
      pos      : col_range;
      new_line : line_ptr;

    begin
    current_paragraph := false;
    new_line := dot^.line;
    if (dot^.col < dot^.line^.used) then
      begin
      pos := dot^.col;
      while (pos > 1) and (ord(new_line^.str^[pos]) in word_elements[0]) do
	pos := pos - 1;
      if (ord(new_line^.str^[pos]) in word_elements[0]) then
	if new_line^.blink = nil then
	  goto 99
	else
	  new_line := new_line^.blink;
      end;
    while (new_line^.blink <> nil) and (new_line^.used = 0) do
      new_line := new_line^.blink;
    if new_line^.used = 0 then
      goto 99;
    while (new_line^.blink <> nil) and (new_line^.used <> 0) do
      new_line := new_line^.blink;
    if new_line^.used = 0 then
      new_line := new_line^.flink; { Oops too far! }
    pos := 1;
    while ord(new_line^.str^[pos]) in word_elements[0] do
      pos := pos + 1;
    if not mark_create(new_line,pos,dot) then
      goto 99;
    current_paragraph := true;
  99:
    end; {current_paragraph}

  function next_paragraph(
		  dot : mark_ptr)
	  : boolean;

    label
      99;

    var
      pos      : col_range;
      new_line : line_ptr;

    begin
    next_paragraph := false;
    new_line := dot^.line;
    if (dot^.col < dot^.line^.used) then
      begin
      pos := dot^.col;
      while (pos > 1) and (ord(new_line^.str^[pos]) in word_elements[0]) do
	pos := pos - 1;
      if (ord(new_line^.str^[pos]) in word_elements[0]) then
	if new_line^.blink = nil then
	  begin
	  dot^.col := 1;
	  while ord(new_line^.str^[dot^.col]) in word_elements[0] do
	    dot^.col := dot^.col + 1;
	  next_paragraph := true;
	  goto 99;
	  end
	else
	  new_line := new_line^.blink;
      end;
    while (new_line^.flink <> nil) and (new_line^.used <> 0) do
      new_line := new_line^.flink;
    if new_line^.used <> 0 then
      goto 99;
    while (new_line^.flink <> nil) and (new_line^.used = 0) do
      new_line := new_line^.flink;
    if new_line^.used = 0 then
      goto 99;
    pos := 1;
    while ord(new_line^.str^[pos]) in word_elements[0] do
      pos := pos + 1;
    if not mark_create(new_line,pos,dot) then
      goto 99;
    next_paragraph := true;
  99:
    end; {next_paragraph}

  begin {newword_advance_paragraph}
  newword_advance_paragraph := false;
  with current_frame^ do
    begin
    new_dot := nil;
    if not mark_create(dot^.line,dot^.col,new_dot) then
      goto 99;
    if rept = marker then
      begin
      if not mark_create(marks[count]^.line,marks[count]^.col,new_dot) then
	goto 98;
      rept := nint;
      count := 0;
      end;
    { If we are doing a 0AP we need to go to the current para, -nAP does this }
    if (rept = pint) and (count = 0) then
      rept := nint;
    case rept of
      none,plus,pint :
	begin
	while count > 0 do
	  begin
	  count := count - 1;
	  if not next_paragraph(new_dot) then
	    goto 98;
	  end;
	if not mark_create(new_dot^.line,new_dot^.col,dot) then
	  goto 98;
	end;
      minus,nint :
	begin
	count := -count;
	if not current_paragraph(new_dot) then
	  goto 98;
	while count > 0 do
	  begin
	  count := count - 1;
	  if new_dot^.line^.blink = nil then
	    goto 98;
	  if not mark_create(new_dot^.line^.blink,1,new_dot) then
	    goto 98;
	  if not current_paragraph(new_dot) then
	    goto 98;
	  end;
	if not mark_create(new_dot^.line,new_dot^.col,dot) then
	  goto 98;
	end;
      pindef :
	begin
	if not mark_create(last_group^.last_line,margin_left,dot) then
	  goto 98;
	end;
      nindef :
	begin
	new_line := new_dot^.line;
	while (new_line^.blink <> nil) and (new_line^.used = 0) do
	  new_line := new_line^.blink;
	if new_line^.used = 0 then
	  goto 98;
	{ OK we know that there is a paragraph behind us, so goto }
	{ the top of the file and go down to the first paragraph  }
	new_line := first_group^.first_line;
	while new_line^.used = 0 do
	  new_line := new_line^.flink;
	pos := 1;
	while ord(new_line^.str^[pos]) in word_elements[0] do
	  pos := pos + 1;
	if not mark_create(new_line,pos,dot) then
	  goto 98;
	end;
    end;
    newword_advance_paragraph := true;
    end;
98:
  if not mark_destroy(new_dot) then
    ;
99:
  end; {newword_advance_paragraph}


function newword_delete_paragraph (
		rept      : leadparam;
		count     : integer;
		from_span : boolean)
	: boolean;

  label
    99;

  var
    old_pos,
    here,
    another_mark,
    the_other_mark : mark_ptr;
    line_nr,
    new_line_nr : line_range;

  begin {newword_delete_paragraph}
  newword_delete_paragraph := false;
  with current_frame^ do
    begin
    old_pos := nil;
    here := nil;
    the_other_mark := nil;
    if not mark_create(dot^.line, dot^.col, old_pos) then goto 99;
    { Get to the beginning of the paragraph }
    if not newword_advance_paragraph(pint, 0, from_span) then
      goto 99;
    if not mark_create(dot^.line, 1, here) then
      goto 99;
    if not newword_advance_paragraph(rept, count, from_span) then
      begin { Something wrong so put dot back and abort }
      if not mark_create(old_pos^.line, old_pos^.col, dot) then
	;
      goto 99;
      end;
    { Now delete all the lines between marks dot and here }
    if not mark_create(dot^.line, 1, the_other_mark) then
      goto 99;
    if not line_to_number(the_other_mark^.line,line_nr) then
      goto 99;
    if not line_to_number(here^.line,new_line_nr) then
      goto 99;
    if  line_nr > new_line_nr then
      begin { reverse marks to get the_other_mark first. }
      another_mark   := here;
      here           := the_other_mark;
      the_other_mark := another_mark;
      end;
    if current_frame <> frame_oops then
      begin
      with frame_oops^ do { Make sure oops_span is okay. }
	begin
	if not mark_create(last_group^.last_line,1,span^.mark_two) then
	  goto 99;
	newword_delete_paragraph :=
	  text_move(false               { Dont copy, transfer }
		   ,1                   { One instance of     }
		   ,the_other_mark      { starting pos.       }
		   ,here                { ending pos.         }
		   ,span^.mark_two      { destination.        }
		   ,marks[mark_equals]  { leave at start.     }
		   ,dot                 { leave at end.       }
		   );
	end;
      end
    else
      begin
      newword_delete_paragraph :=
	text_remove(the_other_mark   { starting pos.       }
		   ,here             { ending pos.         }
		   );
      end;
    end;
99:
  if old_pos <> nil then
   if not mark_destroy(old_pos) then
     ;
  if here <> nil then
   if not mark_destroy(here) then
     ;
  if the_other_mark <> nil then
   if not mark_destroy(the_other_mark) then
     ;
  end; {newword_delete_paragraph}

{#if vms or turbop}
end.
{#endif}
