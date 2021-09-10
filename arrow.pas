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
{       Chris J. Barter (1979-82, 1987-89)                             }
{       Bevin R. Brett (1979-82)                                       }
{       Kevin J. Maciunas (1980-84 )                                   }
{       Kelvin B. Nicolle (1981-90)                                    }
{       Mark R. Prior (1987-88)                                        }
{       Jeff Blows (1988-90,2020)                                      }
{       Martin Sandiford (2002)                                        }
{                                                                      }
{  Copyright  1987, 1989-90 University of Adelaide                     }
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
! Name:         ARROW
!
! Description:  The arrow key, TAB, and BACKTAB commands.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/arrow.pas,v 4.5 1990/01/18 18:30:47 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: arrow.pas,v $
! Revision 4.5  1990/01/18 18:30:47  ludwig
! Entered into RCS at revision level 4.5
!
!
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-003 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
! 4-004 Kelvin B. Nicolle                                    13-Sep-1989
!       Add includes etc. for Tower version.
! 4-005 Kelvin B. Nicolle                                    25-Oct-1989
!       Correct the includes for the Tower version.
!--}

{#if vms}
{##[ident('4-005'),}
{## overlaid]}
{##module arrow;}
{#elseif turbop}
unit arrow;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'arrow.fwd'}
{##%include 'line.h'}
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
{####include "arrow.h"}
{####include "line.h"}
{####include "mark.h"}
{####include "screen.h"}
{####include "text.h"}
{####include "vdu.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=arrow.h#>}
{###<$F=line.h#>}
{###<$F=mark.h#>}
{###<$F=screen.h#>}
{###<$F=text.h#>}
{###<$F=vdu.h#>}
{#elseif turbop}
interface
  uses value;
  {$I arrow.i}

implementation
  uses line, mark, screen, text, vdu;
{#endif}


function arrow_command (
                command   : commands;
                rept      : leadparam;
                count     : integer;
                from_span : boolean)
        : boolean;

  label
    1,        { EXITLOOP label. }
    9;        { Exit. }

  var
    key          : key_code_range;
    cmd_status,
    cmd_valid    : boolean;
    step         : integer;
    line_nr      : line_range;
    eop_line_nr  : line_range;
    new_col      : col_width_range;
    dot_col      : col_range;
    dot_line     : line_ptr;
    old_dot,
    new_eql      : mark_object;
    counter      : integer;

  begin {arrow_command}
  cmd_status := false;
  with current_frame^ do
    begin
    old_dot := dot^;
    with last_group^ do
      eop_line_nr := first_line_nr + last_line^.offset_nr;

    repeat
      cmd_valid := false;
      if command in [cmd_return, cmd_home, cmd_tab, cmd_backtab,
                     cmd_left, cmd_right, cmd_down, cmd_up] then
        case command of

          cmd_return:
            begin
            cmd_valid := true;
            new_eql := dot^;
            with dot^ do begin dot_line := line; dot_col  := col; end;
            for counter := 1 to count do
              begin
              if tt_controlc then goto 9;
              if dot_line^.flink = nil then
                begin
                if not text_realize_null(dot_line) then goto 9;
                eop_line_nr := eop_line_nr+1;
                dot_line := dot_line^.blink;
                if counter = 1 then new_eql.line := dot_line;
                end;
              dot_col  := text_return_col(dot_line,dot_col,false);
              dot_line := dot_line^.flink;
              end;
            if not mark_create(dot_line,dot_col,dot) then goto 9;
            end;

          cmd_home:
            begin
            cmd_valid := true;
            new_eql := dot^;
            if current_frame = scr_frame then
              if not mark_create(scr_top_line,scr_offset+1,dot) then goto 9;
            end;

          cmd_tab, cmd_backtab:
            begin
            new_col := dot^.col;
            if command = cmd_tab then
              begin
              if new_col = max_strlenp then goto 1;
              step := 1;
              end
            else
              step := -1;
            for counter := 1 to count do
              begin
              repeat
                new_col := new_col+step;
              until (tab_stops[new_col]     or
                    (new_col = margin_left) or
                    (new_col = margin_right) );
              if (new_col = 0) or (new_col = max_strlenp) then goto 1;
              end;
            cmd_valid := true;
            new_eql := dot^;
            dot^.col := new_col;
            1:
            end;

          cmd_left:
            with dot^ do
              begin
              case rept of
                none, plus, pint:
                  if col-count >= 1 then
                    begin
                    cmd_valid := true;
                    new_eql := dot^;
                    col := col-count;
                    end;
                pindef:
                  if col >= margin_left then
                    begin
                    cmd_valid := true;
                    new_eql := dot^;
                    col := margin_left;
                    end;
              end{case};
              end;

          cmd_right:
            with dot^ do
              begin
              case rept of
                none, plus, pint:
                  if col+count <= max_strlenp then
                    begin
                    cmd_valid := true;
                    new_eql := dot^;
                    col := col+count;
                    end;
                pindef:
                  if col <= margin_right then
                    begin
                    cmd_valid := true;
                    new_eql := dot^;
                    col := margin_right;
                    end;
              end{case};
              end;

          cmd_down:
            begin
            dot_line := dot^.line;
            if not line_to_number(dot_line,line_nr) then goto 9;
            case rept of
              none, plus, pint:
                if line_nr+count <= eop_line_nr then
                  begin
                  cmd_valid := true;
                  new_eql := dot^;
                  if count < max_grouplines div 2 then
                    for counter := 1 to count do dot_line := dot_line^.flink
                  else
                    if not line_from_number(current_frame,line_nr+count,
                                                        dot_line) then goto 9;
                  end;
              pindef:
                  begin
                  cmd_valid := true;
                  new_eql := dot^;
                  dot_line := last_group^.last_line;
                  end;
            end{case};
            if not mark_create(dot_line,dot^.col,dot) then goto 9;
            end;

          cmd_up:
            begin
            dot_line := dot^.line;
            if not line_to_number(dot_line,line_nr) then goto 9;
            case rept of
              none, plus, pint:
                if line_nr-count > 0 then
                  begin
                  cmd_valid := true;
                  new_eql := dot^;
                  if count < max_grouplines div 2 then
                    for counter := 1 to count do dot_line := dot_line^.blink
                  else
                    if not line_from_number(current_frame,line_nr-count,
                                                          dot_line) then goto 9;
                  end;
              pindef:
                begin
                cmd_valid := true;
                new_eql := dot^;
                dot_line := first_group^.first_line;
                end;
            end{case};
            if not mark_create(dot_line,dot^.col,dot) then goto 9;
            end;
        end{case}
      else
        begin
        vdu_take_back_key(key);
        goto 9;
        end;

      if cmd_valid then
        cmd_status := true;
      if from_span then goto 9;
      screen_fixup;
      if not cmd_valid  or
         ((command = cmd_down) and (rept <> pindef) and
                                   (dot^.line^.flink = nil)) then
        vdu_beep;
      key := vdu_get_key;
      if tt_controlc then goto 9;
      rept    := none;
      count   := 1;
      command := lookup[key].command;
      if (command = cmd_return) and (edit_mode = mode_insert) then
        command := cmd_split_line;
    until false;

  9:if tt_controlc then
      begin
      if mark_create(old_dot.line,old_dot.col,dot) then ;
      end
    else
      begin
      { Define Equals. }
      if cmd_status then
        begin
        if not mark_create(new_eql.line,new_eql.col,marks[mark_equals]) then ;
        if (command = cmd_down) and (rept <> pindef) and
                                    (dot^.line^.flink = nil) then
          cmd_status := false;
        end;
      end;
    arrow_command := cmd_status or not from_span;
    end;
  end; {arrow_command}

{#if vms or turbop}
end.
{#endif}
