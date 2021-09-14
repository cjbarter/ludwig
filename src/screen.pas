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
{       Jeff Blows (1988-90,2020)                                      }
{       Steve Nairn (1990);                                            }
{       Martin Sandiford (1991, 2002, 2008, 2018)                      }
{                                                                      }
{  Copyright  1987-1990, 2002 University of Adelaide                   }
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
! Name:         SCREEN
!
! Description:  Map a range of lines onto the screen, or unmap the
!               screen.
!               Maintain that mapping.
!               Also SCREEN supports the HARDCOPY/BATCH mode of editing,
!               by providing methods of outputting lines and error
!               messages under these circumstances as well.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/screen.pas,v 4.13 2002/07/21 02:56:27 martin Exp $
! $Author: martin $
! $Locker:  $
! $Log: screen.pas,v $
! Revision 4.13  2002/07/21 02:56:27  martin
! Make screen_unix_message conditional on fpc as well as unix.
! Changed turbop conditional for screen_msdos_message to msdos.
! Removed CRT unit from uses statement.  MPS
!
! Revision 4.12  1990/10/12 11:00:10  ludwig
! Turbo Pascal write will not accept a packed array of char > 255 in length.
! Modified screen_str_message.   KBN
!
! Revision 4.11  90/09/21  12:41:50  ludwig
! Change name of IBM-PC module system to msdos (system is reserved name).
!
! Revision 4.10  90/02/28  16:44:38  ludwig
! Stop copying NUL characters at end of Unix messages.
!
! Revision 4.9  90/02/08  17:04:27  ludwig
! fixed one-off error in assignment to margin_left.
!
! Revision 4.8  90/02/08  10:03:24  ludwig
! Steven Nairn.
! new procedure screen_resize. called from exec when the command is cmd_resize
! also called if tt_winchanged is true, wich can be so if the pseudo key-stroke
! of the windiow resize event is nat handled properly.
!
! Revision 4.7  90/01/22  18:57:14  ludwig
! modified screen_fixup to handle redrawing the screen if the window has
! changed size.
!
! Revision 4.6  90/01/18  17:36:07  ludwig
! Entered into RCS at revision level 4.6
!
!
!---
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                    11-Nov-1988
!       In screen_message, test the hangup flag and don't write any
!       messages when it is set.  Both Umax and Mach have a bug where
!       output to a process that has lost its terminal causes a process
!       hang in a CPU loop!
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
{##module screen (output);}
{#elseif turbop}
unit screen;
{#endif}

{Global Data.}
{ SCR_FRAME             -- Frame indicating which frame currently mapped.      }
{ SCR_TOP_LINE          -- A line_pointer indicating the first line of screen. }
{ SCR_BOT_LINE          -- A line_pointer indicating the last  line of screen. }
{ SCR_MSG_ROW           -- Lowest row on screen with msg on it.                }
{                                                                              }
{ LINE.SCR_ROW_NR       -- The row number of a line.  0 means 'not             }
{                          on screen'.                                         }
{                                                                              }
{ FRAME.SCR_OFFSET      -- To find the column number on the screen             }
{                          from the column number of a character in            }
{                          a line of a frame, subtract this value.             }

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##  slide_type  = (slide_dont,slide_left,slide_right,slide_redraw);}
{##  scroll_type = (scroll_dont,scroll_forward,scroll_back,scroll_redraw);}
{##%include 'var.i'}
{##}
{##%include 'screen.fwd'}
{##%include 'bug.h'}
{##%include 'ch.h'}
{##%include 'line.h'}
{##%include 'mark.h'}
{##%include 'system.h'}
{##%include 'vdu.h'}
{##%include 'vdu_vms.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{##  slide_type  = (slide_dont,slide_left,slide_right,slide_redraw);}
{##  scroll_type = (scroll_dont,scroll_forward,scroll_back,scroll_redraw);}
{####include "var.i"}
{##}
{####include "screen.h"}
{####include "ch.h"}
{####include "line.h"}
{####include "system.h"}
{####include "vdu.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{##  slide_type  = (slide_dont,slide_left,slide_right,slide_redraw);}
{##  scroll_type = (scroll_dont,scroll_forward,scroll_back,scroll_redraw);}
{###<$F=var.i#>}
{##}
{###<$F=screen.h#>}
{###<$F=ch.h#>}
{###<$F=line.h#>}
{###<$F=system.h#>}
{###<$F=vdu.h#>}
{#elseif turbop}
interface
  uses value;
  {$I screen.i}

implementation
  uses ch, line, msdos, vdu;

type
  slide_type  = (slide_dont,slide_left,slide_right,slide_redraw);
  scroll_type = (scroll_dont,scroll_forward,scroll_back,scroll_redraw);
{#endif}


procedure screen_message (
                message : msg_str);

  { Purpose  : Put a message out to the user.
    Inputs   : message: blank-filled message.
  }
  label 99;
  var
    length : integer;
    i,j : integer;

  begin {screen_message}
  if hangup then goto 99;
  length := msg_str_len;
  while message[length] = ' ' do
    length := length - 1;
  if ludwig_mode = ludwig_screen then
    begin
    i := 1;
    repeat
      screen_free_bottom_line;                      {Make room for msg.    }
      vdu_movecurs(1,terminal_info.height);
      j := length-i+1;
      if j>terminal_info.width-1 then j := terminal_info.width-1;
      vdu_displaystr(j,message[i],3);               {due to wrap avoidance.}
      i := i+j;
    until i>length;
    end
  else
    begin
{   if ludwig_mode = ludwig_hardcopy then       }
{     write(chr(7));                            }
    writeln(message:length);
    end;
99:
  end; {screen_message}


procedure screen_str_message (
                message : str_object);

  { Purpose  : Put a message out to the user.
    Inputs   : message: blank-filled message in a Ludwig string object.
  }
  label 99;
  var
    length : integer;
    i,j : integer;

  begin {screen_str_message}
  if hangup then goto 99;
  length := max_strlen;
  while message[length] = ' ' do
    length := length - 1;
  if ludwig_mode = ludwig_screen then
    begin
    i := 1;
    repeat
      screen_free_bottom_line;                      {Make room for msg.    }
      vdu_movecurs(1,terminal_info.height);
      j := length-i+1;
      if j>terminal_info.width-1 then j := terminal_info.width-1;
      vdu_displaystr(j,message[i],3);               {due to wrap avoidance.}
      i := i+j;
    until i>length;
    end
  else
    begin
{   if ludwig_mode = ludwig_hardcopy then       }
{     write(chr(7));                            }
{#if turbop}
    for i := 1 to length do
      write(message[i]);
    writeln;
{#else}
{##    writeln(message:length);}
{#endif}
    end;
99:
  end; {screen_str_message}


{#if vms}
{##function screen_vms_message #<(}
{##                message : [class_s] packed array [l1..h1:integer] of char)}
{##        : boolean#>;}
{##}
{##  #< Purpose  : Put a message out to the user.}
{##    Inputs   : message: message passed by descriptor.}
{##  #>}
{##  var}
{##    msg : str_object;}
{##    start, length : integer;}
{##}
{##  begin #<screen_vms_message#>}
{##  start := 1;}
{##  length := h1;}
{##  while length > max_strlen do}
{##    begin}
{##    msg := substr(message, start, max_strlen);}
{##    screen_str_message(msg);}
{##    start := start + max_strlen;}
{##    length := length - max_strlen;}
{##    end;}
{##  msg := substr(message, start, length);}
{##  screen_str_message(msg);}
{##  screen_vms_message := false; #< Don't write to SYS$ERROR. #>}
{##  end; #<screen_vms_message#>}
{#endif}


{#if unix or fpc}
procedure screen_unix_message (
        var     message : str_object);
{#if fpc}
        cdecl; alias : '_screen_unix_message';
{#endif}
  {umax:nonpascal}
  {mach:nonpascal}

  { Purpose  : Put a message out to the user.
    Inputs   : message: nul terminated message.
  }
  var
    msg : str_object;
    start, length : integer;

  begin {screen_unix_message}
  start := 1;
  length := 1;
  while (message[length] <> chr(0)) do
    length := length+1;
  length := length-1;
  while length > max_strlen do
    begin
    ch_move(message, start, msg, 1, max_strlen);
    screen_str_message(msg);
    start := start + max_strlen;
    length := length - max_strlen;
    end;
  ch_copy(message, start, length, msg, 1, max_strlen, ' ');
  screen_str_message(msg);
  end; {screen_unix_message}
{#endif}


{#if msdos}
{##procedure screen_msdos_message#<(message:string)#>;}
{##}
{##  #< Purpose  : Put a message out to the user.}
{##    Inputs   : message: message in 'string' format.}
{##  #>}
{##  var}
{##    buffer : str_object;}
{##}
{##  begin #<screen_msdos_message#>}
{##  fillchar(buffer[1], sizeof(buffer), ' ');}
{##  move(message[1], buffer[1], length(message));}
{##  screen_str_message(buffer);}
{##  end; #<screen_msdos_message#>}
{#endif}


procedure screen_draw_line (
                line : line_ptr);

  {Draw a line if it is on the screen.}
{#if debug}
  label 99;
{#endif}
  var
    strlen,offset : integer;

  begin {screen_draw_line}
  with line^,scr_frame^ do
    begin
{#if debug}
    if scr_row_nr = 0 then
      begin screen_message(dbg_invalid_scr_row_nr); goto 99; end;
{#endif}
    vdu_movecurs(1,scr_row_nr);
    offset := scr_offset;
    if flink <> nil then
      strlen := used-offset
    else
      begin
      strlen := len;
      offset := 0;
      end;
    if strlen<=0 then
      vdu_cleareol
    else
      begin
      if strlen > scr_width then strlen := scr_width;
      vdu_displaystr(strlen,str^[1+offset],3);
      end;
    if scr_row_nr = scr_msg_row then scr_msg_row := scr_msg_row+1;
    end;
{#if debug}
  99:
{#endif}
  end; {screen_draw_line}


procedure screen_redraw{};

  {Redraw the screen, exactly as is.}
  var
    line : line_ptr;

  begin {screen_redraw}
  if scr_frame <> nil then
    begin
    vdu_clearscr;
    scr_msg_row := terminal_info.height+1;
    scr_needs_fix := false;
    line := scr_top_line;
    while line<>scr_bot_line do
      begin
      screen_draw_line(line);
      line := line^.flink;
      end;
    screen_draw_line(line);
    end;
  end; {screen_redraw}


{}procedure screen_slide_line (
                line        : line_ptr;
              slide_dist  : integer;
              slide_state : slide_type);

    { Slide 'line' line, according to slide_dist, slide_state.      }
    { NOTE THIS IS REALLY A PRIVATE ROUTINE FOR SCREEN_POSITION.    }
    {      AND FOR                              SCREEN_SLIDE.       }
    { It assumes the scr_offset has been changed by slide_dist      }
    { and that the lines on the screen are being accordingly fixed. }
    label
      99;
    var
      overlap : integer;
      offset  : col_offset_range;
      width   : scr_col_range;

    begin {screen_slide_line}
    if line^.flink = nil then goto 99;  { Dont slide NULL line. }
    with scr_frame^ do
      begin
      offset := scr_offset;
      width  := scr_width;
      end;

    with line^ do
      begin
      vdu_movecurs(1,scr_row_nr);
      if slide_state = slide_left then
        begin
        overlap := used-offset;
        if overlap > 0 then
          begin
          if overlap > slide_dist then
            begin
            vdu_insertchars(slide_dist);
            overlap := slide_dist;
            end;
          vdu_displaystr(overlap,line^.str^[1+offset],2{anycurs});
          end;
        end
      else
        begin
        if offset-slide_dist < used then
          begin
          overlap := used{+1} - (offset-slide_dist+width{+1});
          if slide_dist >= width then
            begin
            vdu_cleareol;
            slide_dist := width;
            end
          else
            begin
            vdu_deletechars(slide_dist);
            vdu_movecurs(width+1-slide_dist,scr_row_nr);
            end;
          if overlap > 0 then
            begin
            if overlap > slide_dist then overlap := slide_dist;
            vdu_displaystr(overlap,line^.str^[offset+width+1-slide_dist],
                           2{anycurs});
            end;
          end;
        end;
      end;
    99:
    end; {screen_slide_line}


procedure screen_slide (
                dist : integer);

  { Slide the whole screen the specified dist, -ve means left. }
  var
    l : line_ptr;
    s : slide_type;

  begin {screen_slide}
  if scr_frame <> nil then
  if dist <> 0 then
    begin
    with scr_frame^ do scr_offset := scr_offset+dist;
    if dist < 0 then
      begin
      s := slide_left;
      dist := -dist;
      end
    else
      s := slide_right;

    l := scr_top_line;
    while l <> nil do
      begin
      screen_slide_line(l,dist,s);
      if l = scr_bot_line then
        l := nil
      else
        l := l^.flink;
      end;

    end;
  end; {screen_slide}


procedure screen_unload{};

  {Unload the screen.}

  begin {screen_unload}
  if scr_frame <> nil then
    begin
    with scr_frame^ do
      if dot^.line^.scr_row_nr = 0 then
        scr_dot_line := (margin_top+scr_height-margin_bottom+1) div 2
                       +(terminal_info.height-scr_height) div 2
      else
        scr_dot_line := dot^.line^.scr_row_nr;
    vdu_clearscr;
    scr_msg_row := terminal_info.height+1;
    scr_needs_fix := false;
    scr_top_line^.scr_row_nr := 0;
    while scr_top_line <> scr_bot_line do
      begin
      scr_top_line := scr_top_line^.flink;
      scr_top_line^.scr_row_nr := 0;
      end;
    scr_frame    := nil;
    scr_bot_line := nil;
    scr_top_line := nil;
    end;
  end; {screen_unload}


{}procedure screen_expand (
                init_upwards,
                init_downwards : boolean);
    forward;


procedure screen_scroll (
                count  : integer;
                expand : boolean);

  {Scroll the screen forward or back by the specified number of lines.}
  {The only limit is the final screen must contain at least one line. }
  {If expand is true, the screen must keep the same number of lines.  }
  {Count is +ve, means scroll forward, -ve means backwards.           }
  {The actual method of moving is optimized into a REDRAW if "nicer". }
  {                                                                   }
  {WARNING Screen_Position predicts the behaviour of this routine.    }
  {        In particular it predicts which lines this routine will not}
  {        scroll off the screen. Any changes here therefore must have}
  {        implications there also.                                   }
  label 1,99;
  var
    frame           : frame_ptr;
    row_nr,
    top_line_row,
    bot_line_row    : scr_row_range;
    eop_line_nr,
    free_lines,
    remaining_lines : integer;
    bot_line_nr,
    top_line_nr     : line_range;
    top_line,
    bot_line        : line_ptr;

  begin {screen_scroll}
  if scr_frame = nil then goto 99;
  bot_line := scr_bot_line;
  top_line := scr_top_line;

  if count >= 0 then                                  {FORWARD DIRECTION.    }
    begin
    if expand then
      begin
      if not line_to_number(bot_line,bot_line_nr) then goto 99;
      with scr_frame^.last_group^ do
        eop_line_nr := first_line_nr+last_line^.offset_nr;
      remaining_lines := eop_line_nr-bot_line_nr;
      if remaining_lines < count then count := remaining_lines;
      bot_line_row := bot_line^.scr_row_nr;
      free_lines := terminal_info.height-bot_line_row;
      if free_lines > count then free_lines := count;
      if count-free_lines <= bot_line_row then

        { Won't be redrawing so extend downwards if possible. }

        begin
        for row_nr := bot_line_row+1 to bot_line_row+free_lines do
          begin
          bot_line := bot_line^.flink;
          bot_line^.scr_row_nr := row_nr;
          screen_draw_line(bot_line);
          end;
        scr_bot_line := bot_line;
        count := count-free_lines;
        if count = 0 then goto 99;
        end;
      end;

    { Check whether or not we would be scrolling to far. }

    if count > bot_line^.scr_row_nr then
      begin

      { Would have to scroll to far, redraw instead. }

      if expand then {Remember where to reload the screen.}
        begin
        frame := scr_frame;
        bot_line_nr := bot_line_nr+count;
        if not line_from_number(scr_frame,bot_line_nr,bot_line) then goto 99;
        end;
      screen_unload;
      if expand then
        begin
        scr_frame    := frame;
        scr_top_line := bot_line;
        scr_bot_line := bot_line;
        bot_line^.scr_row_nr := terminal_info.height;
        screen_draw_line(bot_line);
        screen_expand(true,false);
        end;
      goto 99;
      end;

    {SCROLL 'COUNT' LINES ONTO THE SCREEN.}

    while count>0 do                                  { Scroll lines on the  }
      begin                                           { the screen.          }
      count := count-1;
      vdu_scrollup(1);
      if scr_msg_row <= terminal_info.height then scr_msg_row := scr_msg_row-1;

      with bot_line^ do
        begin
        if expand then
          begin
          flink^.scr_row_nr := scr_row_nr;
          screen_draw_line(flink);
          bot_line := flink;
          end
        else
          begin
          scr_row_nr := scr_row_nr-1;
{#if debug}
          if scr_row_nr = 0 then
            begin screen_message(dbg_wrong_row_nr); goto 99; end;
{#endif}
          end;
        end;

      with top_line^ do
        begin
        scr_row_nr := scr_row_nr-1;
        if scr_row_nr=0 then                          { See if scrolled off. }
          begin
          flink^.scr_row_nr := 1;                     { Make next line top   }
          top_line := flink;                          { of screen.           }
          end;
        end;

      end;
    end
  else
    begin                                             {BACKWARD DIRECTION.   }
    count := -count;
    if expand then
      begin
      if not line_to_number(top_line,top_line_nr) then goto 99;
      remaining_lines := top_line_nr-1;
      if remaining_lines < count then count := remaining_lines;
      top_line_row := top_line^.scr_row_nr;
      free_lines := top_line_row-1;
      if free_lines >= count then
        free_lines := count
      else
      if not (trmflags_v_scdn in tt_capabilities) then
        begin
        {Removed the Goto 1 from here and replaced it with the code, so if}
        {the code is changed below it should be done here as well. Jumping}
        {into a structured statement is a non-fatal error under pc on Unix.}

        if expand then {Remember where to reload the screen.}
          begin
          frame := scr_frame;
          top_line_nr := top_line_nr-count;
          if not line_from_number(scr_frame,top_line_nr,top_line) then goto 99;
          end;
        screen_unload;
        if expand then
          begin
          scr_frame    := frame;
          scr_top_line := top_line;
          scr_bot_line := top_line;
          top_line^.scr_row_nr := 1+terminal_info.height-scr_frame^.scr_height;
          screen_draw_line(top_line);
          screen_expand(false,true);
          end;
        goto 99;
        end;

      if top_line_row+count-free_lines <= terminal_info.height+1 then

        {IT IS WORTH WHILE EXTENDING THE SCREEN.}

        begin
        for row_nr := top_line_row-1 downto top_line_row-free_lines do
          begin
          top_line := top_line^.blink;
          top_line^.scr_row_nr := row_nr;
          screen_draw_line(top_line);
          end;
        scr_top_line := top_line;
        count := count-free_lines;
        if count = 0 then goto 99;
        end;
      end;

    { Check whether or not to scroll. }

    if (count+top_line^.scr_row_nr > terminal_info.height+1)
    or (not (trmflags_v_scdn in tt_capabilities))
    then
      begin

      {NONE OF THE CURRENT STUFF WILL BE LEFT ON THE SCREEN.}


  1:  {REDRAW}

      if expand then {Remember where to reload the screen.}
        begin
        frame := scr_frame;
        top_line_nr := top_line_nr-count;
        if not line_from_number(scr_frame,top_line_nr,top_line) then goto 99;
        end;
      screen_unload;
      if expand then
        begin
        scr_frame    := frame;
        scr_top_line := top_line;
        scr_bot_line := top_line;
        top_line^.scr_row_nr := 1+terminal_info.height-scr_frame^.scr_height;
        screen_draw_line(top_line);
        screen_expand(false,true);
        end;
      goto 99;
      end;

    {SCROLL 'COUNT' LINES ONTO THE SCREEN.}

    while count>0 do                                  { Scroll lines on the  }
      begin                                           { the screen.          }
      count := count-1;
      vdu_movecurs(1,1);
      vdu_insertlines(1);
      if scr_msg_row <= terminal_info.height then scr_msg_row := scr_msg_row+1;

      with top_line^ do
        begin
        if expand then
          begin
          blink^.scr_row_nr := scr_row_nr;
          screen_draw_line(blink);
          top_line := blink;
          end
        else
          begin
          scr_row_nr := scr_row_nr+1;
          end;
        end;

      with bot_line^ do
        begin
        if scr_row_nr=terminal_info.height then
          begin
          scr_row_nr := 0;
          blink^.scr_row_nr := terminal_info.height;
          bot_line := blink;                          { of screen.           }
          end
        else
          scr_row_nr := scr_row_nr+1;
        end;

      end;
    end;

  { NOW RESET THE DAMAGED SCREEN POINTERS AND LINE NUMBERS. }

  scr_top_line := top_line;
  scr_bot_line := bot_line;

  row_nr := top_line^.scr_row_nr;                     {Reset the row numbers.}
  while top_line <> bot_line do
    with top_line^ do
      begin
      scr_row_nr := row_nr;
      top_line := flink;
      row_nr := row_nr+1;
      end;
{#if debug}
  if bot_line^.scr_row_nr <> row_nr then
    begin screen_message(dbg_wrong_row_nr); goto 99; end;
{#endif}
  99:
  end; {screen_scroll}


{}procedure screen_expand (
                init_upwards,
                init_downwards : boolean);

    { Expand a screen out to at least the frame's specified screen height.     }
    { Use the allowed directions to control the expansion. }
{#if debug}
    label 99;
{#endif}
    var
      upwards,downwards : boolean;
      lines_on_scr,
      cur_row,height : scr_row_range;
      bot_line,
      top_line       : line_ptr;
      nr_lines       : line_range;
{#if turbop}
      marker         : string;
{#else}
{##      marker         : str_object;}
{#endif}

    begin {screen_expand}
    upwards   := init_upwards;
    downwards := init_downwards;

    with scr_frame^ do
      begin
      height   := scr_height;
      bot_line := scr_bot_line;
      top_line := scr_top_line;
      end;

{#if debug}
    if top_line^.scr_row_nr = 0 then
      begin screen_message(dbg_top_line_not_drawn); goto 99; end;
{#endif}
    lines_on_scr := bot_line^.scr_row_nr+1-top_line^.scr_row_nr;

    while (lines_on_scr<height) and (upwards or downwards) do
      begin
      if downwards then
        begin
        downwards := false;
        cur_row := bot_line^.scr_row_nr;
        if bot_line^.flink <> nil then          {Add a line at bottom if poss. }
        if cur_row < terminal_info.height then
          begin
          downwards := true;
          lines_on_scr   := lines_on_scr+1;     {Count the line added.         }
          bot_line       := bot_line^.flink;    {Step on to next new line.     }
          bot_line^.scr_row_nr := cur_row+1;    {Set its number.               }
          screen_draw_line(bot_line);           {Draw it on the screen.        }
          end;
        end;
      if upwards then
        begin
        upwards := false;
        cur_row := top_line^.scr_row_nr;
        if cur_row > 1 then
        if top_line^.blink <> nil then          {Add a line at top if poss.    }
          begin
          upwards := true;
          lines_on_scr   := lines_on_scr+1;     {Count the line added.         }
          top_line       := top_line^.blink;    {Step on to next new line.     }
          top_line^.scr_row_nr := cur_row-1;    {Set its number.               }
          screen_draw_line(top_line);           {Draw it on the screen.        }
          end;
        end;

      end;

    { Reset the BOT and TOP screen pointers. }

    if scr_bot_line <> bot_line then
      begin
      scr_bot_line := bot_line;
      cur_row := bot_line^.scr_row_nr;
      end;
    if scr_top_line <> top_line then
      begin
      scr_top_line := top_line;
      cur_row := top_line^.scr_row_nr;
      end;

    { If just expanding wasn't enough then try scrolling to get the lines.}

    if lines_on_scr < height then
      begin
      if init_downwards then
      if bot_line^.flink <> nil then
        begin
        screen_scroll(height-lines_on_scr,true);
        lines_on_scr := scr_bot_line^.scr_row_nr+1-scr_top_line^.scr_row_nr;
        end;
      if init_upwards then
      if lines_on_scr < height then
      if trmflags_v_scdn in tt_capabilities then
      if line_to_number(scr_top_line,nr_lines) then
        begin
        if nr_lines >= height-lines_on_scr then nr_lines := height-lines_on_scr;
        screen_scroll(-nr_lines,true);
        end;
      end;

    { Redraw the <TOP> and <BOTTOM> markers. }

    with scr_bot_line^ do
    if flink <> nil then
      begin
      cur_row := scr_row_nr;
      if cur_row < terminal_info.height then
        begin
        cur_row := cur_row+1;
        vdu_movecurs(1,cur_row);
        marker := '<BOTTOM>';
        vdu_displaystr(8,marker[1],3);
        if cur_row = scr_msg_row then scr_msg_row := scr_msg_row+1;
        end;
      end;

    if scr_top_line^.scr_row_nr > 1 then
      begin
      vdu_movecurs(1,scr_top_line^.scr_row_nr-1);
      marker := '<TOP>';
      vdu_displaystr(5,marker[1],3);
      end;
{#if debug}
    99:
{#endif}
    end; {screen_expand}


procedure screen_lines_extract (
                first_line : line_ptr;
                last_line  : line_ptr);

  label
    99;
  var
    count      : scr_row_range;
    line_limit : line_ptr;

  begin {screen_lines_extract}
  {The lines specified are removed from the screen.  If the whole screen}
  {is removed then it is unmapped.}

  if last_line <> scr_bot_line then
    begin
    if (trmflags_v_dlln in tt_capabilities
       )
    or (   (trmflags_v_scdn in tt_capabilities)
       and (first_line = scr_top_line)
       )
    then
      begin

      {EXTRACTION NOT AT BOT-OF-SCR ACCOMPLISHED VIA TERMINAL H/W.}

      vdu_movecurs(1,first_line^.scr_row_nr);
      count := last_line^.scr_row_nr+1-first_line^.scr_row_nr;
      vdu_deletelines(count,true);
      if scr_msg_row <= terminal_info.height then scr_msg_row := scr_msg_row-count;

      line_limit := last_line^.flink;
      if first_line = scr_top_line then scr_top_line := line_limit;
      count := line_limit^.scr_row_nr - first_line^.scr_row_nr;
      repeat
        with first_line^ do
          begin
          scr_row_nr := 0;
          first_line := flink;
          end;
      until first_line = line_limit;
      line_limit := scr_bot_line^.flink;
      repeat
        with first_line^ do
          begin
          scr_row_nr := scr_row_nr-count;
          first_line := flink;
          end;
      until first_line = line_limit;
      goto 99;
      end
    else
      begin

      {EXTRACTION NOT AT BOT-OF-SCR ACCOMPLISHED VIA EXCESSIVE EXTRACTION.}

      if first_line^.scr_row_nr-scr_top_line^.scr_row_nr <
         scr_bot_line^.scr_row_nr-last_line^.scr_row_nr
      then
        first_line := scr_top_line
      else
        last_line  := scr_bot_line;
      end;
    end;

  if first_line = scr_top_line then
    begin
    if last_line = scr_bot_line then
      screen_unload
    else
      begin
      line_limit := last_line^.flink;
      repeat
        with scr_frame^,scr_top_line^ do
          begin

          (* THIS IS COMMENTED OUT, THUS THE LINES STAY ON THE SCREEN UNTIL *)
          (* SCREEN_FIXUP IS CALLED.  THIS ALLOWS THE TEXT TO BE USED FOR   *)
          (* OPTIMIZATION PURPOSES WHILEST THE SCREEN IS BEING FIXED UP.    *)

          scr_needs_fix := true;
        { if used >= scr_offset then    }
        {   begin                       }
        {   vdu_movecurs(1,scr_row_nr); }
        {   vdu_cleareol;               }
        {   end;                        }

          scr_row_nr := 0;
          scr_top_line := flink;
          end;
      until scr_top_line = line_limit;
      end;
    end
  else
  if last_line = scr_bot_line then
    begin
    line_limit := first_line^.blink;
    repeat
      with scr_frame^,scr_bot_line^ do
        begin
        scr_row_nr := 0;
        scr_bot_line := blink;
        end;
    until scr_bot_line = line_limit;
    vdu_movecurs(1,scr_bot_line^.scr_row_nr+1);
{             DONT RUBOUT LINES,     THUS THE LINES STAY ON THE SCREEN UNTIL }
{             SCREEN_FIXUP IS CALLED.  THIS ALLOWS THE TEXT TO BE USED FOR   }
{             OPTIMIZATION PURPOSES WHILST THE SCREEN IS BEING FIXED UP.     }
{     SCR_NEEDS_FIX := TRUE;                                                 }
{ above code removed and following line added by KBN 30-Jul-1982             }
    if trmflags_v_cles in tt_capabilities then vdu_cleareos;
    scr_msg_row := terminal_info.height+1;
    end;
  99:
  end; {screen_lines_extract}


procedure screen_lines_inject (
                first_line  : line_ptr;
                count       : line_range;
                before_line : line_ptr);

  { This routine is called just after LINES_INJECT has insert 'count' lines  }
  { just above 'before_line', the first inserted being 'first_line'.         }
  { LINES_INJECT has not changed any 'scr_row_nr' fields,  but has checked   }
  { before_line^.scr_row_nr <> 0,  and before_line <> scr_top_line.          }
  {                                                                          }
  { The rules for this routine are (1) 'first_line' should be   on the screen}
  { and (2) no more than 'scr_height' lines are to be drawn onto the screen. }
  label 1;
  var
    before_line_scr_row : scr_row_range;
    i                   : integer;
    line                : line_ptr;
    row_nr              : scr_row_range;
    scrollup_count      : integer;
    lines_above_insert  : scr_row_range;
    lines_below_insert  : scr_row_range;
    free_space_above    : scr_row_range;
    free_space_below    : scr_row_range;

  begin {screen_lines_inject}
  before_line_scr_row := before_line^.scr_row_nr;
  if trmflags_v_inln in tt_capabilities then
    begin

    {HEURISTIC -- KEEP AS MANY LINES ON THE SCREEN AS POSSIBLE.}
    {          -- IT IS UNLIKELY THAT SCROLLUP WILL BE USED, DONT WASTE}
    {             A LOT OF CODE OPTIMIZING IT.  LET IT HAPPEN IF POSSIBLE.}

    free_space_below := terminal_info.height-scr_bot_line^.scr_row_nr;
    free_space_above := scr_top_line^.scr_row_nr-1;

    if free_space_above > 0 then
    if before_line <> scr_top_line then
    if terminal_info.height > before_line^.scr_row_nr-free_space_above+count then
      begin
      scrollup_count := count-free_space_below;
      if scrollup_count > 0 then
        begin

        {Scrolling the screen upwards is useful to do, because it will}
        {keep some lines on the screen that would otherwise have been lost.}

        if scrollup_count > free_space_above then
          scrollup_count := free_space_above;
        vdu_scrollup(scrollup_count);
        if scr_msg_row <= terminal_info.height then
          scr_msg_row := scr_msg_row-scrollup_count;

        { WARNING -- only the SCR_ROW_NR's up to and including BEFORE_LINE }
        {         -- and SCR_BOT_LINE,                                     }
        {         -- are corrected here.  There is not need to correct the }
        {         -- rest because they are about to change again.          }

        line := scr_top_line;
        row_nr := line^.scr_row_nr-scrollup_count;
        repeat
          with line^ do
            begin
            scr_row_nr := row_nr;
            row_nr := row_nr+1;
            line := flink;
            end;
        until line = first_line;

        {Do the two weirdo exceptions, the order is crucial in case}
        {they are the same line.}

        with scr_bot_line^ do scr_row_nr := scr_row_nr-scrollup_count;
        before_line^.scr_row_nr := row_nr;
        end;
      end;

    { The screen is now optimally placed for the insertion.  If sensible }
    { extend the screen upwards. }

    if before_line = scr_top_line then
    if free_space_above > 0 then

    (* if scr_top_line^.scr_row_nr+count-free_space_above <= tt_height then *)
    (* but free_space_above = scr_row_nr-1, hence the following 'weird' exp *)

    if count+1 <= terminal_info.height then
      begin
      row_nr := scr_top_line^.scr_row_nr-1;
      while (row_nr > 1) and (count > 0) do
        begin
        scr_top_line := scr_top_line^.blink;
        scr_top_line^.scr_row_nr := row_nr;   screen_draw_line(scr_top_line);
        row_nr := row_nr-1;
        count := count-1;
        end;
      before_line := scr_top_line;
      end;

    { Finally do the insert if one necessary. }

    if count > 0 then
      begin
      if before_line = scr_top_line then scr_top_line := first_line;
      row_nr := before_line^.scr_row_nr;
      vdu_movecurs(1,row_nr);
      vdu_insertlines(count);
      if scr_msg_row <= terminal_info.height then
        begin
        scr_msg_row := scr_msg_row+count;
        if scr_msg_row > terminal_info.height then
          scr_msg_row := terminal_info.height+1;
        end;

      { Patch up the pointers and scr_row_nr's of lines pushed off screen. }

      line := scr_bot_line;
      for i := line^.scr_row_nr+count downto terminal_info.height+1 do
        with line^ do
          begin
          if scr_row_nr = 0 then goto 1;
          scr_row_nr := 0;
          line := blink;
          end;
    1:
      if line^.scr_row_nr <> 0 then
        begin

        { Lines were pushed but left on the screen. }
        { Do all the lines on the screen, right up to 'first_line'. }

        scr_bot_line := line;
        row_nr := line^.scr_row_nr+count;
        repeat
          with line^ do
            begin
            if scr_row_nr = 0 then
              begin
              scr_row_nr := row_nr;
              screen_draw_line(line);
              end
            else
              scr_row_nr := row_nr;
            row_nr := row_nr-1;
            line := blink;
            end
        until line = first_line;
        line^.scr_row_nr := row_nr;
        screen_draw_line(line);
        end
      else
        begin

        { No lines were left on the screen.  Redraw downwards until enough }
        { lines on the screen. }

        scr_bot_line := first_line;
        first_line^.scr_row_nr := row_nr; screen_draw_line(first_line);
        screen_expand(false,true);

        end;
      end;
    end
  else
  {DUMB TERMINALS}
    begin

    {HEURISTIC -- REMOVE THE SMALLER OF THE TWO AREAS, THAT ABOVE OR BELOW }
    {             THE NEW LINES.                                           }

    scr_needs_fix := true;
    lines_above_insert := before_line_scr_row-scr_top_line^.scr_row_nr;
    lines_below_insert := scr_bot_line^.scr_row_nr-before_line_scr_row+1;

    if (lines_above_insert>lines_below_insert)
    or (count>=before_line_scr_row)
    then
      begin {Retain area above insert, remove area below insert.}
      repeat
        with scr_bot_line^ do
          begin
          scr_row_nr   := 0;
          scr_bot_line := blink;
          end;
      until scr_bot_line = before_line^.blink;
      scr_bot_line := first_line^.blink;
      end
    else
      begin {Retain area below insert, remove area above insert.}
      repeat
        with scr_top_line^ do
          begin
          scr_row_nr   := 0;
          scr_top_line := flink;
          end;
      until scr_top_line = first_line;
      scr_top_line := before_line;
      end;
    end;
  end; {screen_lines_inject}


procedure screen_load (
                line : line_ptr;
                col  : col_range);

  {LUDWIG_SCREEN:}
  {Map the screen into the specified frame, the line and col specified must  }
  {be on the screen,  it is placed in the most desirable location.           }
  {LUDWIG_BATCH:}
  {Do nothing.}
  {LUDWIG_HARDCOPY:}
  {Draw scr_height lines around the dot.}
  label 99;
  var
    frame       : frame_ptr;
    eop_line_nr,
    line_nr     : line_range;
    new_row     : integer;
    dot_col     : col_range;
    dot_line    : line_ptr;
    half_width  : col_offset_range;
    buflen      : strlen_range;
{#if turbop}
    i           : integer;
{#endif}

  begin {screen_load}
  frame := line^.group^.frame;
  with frame^ do
  case ludwig_mode of
    ludwig_batch:
      ;
    ludwig_hardcopy:
      begin
      new_row := scr_height div 2;
      while (new_row>0) and (line^.blink<>nil) do
        begin
        line := line^.blink;
        new_row := new_row-1;
        end;
      dot_line := dot^.line;
      dot_col  := dot^.col;
      new_row := 1;
      while (new_row<=scr_height) and (line<>nil) do
        begin
        if new_row = 1 then writeln('WINDOW:');
        buflen := 0;
        with line^ do
          begin
          buflen := used;
          if flink = nil then buflen := len;
          if buflen > 0 then
{#if turbop}
            begin
            for i := 1 to buflen do
              write(str^[i]);
            writeln;
            end
{#else}
{##            writeln(str^:buflen)}
{#endif}
          else
            writeln;
          end;
        if line = dot_line then
          begin
          if dot_col = 1 then
            writeln('<')
          else
          if dot_col = max_strlenp then
            writeln(' ':max_strlen-1,'>')
          else
            writeln(' ':dot_col-2,'><');
          end;
        new_row := new_row+1;
        line := line^.flink;
        end;
      end;

    ludwig_screen:
      begin
      if scr_frame <> nil then                { A frame mapped at present.   }
        screen_unload                         {   Unload/clear it.           }
      else
        begin
        vdu_clearscr;                         {   Clear the screen anyway.   }
        scr_msg_row := terminal_info.height+1;
        scr_needs_fix := false;
        end;

      with line^.group^.frame^ do
        new_row := scr_dot_line;
      if (not line_to_number(line,line_nr)) then goto 99;
      eop_line_nr := last_group^.first_line_nr+last_group^.nr_lines-1;
      if (eop_line_nr-line_nr)<(terminal_info.height-new_row) then
        new_row := terminal_info.height-(eop_line_nr-line_nr);
      if line_nr<new_row then new_row := line_nr;

      line^.scr_row_nr := new_row;

      { Move left or right in 1/2 window chunks until DOT on screen. }

      dot_col := dot^.col;
      while (dot_col <= scr_offset)
         or (dot_col  > scr_offset+scr_width)
      do
        begin
        half_width := scr_width div 2;
        if half_width = 0 then half_width := 1;
        if dot_col <= scr_offset then
          if scr_offset > half_width then
            scr_offset := scr_offset - half_width
          else
            scr_offset := 0
        else
          if scr_offset+half_width+scr_width < max_strlenp then
            scr_offset := scr_offset+half_width
          else
            scr_offset := max_strlenp-scr_width;
        end;

      { Load the screen. }

      scr_frame := frame;
      scr_bot_line := line;
      scr_top_line := line;
      screen_draw_line(line);
      screen_expand(true,true);
      end;
  end{case};
  99:
  end; {screen_load}


procedure screen_position (
                new_line : line_ptr;
                new_col  : col_range);

  { Position the screen so that                                              }
  {       (1) The specified line and column are on the screen.               }
  {       (2) At least scr_frame^.scr_height lines are on the screen.        }
  {       (3) If possible the specified line is between the top and          }
  {           bottom margins.                                                }
  {       (4) No more than scr_height lines are written to the screen.       }
  label 99;
  var
    height         : scr_row_range;           {Copies of fields out of       }
    offset         : col_offset_range;        {scr_frame,  taken for reasons }
    width          : scr_col_range;           {of efficiency.                }
    slide_dist     : integer;                 {Used during horizontal scroll.}
    slide_state    : slide_type;
    scroll_dist    : integer;
    scroll_state   : scroll_type;
    row_nr         : scr_row_range;
    nr_rows        : scr_row_range;
    line,
    bot_line,
    top_line       : line_ptr;
    bot_line_nr,
    new_line_nr,
    top_line_nr    : line_range;
    top_margin,
    bot_margin     : scr_row_range;

  begin {screen_position}
  if new_line^.group^.frame <> scr_frame then
    begin
    screen_load(new_line,new_col);
    goto 99;
    end;

  with scr_frame^ do
    begin
    offset     := scr_offset;
    width      := scr_width;
    top_margin := margin_top;
    bot_margin := margin_bottom;
    end;

  { Check that the specified position is not on the screen between margins.  }
  { The very common case is that it is, and that the screen need not be      }
  { moved.                                                                   }

  if (new_line^.scr_row_nr=0)
  or (    (new_line^.scr_row_nr-scr_top_line^.scr_row_nr < top_margin)
      and (scr_top_line^.blink <> nil)
     )
  or (    (scr_bot_line^.scr_row_nr-new_line^.scr_row_nr < bot_margin)
      and (scr_bot_line^.flink <> nil)
     )
  or (new_col<=offset)
  or (new_col> offset+width)
  then
    begin

    { Unfortunately this is the uncommon case.     }

    with scr_frame^ do
      begin
      height   := scr_height;
      bot_line := scr_bot_line;
      top_line := scr_top_line;
      end;

    slide_state := slide_dont;        { Compute horizontal adjusting needed. }
    slide_dist  := offset+1-new_col;
    if slide_dist > 0 then            { Col to left of screen.               }
      begin
      slide_state := slide_redraw;    { Redraw unless can slide there.       }
      if offset < width div 4 then    { Heuristic, slide if sensible.        }
      if trmflags_v_inch in tt_capabilities then
        begin
        slide_state := slide_left;
        slide_dist  := offset;
        end;
      end
    else
      begin
      slide_dist := new_col-(offset+width);
      if slide_dist > 0 then          { Col to right of screen.              }
        begin
        slide_state := slide_redraw;  { Redraw unless can slide there.       }
        if offset > max_strlenp-width div 4 then
                                      { Heuristic, slide if sensible.        }
        if trmflags_v_dlch in tt_capabilities then
          begin
          slide_state := slide_right;
          slide_dist  := max_strlenp-(offset+width);
          end;
        end;
      end;

    scroll_state := scroll_dont;
    if  (slide_state <> slide_redraw)
    and (   (new_line^.scr_row_nr=0)
         or (    (new_line^.scr_row_nr-scr_top_line^.scr_row_nr < top_margin)
             and (scr_top_line^.blink <> nil)
            )
         or (    (scr_bot_line^.scr_row_nr-new_line^.scr_row_nr < bot_margin)
             and (scr_bot_line^.flink <> nil)
            )
        )
    then                              { Compute vertical adjusting needed.   }
      begin
      if (not line_to_number(bot_line,bot_line_nr))
      or (not line_to_number(new_line,new_line_nr))
      or (not line_to_number(top_line,top_line_nr)) then goto 99;

      scroll_state := scroll_redraw;
      if (new_line_nr < top_line_nr)
      or (    (new_line_nr < top_line_nr+top_margin)
          and (new_line_nr < bot_line_nr)
         )
      then
        begin
        scroll_state := scroll_back;
        scroll_dist  := top_line_nr+top_margin-new_line_nr;
        if scroll_dist >= top_line_nr then scroll_dist := top_line_nr-1;
        if scroll_dist >= scr_top_line^.scr_row_nr then
          if not (trmflags_v_scdn in tt_capabilities) then
            scroll_state := scroll_redraw;
        end
      else
        begin
        scroll_state := scroll_forward;
        scroll_dist  := new_line_nr-(bot_line_nr-bot_margin);
        if scroll_dist <= 0 then scroll_state := scroll_dont;
        end;
      if scroll_state <> scroll_redraw then
        if scroll_dist > height then
          scroll_state := scroll_redraw;
      end;

    { At this point SLIDE_STATE, SLIDE_DIST, SCROLL_STATE and SCROLL_DIST    }
    { are carrying all the advice about how to get to the new position.      }
    { If either state has voted for a redraw, then a redraw it is, else      }
    { a combined scroll and slide operation is embarked on.                  }

    if (scroll_state = scroll_redraw)
    or (slide_state  = slide_redraw)
    then
      screen_load(new_line,new_col)
    else
      begin
      if slide_state <> slide_dont then
        begin

        { Adjust the screen offset and the lines that are     }
        { going to be left on the screen when scrolling.      }

        with scr_frame^ do
          begin
          if slide_state = slide_left then
            scr_offset := scr_offset-slide_dist
          else
            scr_offset := scr_offset+slide_dist;
          end;
        line := top_line;
        case scroll_state of
          scroll_redraw  : {impossible};
          scroll_dont    ,
          scroll_forward :
            begin
            if scroll_state = scroll_dont then scroll_dist := 0;

            { Predict which lines are going to be left on the screen. }

            nr_rows := terminal_info.height-bot_line^.scr_row_nr;
            if nr_rows >= scroll_dist then
              row_nr := 0     { slide all the lines.                         }
            else              { slide all but the lines that will scroll off.}
              row_nr := scroll_dist-nr_rows;

            { Adjust those lines that will be left on the screen. }

            repeat
              if line^.scr_row_nr > row_nr then
                screen_slide_line(line,slide_dist,slide_state);
              if line<>bot_line then line := line^.flink else line := nil;
            until line = nil;
            end;
          scroll_back    :
            begin

            { Decide which lines are going to be left on the screen. }

            nr_rows := top_line^.scr_row_nr-1;
            if nr_rows < scroll_dist then { slide all the lines }
              row_nr := terminal_info.height
            else    { slide all the lines that won't scroll off.}
              row_nr := terminal_info.height-(scroll_dist-nr_rows);

            { Adjust those lines that will be left on the screen. }

            repeat
              if line^.scr_row_nr <= row_nr then
                screen_slide_line(line,slide_dist,slide_state);
              if line<>top_line then line := line^.blink else line := nil;
            until line = nil;
            end;
        end{case};
        end; {slide_left,slide_right}

      case scroll_state of
        scroll_redraw  : {impossible};
        scroll_forward : screen_scroll( scroll_dist,true);
        scroll_back    : screen_scroll(-scroll_dist,true);
        scroll_dont    : ;
      end{case};
      end; {slide_left,slide_right,slide_dont}
    end;

  screen_expand(true,true);
  99:
  end; {screen_position}


procedure screen_pause{};

  { Wait until user types a RETURN.  Only in SCREEN mode,  as in HARDCOPY   }
  { or batch there is no point in it.                                       }
  {                                                                         }
  { This routine DOES NOT use SCREEN_GETLINEP because then an infinite loop }
  { would result FIXUP --> CLEAR_MSGS --> PAUSE --> GETLINEP --> FIXUP.     }
  var
    buffer  : str_object;
    outlen  : strlen_range;
{#if turbop}
    tmp_str : string;
{#endif}

  begin {screen_pause}
  if ludwig_mode = ludwig_screen then
    begin
    if scr_frame <> nil then
      vdu_movecurs(1,1)
    else
      vdu_displaycrlf;
    {
    ! The prompt parameter to vdu_get_input is passed by reference for Unix
    ! version as "pc" actually passes strings by value! So we stuff the prompt
    ! in a temporary buffer and pass that.
    }
{#if turbop}
    tmp_str := 'Pausing until RETURN pressed: ';
    move(tmp_str[1], buffer[1], length(tmp_str));
    fillchar(buffer[succ(length(tmp_str))], sizeof(buffer)-length(tmp_str), ' ');
{#else}
{##    buffer := 'Pausing until RETURN pressed: ';}
{#endif}
    vdu_get_input(buffer,30,buffer,max_strlen,outlen);
    if scr_top_line <> nil then
    if scr_top_line^.scr_row_nr = 1 then
      screen_draw_line(scr_top_line)
    else
      begin
      vdu_movecurs(1,1);
      vdu_cleareol;
      if scr_top_line^.scr_row_nr = 2 then scr_needs_fix := true;
      end;
    end;
  end; {screen_pause}


procedure screen_clear_msgs (
                pause : boolean);

  { Clear any messages off the screen. }

  begin {screen_clear_msgs}
  if scr_msg_row <= terminal_info.height then
    begin
    if pause then screen_pause;
    if scr_frame = nil then
      vdu_clearscr
    else
      begin
      vdu_movecurs(1,scr_msg_row);
      vdu_cleareos;
      end;
    scr_msg_row := terminal_info.height+1;
    end;
  end; {screen_clear_msgs}

{#if WINDOWCHANGE or XWINDOWS}
procedure screen_resize{};
  { The screen has changed size, so erase it, get the new size, and redraw }
  { it. }

  var next_span : span_ptr;
      next_frame : frame_ptr;
      band, half_screen : integer;

  procedure change_frame_size(frm : frame_ptr);
  begin
    with frm^ do
      begin
        if (scr_height = initial_scr_height) or
          (scr_height > terminal_info.height) then
            scr_height := terminal_info.height;
        if (scr_width = initial_scr_width) or
          (scr_width > terminal_info.width) then
            scr_width := terminal_info.width;
        { set the margins for the top and bottom }
        { by default, they are 1/6 the height of the screen }
        { if they are equal to initial_margin_top & bottom, then change them }
        { if they are greater or equal to half the height, then change them }
        if (margin_top = initial_margin_top) or (margin_top >=half_screen) then
          margin_top := band;
        if (margin_bottom = initial_margin_bottom)
          or (margin_bottom >= half_screen) then
            margin_bottom := band;
        if (margin_left > terminal_info.width) then
          margin_left := 1;
        if (margin_right = initial_margin_right) or
          (margin_right > terminal_info.width) then
            margin_right := terminal_info.width;
      end
  end;

  begin {screen_resize}
    tt_winchanged := false;
    vdu_get_new_dimensions( terminal_info.width, terminal_info.height );
    scr_msg_row := terminal_info.height + 1;
    vdu_clearscr;
    { change the screen height, width, and margins of all the frames }
    band := terminal_info.height div 6;
    half_screen := terminal_info.height div 2;
    next_span := first_span;
    while (next_span <> nil) do
      begin
        next_frame := next_span^.frame;
        if (next_frame <> nil) then
          change_frame_size(next_frame);
        next_span := next_span^.flink;
      end;
    initial_margin_right := terminal_info.width;
    initial_margin_bottom := band;
    initial_margin_top := band;
    initial_scr_width := terminal_info.width;
    initial_scr_height := terminal_info.height;

    { now actually repaint the screen with the current frame }
    { I'm not terribly happy with this - there might be a memory leak in}
    { here with the screen_load without doing a screen_unload. But since }
    { nobody saw fit to provide any comments describing what the hell    }
    { screen load/unload do, it can't be too much of a problem           }

    with current_frame^, dot^ do
      begin
        screen_load (line, col);
        scr_needs_fix := false;
        screen_expand(true, true);
        vdu_movecurs(col-scr_offset, line^.scr_row_nr);
      end
  end; {screen_resize}

{#endif}

procedure screen_fixup{};

  {Make sure that the screen is user's view of the screen is correct.}
  label 99;
  var
    key :key_code_range;

  begin {screen_fixup}
{#if debug}
  if ludwig_mode <> ludwig_screen then
    begin screen_message(dbg_internal_logic_error); goto 99; end;
{#endif}
{#if WINDOWCHANGE or XWINDOWS}
  if tt_winchanged then
    screen_resize
  else
  begin
{#endif}
  with current_frame^,dot^ do
    begin
    if scr_frame <> current_frame then
      begin
      if scr_msg_row <= terminal_info.height then
        screen_clear_msgs(true);
      screen_load(line,col);
      end
    else
      begin
      if (line^.scr_row_nr = 0)
      or (    (line^.scr_row_nr-scr_top_line^.scr_row_nr < margin_top)
          and (scr_top_line^.blink <> nil)
         )
      or (    (scr_bot_line^.scr_row_nr-line^.scr_row_nr < margin_bottom)
          and (scr_bot_line^.flink <> nil)
         )
      or (col <= scr_offset)
      or (col  > scr_offset+scr_width)
      then
        begin
        if scr_msg_row <= terminal_info.height then
          screen_clear_msgs(true);
        screen_position(line,col);
        end
      else
      if scr_msg_row <= terminal_info.height then
        { Leave screen until key press if there are messages to read.}
        begin
        vdu_movecurs(col-scr_offset,line^.scr_row_nr);
        key := vdu_get_key;
        screen_clear_msgs(false);
        if tt_controlc then goto 99;
        vdu_take_back_key(key);
        end;
      end;

    scr_needs_fix := false;
    screen_expand(true,true);
    vdu_movecurs(col-scr_offset,line^.scr_row_nr);
    end;
{#if WINDOWCHANGE or XWINDOWS}
  end;
{#endif}
  99:
  end; {screen_fixup}


{#if vms}
{##procedure screen_getlinep #<(}
{##                prompt     : packed array [l1..h1:strlen_range] of char;}
{##                prompt_len : strlen_range;}
{##        var     outbuf     : str_object;}
{##        var     outlen     : strlen_range;}
{##                max_tp,}
{##                this_tp    : tpcount_type)#>;}
{#else}
procedure screen_getlinep (
                prompt     : str_object;
                prompt_len : strlen_range;
        var     outbuf     : str_object;
        var     outlen     : strlen_range;
                max_tp,
                this_tp    : tpcount_type);
{#endif}

  label
    1,2;
  var
    index    : tpcount_type;
    tmp_line : line_ptr;
{#if vms}
{##    prompt_dsc : string_descriptor;}
{##    outbuf_dsc : string_descriptor;}
{#else}
    i : integer;
    ch : char;
{#endif}

  begin {screen_getlinep}
  outlen := 0;       { THIS IS DONE BECAUSE ?_GET_INPUT MAY TREAT OUTLEN  }
                     { AS A WORD, NOT AS A LONGWORD.                      }

  max_tp := abs(max_tp);        {this is negative with some file prompts}
  if not tt_controlc then
    begin
    if ludwig_mode = ludwig_screen then
      begin

      prompt_region[this_tp].line_nr := 0;
      prompt_region[this_tp].redraw := nil;

      if scr_top_line = nil then goto 1;
      screen_fixup;
      prompt_region[this_tp].line_nr := this_tp;
      if scr_top_line^.scr_row_nr > max_tp then goto 1;
      if scr_bot_line^.scr_row_nr < scr_msg_row-max_tp then
        begin
        prompt_region[this_tp].line_nr := scr_msg_row-max_tp+this_tp-1;
        goto 1;
        end;
      tmp_line := scr_top_line;
      for index := scr_top_line^.scr_row_nr to this_tp-1 do
        tmp_line := tmp_line^.flink;
      prompt_region[this_tp].redraw := tmp_line;
      if scr_frame^.dot^.line^.scr_row_nr > 2 then goto 1;

      tmp_line := scr_bot_line;
      for index := terminal_info.height-scr_bot_line^.scr_row_nr to max_tp-this_tp-1 do
        tmp_line := tmp_line^.blink;
      if terminal_info.height - scr_bot_line^.scr_row_nr > max_tp - this_tp then
        tmp_line := nil;
      prompt_region[this_tp].redraw := tmp_line;
      prompt_region[this_tp].line_nr := terminal_info.height - max_tp + this_tp;

    1:
      if prompt_region[this_tp].line_nr <> 0 then
        vdu_movecurs(1,prompt_region[this_tp].line_nr);
      vdu_get_input(prompt,prompt_len,outbuf,max_strlen,outlen);
      if tt_controlc then goto 2;
      if outlen = 0 then
        for index := this_tp+1 to max_tp do
          begin
            prompt_region[index].line_nr := 0;
            prompt_region[index].redraw := nil;
          end;
      if (this_tp = max_tp) or (outlen = 0) then
        for index := 1 to max_tp do
          begin
          if prompt_region[index].redraw <> nil then
            screen_draw_line(prompt_region[index].redraw)
          else
          if prompt_region[index].line_nr <> 0 then
            begin
            vdu_movecurs(1,prompt_region[index].line_nr);
            vdu_cleareol;
            end;
          end;
      vdu_flush(false);
      end
    else
      begin
{#if vms}
{##      vms_str_to_dsc(prompt,prompt_len,prompt_dsc);}
{##      vms_str_to_dsc(outbuf,max_strlen,outbuf_dsc);}
{##      vms_check_status(lib$get_input(outbuf_dsc,prompt_dsc,outlen));}
{#else}
      for i := 1 to prompt_len do
        write(prompt[i]);
      outlen := 0;
      while not eoln do
        begin
        outlen := outlen+1;
        read(ch);
        outbuf[outlen] := ch;
        end;
      readln;
{#endif}
      end;
    end;
2:
  if tt_controlc then
    outlen := 0;
  end; {screen_getlinep}


procedure screen_free_bottom_line{};

  label 99;

  begin {screen_free_bottom_line}
  { This routine assumes that the editor is in SCREEN mode.                  }
  { This routine frees the bottom line of the screen for use by the caller.  }
  { The main use of the area is the outputting of messages.                  }
{#if debug}
  if ludwig_mode <> ludwig_screen then
    begin screen_message(dbg_internal_logic_error); goto 99; end;
{#endif}
  if scr_frame = nil then                         { IF SCREEN NOT MAPPED.    }
    begin
    vdu_displaycrlf;
    vdu_deletelines(1,false);
    goto 99;
    end;
  scr_needs_fix := true;
  if (scr_msg_row > terminal_info.height) and   { IF BOTTOM LINE FREE.     }
     (scr_bot_line^.scr_row_nr < terminal_info.height)
  then
    begin
    end
  else
  if (trmflags_v_dlln in tt_capabilities) and     { IF ROOM BELOW BOT LINE.  }
     (scr_bot_line^.scr_row_nr+2 < scr_msg_row)   { +2 because of <eos> line.}
  then
    begin
    vdu_movecurs(1,scr_bot_line^.scr_row_nr+2);
    vdu_deletelines(1,false);
    end
  else
  if scr_top_line^.scr_row_nr <> 1 then           { IF TOP LINE FREE.        }
    begin
    screen_scroll(1,false);
    end
  else
  with scr_bot_line^ do
    begin
    if scr_row_nr+1 < scr_msg_row then            { IF ROOM FOR MORE MSGS.   }
      begin
      if scr_row_nr+2 < scr_msg_row then          { keep <eos> if possible.  }
        vdu_movecurs(1,scr_row_nr+2)
      else
        vdu_movecurs(1,scr_row_nr+1);
      vdu_deletelines(1,false);
      end
    else
    if  (scr_frame^.dot^.line <> scr_top_line)   { IF DOT NOT ON TOP LINE,  }
    and not (   (scr_frame^.dot^.line <> scr_bot_line)
            and (scr_bot_line^.scr_row_nr = terminal_info.height)
            )                                    { AND WE CANT USE THE BOT. }
    then
      begin
      screen_scroll(1,false);
      end
    else
    if scr_msg_row <= terminal_info.height div 2 then { 1/2 SCREEN ALREADY MSGS. }
      begin
      vdu_movecurs(1,scr_msg_row);
      vdu_deletelines(1,false);
      goto 99;
      end
    else
      begin                                      { CONTRACT SCREEN 1 LINE.  }
      scr_row_nr := 0;
      scr_bot_line := blink;
      vdu_movecurs(1,scr_msg_row-1);
      vdu_deletelines(1,false);
      end;
    end;
  scr_msg_row := scr_msg_row-1;
  99:
  end; {screen_free_bottom_line}


function screen_verify (
                prompt     : str_object;
                prompt_len : strlen_range)
        : verify_response;

  { Issue a verify request to the user ... the user is to be shown the }
  { current dot position. }
  label
    99;
  const
    ver_height = 4;
  var
    key        : key_code_range;
    more       : boolean;
    use_prompt : boolean;
    old_height : scr_row_range;
    old_top_m  : scr_row_range;
    old_bot_m  : scr_row_range;
    response   : str_object;
    resp_len   : strlen_range;
    verify     : verify_response;
    i          : integer;
    buffer     : str_object;
{#if turbop}
    tmp_str    : string;
{#endif}

  begin {screen_verify}
  for i := prompt_len + 1 to max_strlen do
    prompt[i] := ' ';
  with current_frame^,dot^ do
    begin
    verify := verify_reply_quit;

    old_height := scr_height;
    old_top_m  := margin_top;
    old_bot_m  := margin_bottom;
    if old_height > ver_height then
      begin
      margin_top    := ver_height div 2;
      scr_height    := ver_height;
      margin_bottom := ver_height div 2;
      end;

    use_prompt := true;
    repeat
      case ludwig_mode of
        ludwig_screen:
          begin
          screen_fixup;
          if use_prompt then
            screen_str_message(prompt)
          else
            begin
{#if turbop}
            tmp_str := 'Reply Y(es),N(o),A(lways),Q(uit),M(ore)';
            move(tmp_str[1], buffer[1], length(tmp_str));
            fillchar(buffer[succ(length(tmp_str))], sizeof(buffer)-length(tmp_str), ' ');
{#else}
{##            buffer := 'Reply Y(es),N(o),A(lways),Q(uit),M(ore)';}
{#endif}
            screen_str_message(buffer);
            end;
          vdu_movecurs(col-scr_offset,line^.scr_row_nr);
          key := vdu_get_key;
          if key in lower_set then
            key := ord(ch_upcase_chr(chr(key)));
          if key = 13 then key := ord('N');     { RETURN <=> NO }
          screen_clear_msgs(false);
          end;
        ludwig_batch,
        ludwig_hardcopy:
          begin
          if use_prompt then
            screen_getlinep(prompt, prompt_len, response, resp_len, 1, 1)
          else
            begin
{#if turbop}
            tmp_str := 'Reply Y(es),N(o),A(lways),Q(uit),M(ore)';
            move(tmp_str[1], buffer[1], length(tmp_str));
            fillchar(buffer[succ(length(tmp_str))], sizeof(buffer)-length(tmp_str), ' ');
{#else}
{##            buffer := 'Reply Y(es),N(o),A(lways),Q(uit),M(ore)';}
{#endif}
            screen_getlinep(buffer,39,
                            response, resp_len, 1, 1);
            end;
          if resp_len = 0 then key := ord('N')
          else key := ord(ch_upcase_chr(response[1]));
          end;
      end{case};
      if tt_controlc then goto 99;
      more := false;
      if key in [ord(' '), ord('Y'), ord('N'), ord('A'), ord('Q'), ord('1')..ord('9'), ord('M')] then
        case chr(key) of
          ' ',                                {default for yes on Tops 20;CJB}
          'Y' : verify := verify_reply_yes;
          'N' : verify := verify_reply_no;
          'A' : verify := verify_reply_always;
          'Q' : verify := verify_reply_quit;
          '1','2','3','4','5','6','7','8','9',
          'M' : begin { MORE CONTEXT PLEASE! }
                {How much is user getting now?}
                if scr_top_line <> nil then
                scr_height := scr_bot_line^.scr_row_nr+1
                               -scr_top_line^.scr_row_nr;
                {How much more does he want?}
                if key = ord('M') then key := ord('1');
                if key-ord('0')+scr_height < terminal_info.height then
                  scr_height := scr_height+key-ord('0')
                else
                  scr_height := terminal_info.height;
                if scr_top_line = nil then
                  screen_load(line,col)
                else
                  screen_expand(true,true);
                more := true;
                use_prompt := true;
                end;
        end{case}
      else
        begin
        vdu_beep;
        more := true;
        use_prompt := false;
        end;
    until not more;
99:

    scr_height    := old_height;
    margin_top    := old_top_m;
    margin_bottom := old_bot_m;

    if verify = verify_reply_quit then exit_abort := true;
    screen_verify := verify;
    end{with};

  end; {screen_verify}


procedure screen_beep{};

  {Beep the terminal bell.}

  begin {screen_beep}
  case ludwig_mode of
    ludwig_screen  : vdu_beep;
    ludwig_hardcopy: writeln(chr(7));
    ludwig_batch   : writeln('LUDWIG RINGS TERMINAL BELL <beep>!');
  end{case};
  end; {screen_beep}


procedure screen_home (
                clear:boolean);

  {If screen editing home the cursor, otherwise do a 'nice' equivalent.      }

  begin {screen_home}
  if ludwig_mode = ludwig_screen then
    begin
    if clear then
      begin
      vdu_clearscr;
      scr_msg_row := terminal_info.height+1;
      end
    else
      vdu_movecurs(1,1);
    end
  else
    begin
    writeln;
    writeln;
    end;
  end; {screen_home}


procedure screen_write_int (
                int   : integer;
                width : scr_col_range);

  {Write an integer at the current cursor position, or to the output file.}
{#if vms}
{##  type}
{##    number_string = packed array[1..20] of char;}
{#endif}
  var
    i   : integer;
{#if vms}
{##    str : number_string;}
{#else}
    str : str_object;
{#endif}
    buffer : str_object;
{#if turbop}
    tmp_str : string;
{#endif}

  begin {screen_write_int}
  if ludwig_mode = ludwig_screen then
    begin
{#if vms}
{##    vms_check_status(ots$cvt_l_ti(int,str));  #< Convert integer to text.     #>}
{##    if width>19 then                          #< Do any extra width.          #>}
{##      begin}
{##      for i := width-19 downto 0 do vdu_displaych(' ');}
{##      width := 19;}
{##      end;}
{##    i := width;                               #< Adjust width so big enough.  #>}
{##    while str[20-i] <> ' ' do i := i+1;}
{##    for i := 21-i to 20 do vdu_displaych(str[i]);}
{#else}
    if not cvt_int_str(int,str,width) then
      begin
{#if turbop}
      tmp_str := 'Integer conversion failed.';
      move(tmp_str[1], buffer[1], length(tmp_str));
      fillchar(buffer[succ(length(tmp_str))], sizeof(buffer)-length(tmp_str), ' ');
{#else}
{##      buffer := 'Integer conversion failed.';}
{#endif}
      screen_str_message(buffer);
      end;
    i := 1;
    while (ord(str[i])<>0) do
      begin
      vdu_displaych(str[i]);
      i := i+1;
      end;
{#endif}
    end
  else
    write(int:width);
  end; {screen_write_int}


procedure screen_write_ch (
                indent : scr_col_range;
                ch     : char);

  {Write a character at the current cursor position, or to the output file.}
  var
    i : integer;

  begin {screen_write_ch}
  if ludwig_mode = ludwig_screen then
    begin
    for i := 1 to indent do vdu_displaych(' ');
    vdu_displaych(ch);
    end
  else
    begin
    for i := 1 to indent do write(' ');
    write(ch);
    end;
  end; {screen_write_ch}


{#if vms}
{##procedure screen_write_str #<(}
{##                indent : scr_col_range;}
{##                str    : packed array [l1..h1:strlen_range] of char;}
{##                width  : scr_col_range)#>;}
{#elseif unix}
{##procedure screen_write_str #<(}
{##                indent : scr_col_range;}
{##                str    : write_str;}
{##                width  : scr_col_range)#>;}
{#elseif turbop}
procedure screen_write_str (
                indent : scr_col_range;
                str    : string;
                width  : scr_col_range);
{#endif}

  {Write a string at the current cursor position, or to the output file.}
  var
    i : integer;

  begin {screen_write_str}
  if ludwig_mode = ludwig_screen then
    begin
    for i := 1 to indent do vdu_displaych(' ');
    for i := 1 to width  do
      vdu_displaych(str[i]);
    end
  else
    begin
    for i := 1 to indent do write(' ');
    for i := 1 to width do
      write(str[i]);
    end;
  end; {screen_write_str}


procedure screen_write_name_str (
                indent : scr_col_range;
                str    : name_str;
                width  : scr_col_range);

  {Write a name string at the current cursor position, or to the output file.}
  var
    i : integer;

  begin {screen_write_name_str}
  if ludwig_mode = ludwig_screen then
    begin
    for i := 1 to indent do vdu_displaych(' ');
    for i := 1 to width  do
      if i <= name_len then
        vdu_displaych(str[i])
      else
        vdu_displaych(' ');
    end
  else
    begin
    for i := 1 to indent do write(' ');
    for i := 1 to width do
      if i <= name_len then
        write(str[i])
      else
        write(' ');
    end;
  end; {screen_write_name_str}


procedure screen_write_file_name_str (
                indent : scr_col_range;
                str    : file_name_str;
                width  : scr_col_range);

  {Write a file name at the current cursor position, or to the output file.}
  var
    i : integer;

  begin {screen_write_file_name_str}
  if ludwig_mode = ludwig_screen then
    begin
    for i := 1 to indent do vdu_displaych(' ');
    for i := 1 to width  do
      if i <= file_name_len then
        vdu_displaych(str[i])
      else
        vdu_displaych(' ');
    end
  else
    begin
    for i := 1 to indent do write(' ');
    for i := 1 to width do
      if i <= file_name_len then
        write(str[i])
      else
        write(' ');
    end;
  end; {screen_write_file_name_str}


procedure screen_writeln{};

  {Write a CRLF to the output file.}

  begin {screen_writeln}
  if ludwig_mode = ludwig_screen then
    vdu_displaycrlf
  else
    writeln;
  end; {screen_writeln}


procedure screen_writeln_clel{};

  {Write a CLEAR_EOL, CRLF to the output file.}

  begin {screen_writeln_clel}
  if ludwig_mode = ludwig_screen then
    begin
    vdu_cleareol;
    vdu_displaycrlf;
    end
  else
    writeln;
  end; {screen_writeln_clel}


{#if unix or turbop}
procedure screen_help_prompt (
                prompt     : write_str;
                prompt_len : strlen_range;
        var     reply      : key_str;
        var     reply_len  : integer);

  var
    key        : key_code_range;
    terminated : boolean;

  begin {screen_help_prompt}
  case ludwig_mode of
    ludwig_screen,
    ludwig_hardcopy:
      begin
      screen_write_str(0,prompt,prompt_len);
      reply_len := 0;
      terminated := false;
      repeat
        key := vdu_get_key;
        if key = 13 then
          terminated := true
        else if key = 127 then
          begin
          if reply_len > 0 then
            begin
            reply_len := reply_len - 1;
            vdu_displaych(chr(8));
            vdu_displaych(' ');
            vdu_displaych(chr(8));
            end
          end
        else if key in printable_set then
          begin
          vdu_displaych(chr(key));
          reply_len := reply_len + 1;
          reply[reply_len] := chr(key);
          terminated := (key = ord(' ')) or (reply_len = key_len);
          end;
      until terminated;
      screen_writeln;
      end;
    ludwig_batch:
      reply_len := 0;
  end{case};
  end; {screen_help_prompt}
{#endif}

{#if vms or turbop}
end.
{#endif}
