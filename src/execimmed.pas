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
{       Kevin J. Maciunas (1980-84 )                                   }
{       Jeff Blows (1989);                                             }
{       Kelvin B. Nicolle (1989); and                                  }
{       Martin Sandiford (2002).                                       }
{                                                                      }
{  Copyright  1979-81, 1987, 1989, 2002 University of Adelaide         }
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
! Name:         EXECIMMED
!
! Description:  Outermost level of command execution for LUDWIG.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/execimmed.pas,v 4.6 2002/07/21 01:55:14 martin Exp $
! $Author: martin $
! $Locker:  $
! $Log: execimmed.pas,v $
! Revision 4.6  2002/07/21 01:55:14  martin
! Fixed minor range bug in debug code.  Removed CRT from the list
! of implementation units in the if turbop code.
!
! Revision 4.5  1990/01/18 18:14:29  ludwig
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
!       Change files.h to fyle.h.
!       Remove the superfluous include of system.h.
!--}

{#if vms}
{##[ident('4-005'),}
{## overlaid]}
{##module execimmed (output);}
{#elseif turbop}
unit execimmed;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'execimmed.fwd'}
{##%include 'bug.h'}
{##%include 'code.h'}
{##%include 'exec.h'}
{##%include 'fyle.h'}
{##%include 'line.h'}
{##%include 'mark.h'}
{##%include 'quit.h'}
{##%include 'screen.h'}
{##%include 'text.h'}
{##%include 'vdu.h'}
{##%include 'vdu_vms.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "execimmed.h"}
{####include "code.h"}
{####include "exec.h"}
{####include "fyle.h"}
{####include "line.h"}
{####include "mark.h"}
{####include "quit.h"}
{####include "screen.h"}
{####include "text.h"}
{####include "vdu.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=execimmed.h#>}
{###<$F=code.h#>}
{###<$F=exec.h#>}
{###<$F=fyle.h#>}
{###<$F=line.h#>}
{###<$F=mark.h#>}
{###<$F=quit.h#>}
{###<$F=screen.h#>}
{###<$F=text.h#>}
{###<$F=vdu.h#>}
{#elseif turbop}
interface
  uses value;
  {$I execimmed.i}

implementation
  uses code, exec, fyle, quit, line, mark, screen, text, vdu;
{#endif}


procedure execute_immed{};

  label
    1,2,9,99;
  var
    i            : integer;
    key          : key_code_range;
    input_buf    : str_object;
    col_1,col_2,
    input_len    : strlen_range;
    scr_col      : scr_col_range;
    jammed       : boolean;
    cmd_success  : boolean;
    { Variables supporting Batch/Hardcopy mode. NOTE THE FUDGE OF THE }
    { CMD_SPAN that is not inside a frame! }
    cmd_span     : span_ptr;
    cmd_fnm      : file_name_str;
    cmd_file     : file_ptr;
    dummy_fptr   : file_ptr;
    cmd_count    : integer;

  begin {execute_immed}
  new(cmd_span);
  with cmd_span^ do
    begin
    flink    := nil;
    blink    := nil;
    name     := 'L. Wittgenstein und Sohn.      ';  {Editors Extraordinaire}
    frame    := nil;
    mark_one := nil;
    mark_two := nil;
    code     := nil;
    end;

  { Vector off to the appropriate main execution mode.  Each mode behaves    }
  { slightly differently at this level. }
  case ludwig_mode of

    ludwig_screen:
      begin
      jammed := false;
      while true do
2:      begin
        cmd_success := true;

        { MAKE SURE THE USER CAN SEE THE CURRENT DOT POSITION. }
        screen_fixup;

        if edit_mode = mode_command then
          key := command_introducer
        else
          begin

          { OVERTYPE/INSERTMODE IS DONE HERE AS A SPECIAL CASE. }
          { THIS IS NECESSARY BECAUSE THE SCREEN IS UPDATED BY  }
          { VDU_GET_TEXT.                                       }
          with current_frame^,dot^ do
            begin
            while true do
              begin

              { Check for boundaries where text cannot be accepted. }
              if jammed or (col = max_strlenp) then
                begin
                key := vdu_get_key;
                if tt_controlc then goto 9;
                if     (key in printable_set)
                   and (key<>command_introducer) then
                  begin
                  cmd_success := false;
                  goto 9;
                  end;
                vdu_take_back_key(key);
                goto 1;
                end;

              {DECIDE MAX CHARS THAT CAN BE READ.}
              scr_col := col-scr_offset;
              input_len := max_strlenp-col;
              if col <= margin_right then
                input_len := margin_right - col + 1;
              if input_len > scr_width+1-scr_col then
                input_len := scr_width+1-scr_col;

              {WATCH OUT FOR NULL LINE.}
              if line^.flink = nil then
                begin
                key := vdu_get_key;
                if tt_controlc then goto 9;
                vdu_take_back_key(key);
                if     (key in printable_set)
                   and (key <> command_introducer) then
                  begin
                  {If printing char, realize NULL, re-fix cursor.}
                  if not text_realize_null(line) then
                    begin cmd_success := false; goto 9; end;

                  { MAKE SURE THE USER CAN SEE THE CURRENT DOT POSITION. }
                  screen_fixup;
                  end;
                end;

              {GET THE ECHOING TEXT}
              if edit_mode = mode_insert then vdu_insert_mode(true);
              vdu_get_text(input_len,input_buf,input_len);
              if edit_mode = mode_insert then
                begin
                vdu_insert_mode(false);
                vdu_flush(false); {Make sure in mode IS off!}
                end;
              if tt_controlc   then goto 9;
              if input_len = 0 then goto 1; {Simulate a continue}

              if edit_mode = mode_overtype then
                cmd_success := text_overtype(false,1,input_buf,input_len,dot)
              else
                cmd_success := text_insert(false,1,input_buf,input_len,dot);
              if cmd_success then
                begin
                text_modified := true;
                if not mark_create(line,col,marks[mark_modified]) then
                  cmd_success := false;
                if not mark_create(line,col-input_len,marks[mark_equals]) then
                  cmd_success := false;
                end
              else
                { IF, FOR SOME REASON, THAT FAILED,  CORRECT THE VDU IMAGE OF  }
                { THE LINE.  THIS IS BECAUSE VDU_GET_TEXT HAS CORRUPTED IT.    }
                begin
                screen_draw_line(line);
                goto 9;
                end;
              if col <> margin_right+1 then
                begin
                { FOLLOW THE DOT. }
                screen_position(line,col);
                vdu_movecurs(col-scr_offset,line^.scr_row_nr);
                end
              else
                begin
                { AT THE RIGHT MARGIN. }
                if opt_auto_wrap in options then
                  begin
                  { Take care of Wrap Option. }
                  key := vdu_get_key;
                  if tt_controlc then goto 9;
                  if     (key in printable_set)
                     and (key <> command_introducer) then
                    with dot^ do
                      begin
                      col_1 := margin_right;
                      if key <> ord(' ') then
                        begin
                        while (line^.str^[col_1] <> ' ') and
                              (col_1 > margin_left) do
                          col_1 := col_1 - 1;
                        col_2 := col_1;
                        while (line^.str^[col_2] = ' ') and
                              (col_2 > margin_left) do
                          col_2 := col_2 - 1;
                        if col_2 = margin_left then  {Line has only one word}
                          col_1 := margin_right; {Split at right margin}
                        vdu_take_back_key(key);
                        end;
                      col := col_1 + 1;
                      cmd_success := text_split_line(dot,0,marks[mark_equals]);
                      dot^.col := dot^.col + margin_right - col_1;
                      goto 2; {Simulate break of inner loop}
                      end;
                  vdu_take_back_key(key);
                  end
                else
                  begin
                  vdu_beep;
                  col := col-1;
                  vdu_movecurs(col-scr_offset,line^.scr_row_nr);
                  jammed := true;
                  end;
                end;
              end; {of overtyping loop}
            end;

       1: key := vdu_get_key; { key is a terminator }
          if tt_controlc then goto 9;

{#if debug}
          if key >= 0 then
            if     (key in printable_set)
               and (key <> command_introducer) then
              begin screen_message(dbg_not_immed_cmd); goto 99; end;
{#endif}
          end;

        if key = command_introducer then
          begin
          if code_compile(cmd_span^,false) then
            cmd_success := code_interpret(none,1,cmd_span^.code,false)
          else
            cmd_success := false;
          end
        else
          with lookup[key] do
            if command = cmd_extended then
              cmd_success := code_interpret(none,1,code,true)
            else
              cmd_success := execute(command,none,1,tpar,false);

    9:  if tt_controlc then
          begin
          tt_controlc := false;
          if current_frame^.dot^.line^.scr_row_nr <> 0
          then screen_redraw
          else screen_unload;
          end
        else
        if not cmd_success then
          begin
          vdu_beep;           { Complain. }
          vdu_flush(false);   { Make sure he hears the complaint. }
          end
        else
          jammed := false;
        exit_abort := false;
        end;
      end;

    ludwig_hardcopy, ludwig_batch:
      begin
      with cmd_span^ do
        begin
        new(mark_one); mark_one^.line := nil; mark_one^.col := 1;
        new(mark_two); mark_two^.line := nil;
        end;
      if ludwig_mode = ludwig_hardcopy then
        cmd_count := 1
      else
        cmd_count := maxint;

      { Open standard input as Ludwig command input file. }
{#if turbop}
      fillchar(cmd_fnm[1], sizeof(cmd_fnm), ' ');
{#else}
{##      cmd_fnm := '  ';}
{#endif}
      cmd_file := nil;
      dummy_fptr := nil;
      if file_create_open(cmd_fnm,parse_stdin,cmd_file,dummy_fptr) then
        begin
        repeat
          with cmd_span^ do
            begin

            { Destroy all of cmd_span's contents. }
            if mark_one^.line <> nil then
              begin
              if not lines_destroy(mark_one^.line,mark_two^.line) then
                goto 99;
              mark_one^.line := nil;
              mark_two^.line := nil;
              end;

            { If necessary, prompt. }
            if ludwig_mode = ludwig_hardcopy then
              begin
              with current_frame^.dot^ do screen_load(line,col);
              writeln('COMMAND: ');
              end;

            { Read, compile, and execute the next lot of commands. }
            if file_read(cmd_file,
                         cmd_count,
                         true,
                         mark_one^.line,
                         mark_two^.line,
                         i)
            then
              if mark_one^.line <> nil then
                begin
                mark_two^.col := mark_two^.line^.used+1;
                if code_compile(cmd_span^,true) then
                  if not code_interpret(none,1,cmd_span^.code,true) then
                    writeln(chr(7),'COMMAND FAILED');
                exit_abort := false;
                tt_controlc := false;
                end;
            end;
        until cmd_file^.eof;
        ludwig_aborted := false;
        quit_close_files;
        cmd_success := true;
        end;
      end;
  end{case};
  99:
  end; {execute_immed}

{#if vms or turbop}
end.
{#endif}
