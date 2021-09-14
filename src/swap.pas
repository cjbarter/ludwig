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
{       Martin Sandiford (1991, 2002, 2008, 2018)                      }
{                                                                      }
{  Copyright  1981, 1987, 1989 University of Adelaide                  }
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
! Name:         SWAP
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/swap.pas,v 4.5 1990/01/18 17:31:21 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: swap.pas,v $
! Revision 4.5  1990/01/18 17:31:21  ludwig
! Entered into RCS at revision level 4.5
!
!
!
! Description:  Swap Line command.
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
{##module swap (output);}
{#elseif turbop}
unit swap;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'swap.fwd'}
{##%include 'mark.h'}
{##%include 'text.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "swap.h"}
{####include "mark.h"}
{####include "text.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=swap.h#>}
{###<$F=mark.h#>}
{###<$F=text.h#>}
{#elseif turbop}
interface
  uses value;
  {$I swap.i}

implementation
  uses mark, text;
{#endif}


function swap_line (
                rept  : leadparam;
                count : integer)
        : boolean;

  { SW is implemented as a ST of the dot line to before the other line. }
  label 99;
  var
    this_line, next_line, dest_line : line_ptr;
    top_mark, end_mark, dest_mark : mark_ptr;
    dot_col : col_range;
    i : integer;

  begin {swap_line}
  swap_line := false;
  top_mark := nil; end_mark := nil; dest_mark := nil;
  with current_frame^ do
    begin
    this_line := dot^.line;
    next_line := this_line^.flink;
    if next_line = nil then goto 99;
    dot_col := dot^.col;
    case rept of
      none,plus,pint:
        begin
        dest_line := next_line;
        for i := 1 to count do
          begin
          dest_line := dest_line^.flink;
          if dest_line = nil then goto 99;
          end;
        end;
      minus,nint:
        begin
        dest_line := this_line;
        for i := -1 downto count do
          begin
          dest_line := dest_line^.blink;
          if dest_line = nil then goto 99;
          end;
        end;
      pindef:
        begin
        dest_line := last_group^.last_line;
        end;
      nindef:
        begin
        dest_line := first_group^.first_line;
        end;
      marker:
        begin
        dest_line := marks[count]^.line;
        end;
    end{case};
    if not mark_create(this_line,1,top_mark) then goto 99;
    if not mark_create(next_line,1,end_mark) then goto 99;
    if not mark_create(dest_line,1,dest_mark) then goto 99;
    if not text_move(false,1,top_mark,end_mark,dest_mark,dot,top_mark)
    then goto 99;
    text_modified := true;
    dot^.col := dot_col;
    if not mark_create(dot^.line,dot^.col,marks[mark_modified]) then goto 99;
    end;
  swap_line := true;
99:
  if top_mark <> nil then if not mark_destroy(top_mark) then ;
  if end_mark <> nil then if not mark_destroy(end_mark) then ;
  if dest_mark <> nil then if not mark_destroy(dest_mark) then ;
  end; {swap_line}

{#if vms or turbop}
end.
{#endif}
