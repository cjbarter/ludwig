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
{       Chris J. Barter (1979-81, 1987);                               }
{       Wayne N. Agutter (1979-81, 1987);                              }
{       Bevin R. Brett (1979-81, 1987);                                }
{       Kelvin B. Nicolle (1987-90).                                   }
{       Kevin J. Maciunas (1980-84 )                                   }
{       Mark R. Prior (1987-88);                                       }
{       Jeff Blows (1989);                                             }
{       Steve Nairn (1990);                                            }
{       Martin Sandiford (1991); and                                   }
{       Jeff Blows (2020).                                             }
{                                                                      }
{  Copyright  1979-81, 1987-91, 2020 University of Adelaide            }
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
! Name:         EXEC
!
! Description:  The primitive LUDWIG commands.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/exec.pas,v 4.18 1991/02/22 14:56:45 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: exec.pas,v $
! Revision 4.18  1991/02/22 14:56:45  ludwig
! Added cases for the handling of X mouse handling and span manipulation
!
! Revision 4.17  90/02/08  10:22:24  ludwig
! changed pcc preprocessor #if to the correct syntax
!
! Revision 4.16  90/02/05  12:04:16  ludwig
! Steven Nairn.
! code to handle window resizing. (on receipt of cmd_window_resize).
!
! Revision 4.15  90/01/18  18:15:52  ludwig
! Entered into RCS at revision level 4.15
!
!
!---
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                     5-May-1987
!       Modified replace code to correctly store multiple line
!       replacement tpars.
! 4-003 Mark R. Prior                                        11-Nov-1987
!       Change the code for SA and KM to fail if their first parameter
!       is empty, regardless of the length of the second parameter.
! 4-004 Mark R. Prior                                        19-Dec-1987
!       Add the NEWWORD module with modified AW and DW commands, and new
!       AP and DP commands.
! 4-005 Mark R. Prior                                        19-Dec-1987
!       Modify the AC command semantics for the new command set.
! 4-006 Mark R. Prior                                        20-Feb-1988
!       Strings passed to ch routines are now passed using conformant
!         arrays, or as type str_object.
!               string[offset],length -> string,offset,length
!       In all calls of ch_length, ch_upcase_str, ch_locase_str, and
!         ch_reverse_str, the offset was 1 and is now omitted.
!       Where conformant arrays are not implemented and the array is not
!         of type str_object, separate routines are provided for each
!         type.
! 4-007 Kelvin B. Nicolle                                    26-Aug-1988
!       The EXEC module is too big for the Multimax pc compiler.  Move
!       the code for the quit command to the QUIT module.
! 4-008 Kelvin B. Nicolle                                     2-Sep-1988
!       Only the Ultrix Pascal compiler does not support underscores in
!       identifiers:  Put the underscores back in the Pascal sources and
!       make the macro definitions of the external names conditional in
!       the C sources.
! 4-009 Kelvin B. Nicolle                                    30-Sep-1988
!       The EXEC module is too big for the Multimax pc compiler.  Move
!       the code for the window commands to a new module.
! 4-010 Kelvin B. Nicolle                                     1-Mar-1989
!       Restore the old semantics of the AC command.
! 4-011 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-012 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
! 4-013 Kelvin B. Nicolle                                    13-Sep-1989
!       Add includes etc. for Tower version.
! 4-014 Kelvin B. Nicolle                                    25-Oct-1989
!       Correct the includes for the Tower version.
!       Change files.h to fyle.h.
!       Remove the superfluous include of system.h.
! 4-015 Kelvin B. Nicolle                                    17-Jan-1990
!       Add cmd_file_save to the main case statement.
!--}

