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
! Name:         CASEDITTO
!
! Description:  The Case change and Ditto commands.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/caseditto.pas,v 4.6 1990/01/18 18:27:54 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: caseditto.pas,v $
! Revision 4.6  1990/01/18 18:27:54  ludwig
! Entered into RCS at revision level 4.6
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
{##module caseditto;}
{#elseif turbop}
unit caseditto;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'caseditto.fwd'}
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
{####include "caseditto.h"}
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
{###<$F=caseditto.h#>}
{###<$F=ch.h#>}
{###<$F=mark.h#>}
{###<$F=screen.h#>}
{###<$F=text.h#>}
{###<$F=vdu.h#>}
{#elseif turbop}
interface
  uses value;
  {$I caseditto.i}

implementation
  uses ch, mark, screen, text, vdu;
{#endif}


function caseditto_command (
                command   : commands;
                rept      : leadparam;
                count     : integer;
                from_span : boolean)
        : boolean;

  label 9, 99;
  var
    cmd_status,
    cmd_valid   : boolean;
    old_dot_col,
    first_col,
    new_col     : col_range;
    old_str,
    new_str     : str_object;
    command_set : set of commands;
    other_line  : line_ptr;
    key,
    key_up      : key_code_range;
    ch          : char;
    i           : integer;
    insert      : boolean;

  begin {caseditto_command}
  caseditto_command := false;
  cmd_status := false;
  insert := (command in [cmd_ditto_up,cmd_ditto_down]) and
            ((edit_mode = mode_insert) or
             ((edit_mode = mode_command) and (previous_mode = mode_insert)));
  with current_frame^,dot^ do
    begin
    { Remember current line. }
    old_dot_col := col;

    ch_copy(line^.str^,1,line^.used,old_str,1,max_strlen,' ');

    case command of
      cmd_case_up,
      cmd_case_low,
      cmd_case_edit :
        begin
        command_set := [cmd_case_up,cmd_case_low,cmd_case_edit];
        other_line := line;
        end;
      cmd_ditto_up,
      cmd_ditto_down :
        begin
        if insert and (rept in [minus, nint, nindef]) then
          begin screen_message(msg_not_allowed_in_insert_mode); goto 99; end;
        command_set := [cmd_ditto_up,cmd_ditto_down];
        end;
    end{case};

    repeat
      if command = cmd_ditto_up then
        other_line  := line^.blink
      else
      if command = cmd_ditto_down then
        other_line  := line^.flink;
      cmd_valid := true;
      if other_line <> nil then
        with other_line^ do
          case rept of
            none,plus,pint:
              begin
              if count <> 0 then
              if col+count > used+1 then
                cmd_valid := false;
              first_col := col;
              new_col   := col+count;
              end;
            pindef:
              begin
              count     := used+1-col;
              if count < 0 then
                cmd_valid := false;
              first_col := col;
              new_col   := used+1;
              end;
            minus,nint:
              begin
              count     := -count;
              if count >= col then
                cmd_valid := false
              else
                first_col := col-count;
              new_col   := first_col;
              end;
            nindef:
              begin
              count     := col-1;
              first_col := 1;
              new_col   := 1;
              end;
          end{case}
      else
        cmd_valid := false;

      { Carry out the command. }
      if cmd_valid then
        with other_line^ do
          begin
          i := used+1-first_col;
          if i <= 0 then
            ch_fill(new_str,1,count,' ')
          else
            ch_copy(str^,first_col,i,new_str,1,count,' ');
          case command of
            cmd_case_up:
              ch_upcase_str(new_str,count);
            cmd_case_low:
              ch_locase_str(new_str,count);
            cmd_case_edit:
              begin
              if (1 < first_col) and (first_col <= used) then
                ch := str^[first_col-1]
              else
                ch := ' ';
              for i := 1 to count do
                begin
                if ch in ['A'..'Z','a'..'z'] then
                  ch := ch_locase_chr(new_str[i])
                else
                  ch := ch_upcase_chr(new_str[i]);
                new_str[i] := ch;
                end;
              end;
            cmd_ditto_up,
            cmd_ditto_down :
              {No massaging required.};
          end{case};
          col := first_col;
          if insert then
            begin
            if not text_insert(true,1,new_str,count,dot) then goto 9;
            end
          else
            if not text_overtype(true,1,new_str,count,dot) then goto 9;
          { Reposition dot. }
          col := new_col;
          cmd_status := true;
          end;
      if from_span then goto 9;
      if cmd_valid then
        screen_fixup
      else
        vdu_beep;
      key := vdu_get_key;
      if tt_controlc then goto 9;
      if key in lower_set then
        key_up := key - 32 {Uppercase it!}
      else
        key_up := key;
      case rept of
        none, plus, pint, pindef : begin  rept := plus ;  count := +1;  end;
              minus,nint, nindef : begin  rept := minus;  count := -1;  end;
      end{case};
      if command in [cmd_ditto_up,cmd_ditto_down] then
        command := lookup[key_up].command
      else
        if key_up = ord('E') then command := cmd_case_edit
        else if key_up = ord('L') then command := cmd_case_low
        else if key_up = ord('U') then command := cmd_case_up
        else command := cmd_noop;
    until not (command in command_set);
    vdu_take_back_key(key);

  9:if tt_controlc then
      begin
      cmd_status := false;
      col := 1;
      if text_overtype(false,1,old_str,max_strlen,dot) then ;
      col := old_dot_col;
      end
    else
      if cmd_status then
        begin
        text_modified := true;
        if not mark_create(line,col,marks[mark_modified]) then ;
        if mark_create(line,old_dot_col,marks[mark_equals]) then ;
        end;
    end;
  caseditto_command := cmd_status or not from_span;
 99:
  end; {caseditto_command}

{#if vms or turbop}
end.
{#endif}
