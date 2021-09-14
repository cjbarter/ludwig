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
{  Copyright  1979-81, 1987, 1989 University of Adelaide               }
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
! Name:         MARK
!
! Description:  Mark manipulation routines.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/mark.pas,v 4.5 1990/01/18 17:46:11 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: mark.pas,v $
! Revision 4.5  1990/01/18 17:46:11  ludwig
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
!       Remove the superfluous include of system.h.
!--}

{#if vms}
{##[ident('4-005'),}
{## overlaid]}
{##module mark (output);}
{#elseif turbop}
unit mark;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'mark.fwd'}
{##%include 'screen.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "mark.h"}
{####include "screen.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=mark.h#>}
{###<$F=screen.h#>}
{#elseif turbop}
interface
  uses value;
  {$I mark.i}

implementation
  uses screen;
{#endif}


{}procedure mark_mark_pool_extend;

    var
      new_mark : mark_ptr;
      i        : integer;

    begin {mark_mark_pool_extend}
    for i := 1 to 20 do
      begin
      new(new_mark);
      new_mark^.next := free_mark_pool;
      free_mark_pool := new_mark;
      end;
    end; {mark_mark_pool_extend}


function mark_create (
                in_line : line_ptr;
                column  : col_range;
        var     mark    : mark_ptr)
        : boolean;

  { Purpose  : Create or move a mark.
    Inputs   : line: the line to be marked.
               column: the column in the line to be marked.
               mark: nil, or a pointer to an existing mark.
    Outputs  : mark: a pointer to the created mark.
    Bugchecks: .in_line pointer is nil
  }
{#if debug}
  label 99;
{#endif}
  var
    this_mark, prev_mark : mark_ptr;
    this_line : line_ptr;

  begin {mark_create}
  mark_create := false;
{#if debug}
  if in_line = nil then
    begin screen_message(dbg_line_ptr_is_nil); goto 99; end;
{#endif}
  if mark = nil then
    begin
    if free_mark_pool = nil then
      mark_mark_pool_extend;
    mark           := free_mark_pool;
    free_mark_pool := mark^.next;
    with mark^ do
      begin
      next := in_line^.mark;
      line := in_line;
      col := column;
      end;
    in_line^.mark := mark;
    end
  else
    begin
    this_line := mark^.line;
    if this_line = in_line then
      mark^.col := column
    else
      begin
      this_mark := this_line^.mark;
      prev_mark := nil;
      while this_mark <> mark do
        begin
        prev_mark := this_mark;
        this_mark := this_mark^.next;
        end;
      if prev_mark = nil then
        this_line^.mark := this_mark^.next
      else
        prev_mark^.next := this_mark^.next;
      with mark^ do
        begin
        next := in_line^.mark;
        line := in_line;
        col := column;
        end;
      in_line^.mark := mark;
      end;
    end;
  mark_create := true;
{#if debug}
  99:
{#endif}
  end; {mark_create}


function mark_destroy (
        var     mark : mark_ptr)
        : boolean;

  { Purpose  : Destroy a mark.
    Inputs   : mark: the mark to be destroyed.
    Outputs  : mark: nil.
    Bugchecks: .mark pointer is nil
  }
{#if debug}
  label 99;
{#endif}
  var
    this_mark, prev_mark : mark_ptr;
    this_line : line_ptr;

  begin {mark_destroy}
  mark_destroy := false;
{#if debug}
  if mark = nil then
    begin screen_message(dbg_mark_ptr_is_nil); goto 99; end;
{#endif}
  this_line := mark^.line;
  this_mark := this_line^.mark;
  prev_mark := nil;
  while this_mark <> mark do
    begin
    prev_mark := this_mark;
    this_mark := this_mark^.next;
    end;
  if prev_mark = nil then
    this_line^.mark := this_mark^.next
  else
    prev_mark^.next := this_mark^.next;
  mark^.next     := free_mark_pool;
  free_mark_pool := mark;
  mark           := nil;
  mark_destroy   := true;
{#if debug}
  99:
{#endif}
  end; {mark_destroy}


function marks_squeeze (
                first_line   : line_ptr;
                first_column : col_range;
                last_line    : line_ptr;
                last_column  : col_range)
        : boolean;

  { Purpose  : Move all marks between <first_line,first_column> and
               <last_line,last_column> to the latter position.
    Inputs   : first_line, first_column: the beginning of the range.
               last_line, last_column: the end of the range.
    Outputs  : none.
    Bugchecks: .first or last line pointer is nil
               .first column > last column when in same line
               .first and last lines in different frames
               .first line > last line
  }
{#if debug}
  label 99;
{#endif}
  var
    this_mark, prev_mark, next_mark : mark_ptr;
    this_line : line_ptr;

  begin {marks_squeeze}
  marks_squeeze := false;
{#if debug}
  if (first_line = nil) or (last_line = nil) then
    begin screen_message(dbg_line_ptr_is_nil); goto 99; end;
{#endif}
  if first_line = last_line then
    begin
{#if debug}
    if first_column > last_column then
      begin screen_message(dbg_first_follows_last); goto 99; end;
{#endif}
    this_mark := last_line^.mark;
    while this_mark <> nil do
      begin
      with this_mark^ do
        begin
        if (col >= first_column) and (col < last_column) then
          col := last_column;
        this_mark := next;
        end;
      end;
    end
  else
    begin
{#if debug}
    if first_line^.group^.frame <> last_line^.group^.frame then
      begin screen_message(dbg_lines_from_diff_frames); goto 99; end;
    if first_line^.group^.first_line_nr + first_line^.offset_nr >
         last_line^.group^.first_line_nr + last_line^.offset_nr then
      begin screen_message(dbg_first_follows_last); goto 99; end;
{#endif}
    { Move marks in last_line. }
    this_mark := last_line^.mark;
    while this_mark <> nil do
      begin
      with this_mark^ do
        begin
        if col < last_column then
          col := last_column;
        this_mark := next;
        end;
      end;
    { Move marks in lines first_line..last_line-1. }
    this_line := first_line;
    while this_line <> last_line do
      begin
      this_mark := this_line^.mark;
      prev_mark := nil;
      while this_mark <> nil do
        begin
        with this_mark^ do
          begin
          next_mark := next;
          if col >= first_column then
            begin
            if prev_mark = nil then
              this_line^.mark := next
            else
              prev_mark^.next := next;
            next := last_line^.mark;
            line := last_line;
            col := last_column;
            last_line^.mark := this_mark;
            end
          else
            prev_mark := this_mark;
          end;
        this_mark := next_mark;
        end;
      this_line := this_line^.flink;
      first_column := 1;
      end;
    end;
  marks_squeeze := true;
{#if debug}
  99:
{#endif}
  end; {marks_squeeze}


function marks_shift (
                source_line   : line_ptr;
                source_column : col_range;
                width         : col_width_range;
                dest_line     : line_ptr;
                dest_column   : col_range)
        : boolean;

  { Purpose  : Move all marks from the <width> columns starting at
               <source_line,source_column> to corresponding positions
               starting from <dest_line,dest_column>.
    Inputs   : source_line, source_column: location of the source range.
               width: the size of the range.
               last_line, last_column: location of the destination range.
    Outputs  : none.
    Bugchecks: .source or dest line pointer is nil
               .source and dest lines in different frames
               .source ranges exceed maximum line length
  }
{#if debug}
  label 99;
{#endif}
  var
    new_col    : integer;
    source_end : col_range;
    offset : integer;
    this_mark, prev_mark, next_mark : mark_ptr;

  begin {marks_shift}
  marks_shift := false;
{#if debug}
  if (source_line = nil) or (dest_line = nil) then
    begin screen_message(dbg_line_ptr_is_nil); goto 99; end;
  if width = 0 then
    begin screen_message(dbg_invalid_offset_nr); goto 99; end;
  if (source_column + width - 1 > max_strlenp) then
    begin screen_message(dbg_invalid_column_number); goto 99; end;
{#endif}
  source_end := source_column + width - 1;
  offset := dest_column - source_column;
  if source_line = dest_line then
    begin
    this_mark := source_line^.mark;
    while this_mark <> nil do
      begin
      with this_mark^ do
        begin
        if (col >= source_column) and (col <= source_end) then
          begin
          new_col := col + offset;
          if new_col >= max_strlenp then
            col := max_strlenp
          else
            col := new_col;
          end;
        this_mark := next;
        end;
      end;
    end
  else
    begin
{#if debug}
    if source_line^.group^.frame <> dest_line^.group^.frame then
      begin screen_message(dbg_lines_from_diff_frames); goto 99; end;
{#endif}
    this_mark := source_line^.mark;
    prev_mark := nil;
    while this_mark <> nil do
      begin
      with this_mark^ do
        begin
        next_mark := next;
        if (col >= source_column) and (col <= source_end) then
          begin
          if prev_mark = nil then
            source_line^.mark := next
          else
            prev_mark^.next := next;
          next := dest_line^.mark;
          line := dest_line;
          new_col := col + offset;
          if new_col >= max_strlenp then
            col := max_strlenp
          else
            col := new_col;
          dest_line^.mark := this_mark;
          end
        else
          prev_mark := this_mark;
        end;
      this_mark := next_mark;
      end;
    end;
  marks_shift := true;
{#if debug}
  99:
{#endif}
  end; {marks_shift}

{#if vms or turbop}
end.
{#endif}
