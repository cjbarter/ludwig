
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
{       Kelvin B. Nicolle (1988-90);                                   }
{       John Warburton (1989);                                         }
{       Jeff Blows (1989-90); and                                      }
{       Martin Sandiford (2002).                                       }
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
! Name:         QUIT
!
! Description:  Quit Ludwig
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/quit.pas,v 4.9 2002/07/15 14:09:28 martin Exp $
! $Author: martin $
! $Locker:  $
! $Log: quit.pas,v $
! Revision 4.9  2002/07/15 14:09:28  martin
! Replaced halt() for msdos with turbop
!
! Revision 4.8  1990/09/21 12:41:01  ludwig
! Change name of IBM-PC module system to msdos (system is reserved name).
!
! Revision 4.7  90/04/26  17:21:34  ludwig
! Fix VMS version of call to screen_verify. Strings are no longer
! padded automatically.
!
Revision 4.6  90/01/18  18:33:25  ludwig
Entered into RCS at revision level 4.6

!
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                    26-Aug-1988
!       The EXEC module is too big for the Multimax pc compiler.  Move
!       the code for the quit command to the QUIT module.
! 4-003 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-004 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
! 4-005 Kelvin B. Nicolle                                    13-Sep-1989
!       Add includes etc. for Tower version.
! 4-006 Kelvin B. Nicolle                                    25-Oct-1989
!       Correct the includes for the Tower version.
!       Change files.h to fyle.h.
!--}

{#if vms}
{##[ident('4-006'),}
{## overlaid]}
{##module quit (output);}
{#elseif turbop}
unit quit;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'quit.fwd'}
{##%include 'fyle.h'}
{##%include 'mark.h'}
{##%include 'screen.h'}
{##%include 'system.h'}
{##%include 'vdu.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "quit.h"}
{####include "fyle.h"}
{####include "mark.h"}
{####include "screen.h"}
{####include "system.h"}
{####include "vdu.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=quit.h#>}
{###<$F=fyle.h#>}
{###<$F=mark.h#>}
{###<$F=screen.h#>}
{###<$F=system.h#>}
{###<$F=vdu.h#>}
{#elseif turbop}
interface
  uses value;
  {$I quit.i}

implementation
  uses fyle, mark, screen, msdos, vdu;
{#endif}


function quit_command :boolean;

  label 2, 99;
  var
    new_span : span_ptr;
{#if turbop}
    tmp_buffer : str_object;
    tmp_str : string;
{#endif}

  begin {quit_command}
  quit_command := false;
  with current_frame^ do
    begin
    if ludwig_mode <> ludwig_batch then
      begin
      new_span := first_span;
      while new_span <> nil do
        begin
        if new_span^.frame <> nil then
          with new_span^.frame^ do
            if text_modified and (output_file=0) and (input_file<>0) then
              begin
              current_frame := new_span^.frame;
              with marks[mark_modified]^ do
                if not mark_create(line,col,dot) then ;
              if ludwig_mode = ludwig_screen then screen_fixup;
              screen_beep;
{#if turbop}
              fillchar(tmp_buffer[1], sizeof(tmp_buffer), ' ');
              tmp_str := 'This frame has no output file--are you sure you want to QUIT? ';
              move(tmp_str[1], tmp_buffer[1], length(tmp_str));
              case screen_verify(tmp_buffer, 62) of
{#elseif vms}
{##              case screen_verify(pad(}
{##          'This frame has no output file--are you sure you want to QUIT? '}
{##                                 , ' ', max_strlen), 62) of}
{#else}
{##              case screen_verify(}
{##          'This frame has no output file--are you sure you want to QUIT? '}
{##                                 ,62) of}
{#endif}
                verify_reply_yes :
                  ;
                verify_reply_always :
                  goto 2;
                verify_reply_no,
                verify_reply_quit :
                  begin
                  exit_abort := true;
                  goto 99;
                  end;
              end{case};
              end;
        new_span := new_span^.flink;
        end;
      end;
2:  screen_unload;
    if ludwig_mode <> ludwig_batch then screen_message(msg_quitting);
    if ludwig_mode = ludwig_screen then vdu_flush(false);
    ludwig_aborted := false;
    quit_close_files;
{#if vms}
{##    sys$exit(normal_exit);}
{#elseif unix}
{##    exit_handler(0);}
{##    exit(normal_exit);}
{#elseif turbop}
    exit_handler(0);
    halt(normal_exit);
{#endif}
    end;
99:
  end; {quit_command}


procedure quit_close_files{};

  label 99;
  var
    next_span  : span_ptr;
    next_frame : frame_ptr;
    file_index : file_range;

  function do_frame (f:frame_ptr) : boolean;

    label 99;

    begin {do_frame}
    with f^ do
      begin
      do_frame := true;
      if output_file = 0 then goto 99;
      if files[output_file] = nil then goto 99;
      do_frame := false;
      {Wind out and close the associated input file.}
      if not file_windthru(f,true) then
        goto 99;
      if input_file <> 0 then
        if files[input_file] <> nil then
          begin
          if not file_close_delete(files[input_file],false,true) then goto 99;
          input_file := 0;
          end;
      {Close the output file.}
      if not ludwig_aborted then
        do_frame := file_close_delete(files[output_file],not text_modified,text_modified)
      else
        do_frame := true;
      output_file := 0;
      end;
   99:
    end {do_frame};

  begin {quit_close_files}

  { THIS ROUTINE DOES BOTH THE NORMAL "Q" COMMAND, AND ALSO IS CALLED AS PART}
  { OF THE LUDWIG "PROG_WINDUP" SEQUENCE.  THUS BY TYPING "^Y EXIT" USERS MAY}
  { SAFELY ABORT LUDWIG AND NOT LOSE ANY FILES.                              }
  next_span := first_span;
  while next_span <> nil do
    begin
    next_frame := next_span^.frame;
    if next_frame <> nil then
      if not do_frame(next_frame) then goto 99;
    next_span := next_span^.flink;
    end;
  { Close all remaining files. }
  if not ludwig_aborted then
  for file_index := 1 to max_files do
    begin
    if files[file_index] <> nil then
      if not file_close_delete(files[file_index],false,true) then goto 99;
    end;
 99:
  { Now free up the VDU, thus re-setting anything we have changed }
  if not vdu_free_flag then   { Has it been called already? }
    begin
    vdu_free;
    vdu_free_flag := true;    { Well it has now }
    ludwig_mode := ludwig_batch;
    end;
  if ludwig_aborted then
    begin
    screen_message(msg_not_renamed);
    screen_message(msg_abort);
    end;
  end; {quit_close_files}

{#if vms or turbop}
end.
{#endif}
