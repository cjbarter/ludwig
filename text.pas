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
{       Wayne N. Agutter (1979-80)                                     }
{       Chris J. Barter (1979-89)                                      }
{       Bevin R. Brett (1979-82)                                       }
{       Kevin J. Maciunas (1980-84 )                                   }
{       Kelvin B. Nicolle (1981-90)                                    }
{       Mark R. Prior (1987-88)                                        }
{       Jeff Blows (1988-90,2020)                                      }
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
! Name:         TEXT
!
! Description:  Text manipulation routines.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/text.pas,v 4.6 1990/01/18 17:23:24 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: text.pas,v $
! Revision 4.6  1990/01/18 17:23:24  ludwig
! Entered into RCS at reviosion level 4.6.
!
!
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Mark R. Prior                                        20-Feb-1988
!       Use conformant arrays to pass string parameters to ch routines.
!               string[offset],length -> string,offset,length
!       In all calls of ch_length, ch_upcase_str, ch_locase_str,
!         ch_reverse_str, ch_compare_str, and ch_search_str the offset
!         was 1 and is now omitted.
! 4-003 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-004 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
! 4-005 Kelvin B. Nicolle                                    13-Sep-1989
!       Add includes etc. for Tower version.
! 4-006 Kelvin B. Nicolle                                    25-Oct-1989
!       Correct the includes for the Tower version.
!       Remove the superfluous include of system.h.
!--}