{#if vms}
{##[ident('4-015'),}
{## overlaid]}
{##module exec (output);}
{#elseif turbop}
unit exec;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'exec.fwd'}
{##%include 'arrow.h'}
{##%include 'caseditto.h'}
{##%include 'ch.h'}
{##%include 'charcmd.h'}
{##%include 'code.h'}
{##%include 'eqsgetrep.h'}
{##%include 'fyle.h'}
{##%include 'frame.h'}
{##%include 'help.h'}
{##%include 'line.h'}
{##%include 'mark.h'}
{##%include 'newword.h'}
{##%include 'nextbridge.h'}
{##%include 'opsys.h'}
{##%include 'quit.h'}
{##%include 'screen.h'}
{##%include 'span.h'}
{##%include 'swap.h'}
{##%include 'tpar.h'}
{##%include 'text.h'}
{##%include 'user.h'}
{##%include 'validate.h'}
{##%include 'vdu.h'}
{##%include 'vdu_vms.h'}
{##%include 'window.h'}
{##%include 'word.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "exec.h"}
{####include "arrow.h"}
{####include "caseditto.h"}
{####include "ch.h"}
{####include "charcmd.h"}
{####include "code.h"}
{####include "eqsgetrep.h"}
{####include "fyle.h"}
{####include "frame.h"}
{####include "help.h"}
{####include "line.h"}
{####include "mark.h"}
{####include "newword.h"}
{####include "nextbridge.h"}
{####include "opsys.h"}
{####include "quit.h"}
{####include "screen.h"}
{####include "span.h"}
{####include "swap.h"}
{####include "tpar.h"}
{####include "text.h"}
{####include "user.h"}
{####include "validate.h"}
{####include "vdu.h"}
{####include "window.h"}
{####include "word.h"}
{#if XWINDOWS}
{####include "x-mouse.h"}
{#endif}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=exec.h#>}
{###<$F=arrow.h#>}
{###<$F=caseditto.h#>}
{###<$F=ch.h#>}
{###<$F=charcmd.h#>}
{###<$F=code.h#>}
{###<$F=eqsgetrep.h#>}
{###<$F=fyle.h#>}
{###<$F=frame.h#>}
{###<$F=help.h#>}
{###<$F=line.h#>}
{###<$F=mark.h#>}
{###<$F=newword.h#>}
{###<$F=nextbridge.h#>}
{###<$F=opsys.h#>}
{###<$F=quit.h#>}
{###<$F=screen.h#>}
{###<$F=span.h#>}
{###<$F=swap.h#>}
{###<$F=tpar.h#>}
{###<$F=text.h#>}
{###<$F=user.h#>}
{###<$F=validate.h#>}
{###<$F=vdu.h#>}
{###<$F=window.h#>}
{###<$F=word.h#>}
{#if XWINDOWS}
{###<$F=x-mouse.h#>}
{#endif}
{#elseif turbop}
interface
  uses value;
  {$I exec.i}

implementation
  uses arrow, caseditto, ch, charcmd, code, eqsgetrep, fyle, frame,
        help, line, mark, newword, nextbridge, opsys, quit,
        screen, span, swap, tpar, text, user,
        validate, vdu, window, word, ncurses_mouse;
{#endif}


function exec_compute_line_range (
                frame      : frame_ptr;
                rept       : leadparam;
                count      : integer;
        var     first_line : line_ptr;
        var     last_line  : line_ptr)
        : boolean;

  { This routine returns the range of lines specified by the REPT/COUNT pair.}
  { It returns FALSE if the range does not exist. }
  { It returns First_Line as NIL if the range is empty. }
  { The range returned WILL NOT include the null line.}
  { It is assumed that the mark (if any) has been checked for validity. }
  label 99;
  var
    line_nr,mark_line_nr : line_range;
    mark_line            : line_ptr;

  begin {exec_compute_line_range}
  exec_compute_line_range := false;
  with frame^,dot^ do
    begin
    first_line := line;
    last_line  := line;
    case rept of
      none,
      plus,pint:
        begin
        if count = 0 then
          first_line := nil
        else
        if count <= 20 then            { TRY TO OPTIMIZE COMMON CASE }
          begin
          for line_nr := 1 to count-1 do
            begin
            last_line := last_line^.flink;
            if last_line = nil then goto 99;
            end;
          if last_line^.flink = nil then goto 99;
          end
        else
          begin
          if not line_to_number(first_line,line_nr) then goto 99;
          if not line_from_number(current_frame,line_nr+count-1,last_line)
          then goto 99;
          if last_line = nil then goto 99;
          if last_line^.flink = nil then goto 99;
          end;
        end;
      minus,nint:
        begin
        count := -count;
        last_line := line^.blink;
        if last_line = nil then goto 99;
        if count <= 20 then
          begin
          for line_nr := 1 to count do
            begin
            first_line := first_line^.blink;
            if first_line = nil then goto 99;
            end;
          end
        else
          begin
          if not line_to_number(last_line,line_nr) then goto 99;
          if count > line_nr then goto 99;
          line_nr := line_nr-count+1;
          if not line_from_number(current_frame,line_nr,first_line)
          then goto 99;
          end;
        end;
      pindef:
        begin
        if line^.flink = nil then
          first_line := nil
        else
          last_line := last_group^.last_line^.blink;
        end;
      nindef:
        begin
        last_line := line^.blink;
        if last_line = nil then
          first_line := nil
        else
          first_line := first_group^.first_line;
        end;
      marker:
        begin
        mark_line := marks[count]^.line;
        if mark_line = first_line then        { TRY TO OPTIMIZE MOST COMMON }
          first_line := nil                   { CASES. }
        else
        if mark_line^.flink = first_line then
          begin
          first_line := mark_line;
          last_line  := mark_line;
          end
        else
        if mark_line^.blink = first_line then
          begin
          last_line := first_line;
          end
        else
          begin                               { DO IT THE HARD WAY! }
          if not line_to_number(mark_line,mark_line_nr) then goto 99;
          if not line_to_number(     line,     line_nr) then goto 99;
          if mark_line_nr < line_nr then
            begin
            first_line := mark_line;
            last_line  := last_line^.blink;
            end
          else
            last_line  := mark_line^.blink;
          end;
        end;
    end{case};
    end{with};
  exec_compute_line_range := true;
99:
  end; {exec_compute_line_range}


function execute (
                command   : commands;
                rept      : leadparam;
                count     : integer;
                tparam    : tpar_ptr;
                from_span : boolean)
        : boolean;

  label 99;
  var
    cmd_success    : boolean;
    new_col,
    dot_col        : col_range;
    new_line,
    first_line,
    last_line      : line_ptr;
    key            : key_code_range;
    i,j            : integer;
    line_nr,
    line2_nr       : line_range;
    new_name       : name_str;
    new_span,
    old_span       : span_ptr;
    new_tparam     : tpar_ptr;
    request,
    request2       : tpar_object;
    the_mark       : mark_ptr;
    the_other_mark : mark_ptr;
    another_mark   : mark_ptr;
    eq_set         : boolean;            { These 3 are used for      }
    old_frame      : frame_ptr;          { the setting up of         }
    old_dot        : mark_object;        { the commands' = behaviour }
    new_str        : str_object;

  begin {execute}
  cmd_success := false;
  with request do
    begin
    nxt:= nil;  con:= nil;
    end;
  with request2 do
    begin
    nxt:= nil;  con:= nil;
    end;
  exec_level := exec_level + 1;
  if tt_controlc then goto 99;
  if exec_level = max_exec_recursion then
    begin screen_message(msg_command_recursion_limit); goto 99; end;
  with current_frame^,dot^ do
    begin
    { Fix commands which use marks without using @ in the syntax. }
    if command = cmd_mark then
      begin
      if (count = 0) or (abs(count) > max_mark_number) then
        begin screen_message(msg_illegal_mark_number); goto 99; end;
      end
    else if command = cmd_span_define then
      if rept in [none, pint] then
        begin
        if (count = 0) or (count > max_mark_number) then
          begin screen_message(msg_illegal_mark_number); goto 99; end;
        rept := marker;
        end;

    { Check the mark, assign The_Mark to the mark. }
    if rept = marker then
      begin
      the_mark := marks[count];
      if the_mark = nil then
        begin screen_message(msg_mark_not_defined); goto 99; end;
      end;

    { Save the current value of DOT and CURRENT_FRAME for use by equals }
    old_dot := dot^;
    old_frame := current_frame;

    { Execute the command. }
    if command in [cmd_noop..cmd_do_last_command] then
      case command of

        cmd_advance:
          begin
          { Establish which line to advance to. }
          cmd_success := (rept in [pindef,nindef,marker]);
          new_line := line;
          case rept of
            none,
            plus,pint:
              begin
              if count < 20 then
                begin
                while count > 0 do
                  begin
                  count := count-1;
                  new_line := new_line^.flink;
                  if new_line = nil then goto 99;
                  end;
                end
              else
                begin
                if not line_to_number(new_line,line_nr) then goto 99;
                if not line_from_number(current_frame,line_nr+count,new_line)
                then goto 99;
                if new_line = nil then goto 99;
                end;
              { if flink is nil we are on eop-line, so fail }
              if new_line^.flink = nil then goto 99;
              cmd_success := true;
              end;
            minus,nint:
              begin
              count := -count;
              if count < 20 then
                begin
                while count > 0 do
                  begin
                  count := count-1;
                  new_line := new_line^.blink;
                  if new_line = nil then goto 99;
                  end;
                end
              else
                begin
                if not line_to_number(new_line,line_nr) then goto 99;
                if count >= line_nr then goto 99;
                if not line_from_number(current_frame,line_nr-count,new_line)
                then goto 99;
                if new_line = nil then goto 99;
                end;
              cmd_success := true;
              end;
            pindef:
              new_line := last_group^.last_line;
            nindef:
              new_line := first_group^.first_line;
            marker:
              new_line := the_mark^.line;
          end{case};
          if not mark_create(line,col,marks[mark_equals]) then goto 99;
          if mark_create(new_line,1,dot) then ;
          end;

        cmd_bridge,
        cmd_next:
          if tpar_get_1(tparam,command,request) then
            cmd_success := nextbridge_command(rept,
                                              count,
                                              request,
                                              command=cmd_bridge);

        cmd_case_edit,
        cmd_case_low,
        cmd_case_up,
        cmd_ditto_down,
        cmd_ditto_up:
          cmd_success := caseditto_command(command,rept,count,from_span);

        cmd_delete_char:
          begin
          if rept <> marker then
            cmd_success := charcmd_delete(command,rept,count,from_span)
          else
            begin
            the_other_mark := dot;
            if not line_to_number(line,line_nr) then goto 99;
            if not line_to_number(the_mark^.line,line2_nr) then goto 99;
            if  (line_nr > line2_nr)
            or ((line_nr = line2_nr) and (col > the_mark^.col))
            then
              begin     { Reverse mark pointers to get The_Other_Mark first. }
              another_mark   := the_mark;
              the_mark       := the_other_mark;
              the_other_mark := another_mark;
              end;
            if current_frame <> frame_oops then
              begin
              with frame_oops^ do { Make sure oops_span is okay. }
                begin
                if not mark_create(last_group^.last_line,1,span^.mark_two) then
                  goto 99;
                cmd_success := text_move(false,             { Dont copy,transfer}
                                         1,                 { One instance of}
                                         the_other_mark,    { starting pos.  }
                                         the_mark,          { ending pos.    }
                                         span^.mark_two,    { destination.   }
                                         marks[mark_equals],{ leave at start.}
                                         dot);              { leave at end.  }
                text_modified := true;
                if not mark_create(dot^.line,dot^.col,marks[mark_modified]) then ;
                end;
              end
            else
              begin
              cmd_success := text_remove(the_other_mark,  { starting pos.   }
                                         the_mark);       { ending pos.     }
              end;
            text_modified := true;
            if not mark_create(line,col,marks[mark_modified]) then ;
            end;
          end;

        cmd_delete_line:
          begin
          { Establish which lines to kill, this is common to K and FW cmds. }
          if not exec_compute_line_range(current_frame,
                                         rept,
                                         count,
                                         first_line,
                                         last_line)
          then goto 99;
          if first_line <> nil then
            begin
            dot_col := col;
            if last_line^.flink = nil                              then goto 99;
            if not marks_squeeze(first_line,1,last_line^.flink,1)  then goto 99;
            if not lines_extract(first_line,last_line)             then goto 99;
            if current_frame <> frame_oops then
              begin
              if not lines_inject(first_line,last_line,
                                  frame_oops^.last_group^.last_line)
              then goto 99;
              with frame_oops^ do
                begin
                if not mark_create(first_line,1,marks[mark_equals]) then
                  goto 99;
                if not mark_create(last_group^.last_line,1,dot) then goto 99;
                text_modified := true;
                if not mark_create(dot^.line,dot^.col,marks[mark_modified]) then ;
                end;
              end
            else
              if not lines_destroy(first_line,last_line) then goto 99;
            col := dot_col;
            text_modified := true;
            if not mark_create(line,col,marks[mark_modified]) then ;
            end;
          cmd_success := true;
          end;

        cmd_backtab,
        cmd_down,
        cmd_home,
        cmd_left,
        cmd_return,
        cmd_right,
        cmd_tab,
        cmd_up:
          if (command = cmd_return)    and
             (edit_mode = mode_insert) and
             (opt_new_line in options)
          then
            begin
            if line^.flink = nil then
              begin
              cmd_success := text_realize_null(line);
              cmd_success := arrow_command(command,rept,count,from_span);
              end
            else
              cmd_success := execute(cmd_split_line,rept,count,tparam,from_span)
            end
          else
            cmd_success := arrow_command(command,rept,count,from_span);

{#if debug}
        cmd_dump:
          begin
          first_line := scr_frame^.first_group^.first_line;
          vdu_movecurs(1,terminal_info.height);
          vdu_flush(true);
          writeln('DUMP sr ln');
          while first_line <> nil do
            begin
            if first_line = scr_top_line then
              writeln('SCR_TOP_LINE:');
            if first_line = scr_bot_line then
              writeln('SCR_BOT_LINE:');
            if first_line = scr_frame^.dot^.line then
              writeln('DOT         :');
            with first_line^ do
              begin
              if line_to_number(first_line,line_nr) then
                writeln('     ',scr_row_nr:2,' ',line_nr:2)
              else
                writeln('Line to number failed');
              first_line := flink;
              end;
            end;
          cmd_success := true;
          end;
{#endif}

        cmd_equal_column:
          begin
          i := 1; {Start of column number, j receives column number.}
          if tpar_get_1(tparam,command,request) then
          if tpar_to_int(request,i,j) then
            case rept of
              none,plus : cmd_success := (col =  j);
              minus     : cmd_success := (col <> j);
              pindef    : cmd_success := (col >= j);
              nindef    : cmd_success := (col <= j);
            end{case};
          end;

        cmd_equal_eol:
          begin
          case rept of
            none,plus : cmd_success := (col =  line^.used+1);
            minus     : cmd_success := (col <> line^.used+1);
            pindef    : cmd_success := (col >= line^.used+1);
            nindef    : cmd_success := (col <= line^.used+1);
          end{case};
          end;

        cmd_equal_eop,
        cmd_equal_eof:
          begin
          cmd_success := (line^.flink = nil);
          if command = cmd_equal_eof then
          if input_file <> 0 then
          if not files[input_file]^.eof then cmd_success := false;
          if rept = minus then cmd_success := not cmd_success;
          end;

        cmd_equal_mark:
          begin
          if not tpar_get_1(tparam,command,request) then goto 99;
          if not tpar_to_mark(request,j) then goto 99;
          if marks[j] <> nil then
            case rept of
              none  ,
              plus  ,
              minus :
                begin
                if (marks[j]^.line = line) and (marks[j]^.col = col)
                then cmd_success := true;
                if rept = minus then cmd_success := not cmd_success;
                end;
              pindef,
              nindef:
                begin
                if marks[j]^.line = line then
                  if rept = pindef then
                    cmd_success := (col >= marks[j]^.col)
                  else
                    cmd_success := (col <= marks[j]^.col)
                else if line_to_number(line,line_nr) and
                        line_to_number(marks[j]^.line,line2_nr) then
                  if rept = pindef then
                    cmd_success := (line_nr >= line2_nr)
                  else
                    cmd_success := (line_nr <= line2_nr);
                end;
            end{case};
          end;

        cmd_equal_string:
          begin
          if tpar_get_1(tparam,command,request) then
            begin
            if request.len = 0 then     { If didn't specify, use default. }
              begin
              request := eqs_tpar;
              if request.len = 0 then
                begin screen_message(msg_no_default_str); goto 99; end;
              end
            else
              eqs_tpar := request;      { If did specify, save for next time. }
            cmd_success := eqsgetrep_eqs(rept,count,request,from_span);
            end;
          end;

        cmd_do_last_command,
        cmd_execute_string:
          begin
          if current_frame = frame_cmd then
            begin screen_message(msg_not_while_editing_cmd); goto 99; end;
          with frame_cmd^ do
            begin
            if command = cmd_execute_string then
              begin
              if not tpar_get_1(tparam,command,request) then goto 99;

              return_frame := current_frame;
              current_frame := frame_cmd;

              { Zap frame COMMAND's current contents.}
              first_line := first_group^.first_line;
              last_line  := last_group^.last_line^.blink;
              if last_line <> nil then
                begin
                if (not marks_squeeze(first_line,1,last_line^.flink,1))
                then goto 99;
                if (not lines_extract(first_line,last_line))
                then goto 99;
                if not lines_destroy(first_line,last_line) then goto 99;
                end;

              { Insert the new tpar into frame COMMAND. }
              if not text_insert_tpar(request,dot,marks[mark_equals]) then
                goto 99;

              current_frame := return_frame;
              end;

            { Recompile and execute frame COMMAND. }
            { First we look it up, mainly to reset the end-of-span marks. }
            { This is an expensive way of doing it, but this is not too freq. }
            { an operation. }
            if span_find(frame_cmd^.span^.name,new_span,old_span) then
            if not code_compile(span^,true) then
              goto 99;
            cmd_success := code_interpret(rept,count,span^.code,true);
            end;
          end;

        cmd_file_input,
        cmd_file_output,
        cmd_file_edit,
        cmd_file_read,
        cmd_file_write,
        cmd_file_rewind,
        cmd_file_kill,
        cmd_file_save,
        cmd_file_global_input,
        cmd_file_global_output,
        cmd_file_global_rewind,
        cmd_file_global_kill:
          cmd_success := file_command(command,rept,count,tparam,from_span);

        cmd_file_execute:
          begin
          if current_frame = frame_cmd then
            begin screen_message(msg_not_while_editing_cmd); goto 99; end;
          if tpar_get_1(tparam,command,request) then
            begin
            new(new_tparam);
            new_tparam^ := request;
            with frame_cmd^ do
              begin
              return_frame := current_frame;
              current_frame := frame_cmd;
              { Zap frame COMMAND's current contents.}
              first_line := first_group^.first_line;
              last_line  := last_group^.last_line^.blink;
              if last_line <> nil then
                begin
                if (not marks_squeeze(first_line,1,last_line^.flink,1))
                then goto 99;
                if (not lines_extract(first_line,last_line)) then goto 99;
                if not lines_destroy(first_line,last_line) then goto 99;
                end;
              if file_command(cmd_file_execute,none,0,new_tparam,false) then
                begin
                current_frame := return_frame;
                {
                ! Recompile and execute frame COMMAND
                ! First we look it up, mainly to reset the end-of-span marks.
                ! This is an expensive way of doing it, but this is not too
                ! frequent an operation.
                }
                if span_find(span^.name,new_span,old_span) then
                  if code_compile(span^,true) then
                    cmd_success := code_interpret(rept,count,span^.code,true);
                end
              else
                current_frame := return_frame;
              end;
            { Get rid of the tpar we have created. }
            dispose(new_tparam);
            end;
          end;

        cmd_file_table:
          begin
          file_table;
          cmd_success := true;
          end;

        cmd_frame_edit:
          if tpar_get_1(tparam,command,request) then
            begin
            with request do
{#if ISO1}
              ch_copy(str,1,len,new_name,1,name_len,' ');
{#else}
{##              ch_copy_str_name(str,1,len,new_name,1,name_len,' ');}
{#endif}
            cmd_success := frame_edit(new_name);
            end;

        cmd_frame_kill:
          if tpar_get_1(tparam,command,request) then
            begin
            with request do
{#if ISO1}
              ch_copy(str,1,len,new_name,1,name_len,' ');
{#else}
{##              ch_copy_str_name(str,1,len,new_name,1,name_len,' ');}
{#endif}
            cmd_success := frame_kill(new_name);
            end;

        cmd_frame_parameters :
          cmd_success := frame_parameter(tparam);

        cmd_frame_return:
          begin
          for i := 1 to count do
            with current_frame^ do
              begin
              if return_frame = nil then
                begin
                current_frame := old_frame;
                goto 99;
                end;
              current_frame := return_frame;
              end;
          cmd_success := true;
          end;

        cmd_get:
          if tpar_get_1(tparam,command,request) then
            begin
            if request.len = 0 then     { If didn't specify, use default. }
              begin
              request := get_tpar;
              if request.len = 0 then
                begin screen_message(msg_no_default_str); goto 99; end;
              end
            else
              get_tpar := request;      { If did specify, save for next time. }
            cmd_success := eqsgetrep_get(rept,count,request,from_span);
            end;

        cmd_help:
          begin
          if ludwig_mode = ludwig_batch then
            begin screen_message(msg_interactive_mode_only); goto 99; end;
          if tpar_get_1(tparam,command,request) then
            begin
            with request do
              help_help(len,str);
            cmd_success := true; { Never Fails. }
            end;
          end;

        cmd_insert_char:
          cmd_success := charcmd_insert(command,rept,count,from_span);

        cmd_insert_line:
          begin
          if count <> 0 then
            begin
            cmd_success := lines_create(abs(count),first_line,last_line);
            if cmd_success then
              cmd_success := lines_inject(first_line,last_line,line);
            if cmd_success then
              begin
              if count > 0 then
                begin
                cmd_success := mark_create(line,col,marks[mark_equals]);
                cmd_success := mark_create(first_line,col,dot);
                end
              else
                cmd_success := mark_create(first_line,col,marks[mark_equals]);
              text_modified := true;
              if not mark_create(line,col,marks[mark_modified]) then ;
              end;
            end
          else
            cmd_success := mark_create(line,col,marks[mark_equals]);
          end;

        cmd_insert_mode:
          begin
          edit_mode   := mode_insert;
          cmd_success := true;
          end;

        cmd_insert_text:
          begin
          if file_data.old_cmds and not from_span then
            if rept = none then
              begin
              edit_mode   := mode_insert;
              cmd_success := true;
              end
            else
              screen_message(msg_syntax_error)
          else if tpar_get_1(tparam,command,request) then
            begin
            with request do
              if con = nil then
                begin
                cmd_success := text_insert(true,count,str,len,dot);
                if cmd_success and (count*len <> 0) then
                  begin
                  text_modified := true;
                  cmd_success := mark_create(line,col,marks[mark_modified]);
                  end;
                end
              else
                begin
                for i := 1 to count do
                  if not text_insert_tpar(request,dot,marks[mark_equals]) then
                    goto 99;
                text_modified := true;
                cmd_success := mark_create(line,col,marks[mark_modified]);
                end;
            end;
          end;

        cmd_insert_invisible:
          begin
          if ludwig_mode <> ludwig_screen then goto 99;
          with line^ do
            begin
            if col > used then
              i := max_strlenp - col
            else
              i := max_strlen - used;
            end;
          if rept = pindef then count := i;
          if count > i then goto 99;
          new_str := blank_string;
          i := 0;
          while i<count do
            begin
            key := vdu_get_key;
            if tt_controlc then goto 99;
            if key in printable_set then
              begin
              i := i + 1;
              new_str[i] := chr(key);
              end
            else
            if key = 13 then
              if rept = pindef
              then count := i
              else i := count
            else vdu_beep;
            end;
          cmd_success := text_insert(true,1,new_str,count,dot);
          if cmd_success and (count <> 0) then
            begin
            text_modified := true;
            if not mark_create(line,col,marks[mark_modified]) then
              cmd_success := false;
            end;
          end;

        cmd_jump :
          begin
          case rept of
            none,plus,pint :
              if col+count>max_strlenp then goto 99;
            minus,nint     :
              if col<=-count then goto 99;
            pindef         :
              begin
              if col > line^.used+1 then goto 99;
              count := 1+line^.used-col;
              end;
            nindef         :
              count := 1-col;
            marker         :
              begin
              if not mark_create(the_mark^.line,
                                 the_mark^.col,
                                 dot)
              then goto 99;
              count := 0;
              end;
          end{case};
          col := col+count;
          cmd_success := true;
          end;

        cmd_line_centre:
          cmd_success := word_centre(rept,count,from_span);

        cmd_line_fill:
          cmd_success := word_fill(rept,count,from_span);

        cmd_line_justify:
          cmd_success := word_justify(rept,count,from_span);

        cmd_line_squash:
          cmd_success := word_squeeze(rept,count,from_span);

        cmd_line_left:
          cmd_success := word_left(rept,count,from_span);

        cmd_line_right:
          cmd_success := word_right(rept,count,from_span);

        cmd_word_advance:
          if file_data.old_cmds then
            cmd_success := word_advance_word(rept,count,from_span)
          else
            cmd_success := newword_advance_word(rept,count,from_span);

        cmd_word_delete:
          if file_data.old_cmds then
            cmd_success := word_delete_word(rept,count,from_span)
          else
            cmd_success := newword_delete_word(rept,count,from_span);

        cmd_advance_paragraph:
          cmd_success := newword_advance_paragraph(rept,count,from_span);

        cmd_delete_paragraph:
          cmd_success := newword_delete_paragraph(rept,count,from_span);

        cmd_mark:
          begin
          if count < 0 then
            begin
            if marks[-count] <> nil then
              cmd_success := mark_destroy(marks[-count])
            else
              cmd_success := true;
            end
          else
            cmd_success := mark_create(line,col,marks[count]);
          end;

        cmd_noop:
          ;

        cmd_command:
          begin
          if rept = minus then
            begin
            if edit_mode <> mode_command then
              begin
              previous_mode := edit_mode;
              edit_mode := mode_command;
              end
            else goto 99;
            end
          else
            begin
            if edit_mode = mode_command then
              edit_mode := previous_mode
            else goto 99;
            end;
          cmd_success := true;
          end;

        cmd_overtype_mode:
          begin
          edit_mode   := mode_overtype;
          cmd_success := true;
          end;

        cmd_overtype_text:
          begin
          if file_data.old_cmds and not from_span then
            if rept = none then
              begin
              edit_mode   := mode_overtype;
              cmd_success := true;
              end
            else
              screen_message(msg_syntax_error)
          else if tpar_get_1(tparam,command,request) then
            begin
            with request do
              cmd_success := text_overtype(true,count,str,len,dot);
            if cmd_success and (count*request.len <> 0) then
              begin
              text_modified := true;
              if not mark_create(line,col,marks[mark_modified]) then
                cmd_success := false;
              end;
            end;
          end;

        cmd_page:
          begin
          if not from_span then
            begin
            screen_message(msg_paging);
            if ludwig_mode = ludwig_screen then
              vdu_flush(false);
            end;
          cmd_success := file_page(current_frame,exit_abort);
          { Clean up the PAGING message. }
          if not from_span then
            screen_clear_msgs(false);
          end;

        cmd_op_sys_command :
          if tpar_get_1(tparam,command,request) then
            begin
            if not opsys_command(request,first_line,last_line,i) then
              goto 99;
            if first_line <> nil then
              begin
              if not lines_inject(first_line,last_line,dot^.line) then
                goto 99;
              if not mark_create (first_line,1,marks[mark_equals]) then
                goto 99;
              text_modified := true;
              if not mark_create(last_line^.flink,1,marks[mark_modified]) then
                goto 99;
              if not mark_create (last_line^.flink,1,dot) then
                goto 99;
              cmd_success := true;
              end;
            end;

        cmd_position_column :
          begin
          if count > max_strlen then goto 99;
          col := count;
          cmd_success := true;
          end;

        cmd_position_line:
          begin
          if not line_from_number(current_frame,count,new_line) then goto 99;
          if new_line = nil then goto 99;
          cmd_success := true;
          if not mark_create(line,col,marks[mark_equals]) then goto 99;
          if mark_create(new_line,1,dot) then ;
          end;

        cmd_quit:
          cmd_success := quit_command;

        cmd_replace:
          begin
          if tpar_get_2(tparam,command,request,request2) then
            begin
            if request.len = 0 then     { If didn't specify, use default. }
              begin
              if rep1_tpar.len = 0 then
                begin screen_message(msg_no_default_str); goto 99; end;
              end
            else
              begin
              rep1_tpar := request;     { If did specify, save for next time. }
              tpar_clean_object(rep2_tpar);
              rep2_tpar := request2;
              request2.con := nil;
              end;
            cmd_success := eqsgetrep_rep(rept,count,rep1_tpar,rep2_tpar,from_span);
            end;
          end;

        cmd_rubout:
          cmd_success := charcmd_rubout(command,rept,count,from_span);

        cmd_set_margin_left:
          begin
          if rept = minus then
            margin_left := initial_margin_left
          else
            begin
            if col >= margin_right then
              begin screen_message(msg_left_margin_ge_right); goto 99; end;
            margin_left := col;
            end;
          cmd_success := true;
          end;

        cmd_set_margin_right:
          begin
          if rept = minus then
            margin_right := initial_margin_right
          else
            begin
            if col <= margin_left then
              begin screen_message(msg_left_margin_ge_right); goto 99; end;
            margin_right := col;
            end;
          cmd_success := true;
          end;

        cmd_span_jump,
        cmd_span_compile,
        cmd_span_copy,
        cmd_span_define,
        cmd_span_execute,
        cmd_span_execute_no_recompile,
        cmd_span_transfer:
          begin
          if tpar_get_1(tparam,command,request) then
            begin
            with request do
{#if ISO1}
              ch_copy(str,1,len,new_name,1,name_len,' ');
{#else}
{##              ch_copy_str_name(str,1,len,new_name,1,name_len,' ');}
{#endif}
            case command of

              cmd_span_define:
                if rept = minus then
                  if span_find(new_name,new_span,old_span) then
                    cmd_success := span_destroy(new_span)
                  else
                    screen_message(msg_no_such_span)
                else
                  cmd_success := span_create(new_name,the_mark,dot);

              cmd_span_jump:
                begin
                if span_find(new_name,new_span,old_span) then
                  begin
                  with new_span^ do
                    begin
                    if rept = minus then
                      with mark_one^ do
                        begin
                        new_col := col; new_line := line;
                        end
                    else
                      with mark_two^ do
                        begin
                        new_col := col; new_line := line;
                        end;
                    end;
                  if new_line^.group^.frame = current_frame then
                    begin
                    cmd_success := mark_create(line,col,marks[mark_equals]);
                    if cmd_success then
                      cmd_success := mark_create(new_line,new_col,dot);
                    end
                  else
                    with new_line^.group^.frame^ do
                      begin
                      if frame_edit(span^.name) then
                        begin
                        if marks[mark_equals] <> nil then
                          if mark_destroy(marks[mark_equals]) then ;
                        cmd_success := mark_create(new_line,new_col,dot);
                        end;
                      end;
                  end
                else screen_message(msg_no_such_span);
                end;

              cmd_span_copy,
              cmd_span_transfer:
                begin
                if span_find(new_name,new_span,old_span) then
                with new_span^ do
                  begin
                  cmd_success := text_move(command=cmd_span_copy,
                                           count,
                                           mark_one,
                                           mark_two,
                                           dot,                { Dest.     }
                                           marks[mark_equals], { New_Start. }
                                           dot);               { New_End.   }
                  if  (command = cmd_span_transfer)
                  and (new_span^.frame = nil) and cmd_success
                  then
                    begin
                    if  mark_create(marks[mark_equals]^.line,marks[mark_equals]^.col,mark_one)
                    and mark_create(dot     ^.line,dot     ^.col,mark_two)
                    then ;
                    end;
                  end
                else screen_message(msg_no_such_span);
                end;

              cmd_span_compile,
              cmd_span_execute,
              cmd_span_execute_no_recompile:
                begin
                if span_find(new_name,new_span,old_span) then
                  begin
                  if (new_span^.code = nil) or
                     (command <> cmd_span_execute_no_recompile) then
                    if not code_compile(new_span^,true) then
                      goto 99;
                  if command = cmd_span_compile then
                    cmd_success:=true
                  else
                    cmd_success:=code_interpret(rept,count,new_span^.code,true);
                  end
                else screen_message(msg_no_such_span);
                end;

            end{case};
            end;
          end;

        cmd_span_index:
          cmd_success := span_index;

        cmd_span_assign:
          begin
          if not tpar_get_2(tparam,command,request,request2) then goto 99;
          if request.len = 0 then goto 99;
          with request do
{#if ISO1}
            ch_copy(str,1,len,new_name,1,name_len,' ');
{#else}
{##            ch_copy_str_name(str,1,len,new_name,1,name_len,' ');}
{#endif}
          if span_find(new_name,new_span,old_span) then
            begin {Grunge the old one}
            if new_span = frame_oops^.span then
              begin
              with frame_oops^.span^ do
                if not text_remove(mark_one,mark_two) then goto 99;
              end
            else
              with frame_oops^ do { Make sure oops_span is okay. }
                begin
                if not mark_create(last_group^.last_line,1,span^.mark_two) then
                  goto 99;
                if not text_move(false,              { Don't copy,transfer}
                                 1,                  { One instance of }
                                 new_span^.mark_one,
                                 new_span^.mark_two,
                                 span^.mark_two,     { destination.    }
                                 marks[mark_equals], { leave at start. }
                                 dot)                { leave at end.   }
                then goto 99;
                end;
            end
          else
            begin {Create a span in frame "HEAP"}
            with frame_heap^ do
              begin
              if not mark_create(last_group^.last_line,1,span^.mark_two)
              then goto 99;
              if not span_create(new_name,span^.mark_two,span^.mark_two)
              then goto 99;
              end;
            if not span_find(new_name,new_span,old_span) then goto 99;
            end;
          {Phew. That's done. Now NEW_SPAN is an empty span}
          with request2 do
            begin
{ We have not decided what 3sa should do yet.
!           if rept in [none, pindef] then
!             count := len
!           else
!             if rept in [plus, pint] then
!               begin
!               if count > max_strlen then
!                 goto 99;
!               if count > len then
!                 begin <Fiddle>
!                 ch_fill(str,len+1,count-len,' ');
!                 len := count;
!                 end
!               else
!                 len := count;
!               end
!             else
!               begin <Take the last "Count" Chars.>
!               if -count > max_strlen then
!                 goto 99;
!               if -count > len then
!                 begin <Must put some spaces in>
!                 ch_copy(str,1,len,str,1-count-len,len,' ');
!                 ch_fill(str,1,-count-len,' ');
!                 len := -count;
!                 end
!               else
!                 begin <Just move the string>
!                 ch_copy(str,len+count+1,-count,str,1,-count,' ');
!                 len := -count;
!                 end;
!               end;
}           {Now copy the tpar into the span.}
            if not text_insert_tpar(request2,
                           new_span^.mark_two,new_span^.mark_one) then
              goto 99;
            with new_span^.mark_two^, line^.group^.frame^ do
              begin
              text_modified := true;
              cmd_success := mark_create(line,col,marks[mark_modified]);
              end;
            end;
          end;

        cmd_split_line:
          begin
          if line^.flink = nil then
            if not text_realize_null(line) then goto 99;
          cmd_success := text_split_line(dot,0,marks[mark_equals]);
          end;

        cmd_swap_line:
          cmd_success := swap_line(rept,count);

        cmd_user_command_introducer:
          begin
          if ludwig_mode <> ludwig_screen then
            begin screen_message(msg_screen_mode_only); goto 99; end;
          cmd_success := user_command_introducer;
          end;

        cmd_user_key:
          begin
          if ludwig_mode <> ludwig_screen then
            begin screen_message(msg_screen_mode_only); goto 99; end;
          if tpar_get_2(tparam,command,request,request2) then
            begin
            if request.len = 0 then
              cmd_success := false
            else
              cmd_success := user_key(request,request2);
            end;
          end;

        cmd_user_parent:
          begin
          if ludwig_mode = ludwig_batch then
            begin screen_message(msg_interactive_mode_only); goto 99; end;
          cmd_success := user_parent;
          end;

        cmd_user_subprocess:
          begin
          if ludwig_mode = ludwig_batch then
            begin screen_message(msg_interactive_mode_only); goto 99; end;
          cmd_success := user_subprocess;
          end;

        cmd_user_undo:
          cmd_success := user_undo;

        cmd_window_backward,
        cmd_window_end,
        cmd_window_forward,
        cmd_window_left,
        cmd_window_middle,
        cmd_window_new,
        cmd_window_right,
        cmd_window_scroll,
        cmd_window_setheight,
        cmd_window_top,
        cmd_window_update:
          cmd_success := window_command(command,rept,count,tparam,from_span);

{#if WINDOWCHANGE or XWINDOWS}
        cmd_resize_window:
          begin
            screen_resize;
            cmd_success := true;
          end;
{#endif}

{#if XWINDOWS}
{##        cmd_handle_mouse_event:}
{##          cmd_success := handle_X_mouse_event;}
{##        cmd_cut_X_span:}
{##          cmd_success := cut_X_span;}
{##        cmd_paste_X_span:}
{##          cmd_success := paste_X_span;}
{#endif}

{#if NCURSESMOUSE}
    cmd_ncurses_mouse_event:
    begin
      cmd_success := handle_ncurses_mouse_event;
    end;
{#endif}

{#if debug}
        cmd_validate:
          cmd_success := validate_command;
{#endif}

        cmd_block_define,
        cmd_block_transfer,
        cmd_block_copy:
          screen_message(msg_not_implemented);

      end{case}
    else
      screen_message(dbg_internal_logic_error);
    end; {with current_frame^,dot^}

  if cmd_success then
    begin
    with old_frame^,old_dot do
      case cmd_attrib[command].eq_action of
        eqold : eq_set := mark_create(line,col,marks[mark_equals]);
        eqdel : if marks[mark_equals] = nil then
                  eq_set := true
                else
                  eq_set := mark_destroy(marks[mark_equals]);
        eqnil : eq_set := true;
      end{case};
    if not eq_set then screen_message(msg_equals_not_set);
    end;
  99:
  tpar_clean_object(request);
  tpar_clean_object(request2);
  execute := cmd_success;
  exec_level := exec_level - 1;
  end; {execute}

{#if vms or turbop}
end.
{#endif}
