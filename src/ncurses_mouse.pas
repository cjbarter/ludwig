{**********************************************************************}
{                                                                      }
{            L      U   U   DDDD   W      W  IIIII   GGGG              }
{            L      U   U   D   D   W    W     I    G                  }
{            L      U   U   D   D   W ww W     I    G   GG             }
{            L      U   U   D   D    W  W      I    G    G             }
{            LLLLL   UUU    DDDD     W  W    IIIII   GGGG              }
{                                                                      }
{**********************************************************************}
{                                                                      }
{   Copyright (C) 2020                                                 }
{   Jeff Blows, Sydney, Australia                                      }
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
{                                                                      }
{**********************************************************************}

{++
! Name:         NCURSES_MOUSE
!
! Description:  This module implements the commands to support
!               mouse interaction.
!               This is the Free Pascal version.
!
! $Header$
!--}

{#if fpc}
unit ncurses_mouse;

interface
  uses value, vdu, screen, mark;
 {$I ncurses_mouse.i}

implementation
uses
  ncurses, termio, strings, sysUtils;

{++
! Brief: Match the key event and take action for
!          - button1_clicked
!          - button1_pressed
!          - button1_released
!          - button1_double_clicked
!          - button1_triple_clicked
!        There is no support for button2 and higher.
!--}

{}function handle_ncurses_mouse_event : boolean;

var
  event        : MEVENT;
  msg_string   : string;
  lines_on_scr : integer;
  new_line_row : integer;
  new_line     : line_ptr;

begin {handle_ncurses_mouse_event}
    if ludwig_mode = ludwig_screen then
      begin
          getmouse(@event);
          { can I use a switch? }
          if (((event.bstate AND BUTTON1_CLICKED) <> 0) OR ((event.bstate AND BUTTON1_RELEASED) <> 0)) then
          begin
            lines_on_scr := scr_bot_line^.scr_row_nr+1-scr_top_line^.scr_row_nr;
            if (lines_on_scr-1 <= event.y) then
              begin
                { past end of file or page marker - do nothing }
                vdu_beep;
              end
            else
              begin
                { move to the x,y position relative to the screen }
                new_line_row := event.y;
                new_line := scr_top_line;
                while (new_line_row > 0) do
                  begin
                    new_line_row := new_line_row - 1;
                    new_line := new_line^.flink;
                  end;
                mark_create(new_line,event.x+1,current_frame^.dot)
              end;
          end;
{--
-          msg_string := format('X %d, Y %d', [event.x, event.y]);
-          screen_message(msg_string);
--}
          handle_ncurses_mouse_event := true;
      end;
end; {handle_ncurses_mouse_event}

end.