{#if vms}
{##[ident('4-006'),}
{## overlaid]}
{##module text (output);}
{#elseif turbop}
unit text;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'text.fwd'}
{##%include 'ch.h'}
{##%include 'line.h'}
{##%include 'mark.h'}
{##%include 'screen.h'}
{##%include 'vdu.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "text.h"}
{####include "ch.h"}
{####include "line.h"}
{####include "mark.h"}
{####include "screen.h"}
{####include "vdu.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=text.h#>}
{###<$F=ch.h#>}
{###<$F=line.h#>}
{###<$F=mark.h#>}
{###<$F=screen.h#>}
{###<$F=vdu.h#>}
{#elseif turbop}
interface
  uses value;
  {$I text.i}

implementation
  uses ch, line , mark, screen, vdu;
{#endif}


function text_return_col (
                cur_line  : line_ptr;
                cur_col   : col_range;
                splitting : boolean)
        : col_range;

  label 1;
  var
    new_line : line_ptr;
    new_col  : col_range;
    str_1,
    str_2    : str_ptr;
    used_1,
    used_2   : strlen_range;

  begin {text_return_col}
  { Calculate which col to place dot on. }
  with cur_line^.group^.frame^ do
    begin
    new_line := cur_line;
    if cur_col >= margin_left then
      new_col := margin_left
    else
      new_col := 1;
    if opt_auto_indent in options then
    if new_line^.flink <> nil then
      begin
      with new_line^ do
        begin
        str_1  := str;   { Aim at this line. }
        used_1 := used;  { Length of this line. }
        str_2  := str;   { Aim at next iff next is not null line. }
        used_2 := used;  { Len of next iff next is not null line. }
        with flink^ do
          begin
          if (flink <> nil) and (not splitting) then
            begin
            str_2  := str;
            used_2 := used;
            end;
          end;
        end;
      repeat
        if new_col <= used_1 then
          begin if str_1^[new_col] <> ' ' then goto 1; end;
        if new_col <= used_2 then
          begin if str_2^[new_col] <> ' ' then goto 1; end
        else
          begin if new_col >= used_1      then goto 1; end;
        new_col := new_col+1;
      until false;
     1:
      end; {of auto_indent processing}
    end; {with}
  text_return_col := new_col;
  end; {text_return_col}


function text_realize_null (
                old_null : line_ptr)
        : boolean;

  var
    new_null : line_ptr;

  begin {text_realize_null}
  text_realize_null := false;
  if lines_create(1,new_null,new_null) then
    if lines_inject(new_null,new_null,old_null) then
      if marks_shift (old_null,1,max_strlenp,new_null,1) then
        with new_null^.group^.frame^ do
          begin
          text_modified := true;
          if mark_create(dot^.line,dot^.col,marks[mark_modified]) then
            text_realize_null := true;
          end;
  end; {text_realize_null}


function text_insert (
                update_screen : boolean;
                count         : integer;
                buf           : str_object;
                buf_len       : strlen_range;
                dst           : mark_ptr)
        : boolean;

  label 99;
  var
    dst_line         : line_ptr;
    dst_col          : col_range;
    i                : integer;
    insert_len       : 0..maxint;
    tail_len,
    len_redraw,
    final_len        : integer;
    first_col_redraw,
    last_col_redraw  : integer;
    new_col          : col_range;
    scr_col          : integer;

  begin {text_insert}
  text_insert := false;
{#if debug}
  if count < 0 then
    begin screen_message(dbg_repeat_negative); goto 99; end;
{#endif}
  insert_len := count*buf_len;
  if insert_len > 0 then
    begin
    with dst^ do
      begin
      dst_line := line;
      dst_col := col;
      end;
    with dst_line^ do
      begin
      final_len := dst_col-1+insert_len;
      tail_len  := used+1-dst_col;
      if tail_len <= 0 then
        tail_len := 0
      else
        final_len := final_len+tail_len;
      if final_len > max_strlen then goto 99;
      if flink = nil then
        begin
        if not text_realize_null(dst_line) then goto 99;
        dst_line := blink;
        end;
      end;
    with dst_line^ do
      begin
      if final_len > len then
        if not line_change_length(dst_line,final_len) then goto 99;
      if not marks_shift(dst_line,dst_col,max_strlenp-dst_col,
                         dst_line,dst_col+insert_len)
      then goto 99;
      if tail_len > 0 then { to avoid subscript error when dst_col=400 }
        ch_move(str^,dst_col,str^,dst_col+insert_len,tail_len);
      new_col := dst_col;
      for i := 1 to count do
        begin
        ch_move(buf,1,str^,new_col,buf_len);
        new_col := new_col+buf_len;
        end;

      { Re-compute length of line, to remove trailing spaces. }
      if tail_len = 0 then
        used := ch_length(str^,len)
      else
        used := used+insert_len;

      { Update screen if necessary, and it is affected. }
      if update_screen and (scr_row_nr <> 0) then
        with group^.frame^ do
          begin

          { Update the VDU. }
          scr_col := dst_col-scr_offset;
          if scr_col <= scr_width then
            begin
            if scr_col <= 0 then scr_col := 1;
            vdu_movecurs(scr_col,scr_row_nr);
            first_col_redraw := dst_col;
            if first_col_redraw <= scr_offset then
              first_col_redraw := scr_offset+1;
            if  (trmflags_v_inch in tt_capabilities)
            and (scr_col+insert_len <= scr_width)
            and (scr_col+scr_offset <= used)
            then
              begin
              vdu_insertchars(insert_len);
              last_col_redraw  := first_col_redraw + insert_len - 1;
              end
            else
              last_col_redraw := used;
            if last_col_redraw > scr_width+scr_offset then
              last_col_redraw := scr_width+scr_offset;
            len_redraw := last_col_redraw-first_col_redraw+1;
            if len_redraw > 0 then
              vdu_displaystr(len_redraw,str^[first_col_redraw],0);
            end;
          end;
      end;
    end;
  text_insert := true;
 99:
  end; {text_insert}


function text_overtype (
                update_screen : boolean;
                count         : integer;
                buf           : str_object;
                buf_len       : strlen_range;
        var     dst           : mark_ptr)
        : boolean;

  {
  ! Inputs:
  !   update_screen     Do/Do not update screen. (The screen may already
  !                     have been updated by echo from the input
  !                     routines.)
  !   count             Number of copies of the text to be overtyped.
  !   buf_len           Length of the string to be overtyped.
  !   buf               The string to be overtyped.
  !   dst               A mark indicating where the overtyping is to
  !                     start.
  ! Outputs:
  !   dst               Modified to point past the insertion.
  }

  label 99;
  var
    i                : integer;
    dst_line         : line_ptr;
    len_on_scr,
    first_col_on_scr,
    last_col_on_scr,
    overtype_len,
    final_len        : integer;
    new_col          : col_range;

  begin {text_overtype}
  text_overtype := false;
{#if debug}
  if count < 0 then
    begin screen_message(dbg_repeat_negative); goto 99; end;
{#endif}
  overtype_len := count*buf_len;
  if overtype_len > 0 then
  with dst^ do
    begin
    dst_line := line;
    with dst_line^ do
      begin
      final_len := col+overtype_len-1;
      if final_len > max_strlen then goto 99;
      if flink = nil then
        begin
        if not text_realize_null(line) then goto 99;
        dst_line := blink;
        end;
      end;
    with dst_line^ do
      begin
      if final_len > len then
        if not line_change_length(line,final_len) then goto 99;
      new_col := col;
      for i := 1 to count do
        begin
        ch_move(buf,1,str^,new_col,buf_len);
        new_col := new_col+buf_len;
        end;

      { Re-compute length of line, to remove trailing spaces. }
      if new_col > used then used := ch_length(str^,len);

      { Update screen if necessary, and it is affected. }
      if update_screen then
      if scr_row_nr <> 0 then
      with group^.frame^ do
        begin

        { Aim first... at the first screen character changed. }
        { Aim last... at PAST the last screen character changed. }
        first_col_on_scr := col;
        if first_col_on_scr <= scr_offset then
          first_col_on_scr := scr_offset+1;
        last_col_on_scr  := new_col;
        if last_col_on_scr > scr_width+scr_offset then
          last_col_on_scr := scr_width+scr_offset+1;

        { Update the VDU. }
        len_on_scr := last_col_on_scr-first_col_on_scr;
        if len_on_scr > 0 then
          begin
          vdu_movecurs(first_col_on_scr-scr_offset,scr_row_nr);
          vdu_displaystr(len_on_scr,
                         str^[first_col_on_scr],
                         0 {no-cleareol,no-anycurs});
          end;
        end;

      { Update the destination mark. }
      col := col + overtype_len;

      end;
    end;
  text_overtype := true;
 99:
  end; {text_overtype}


function text_insert_tpar (
                tp          : tpar_object;
                before_mark : mark_ptr;
        var     equals_mark : mark_ptr)
        : boolean;

  {
  ! Inputs:
  !   tp                The trailing parameter to be inserted.
  !   before_mark       Insert the text at before_mark.
  ! Outputs:
  !   before_mark       Marks the end of the inserted text.
  !   equals_mark       Marks the beginning of the inserted text.
  }

  label 99;

  var
    line_count, lc : integer;
    tmp_tp : tpar_ptr;
    tmp_line : line_ptr;
    first_line,
    last_line : line_ptr;
    discard : boolean;

  begin {text_insert_tpar}
  text_insert_tpar := false;
  discard := false;
  {check for the simple case}
  with before_mark^ do
    if tp.con = nil then
      begin
      if not text_insert(true,1,tp.str,tp.len,before_mark) then
        begin screen_message(msg_no_room_on_line); goto 99; end;
      if not mark_create(line,col-tp.len,equals_mark) then
        goto 99;
      end
    else
      begin
      if col + tp.len > max_strlen then
        begin screen_message(msg_no_room_on_line); goto 99; end;
      line_count := 0;
      tmp_tp := tp.con;
      while tmp_tp^.con <> nil do
        begin
        line_count := line_count + 1;
        tmp_tp := tmp_tp^.con;
        end;
      if tmp_tp^.len + (line^.used - col) > max_strlen then
        begin screen_message(msg_no_room_on_line); goto 99; end;
      if not lines_create(line_count,first_line,last_line) then
        goto 99;
      discard := true;
      if line^.flink = nil then
        if not text_realize_null(line) then goto 99;
      if not text_split_line(before_mark,1,equals_mark) then goto 99;
      if not text_insert(true,1,tp.str,tp.len,equals_mark) then
        goto 99;
      with equals_mark^ do
        col := col - tp.len;
      tmp_tp := tp.con;
      tmp_line := first_line;
      for lc := 1 to line_count do
        begin
        if not line_change_length(tmp_line,tmp_tp^.len) then goto 99;
        ch_move(tmp_tp^.str,1,tmp_line^.str^,1,tmp_tp^.len);
        tmp_line^.used := ch_length(tmp_line^.str^,tmp_tp^.len);
        tmp_tp := tmp_tp^.con;
        tmp_line := tmp_line^.flink;
        end;
      if line_count <> 0 then
        if not lines_inject(first_line,last_line,before_mark^.line) then
          goto 99;
      discard := false;
      with tmp_tp^ do
        if not text_insert(true,1,str,len,before_mark) then goto 99;
      end;
  text_insert_tpar := true;
 99:
  if discard then if not lines_destroy(first_line,last_line) then ;
  end; {text_insert_tpar}


{}function text_intra_remove (mark_one:mark_ptr; size:strlen_range) : boolean;

    label 99;
    var
      buf_len         : integer;
      ln              : line_ptr;
      offset_p_width  : 0..maxint;
      first_col_on_scr,
      col_one,col_two : col_range;
      old_used,
      dst_len         : strlen_range;
      distance        : col_width_range;

    begin {text_intra_remove}
    text_intra_remove := false;
    with mark_one^ do begin ln := line; col_one := col; end;
    col_two  := col_one + size;
    if not marks_squeeze(ln,col_one,ln,col_two) then goto 99;
    if not marks_shift(ln,col_two,max_strlenp+1-col_two,ln,col_one) then
      goto 99;
    text_intra_remove := true;
    if size = 0 then goto 99;
    with ln^ do
      begin
      old_used := used;
      if col_one > old_used then goto 99;
      dst_len := old_used+1-col_one;
      if col_two <= old_used then
        ch_copy(str^,col_two,old_used+1-col_two,str^,col_one,dst_len,' ')
      else
        ch_fill(                                str^,col_one,dst_len,' ');
      used := ch_length(str^,old_used);

      { Now update screen if necessary. }
      if scr_row_nr = 0 then goto 99;
      with group^.frame^ do
        begin
        offset_p_width := scr_offset+scr_width;
        if col_one > offset_p_width then goto 99;
        distance := col_two-col_one;
        first_col_on_scr := col_one;
        if col_one <= scr_offset then first_col_on_scr := scr_offset+1;

        { If possible, drag any characters on screen to final place. }
        if trmflags_v_dlch in tt_capabilities then
        if  (first_col_on_scr+distance <= offset_p_width)
        and (first_col_on_scr+distance <= old_used)
        then
          begin
          vdu_movecurs(first_col_on_scr-scr_offset,scr_row_nr);
          vdu_deletechars(distance);
          first_col_on_scr := offset_p_width+1-distance;
          if first_col_on_scr > used then goto 99;
          end;

        { Fix the remainder of the lines appearance on the screen. }
        vdu_movecurs(first_col_on_scr-scr_offset,scr_row_nr);
        if used <= scr_offset+scr_width then
          buf_len := used+1-first_col_on_scr
        else
          buf_len := scr_offset+scr_width+1-first_col_on_scr;
        if buf_len <= 0 then
          vdu_cleareol
        else
          vdu_displaystr(buf_len                {len}
                        ,str^[first_col_on_scr] {buf}
                        ,3                {cleareol,leave cursor anywhere}
                        );
        end;
      end;
   99:
    end; {text_intra_remove}


{}function text_inter_remove (mark_one,mark_two:mark_ptr) : boolean;

    label 77,88,99;
    var
      mark_start        : mark_ptr;
      extr_one,extr_two : line_ptr;
      text_len          : strlen_range;
      strng             : str_object;
      strng_tail        : str_object;
      delta             : integer;
      line_one          : line_ptr;
      col_one           : col_range;

    begin {text_inter_remove}
    text_inter_remove := false;
    mark_start := nil;
    if (mark_two^.line^.flink = nil) and (mark_one^.col <> 1) then
      begin
      with mark_one^ do begin line_one := line; col_one := col; end;
      extr_one := line_one^.flink;
      extr_two := mark_two^.line;
      if not text_intra_remove(mark_one,max_strlenp-mark_one^.col) then
        goto 99;
      if not marks_squeeze(line_one,col_one,mark_two^.line,mark_two^.col)
      then goto 99;
      if not marks_shift(mark_two^.line,mark_two^.col
                        ,max_strlenp+1-mark_two^.col
                        ,line_one,col_one
                        )
      then goto 99;
      if extr_one = extr_two then goto 88; { Okay but No lines to extract.  }
      extr_two := extr_two^.blink;         { Okay but has lines to extract. }
      goto 77;
      end;

    { Bring the start of line_one down to replace the start of line_two. }
    with mark_one^,line^ do
      begin
      text_len := used;
      if col <= text_len then text_len := col-1;
      ch_copy(str^,1,text_len,strng,1,col-1,' ');
      text_len := col-1;
      end;
    delta := mark_one^.col-mark_two^.col;
    if delta < 0 then
      begin
      if not mark_create(mark_two^.line,mark_one^.col,mark_start)
      then goto 99;
      if not text_intra_remove(mark_start,mark_two^.col-mark_start^.col) then
        goto 99;
      end
    else
    if delta > 0 then
      begin
      ch_move(strng,mark_two^.col,strng_tail,1,delta);
      if not text_insert(true,1,strng_tail,delta,mark_two) then goto 99;
      text_len := text_len-delta;
      end;
    if not mark_create(mark_two^.line,1,mark_start) then goto 99;
    if text_len > 0 then
      if not text_overtype(true,1,strng,text_len,mark_start) then goto 99;
    with mark_one^ do begin col_one := col; extr_one := line; end;
    with mark_two^ do
      begin
      extr_two := line^.blink;
      if not marks_squeeze(extr_one,col_one,line,col) then goto 99;
      if col_one > 1 then
        if not marks_shift(extr_one,1,col_one-1,line,1) then goto 99;
      end;
   77:
    if not lines_extract(extr_one,extr_two) then goto 99;
    if not lines_destroy(extr_one,extr_two) then goto 99;
   88:
    text_inter_remove := true;
   99:
    if mark_start <> nil then
      if mark_destroy(mark_start) then ;
    end; {text_inter_remove}


function text_remove (
                mark_one,
                mark_two : mark_ptr)
        : boolean;

{#if debug}
  label 99;
  var
    line_one_nr,line_two_nr : line_range;
{#endif}

  begin {text_remove}
{#if debug}
  text_remove := false;
  if not line_to_number(mark_one^.line,line_one_nr) then goto 99;
  if not line_to_number(mark_two^.line,line_two_nr) then goto 99;
  if (mark_one^.line^.group^.frame <> mark_two^.line^.group^.frame)
  or (line_one_nr > line_two_nr)
  then begin screen_message(dbg_internal_logic_error); goto 99; end;
{#endif}
  if mark_one^.line = mark_two^.line then
    text_remove := text_intra_remove(mark_one,mark_two^.col-mark_one^.col)
  else
    text_remove := text_inter_remove(mark_one,mark_two);
{#if debug}
 99:
{#endif}
  end; {text_remove}


function text_move (
                copy      : boolean;
                count     : integer;
                mark_one  : mark_ptr;
                mark_two  : mark_ptr;
                dst       : mark_ptr;
        var     new_start : mark_ptr;
        var     new_end   : mark_ptr)
        : boolean;

  label 99;
  var
    cmd_success : boolean;
{#if debug}
    line_one_nr,line_two_nr : line_range;
{#endif}

  function text_intra_move : boolean;

    { ASSUMES COUNT >= 1, MARKS ON SAME LINE,  MARK_ONE AT OR BEFORE _TWO. }
    label 99;
    var
      full_len : strlen_range;
      text_len : strlen_range;
      text_str : str_object;
      i        : integer;
      tail_len : strlen_range;
      col_one,col_two : col_range;
      dst_col  : col_range;
      dst_used : strlen_range;

    begin {text_intra_move}
    text_intra_move := false;
    col_one := mark_one^.col;
    col_two := mark_two^.col;

    {Take COUNT copies of the source string.}
    full_len := col_two-col_one;
    if full_len <> 0 then
      begin
      if full_len*count > max_strlen then goto 99;
      with mark_one^.line^ do
        begin
        text_len := full_len;
        if col_one > used then text_len := 0 else
        if col_two > used then text_len := used+1-col_one;
        ch_copy(str^,col_one,text_len,text_str,1,full_len,' ');
        end;
      text_len := full_len;
      for i := 2 to count do
        begin
        ch_move(text_str,1,text_str,1+full_len,text_len);
        full_len := full_len+text_len;
        if tt_controlc then goto 99;
        end;
      end;
    if not copy then
      begin
      with dst^ do          { Predict dst^.col & dst^.line^.used after the }
        begin               { removal of the span.                         }
        with line^ do
          begin
          dst_col  := col;  { They will be the current values, unless ...  }
          dst_used := used;
          end;
        if mark_one^.line = line then
          begin
          if dst_col > col_two then
            dst_col := dst_col-(col_two-col_one)
          else
          if dst_col > col_one then
            dst_col := col_one;
          if dst_used > col_two then
            dst_used := dst_used-(col_two-col_one)
          else
            dst_used := col_one-1;    {This is a good enough guess.}
          end;
        end;
      tail_len := 0;
      if dst_col <= dst_used then tail_len := dst_used+1-dst_col;
      if dst_col+full_len+tail_len > max_strlenp then goto 99;
      if full_len <> 0 then
        if not text_intra_remove(mark_one,mark_two^.col-mark_one^.col) then
          goto 99;
      end;
    if full_len <> 0 then
      if not text_insert(true,1,text_str,full_len,dst) then goto 99;
    with dst^ do
      begin
      dst_col := col;
      if not mark_create(line,dst_col-full_len,new_start) then goto 99;
      if not mark_create(line,dst_col,         new_end  ) then goto 99;
      text_intra_move := true;
      end;
   99:
    end; {text_intra_move}

  function text_inter_move : boolean;

    { ASSUMES COUNT >= 1, MARK_ONE^.LINE BEFORE MARK_TWO^.LINE }
    label 88,99;
    var
      first_line,
      last_line,
      next_src_line,
      next_dst_line,
      first_nicked,
      last_nicked      : line_ptr;
      line_one_nr,
      line_two_nr,
      line_dst_nr      : line_range;
      lines_required   : integer;
      last_line_length : strlen_range;
      temp_len         : strlen_range;
      text_len         : strlen_range;
      text_str         : str_object;
      i                : integer;
      line_one         : line_ptr;
      col_one          : col_range;
      line_two         : line_ptr;
      col_two          : col_range;
      dst_col          : col_range;
      dst_used         : strlen_range;
      dst_line         : line_ptr;

    begin {text_inter_move}
    text_inter_move := false;
    first_line := nil;
    with mark_one^ do begin line_one := line; col_one := col; end;
    with mark_two^ do begin line_two := line; col_two := col; end;
    if not line_to_number(line_one,line_one_nr) then goto 99;
    if not line_to_number(line_two,line_two_nr) then goto 99;

    { Verify that the insertion will work. }
    with dst^ do            { Predict dst^.col & dst^.line^.used just before }
      begin                 { the insertion of the span.                     }
      dst_col  := col;
      dst_used := line^.used;
      if not copy then
      if line^.group^.frame = line_one^.group^.frame then
        begin
        if not line_to_number(line,line_dst_nr) then goto 99;
        if (line_one_nr <= line_dst_nr) and (line_dst_nr <= line_two_nr) then
          begin
          if (line_two_nr = line_dst_nr) and (dst_col >= col_two) then
            { DST IS ON SAME LINE AS END, BUT BEYOND END }
            dst_col := col_one+dst_col-col_two
          else
          if (line_one_nr <> line_dst_nr) or (dst_col >= col_one) then
            dst_col := col_one; { DST IS INSIDE AREA TO BE REMOVED }
          temp_len := 0;
          with line_two^ do
            if col_two <= used then temp_len := used+1-col_two;
          dst_used := col_one-1+temp_len;
          end;
        end;
      if col_two <= line_two^.used then
        if col_one{-1}+line_two^.used{+1}-col_two > max_strlenp then
          goto 99;
      if col_one <= line_one^.used then
        if dst_col{-1}+line_one^.used{+1}-col_one > max_strlenp then
          goto 99;
      if dst_col <= dst_used then
        if col_two{-1}+dst_used{+1}-dst_col > max_strlen then goto 99;
      if count>1 then
      if col_one <= line_one^.used then
        if col_two{-1}+line_one^.used{+1}-col_one > max_strlen then goto 99;
      end;

    { Create any extra lines required. }
    lines_required := count*(line_two_nr-line_one_nr);
    if not copy then
      begin
      { Allow for lines nicked from the source! }
      lines_required := lines_required-(line_two_nr-line_one_nr-1);
      end;
    if not lines_create(lines_required,first_line,last_line) then goto 99;

    { Copy end of first line of area, TEXT_LEN and TEXT_STR keep result. }
    with line_one^ do
      begin
      text_len := 0;
      if col_one <= used then
        begin
        text_len := used+1-col_one;
        ch_move(str^,col_one,text_str,1,text_len);
        end;
      end;

    { Complete taking the COUNT copies, including nicking the interior lines }
    { if this is a Transfer operation. }
    next_dst_line := first_line;
    for i := count-1 downto 0 do
      begin
      if tt_controlc then { ABORT }
        goto 99;          {Note: Can't harm ST as count = 1 in that case}
      next_src_line := line_one^.flink;
      if i=0 then                     { Last time round the loop, nick }
        begin                         { the original INTERIOR lines. }
        if not copy then
        if line_two_nr-line_one_nr > 1 then
          begin
          first_nicked := line_one^.flink;
          last_nicked  := line_two^.blink;
          if not marks_squeeze(first_nicked,1,last_nicked^.flink,1) then
            goto 99;
          if not lines_extract(first_nicked,last_nicked) then goto 99;
{#if debug}
          if next_dst_line^.flink <> nil then
            begin screen_message(dbg_internal_logic_error); goto 99; end;
{#endif}
          last_nicked^.flink   := next_dst_line;
          first_nicked^.blink  := next_dst_line^.blink;
          if first_nicked^.blink <> nil then
            first_nicked^.blink^.flink := first_nicked;
          next_dst_line^.blink := last_nicked;
          if next_dst_line = first_line then first_line := first_nicked;
          next_src_line := line_two;
          end;
        end;

      { Copy remaining INTERIOR lines. }
      while next_src_line<>line_two do
        begin
        with next_src_line^ do
          begin
          if not line_change_length(next_dst_line,used) then goto 99;
          ch_move(str^,1,next_dst_line^.str^,1,used);
          next_dst_line^.used := used;
          next_src_line := flink;
          next_dst_line := next_dst_line^.flink;
          end;
        end;

      { Copy the last_line, and for all but the last copy append the }
      { start of the next copy to it. }
      with next_dst_line^ do
        begin
        if i <> 0 then
          begin { PLACE START OF NEXT COPY AT END OF LINE }
          if not line_change_length(next_dst_line,col_two-1+text_len) then
            goto 99;
          ch_move(text_str,1,str^,col_two,text_len);
          end
        else
          begin { JUST MAKE LONG ENOUGH FOR THE END OF COPY. }
          if not line_change_length(next_dst_line,col_two-1) then
            goto 99;
          end;  { PLACE THE END OF THE COPY IN POSITION }
        if col_two <= next_src_line^.used then
          ch_move(next_src_line^.str^,1,str^,1,col_two-1)
        else
          ch_copy(next_src_line^.str^,1,next_src_line^.used,
                  str^,1,col_two-1,' ');
        if i <> 0 then
          used := ch_length(str^,col_two-1+text_len)
        else
          used := col_two-1;  { THIS PRESERVES KNOWLEGE OF THE LENGTH OF THE }
                              { LAST_LINE }
        next_dst_line := flink;
        end;
      end;
{#if debug}
    if next_dst_line <> nil then
      begin screen_message(dbg_internal_logic_error); goto 99; end;
{#endif}

    { If necessary, remove the original text <or what is left of it>. }
    if not copy then
      if not text_inter_remove(mark_one,mark_two) then goto 99;

    {Insert the source text into the destination text.}
    with dst^ do
      begin
      dst_line := line;
      dst_col  := col;

      { COMPLETE THE LAST LINE WITH THE REST OF THE DESTINATION LINE. }
      with last_line^ do
        begin
        last_line_length := used;
        i := dst_line^.used+1-dst_col;
        if i > 0 then
          begin
          if not line_change_length(last_line,used+i) then goto 99;
          ch_move(dst_line^.str^,dst_col,str^,last_line_length+1,i);
          used := ch_length(str^,last_line_length+i);
          end
        else
          used := ch_length(str^,last_line_length);
        end;
      end;

    { Special case for the NULL line and for accurate copying of }
    { one frame into another empty frame. }
    if dst_line^.flink = nil then
      begin
      if (dst_col <> 1)
      or (last_line_length <> 0)
      then
        begin
        if not text_realize_null(dst_line) then goto 99;
        dst_line := dst_line^.blink;
        end
      else
        begin

        { Shift last line to first line to give somewhere to place text_str.}
        if first_line <> last_line then
          begin
          first_nicked        := last_line;
          last_line           := last_line^.blink;
          last_line^.flink    := nil;
          first_nicked^.blink := nil;
          first_nicked^.flink := first_line;
          first_line^.blink   := first_nicked;
          first_line          := first_nicked;
          end;

        { Place the text in the first line, and inject them all. }
        if text_len > 0 then
          begin
          if not line_change_length(first_line,text_len) then goto 99;
          ch_copy(text_str,1,text_len,
                  first_line^.str^,1,first_line^.len,' ');
          first_line^.used := text_len;
          end;
        if not lines_inject(first_line,last_line,dst_line) then goto 99;

        { Set up variables so that the creation of the New_Start and }
        { New_End marks will be correct. }
        last_line  := dst_line;
        dst_line   := first_line;
        first_line := nil;    { To prevent their destruction. }
        goto 88;
        end;
      end;
    if not lines_inject(first_line,last_line,dst_line^.flink) then goto 99;
    if not marks_shift(dst_line,dst_col,max_strlenp+1-dst_col
                      ,last_line,col_two
                      ) then goto 99;
    first_line := nil;        { To prevent their destruction. }
    with dst_line^ do
      begin
      if text_len > 0 then
        begin
        if not line_change_length(dst_line,dst_col+text_len-1) then goto 99;
        ch_copy(text_str,1,text_len,str^,dst_col,len+1-dst_col,' ');
        used := dst_col+text_len-1;
      { The following method of re-drawing the line is adequate given the }
      { relative low usage of this area of code.  The screen is optimally }
      { updated by VDU. }
        if scr_row_nr <> 0 then screen_draw_line(dst_line);
        end
      else
      if dst_col <= used then
        begin
        ch_fill(str^,dst_col,used+1-dst_col,' ');
        used := ch_length(str^,dst_col);
      { The following method of re-drawing the line is adequate given the }
      { relative low usage of this area of code.  The screen is optimally }
      { updated by VDU. }
        if scr_row_nr <> 0 then screen_draw_line(dst_line);
        end;
      end;
    { FINISHED -- AT LAST! }
   88:
    if not mark_create(dst_line,dst_col ,new_start) then goto 99;
    if not mark_create(last_line,col_two,new_end  ) then goto 99;
    text_inter_move := true;
   99:
    if first_line <> nil then { If anything wrong, Destroy any created lines.}
      if not lines_destroy(first_line,last_line) then { Ignore failures. };
    end; {text_inter_move}

  begin {text_move}
{#if debug}
  text_move := false;
  if not line_to_number(mark_one^.line,line_one_nr) then goto 99;
  if not line_to_number(mark_two^.line,line_two_nr) then goto 99;
  if (mark_one^.line^.group^.frame <> mark_two^.line^.group^.frame)
  or (line_one_nr > line_two_nr)
  then begin screen_message(dbg_internal_logic_error); goto 99; end;
{#endif}
  if count > 0 then
    begin
    if mark_one^.line = mark_two^.line then
      cmd_success := text_intra_move
    else
      cmd_success := text_inter_move;
    if tt_controlc then goto 99;
    if not cmd_success then
      begin screen_message(msg_no_room_on_line); goto 99; end;
    {
    ! Everything has gone well, now set the modified flag for the destination
    ! frame, and the source frame, if it's a transfer.
    }
    if not copy then
      with mark_two^, line^.group^.frame^ do
        begin
        text_modified := true;
        if not mark_create(line,col,marks[mark_modified]) then
          goto 99;
        end;
    with new_end^, line^.group^.frame^ do
      begin
      text_modified := true;
      if not mark_create(line,col,marks[mark_modified]) then
        goto 99;
      end;
    end;
  text_move := true;
 99:
  end; {text_move}


function text_split_line (
                before_mark : mark_ptr;
                new_col     : integer;
        var     equals_mark : mark_ptr)
        : boolean;

  {
  ! Inputs:
  !   before_mark       Indicates where the split is to be done.
  !   new_col           The split text is to be moved to this column.
  ! Outputs:
  !   before_mark       In column new_col of the second line.
  !   equals_mark       Where before_mark used to be.
  }

  label 99;
  var
    length   : integer;
    save_col : col_range;
    shift    : integer;
    new_line : line_ptr;
    discard  : boolean;
    cost     : integer;
    equals_col  : col_range;
    equals_line : line_ptr;

  begin {text_split_line}
  text_split_line := false;
  discard := false;
  with before_mark^,line^ do
    begin
    if flink = nil then
      begin screen_message(msg_cant_split_null_line); goto 99; end;
    if new_col = 0 then new_col := text_return_col(line,col,true);
    length := used+1-col;
    if length <= 0 then length := 0
    else
      begin
      if new_col+length > max_strlenp then
        begin screen_message(msg_no_room_on_line); goto 99; end;
      end;

    { Do everything that requires additional memory allocation first. }
    if not lines_create(1,new_line,new_line) then goto 99;
    discard := true;

    { The following is a HEURISTIC calculation to decide which way to do the }
    { split. By default we are going to move the end of this line down to a  }
    { new line.                                                              }
    shift := new_col-col;
    cost := maxint;
    if (col <= used) and (scr_row_nr <> 0) then
      begin
      if shift = 0 then
        cost := col+col               { allow for move-up + erase current }
      else
      if (shift > 0) and (trmflags_v_inch in tt_capabilities) then
        cost := col+col+3*shift       { up+erase+shift }
      else
      if (shift < 0) and (trmflags_v_dlch in tt_capabilities) then
        cost := col+col-3*shift;      { up+erase+shift }
      end;

    { Do the split. }
    if 2*length < cost then
      begin                           { move end to next (new) line }
      equals_col  := col;
      equals_line := line;
      if length > 0 then
        begin
        if not line_change_length(new_line,new_col+length-1) then goto 99;
        ch_fill(new_line^.str^,1,new_col-1,' ');
        ch_move(str^,col,new_line^.str^,new_col,length);
        ch_fill(str^,col,length,' ');
        used := ch_length(str^,used);
        new_line^.used := new_col+length-1;
        if scr_row_nr <> 0 then
          begin
          with group^.frame^ do
            begin
            if used <= scr_offset then
              begin
              vdu_movecurs(1,scr_row_nr);
              vdu_cleareol;
              end
            else
            if used+1 <= scr_offset+scr_width then
              begin
              vdu_movecurs(used+1-scr_offset,scr_row_nr);
              vdu_cleareol;
              end;
            end;
          end;
        end;
      if not lines_inject(new_line,new_line,flink) then goto 99;
      discard := false;
      if not marks_shift(line,col,max_strlenp+1-col,new_line,new_col) then
        goto 99;
      end
    else
      begin                           { move front up and adjust rest }
      equals_col  := col;
      equals_line := new_line;
      if col <= used then shift := col-1 else col := used;
      if shift > 0 then
        begin
        if not line_change_length(new_line,shift) then goto 99;
        ch_move(str^,1,new_line^.str^,1,shift);
        new_line^.used := ch_length(new_line^.str^,shift);
        end;
      if not lines_inject(new_line,new_line,line) then goto 99;
      discard := false;
      if col > 1 then
        if not marks_shift(line,1,col-1,new_line,1) then goto 99;
      shift := new_col-col;
      if shift <= 0 then
        begin
        if shift < 0 then
          begin
          col := col+shift;
          if not text_intra_remove(before_mark,-shift) then goto 99;
          end;
        if new_col > 1 then
          begin
          save_col := col;
          col := 1;
          if not text_overtype(true,1,
                               blank_string,new_col-1,before_mark) then
            goto 99;
          col := save_col;
          end;
        end
      else
        begin
        if not text_insert(true,1,blank_string,shift,before_mark)
          then goto 99;
        if new_col > 1 then
          begin
          save_col := col;
          col := 1;
          if not text_overtype(true,1,blank_string,new_col-1,before_mark)
            then goto 99;
          col := save_col;
          end;
        end;
      end;
    with group^.frame^ do
      begin
      if not mark_create(line,col,marks[mark_modified]) then goto 99;
      text_modified := true;
      end;
    end;
  { FINISHED -- AT LAST }
  if not mark_create(equals_line,equals_col,equals_mark) then goto 99;
  text_split_line := true;
 99:
  if discard then if not lines_destroy(new_line,new_line) then ;
  end; {text_split_line}

{#if vms or turbop}
end.
{#endif}
