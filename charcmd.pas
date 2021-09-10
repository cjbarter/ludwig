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
{  Copyright  1987-89 University of Adelaide                           }
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
! Name:         CHARCMD
!
! Description:  Character Insert/Delete/Rubout commands.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/charcmd.pas,v 4.7 1990/01/18 18:24:01 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: charcmd.pas,v $
! Revision 4.7  1990/01/18 18:24:01  ludwig
! Entered into RCS at revision level 4.7
!
!
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Mark R. Prior                                        20-Feb-1988
!       Strings passed to ch routines are now passed using conformant
!         arrays, or as type str_object.
!               string[offset],length -> string,offset,length
!       In all calls of ch_length, ch_upcase_str, ch_locase_str, and
!         ch_reverse_str, the offset was 1 and is now omitted.
! 4-003 Kelvin B. Nicolle                                     9-Sep-1988
!       Work around a code generation bug in the Multimax pc compiler.
!       (See UMAX bug report 18.)
! 4-004 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-005 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
! 4-006 Kelvin B. Nicolle                                    13-Sep-1989
!       Add includes etc. for Tower version.
! 4-007 Kelvin B. Nicolle                                    25-Oct-1989
!       Correct the includes for the Tower version.
!--}

{#if vms}
{##[ident('4-007'),}
{## overlaid]}
{##module charcmd;}
{#elseif turbop}
unit charcmd;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'charcmd.fwd'}
{##%include 'ch.h'}
{##%include 'mark.h'}
{##%include 'screen.h'}
{##%include 'text.h'}
{##%include 'vdu.h'}
{##%include 'vdu_vms.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "charcmd.h"}
{####include "ch.h"}
{####include "mark.h"}
{####include "screen.h"}
{####include "text.h"}
{####include "vdu.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=charcmd.h#>}
{###<$F=ch.h#>}
{###<$F=mark.h#>}
{###<$F=screen.h#>}
{###<$F=text.h#>}
{###<$F=vdu.h#>}
{#elseif turbop}
interface
  uses value;
  {$I charcmd.i}

implementation
  uses ch, mark, screen, text, vdu;
{#endif}


function charcmd_insert (
                cmd       : commands;
                rept      : leadparam;
                count     : integer;
                from_span : boolean)
        : boolean;

  label 9;
  var
    cmd_status,
    cmd_valid  : boolean;
    old_dot_col,
    eql_col    : col_range;
    maximum,
    inserted   : strlen_range;
    key        : key_code_range;
    temp_mark  : mark_ptr;

  begin {charcmd_insert}
  cmd_status := false;
  if rept = minus then rept := nint;
  count := abs(count);
  with current_frame^ do
    begin
    with dot^,line^ do
      begin
      old_dot_col := col;
      if col <= used
      then maximum := max_strlen-used
      else maximum := max_strlen-col;
      end;
    inserted := 0;
    repeat
      cmd_valid := count <= maximum;
      if cmd_valid then
        begin
        maximum := maximum - count;
        inserted := inserted + count;
        if not text_insert(true,1,blank_string,count,dot) then goto 9;
        with dot^ do
          if rept = nint then
            eql_col := col - count
          else
            begin
            eql_col := col;
            col := col - count;
            end;
        cmd_status := true;
        end;
      if from_span then goto 9;
      if cmd_valid then
        screen_fixup
      else
        vdu_beep;
      key := vdu_get_key;
      if tt_controlc then goto 9;
      rept := none;
      count := 1;
      if key in printable_set then
        cmd := cmd_noop
      else
        cmd := lookup[key].command;
    until cmd <> cmd_insert_char;
    vdu_take_back_key(key);

 9: with dot^ do
      if tt_controlc then
        begin
        cmd_status := false;
        col := old_dot_col;
        temp_mark := nil;
        if mark_create(line,col+inserted,temp_mark) then;
        if text_remove(dot,temp_mark) then;
        if mark_destroy(temp_mark) then;
        end
      else
        if cmd_status then
          begin
          text_modified := true;
          if not mark_create(line,col,marks[mark_modified]) then ;
          if not mark_create(line,eql_col,marks[mark_equals]) then;
          end;
    end;
  charcmd_insert := cmd_status or not from_span;
  end; {charcmd_insert}


function charcmd_delete (
                cmd       : commands;
                rept      : leadparam;
                count     : integer;
                from_span : boolean)
        : boolean;

  label 9;
  var
    cmd_status,
    cmd_valid   : boolean;
    first_col,
    scr_col     : integer;
    old_dot_col : col_range;
    old_str     : str_object;
    old_used    : strlen_range;
    deleted     : integer;
    key         : key_code_range;
    length      : integer;

  begin {charcmd_delete}
  cmd_status := false;
  with current_frame^,dot^,line^ do
    begin
    old_dot_col := col;
    ch_copy(str^,1,used,old_str,1,max_strlen,' ');
    deleted := 0;
    repeat
      cmd_valid := true;
      case rept of
        none,plus,pint:
          if count > max_strlenp - col then
            cmd_valid := false;
        pindef:
          count := max_strlenp - col;
        minus,nint:
          begin
          count := -count;
          if count < col
          then col := col - count
          else cmd_valid := false;
          end;
        nindef:
          begin
          count := col - 1;
          col := 1;
          end;
      end{case};
      if cmd_valid then
        begin
        { Update the text of the line. }
        old_used := used;
        length := (used+1)-(col+count);
        if length > 0 then
          begin
          ch_move(str^,col+count,str^,col,length);
          ch_fill(str^,used+1-count,count,' ');
          used := used-count;
          end
        else
        if col <= used then
          begin
          ch_fill(str^,col,used+1-col,' ');
          used := ch_length(str^,col);
          end;
        { Update the screen. }
        scr_col := col - scr_offset;
        if (scr_row_nr <> 0) and (count <> 0) and (col <= old_used) and
           (scr_col <= scr_width) then
          begin
          if scr_col <= 0 then scr_col := 1;
          vdu_movecurs(scr_col,scr_row_nr);
          length := scr_width+1-scr_col;
          if count < length then
            begin
            length := count;
            vdu_deletechars(count);
            end
          else
            vdu_cleareol;
          first_col := scr_offset+scr_width+1-length;
          if first_col <= used then           { If non-blank then            }
            begin                             { redraw area.                 }
            vdu_movecurs(scr_width+1-length,scr_row_nr);
            if length > used+1-first_col then
              length := used+1-first_col;
            vdu_displaystr(length,str^[first_col],3);
            end;
          end;
        deleted := deleted + count;
        cmd_status := true;
        end;
      if from_span then goto 9;
      if cmd_valid then
        screen_fixup
      else
        vdu_beep;
      key := vdu_get_key;
      if tt_controlc then goto 9;
      rept := none;
      count := 1;
      if key in printable_set then
        cmd := cmd_noop
      else
        cmd := lookup[key].command;
      if (cmd = cmd_rubout) and (edit_mode = mode_insert) then
        begin { In insert_mode treat RUBOUT as \-D }
        rept  := minus;
        count := -1;
        cmd   := cmd_delete_char;
        end;
    until cmd <> cmd_delete_char;
    vdu_take_back_key(key);

9:  if tt_controlc then
      begin
      cmd_status := false;
      col := 1;
      if text_overtype(false,1,old_str,max_strlen,dot) then;
      col := old_dot_col;
      end
    else
      if cmd_status then
        begin
        old_dot_col := col;
        count := max_strlenp - old_dot_col;
        if deleted > count then
          deleted := count;
        if marks_squeeze(line,old_dot_col,line,old_dot_col+deleted) then;
        if marks_shift(line,old_dot_col+deleted,
                       max_strlenp-(old_dot_col+deleted)+1,
                       line,old_dot_col) then;
        text_modified := true;
        if not mark_create(line,col,marks[mark_modified]) then ;
        if marks[mark_equals] <> nil then
          if mark_destroy(marks[mark_equals]) then;
        end;
    end;
  charcmd_delete := cmd_status or not from_span;
  end; {charcmd_delete}


function charcmd_rubout (
                cmd       : commands;
                rept      : leadparam;
                count     : integer;
                from_span : boolean)
        : boolean;

  label 9;
  var
    cmd_status,
    cmd_valid   : boolean;
    old_dot_col : col_range;
    old_str     : str_object;
    dot_used    : strlen_range;
    eql_col     : col_range;
    key         : key_code_range;

  begin {charcmd_rubout}
  if edit_mode = mode_insert then
    begin
    if rept = pindef
    then rept := nindef
    else rept := nint;
    cmd_status := charcmd_delete(cmd_delete_char,rept,-count,from_span);
    end
  else
    begin
    cmd_status := false;
    with current_frame^,dot^ do
      begin
      old_dot_col := col;
      dot_used := line^.used;
      ch_copy(line^.str^,1,dot_used,old_str,1,max_strlen,' ');
      repeat
        if rept = pindef then count := col-1;
        cmd_valid := count <= col-1;
        if cmd_valid then
          begin
          eql_col := col;
          col := col-count;
          if not text_overtype(true,1,blank_string,count,dot) then goto 9;
{#if ns32000}
{##          col := dot^.col-count;   #<Multimax bug workaround#>}
{#else}
          col := col-count;
{#endif}
          cmd_status := true;
          end;
        if from_span then goto 9;
        if cmd_valid
        then screen_fixup
        else vdu_beep;
        key := vdu_get_key;
        if tt_controlc then goto 9;
        rept  := none;
        count := 1;
        if key in printable_set then
          cmd := cmd_noop
        else
          cmd := lookup[key].command;
      until cmd <> cmd_rubout;
      vdu_take_back_key(key);

   9: if tt_controlc then
        begin
        cmd_status := false;
        col := 1;
        if text_overtype(false,1,old_str,dot_used,dot) then;
        col := old_dot_col;
        end
      else
        if cmd_status then
          begin
          text_modified := true;
          if not mark_create(line,col,marks[mark_modified]) then ;
          if not mark_create(line,eql_col,marks[mark_equals]) then;
          end;
      end;
    end;
  charcmd_rubout := cmd_status or not from_span;
  end; {charcmd_rubout}

{#if vms or turbop}
end.
{#endif}
