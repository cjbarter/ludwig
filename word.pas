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
{       Chris J. Barter (1979-89)                                      }
{       Kelvin B. Nicolle (1987, 1989);                                }
{       Jeff Blows (1989); and                                         }
{       Martin Sandiford (1990),                                       }
{                                                                      }
{  Copyright  1979-81, 1987-89 University of Adelaide                  }
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
! Name:         WORD
!
! Description:  Word Processing Commands in Ludwig.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/word.pas,v 4.8 1990/05/23 14:47:52 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: word.pas,v $
! Revision 4.8  1990/05/23 14:47:52  ludwig
! Missed the initialization of "the_other_mark" in previous edit.
!
! Revision 4.7  90/05/16  11:59:01  ludwig
! Fix bug in YD command, a mark pointer was being copied
! instead of the mark structure being duplicated.
! Same problem as fixed in the newword module, edit 4-002.
!
! Revision 4.6  90/01/18  16:48:15  ludwig
! Entered into RCS archive
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                    22-May-1987
!       In word_advance, move Dot to used at beginning of code for -ve
!       and 0 YA.
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
{##[ident('4-008'),}
{## overlaid]}
{##module word (output);}
{#elseif turbop}
unit word;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'word.fwd'}
{##%include 'line.h'}
{##%include 'mark.h'}
{##%include 'screen.h'}
{##%include 'text.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "word.h"}
{####include "line.h"}
{####include "mark.h"}
{####include "screen.h"}
{####include "text.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=word.h#>}
{###<$F=line.h#>}
{###<$F=mark.h#>}
{###<$F=screen.h#>}
{###<$F=text.h#>}
{#elseif turbop}
interface
  uses value;
  {$I word.i}

implementation
  uses line, mark, screen, text;
{#endif}


function word_fill (
                rept      : leadparam;
                count     : integer;
                from_span : boolean)
        : boolean;

  { Description:
            This routine takes the current line and moves words within
            the line so that the line fits between Left_margin & right_margin
            If necessary, it will grab stuff from the next line.
            nYF => Upset (at most) n lines after this one
            It preserves multiple spaces.
  }

  label
    3,99;

  var
    start_char,
    old_end,
    end_char     : strlen_range;
    line_count,
    space_to_add : integer;
    this_line    : line_ptr;
    here,
    there,
    old_here,
    old_there    : mark_ptr;
    leave_dot_alone : boolean;

  begin {word_fill}
  word_fill := false;
  leave_dot_alone := false;
  here := nil;
  there := nil;
  if rept=pindef then count := maxint;
  if rept=none then
    begin
    count := 1;
    rept := pint;
    end;
  if rept=pint then
    begin
    line_count := count;
    this_line  := current_frame^.dot^.line;
    while (line_count > 0) and (this_line^.used > 0) do
      begin
      this_line := this_line^.flink;
      line_count := line_count - 1;
      if this_line = nil then goto 99;
      end;
    if line_count <> 0 then goto 99;
    end;
  while (count > 0) and (current_frame^.dot^.line^.used > 0) do
    begin
    with current_frame^,dot^,line^ do
      begin
      if flink = nil then { on EOP line so abort }
        goto 99;
      { adjust the current line to the margins }
      if blink <> nil then
        if blink^.used <> 0 then
          begin
          {this is not the first line of a paragraph so adjust to left margin}
          start_char := 1;
          while (str^[start_char] = ' ') and (start_char < used) do
            start_char := start_char + 1;
          if (start_char < margin_left) and (start_char < used) then
            begin
            if not mark_create(line,start_char,here) then goto 99;
            if not text_insert(true,1,blank_string,
                               margin_left-start_char,here) then goto 99;
            if not mark_destroy(here) then ;
            end
          else
            begin
            {we might have to remove some spaces}
            start_char := margin_left;
            end_char := margin_left;
            if end_char < used then
              begin
              while (str^[end_char] = ' ') and (end_char < used) do
                end_char := end_char + 1;
              if end_char > 1 then
                begin
                if not mark_create(line, start_char, here) then goto 99;
                if not mark_create(line, end_char, there) then goto 99;
                if not text_remove(here, there) then goto 99;
                if not mark_destroy(here) then ;
                if not mark_destroy(there) then ;
                end;
              end;
            end;
          end;
      if used > margin_right then
        begin {We must split this line if possible}
        {1. Scan back for first non-blank }
        end_char := margin_right+1;
        if str^[end_char] <> ' ' then
          begin
          while (str^[end_char] <> ' ') and (end_char > margin_left) do
            end_char := end_char - 1;
          if (end_char = margin_left) then
            goto 99;
          end;
        start_char := end_char;
        while (str^[end_char] = ' ') and (end_char > margin_left) do
          end_char := end_char - 1;
        if end_char = margin_left then goto 99; {Nothing to do}
        {2. Scan forward for first non-blank}
        while (str^[start_char] = ' ') do
          start_char := start_char + 1;
        {3. Split the line at end_char and make sure the new line     }
        {   starts with start_char at margin_left                     }
        {   Make sure the DOT stays on THIS LINE                      }
        if not mark_create(line,start_char,here) then goto 99;
        if col > end_char then
          if not mark_create(line,end_char,dot) then goto 99;
        if not text_split_line(here,margin_left,there) then goto 99;
        if not mark_destroy(here) then goto 99;
        if not mark_destroy(there) then goto 99;
        if rept <> pindef then
          count := count + 1;
        end {Line^.used > Margin_right}
      else
        begin {need to get stuff from the next line}
  3:    {1. Figure out how many chars we can fit in}
        space_to_add := margin_right - dot^.line^.used - 1;{Allow for 1 space}
        {2. See if we can find a word to fit}
        start_char := 1;
        if (space_to_add > 0) and (flink^.used <> 0) then
          begin
          while (flink^.str^[start_char]=' ') do
            start_char := start_char + 1;
          end_char := start_char;
          old_end  := end_char;
          while end_char <= flink^.used do
            begin
            while (flink^.str^[end_char] = ' ') do
              end_char := end_char + 1;
            while (flink^.str^[end_char]<>' ') and (end_char < flink^.used) do
              end_char := end_char + 1;
            if end_char = flink^.used then end_char := end_char+1;
            if space_to_add < (end_char-start_char) then
              end_char := flink^.used+1
            else
              old_end := end_char;
            end;
          if ((old_end - start_char) <= space_to_add) and
             (old_end <> start_char) then
            begin
            {Hooray !! It will fit }
            old_here := nil;
            old_there:= nil;
            if not mark_create(flink,start_char,here) then goto 99;
            if not mark_create(flink,start_char,old_here) then goto 99;
            if not mark_create(flink,old_end,there) then goto 99;
            if not mark_create(flink,old_end,old_there) then goto 99;
            col       := used + 2;{Allow for a space !}
            {Copy the text}
            if not text_move(true,1,here,there,dot,here,there) then goto 99;
            {Copy the marks}
            if not marks_shift(flink, old_here^.col,
                               old_there^.col-old_here^.col,
                               here^.line, here^.col) then goto 99;
            {Now wipe out the old Grungy text}
            {First though, put the old_here and there marks back!}
            if not mark_create(flink,1,old_here) then goto 99;
            if not mark_create(flink,old_end,old_there) then goto 99;
            if not text_remove(old_here, old_there) then goto 99;
            if not mark_destroy(old_here) then ;
            if not mark_destroy(old_there) then ;
            {Now clean up the next line}
            {If it is now empty, delete it}
            with dot^.line^ do
            if flink^.used = 0 then
              begin
              this_line := flink;
              if not marks_squeeze(flink,1,flink^.flink,1) then goto 99;
              if not lines_extract(this_line,this_line) then goto 99;
              if not lines_destroy(this_line,this_line) then goto 99;
              count := count - 1;
              if count > 0 then
                goto 3; { Go back and have another go }
              {Put DOT here, so we can have another go if we want}
              leave_dot_alone := true;
              end;
            end;
          {Now make sure the first char in this line is at LM}
          with dot^.line^ do
          if (count > 0) and (flink^.used <> 0) then
            begin
            start_char := 1;
            while (flink^.str^[start_char] = ' ') do
              start_char := start_char + 1;
            if not mark_create(flink,start_char,there) then goto 99;
            if start_char < margin_left then
              begin { Must insert some chars here }
              if not text_insert(true,1,blank_string,
                                        margin_left-start_char,there)
              then goto 99;
              end
            else
              begin
              if not mark_create(flink,margin_left,here) then goto 99;
              if not text_remove(here,there) then goto 99;
              end;
            end;
          if here <> nil then
            if not mark_destroy(here) then goto 99;
          if there <> nil then
            if not mark_destroy(there) then goto 99;
          end;
        end;
      count := count - 1;
      if not leave_dot_alone then
        if not mark_create(dot^.line^.flink,margin_left,dot) then goto 99;
      text_modified := true;
      if not mark_create(line,col,marks[mark_modified]) then goto 99;
      end;{With}
    end;{While}
  word_fill := (count <= 0) or (rept=pindef);
99:
  { Clean up those temporary marks if necessary }
  if here <> nil then
    if not mark_destroy(here) then
      ;
  if there <> nil then
    if not mark_destroy(there) then
      ;
  end; {word_fill}


function word_centre (
                rept      : leadparam;
                count     : integer;
                from_span : boolean)
        : boolean;

  { Description:
            This routine takes the current line and moves it so that
            there are an equal number of spaces before and after the
            line, with respect to the left_margin & right_margin
            It assumes that the text already lies between Lm&Rm.
  }
  label 2;
  var
     start_char   : strlen_range;
     line_count,
     space_to_add : integer;
     this_line    : line_ptr;
     here,there   : mark_ptr;

  begin {word_centre}
  word_centre := false;
  here := nil;
  there := nil;
  if rept=pindef then count := maxint;
  if (rept=none) or (rept=plus) then
    begin
    count := 1;
    rept := pint;
    end;
  if rept=pint then
    begin
    line_count := count;
    this_line  := current_frame^.dot^.line;
    while (line_count > 0) and (this_line^.used > 0) do
      begin
      this_line := this_line^.flink;
      line_count := line_count - 1;
      if this_line = nil then goto 2;
      end;
    if line_count <> 0 then goto 2;
    end;
  while (count > 0) and (current_frame^.dot^.line^.used > 0) do
    begin
    with current_frame^,dot^ do
      begin
      if line^.flink = nil then { on EOP line so abort }
        goto 2;
      if (line^.used < margin_left) or (line^.used > margin_right) then
        goto 2;
      start_char := 1;
      while line^.str^[start_char] = ' ' do start_char := start_char + 1;
      if start_char < margin_left then goto 2;
      space_to_add := (margin_right-margin_left-(line^.used-start_char)) div 2
                      -(start_char-margin_left);
      if space_to_add <> 0 then
        begin
        here := nil;
        word_centre := mark_create(line,margin_left,here);
        if space_to_add > 0 then
          word_centre := text_insert(true,1,blank_string,space_to_add,here)
        else
          begin
          there := nil;
          word_centre := mark_create(line,margin_left-space_to_add,there);
          word_centre := text_remove(here,there);
          word_centre := mark_destroy(there);
          end;
        word_centre := mark_destroy(here);
        end;
      count := count - 1;
      word_centre := mark_create(line^.flink,margin_left,dot);
      text_modified := true;
      if not mark_create(line,col,marks[mark_modified]) then goto 2;
      end;{With}
    end;{While}
  word_centre := (count = 0) or (rept=pindef);
  2:
  { Clean up those temporary marks if necessary }
  if here <> nil then
    if not mark_destroy(here) then
      ;
  if there <> nil then
    if not mark_destroy(there) then
      ;
  end; {word_centre}


function word_justify (
                rept      : leadparam;
                count     : integer;
                from_span : boolean)
        : boolean;

  { Description:
            This routine takes the current line space justifies it
            between the left and right margins. It preserves multiple spaces.
  }
  label 1,2;
  var
     start_char,
     end_char     : strlen_range;
     holes,i,
     line_count,
     space_to_add : integer;
     this_line    : line_ptr;
     here         : mark_ptr;
     fill_ratio,
     debit        : real;

  begin {word_justify}
  word_justify := false;
  here := nil;
  if rept=pindef then count := maxint;
  if (rept=none) or (rept=plus) then
    begin
    count := 1;
    rept := pint;
    end;
  if rept=pint then
    begin
    line_count := count;
    this_line  := current_frame^.dot^.line;
    while (line_count > 0) and (this_line^.used > 0) do
      begin
      this_line := this_line^.flink;
      line_count := line_count - 1;
      if this_line = nil then goto 2;
      end;
    if line_count <> 0 then goto 2;
    end;
  while (count > 0) and (current_frame^.dot^.line^.used > 0) do
    begin
    with current_frame^,dot^,line^ do
      begin
      if flink = nil then { on EOP line so abort }
        goto 2;
      if flink^.used = 0 then
        goto 1;
      if used > margin_right then
        goto 2;         { Line is too long to justify}
      {1. Figure out how many spaces to add }
      space_to_add := margin_right - used;
      {2. Find number of holes into which spaces are to be distributed}
      start_char := margin_left;
      while (str^[start_char] = ' ') and (start_char < used) do
        start_char := start_char + 1;
      end_char   := start_char;  { Remember starting position }
      holes := 0;
      repeat
        while (str^[start_char] <> ' ') and (start_char < used) do
          start_char := start_char + 1;
        while (str^[start_char] = ' ') and (start_char < used) do
          start_char := start_char + 1;
        holes := holes + 1;
      until (start_char >= used);
      holes      := holes - 1;
      if holes > 0 then
        fill_ratio := space_to_add / holes;
      debit      := 0.0;
      start_char := end_char;
      for i := 1 to holes do
        begin
        {Find a hole }
        while (str^[start_char] <> ' ') do
          start_char := start_char + 1;
        debit := debit + fill_ratio;
        space_to_add := round(debit);
        if space_to_add > 0 then
          begin
          here := nil;
          if not mark_create(line,start_char,here) then goto 2;
          if not text_insert(true,1,blank_string,space_to_add,here)
          then goto 2;
          if not mark_destroy(here) then goto 2;
          debit := debit - space_to_add;
          end;
        while str^[start_char] = ' ' do
          start_char := start_char + 1;
        end;
      1:
      count := count - 1;
      if not mark_create(dot^.line^.flink,margin_left,dot) then goto 2;
      text_modified := true;
      if not mark_create(line,col,marks[mark_modified]) then goto 2;
      end;{With}
    end;{While}
  word_justify := (count <= 0) or (rept=pindef);
  2:
  { Clean up those temporary marks if necessary }
  if here <> nil then
    if not mark_destroy(here) then
      ;
  end; {word_justify}


function word_squeeze (
                rept      : leadparam;
                count     : integer;
                from_span : boolean)
        : boolean;

  { Description:
            This routine takes the current line and removes multiple
            spaces from it.
  }
  label 1,2;
  var
     start_char,
     end_char     : strlen_range;
     line_count   : integer;
     this_line    : line_ptr;
     here,there   : mark_ptr;

  begin {word_squeeze}
  word_squeeze := false;
  here := nil;
  there := nil;
  if rept=pindef then count := maxint;
  if (rept=none) or (rept=plus) then
    begin
    count := 1;
    rept := pint;
    end;
  if rept=pint then
    begin
    line_count := count;
    this_line  := current_frame^.dot^.line;
    while (line_count > 0) and (this_line^.used > 0) do
      begin
      this_line := this_line^.flink;
      line_count := line_count - 1;
      if this_line = nil then goto 2;
      end;
    if line_count <> 0 then goto 2;
    end;
  while (count > 0) and (current_frame^.dot^.line^.used > 0) do
    begin
    with current_frame^,dot^ do
      begin
      if line^.flink = nil then { on EOP line so abort }
        goto 2;
      start_char := 1;
      while line^.str^[start_char] = ' ' do
        start_char := start_char + 1;
      with line^ do
        repeat
          while (str^[start_char] <> ' ') and (start_char < used) do
            start_char := start_char + 1;
          if str^[start_char] <> ' ' then
            goto 1; { Nothing more to do }
          end_char := start_char;
          while (str^[end_char] = ' ') do
            end_char := end_char + 1;
          if (end_char - start_char) > 1 then
            begin
            here         := nil;
            if not mark_create(line,start_char,here) then goto 2;
            there        := nil;
            if not mark_create(line,end_char-1,there) then goto 2;
            if not text_remove(here,there) then goto 2;
            start_char   := here^.col;
            end
          else
            start_char := end_char;
          until false;
      1:
      count := count - 1;
      if not mark_create(line^.flink,margin_left,dot) then goto 2;
      text_modified := true;
      if not mark_create(line,col,marks[mark_modified]) then goto 2;
      end;{With}
    end;{While}
  word_squeeze := (count = 0) or (rept=pindef);
  2:
  { Clean up those temporary marks if necessary }
  if here <> nil then
    if not mark_destroy(here) then
      ;
  if there <> nil then
    if not mark_destroy(there) then
      ;
  end; {word_squeeze}


function word_right (
                rept      : leadparam;
                count     : integer;
                from_span : boolean)
        : boolean;

  { Description:
            This routine takes the current line and aligns it at RM
  }
  label 2;
  var
     line_count,
     space_to_add : integer;
     here         : mark_ptr;
     this_line    : line_ptr;

  begin {word_right}
  word_right := false;
  here := nil;
  if rept=pindef then count := maxint;
  if (rept=none) or (rept=plus) then
    begin
    count := 1;
    rept := pint;
    end;
  if rept=pint then
    begin
    line_count := count;
    this_line  := current_frame^.dot^.line;
    while (line_count > 0) and (this_line^.used > 0) do
      begin
      this_line := this_line^.flink;
      line_count := line_count - 1;
      if this_line = nil then goto 2;
      end;
    if line_count <> 0 then goto 2;
    end;
  while (count > 0) and (current_frame^.dot^.line^.used > 0) do
    begin
    with current_frame^,dot^ do
      begin
      if line^.flink = nil then { on EOP line so abort }
        goto 2;
      if line^.used < margin_right then
        begin
        space_to_add := margin_right - line^.used;
        here := nil;
        if not mark_create(line,1,here) then goto 2;
        if not text_insert(true,1,blank_string,space_to_add,here) then
          goto 2;
        if not mark_destroy(here) then goto 2;
        end {Line^.used < Margin_Right}
      else
        if line^.used <> margin_right then
          goto 2;
      count := count - 1;
      if not mark_create(line^.flink,margin_left,dot) then goto 2;
      text_modified := true;
      if not mark_create(line,col,marks[mark_modified]) then goto 2;
      end;{With}
    end;{While}
  word_right := (count = 0) or (rept=pindef);
  2:
  { Clean up those temporary marks if necessary }
  if here <> nil then
    if not mark_destroy(here) then
      ;
  end; {word_right}


function word_left (
                rept      : leadparam;
                count     : integer;
                from_span : boolean)
        : boolean;

  { Description:
            This routine takes the current line and Aligns it at LM
  }
  label 2;
  var
     line_count,
     line_start   : integer;
     here,there   : mark_ptr;
     this_line    : line_ptr;

  begin {word_left}
  word_left := false;
  here := nil;
  there := nil;
  if rept=pindef then count := maxint;
  if (rept=none) or (rept=plus) then
    begin
    count := 1;
    rept := pint;
    end;
  if rept = pint then
    begin
    line_count := count;
    this_line  := current_frame^.dot^.line;
    while (line_count > 0) and (this_line^.used > 0) do
      begin
      this_line := this_line^.flink;
      line_count := line_count - 1;
      if this_line = nil then goto 2;
      end;
    if line_count <> 0 then goto 2;
    end;
  while (count > 0) and (current_frame^.dot^.line^.used > 0) do
    begin
    with current_frame^,dot^ do
      begin
      if line^.flink = nil then { on EOP line so abort }
        goto 2;
      if line^.used > margin_left then
        begin
        line_start := 1;
        while line^.str^[line_start] = ' ' do line_start := line_start + 1;
        if line_start < margin_left then goto 2;
        here := nil;
        there := nil;
        if not mark_create(line,margin_left,here) then goto 2;
        if not mark_create(line,line_start,there) then goto 2;
        if not text_remove(here,there) then goto 2;
        if not mark_destroy( here) then goto 2;
        if not mark_destroy(there) then goto 2;
        end {Line^.used < Margin_Left}
      else
        goto 2;
      count := count - 1;
      if not mark_create(line^.flink,margin_left,dot) then goto 2;
      text_modified := true;
      if not mark_create(line,col,marks[mark_modified]) then goto 2;
      end;{With}
    end;{While}
  word_left := (count = 0) or (rept=pindef);
  2:
  { Clean up those temporary marks if necessary }
  if here <> nil then
    if not mark_destroy(here) then
      ;
  if there <> nil then
    if not mark_destroy(there) then
      ;
  end; {word_left}


function word_advance_word (
                rept      : leadparam;
                count     : integer;
                from_span : boolean)
        : boolean;

  {
  ! This routine advances Dot to the start of the a word.
  ! Definitions:
  !   A word is a sequence of non-spaces followed by spaces.
  !   A paragraph is a sequence of words separated by one or more blank
  !   lines and is terminated by the first word of the next paragraph,
  !   or End-of-File.
  ! The semantics of the leading parameter is to advance to -
  !   0  the start of the current word.
  !   +n the start of the n'th next word.
  !   -n the start of the n'th previous word.
  !   >  the start of the first word in the next paragraph,
  !      ie. the start of the next word after the current paragraph.
  !   <  the start of the first word in the current paragraph.
  }

  label
    1,2,99;

  var
    this_line : line_ptr;
    pos       : col_width_range;

  begin {word_advance_word}
  word_advance_word := false;
  if rept = marker then
    begin
    screen_message(msg_syntax_error);
    goto 99;
    end;
  with current_frame^ do
    begin
    pos := dot^.col;
    this_line := dot^.line;
    if    (rept in [none, plus, pindef])
       or ((rept = pint) and (count <> 0)) then
      begin
      {Take care of the PINDEF case}
      if rept = pindef then
        begin
        {Get to the blank line between the current para. and the next}
        while (this_line^.used <> 0) and (this_line^.flink <> nil) do
          this_line := this_line^.flink;
        pos := 1;
        count := 1;
        end;
      while (count > 0) do
        begin { Move Forwards }
        { Locate the next Whitespace position}
        repeat
          if pos < this_line^.used then
            begin
            if this_line^.str^[pos] <> ' ' then
              pos := pos + 1;
            end
          else
            goto 1;
        until this_line^.str^[pos] = ' ';
1:
        { Now Skip the Whitespace till we get to a Non-Space Char}
        if pos >= this_line^.used then {Must move onto next line}
          begin
          pos := 1;
          {Go get the next line with something on it!}
          repeat
            if this_line^.flink = nil then
              if rept = pindef then
                goto 2 {This is close enough!}
              else
                goto 99; {Not enough words left, FAIL!}
            this_line := this_line^.flink;
          until this_line^.used > 0;
          end;
        while this_line^.str^[pos] = ' ' do
          pos := pos + 1;
        { OK. We have got the start of a word.}
        count := count - 1;
        end; {While}
      {Fine, now move dot}
2:
      if not mark_create(this_line, pos, current_frame^.dot) then
        goto 99;
      word_advance_word := true;
      end
    else if rept = nindef then
      begin
      {Find a non blank line in this paragraph}
      while (this_line^.used = 0) and (this_line^.blink <> nil) do
        this_line := this_line^.blink;
      {Find the blank line separating this para. from the one before}
      while (this_line^.used <> 0) and (this_line^.blink <> nil) do
        this_line := this_line^.blink;
      {Now it's time to find the first non blank}
      pos := 1;
      while this_line^.used = 0 do
        begin
        if this_line^.flink = nil then
          goto 99; {BAIL OUT!}
        this_line := this_line^.flink;
        end;
      while this_line^.str^[pos] = ' ' do
        pos := pos + 1;
      if not mark_create(this_line, pos, current_frame^.dot) then
        goto 99;
      word_advance_word := true;
      end
    else
      begin { Move Backwards }
      {
      ! OK lets now move to the start of the word to the left of where we
      ! are currently positioned, and then count off from there.
      }
      count := - count;
      if pos > this_line^.used then
        pos := this_line^.used;
      repeat
        {
        ! if we are at the start of the line or on the eop-line go back to
        ! a previous line with characters on it.
        }
        if (pos = 0) or (this_line^.flink = nil) then
          repeat
            if this_line^.blink = nil then
              goto 99; {BAIL OUT!}
            this_line := this_line^.blink;
            pos := this_line^.used;
          until pos > 0;
        {Skip Over any WhiteSpace}
        while (this_line^.str^[pos] = ' ') and (pos > 1) do
          pos := pos - 1;
        if (pos = 1) and (this_line^.str^[1] = ' ') then
          repeat
            if this_line^.blink = nil then
              goto 99; {BAIL OUT!}
            this_line := this_line^.blink;
            pos := this_line^.used;
          until pos > 0;
        {
        ! ASSERTION: pos now points at a non-space character
        ! Now find the start of the word by skipping over non-whitespace
        }
        while (this_line^.str^[pos] <> ' ') and (pos > 1) do
          pos := pos - 1;
        count := count - 1;
        if count < 0 then
          begin
          if this_line^.str^[pos] = ' ' then
            pos := pos + 1 {Put Pos back onto the 1st char of the word}
          end
        else
          pos := pos - 1; {Setup to look for previous word}
      until count < 0;
      {Fine, now move dot}
      if not mark_create(this_line, pos, current_frame^.dot) then
        goto 99;
      word_advance_word := true;
      end;
    end; {With Current_Frame^}
99:
  end; {word_advance_word}


function word_delete_word (
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

  begin {word_delete_word}
  word_delete_word := false;
  old_pos := nil;
  here := nil;
  the_other_mark := nil;
  if rept = marker then
    begin
    screen_message(msg_syntax_error);
    goto 99;
    end;
  with current_frame^ do
    begin
    if not mark_create(dot^.line, dot^.col, old_pos) then goto 99;
    {First Step.}
    {  Get to the beginning of the word if we are in the middle of it}
    if not word_advance_word(pint, 0, from_span) then goto 99;
    {ASSERTION: We are on the beginning of a word}
    if not mark_create(dot^.line, dot^.col, here) then goto 99;
    if not word_advance_word(rept, count, from_span) then
      begin {Put Dot back and bail out}
      if not mark_create(old_pos^.line, old_pos^.col, dot) then goto 99;
      goto 99;
      end;
    {OK. We now wipe out everything from Dot to here}
    old_dot_col := dot^.col;
    if not mark_create(dot^.line,dot^.col,the_other_mark) then goto 99;
    if not line_to_number(dot^.line,line_nr) then goto 99;
    if not line_to_number(here^.line,new_line_nr) then goto 99;
    if  (line_nr > new_line_nr)
    or ((line_nr = new_line_nr) and (dot^.col > here^.col))
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
        word_delete_word := text_move(false            { Dont copy,transfer}
                                     ,1                { One instance of }
                                     ,the_other_mark   { starting pos.   }
                                     ,here             { ending pos.     }
                                     ,span^.mark_two   { destination.    }
                                     ,marks[0]         { leave at start. }
                                     ,dot              { leave at end.   }
                                     );
        end;
      end
    else
      begin
      word_delete_word := text_remove(the_other_mark   { starting pos.   }
                                     ,here         { ending pos.     }
                                     );
      end;
    if line_nr <> new_line_nr then
      word_delete_word := text_split_line(dot, old_dot_col, here);
    end;
99:
  { If these marks are still hanging around then zap 'em! }
  if old_pos <> nil then
    if not mark_destroy(old_pos) then
      ;
  if here <> nil then
    if not mark_destroy(here) then
      ;
  end; {word_delete_word}

{#if vms or turbop}
end.
{#endif}
