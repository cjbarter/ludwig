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
! Name:         NEXTBRIDGE
!
! Description:  The NEXT and BRIDGE commands.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/nextbridge.pas,v 4.6 1990/01/18 17:44:20 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: nextbridge.pas,v $
! Revision 4.6  1990/01/18 17:44:20  ludwig
! Entered into RCS at revision level 4.6
!
!
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Jeff Blows                                           15-May-1987
!       Add conditional code to bypass a compiler problem on the Unity.
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
{##module nextbridge (output);}
{#elseif turbop}
unit nextbridge;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'nextbridge.fwd'}
{##%include 'mark.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "nextbridge.h"}
{####include "mark.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=nextbridge.h#>}
{###<$F=mark.h#>}
{#elseif turbop}
interface
  uses value;
  {$I nextbridge.i}

implementation
  uses mark;
{#endif}


function nextbridge_command (
                rept      : leadparam;
                count     : integer;
                tpar      : tpar_object;
                bridge    : boolean)
        : boolean;

  label 1,2,99;
  var
    i        : integer;
    new_col  : integer;
    new_line : line_ptr;
    ch1,ch2  : char;
    chars    : set of char;

  begin {nextbridge_command}
  nextbridge_command := false;
  chars := [];
  { Form the character set. }
  with tpar do
    begin
    i := 1;
    while i <= len do
      begin
      ch1 := str[i]; ch2 := ch1; i := i+1;
      if i+2 <= len then
        if (str[i] = '.') and (str[i+1] = '.') then
          begin ch2 := str[i+2]; i := i+3; end;
      chars := chars+[ch1..ch2];
      end;
    end;
{#if unity }
{##  ch1 := chr(0);}
{##  ch2 := chr(ord_maxchar);}
{##  if bridge then chars := [ch1..ch2]-chars;}
{#else }
  if bridge then chars := [chr(0)..chr(ord_maxchar)]-chars;
{#endif }
  { Search for a character in the set. }
  with current_frame^ do
    begin
    new_line := dot^.line;
    if count > 0 then
      begin
      new_col := dot^.col;
      if not bridge then new_col := new_col+1;
      repeat
        while new_line <> nil do
          with new_line^ do
            begin
            i := new_col;
            while i <= used do
              begin
              if str^[i] in chars then
                begin
                new_col := i;
                goto 1;
                end;
              i := i+1;
              end;
            if ' ' in chars then              { Match a space at EOL. }
            if i = used+1 then
              begin
              new_col := i;
              goto 1;
              end;
            new_line := flink;
            new_col := 1;
            end;
        goto 99;
      1:
        new_col := new_col+1;
        count := count-1;
      until count=0;
      new_col := new_col-1;
      if not mark_create(dot^.line,dot^.col,marks[mark_equals]) then
        goto 99;
      end
    else
    if count < 0 then
      begin
      new_col := dot^.col-1;
      if not bridge then new_col := new_col-1;
      repeat
        while new_line <> nil do
          with new_line^ do
            begin
            if used < new_col then
              begin
              if ' ' in chars then goto 2;
              new_col := used;
              end;
            for i := new_col downto 1 do
              if str^[i] in chars then
                begin
                new_col := i;
                goto 2;
                end;
            if blink <> nil then
              begin
              new_line := blink;
              new_col := new_line^.used+1;
              end
            else if bridge then
              goto 2 { This is safe since only -1BR is allowed }
            else
              goto 99;
            end;
        goto 99;
      2:
        new_col := new_col-1;
        count := count+1;
      until count = 0;
      new_col := new_col+2;
      if not mark_create(dot^.line,dot^.col,marks[mark_equals]) then
        goto 99;
      end
    else
      begin
      nextbridge_command := mark_create(dot^.line,dot^.col,marks[mark_equals]);
      goto 99;
      end;
    { Found it, move dot to new point. }
    nextbridge_command := mark_create(new_line,new_col,dot);
    end;
 99:
  end; {nextbridge_command}

{#if vms or turbop}
end.
{#endif}
