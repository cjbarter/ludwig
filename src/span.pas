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
! Name:         SPAN
!
! Description:  Creation/destruction, manipulation of spans.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/span.pas,v 4.5 1990/01/18 17:32:37 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: span.pas,v $
! Revision 4.5  1990/01/18 17:32:37  ludwig
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
{##module span (output);}
{#elseif turbop}
unit span;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'span.fwd'}
{##%include 'ch.h'}
{##%include 'code.h'}
{##%include 'fyle.h'}
{##%include 'line.h'}
{##%include 'mark.h'}
{##%include 'screen.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "span.h"}
{####include "ch.h"}
{####include "code.h"}
{####include "fyle.h"}
{####include "line.h"}
{####include "mark.h"}
{####include "screen.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=span.h#>}
{###<$F=ch.h#>}
{###<$F=code.h#>}
{###<$F=fyle.h#>}
{###<$F=line.h#>}
{###<$F=mark.h#>}
{###<$F=screen.h#>}
{#elseif turbop}
interface
  uses value;
  {$I span.i}

implementation
  uses ch, code, fyle, line, mark, screen;
{#endif}


function span_find (
                span_name : name_str;
        var     ptr,
                oldp      : span_ptr)
        : boolean;

  {***************************************************************************
  *    D E S C R I P T I O N :-                                              *
  * Input   : span_name                                                      *
  * Output  : ptr                                                            *
  * Purpose : Finds a span of the specified name.  Returns a pointer to the  *
  *           entry if the span table if found.  If the span is a frame then *
  *           reset the frame's two marks.                                   *
  * Errors  : Fails if span not found.                                       *
  ***************************************************************************}
  label 99;

  begin {span_find}
  span_find := false;
  oldp := nil;
  ptr  := first_span;
  if ptr = nil then goto 99;
  while ptr^.name < span_name do
    begin
    oldp := ptr;
    ptr  := ptr^.flink;
    if ptr = nil then goto 99;
    end;
  with ptr^ do
    if name = span_name then
      begin
      span_find := true;
      if frame <> nil then
        with frame^ do
          if (not mark_create(first_group^.first_line,1,mark_one))
          or (not mark_create(last_group ^.last_line ,1,mark_two))
          then span_find := false;
      end;
99:
  end; {span_find}


function span_create (
                span_name : name_str;
                first_mark,
                last_mark : mark_ptr)
        : boolean;

  {***************************************************************************
  *    D E S C R I P T I O N :-                                              *
  * Input   : span_name, first_mark & last_mark                              *
  * Purpose : Creates a span of the specified name over the specified        *
  *           range of lines. Checks first that a span of this name doesn't  *
  *           already exist. If it does, it re-defines it                    *
  * Errors  : Fails if span already exists and is a frame                    *
  ***************************************************************************}
  label 99;
  var
    line_nr_first,
    line_nr_last   : line_range;
    oldp,
    p,ptr          : span_ptr;
    mrk1,mrk2      : mark_ptr;

  begin {span_create}
  span_create := false;
  if span_find(span_name,p,oldp) then
    begin
    if p^.frame <> nil then
      begin screen_message(msg_frame_of_that_name_exists); goto 99; end;
    ptr := p;
    with ptr^ do
      begin
      if code <> nil then code_discard(code);
      mrk1 := mark_one;
      mrk2 := mark_two;
      end
    end
  else
    begin
    mrk1 := nil;
    mrk2 := nil;
    new(ptr);
    with ptr^ do
      begin
      name := span_name;
      code := nil;
      { Now hook the span into the span structure }
      if p = nil then
        flink := nil
      else
        begin
        flink    := p;
        p^.blink := ptr;
        end;
      if oldp = nil then
        begin
        blink      := nil;
        first_span := ptr;
        end
      else
        begin
        blink       := oldp;
        oldp^.flink := ptr;
        end;
      end;
    end;
  with first_mark^ do if not mark_create(line,col,mrk1) then goto 99;
  with last_mark^  do if not mark_create(line,col,mrk2) then goto 99;
  if line_to_number(mrk1^.line,line_nr_first) and
     line_to_number(mrk2^.line,line_nr_last)
  then
    with ptr^ do
      begin
      frame    := nil;
      if (line_nr_first < line_nr_last)    or
        ((line_nr_first = line_nr_last)    and
         (mrk1^.col < mrk2^.col))
      then { Marks are in the right order }
        begin
        mark_one := mrk1;
        mark_two := mrk2;
        end
      else { Marks are in reverse order }
        begin
        mark_one := mrk2;
        mark_two := mrk1;
        end;
      span_create := true;
      end;
  99:
  end; {span_create}


function span_destroy (
        var     span : span_ptr)
        : boolean;

  {***************************************************************************
  *    D E S C R I P T I O N :-                                              *
  * Input   : span                                                           *
  * Output  : span set to nil                                                *
  * Purpose : Destroys the specified span.                                   *
  * Errors  : Fails if span is not destroyed.                                *
  ***************************************************************************}
  label 99;

  begin {span_destroy}
  span_destroy := false;
  with span^ do
    begin
    if frame <> nil then
      begin screen_message(msg_cant_kill_frame); goto 99; end;
    if code <> nil then code_discard(code);
    if blink <> nil then
      blink^.flink := flink
    else
      first_span := flink;
    if flink <> nil then flink^.blink := blink;
    if mark_destroy(mark_one) then
      begin
      if mark_destroy(mark_two) then
        begin
        dispose(span);
        span := nil;
        span_destroy := true;
        goto 99;
        end;
      end;
    end;
{#if debug}
  screen_message(dbg_span_not_destroyed);
{#endif}
  99:
  end; {span_destroy}


function span_index
        : boolean;

  {***************************************************************************
  *    D E S C R I P T I O N :-                                              *
  * Input   : <none>                                                         *
  * Output  : <none>                                                         *
  * Purpose : Displays the list of spans. This is the \SI command.           *
  * Errors  : Fails something terrible happens.                              *
  ***************************************************************************}
  var
    p          : span_ptr;
    continue,
    have_span,
    first_time : boolean;
    line_count,
    fyl_nam_len,
    old_count  : integer;
    span_start : name_str;
    fyl_nam    : file_name_str;

  begin {span_index}
  span_index := true; {It can never fail....}
  screen_unload;
  screen_home(true);
  p := first_span;
  have_span := false;
  screen_writeln;
  screen_write_str(0,'Spans',5);
  screen_writeln;
  screen_write_str(0,'=====',5);
  screen_writeln;
  line_count := 3;
  while p <> nil do
    begin
    if p^.frame = nil then
      begin
      have_span := true;
      if line_count > terminal_info.height - 2 then
        begin
        screen_pause;
        screen_home(true);
        screen_writeln;
        screen_write_str(0,'Spans',5);
        screen_writeln;
        screen_write_str(0,'=====',5);
        screen_writeln;
        line_count := 3;
        end;
      screen_write_name_str(0,p^.name,name_len);
      screen_write_str(0,' : ',3);
      with p^,mark_one^,line^ do
        begin
        continue := mark_one^.line <> mark_two^.line;
        if col <= used then
          if not continue then
            begin
            continue := mark_two^.col-col > name_len;
{#if ISO1}
            ch_copy(str^,col,mark_two^.col-col,span_start,1,name_len,' ');
{#else}
{##            ch_copy_str_name(str^,col,mark_two^.col-col,span_start,1,name_len,' ');}
{#endif}
            end
          else
{#if ISO1}
            ch_copy(str^,col,used+1-col,span_start,1,name_len,' ')
{#else}
{##            ch_copy_str_name(str^,col,used+1-col,span_start,1,name_len,' ')}
{#endif}
        else
{#if ISO1}
          ch_fill(span_start,1,name_len,' ');
{#else}
{##          ch_fill_name(span_start,1,name_len,' ');}
{#endif}
        screen_write_name_str(0,span_start,name_len);
        if continue then
          screen_write_str(1,'...',3);
        end;
      screen_writeln;
      line_count := line_count + 1;
      end;
    p := p^.flink;
    end;
  if not have_span then
    begin
    screen_write_str(10,'<none>',6);
    screen_writeln;
    line_count := line_count + 1;
    end;
  p          := first_span;
  first_time := true;
  old_count  := line_count;
  line_count := terminal_info.height;
  while p <> nil do
    begin
    if p^.frame <> nil then
      begin
      if line_count > terminal_info.height - 2 then
        begin
        if not first_time then
          begin
          screen_pause;
          screen_home(true);
          end;
        screen_writeln;
        screen_write_str(0,'Frames',6);
        screen_writeln;
        screen_write_str(0,'======',6);
        screen_writeln;
        if first_time then
          begin
          line_count := old_count + 3;
          first_time := false;
          end
        else
          line_count := 3;
        end;
      screen_write_name_str(0,p^.name,name_len);
      screen_writeln;
      line_count := line_count + 1;
      with p^.frame^ do
        begin
        if input_file <> 0 then
          begin
          screen_write_str(0,'  Input:  ',10);
          file_name(files[input_file],70,fyl_nam,fyl_nam_len);
          screen_write_file_name_str(0,fyl_nam,fyl_nam_len);
          screen_writeln;
          line_count := line_count + 1;
          end;
        if output_file <> 0 then
          begin
          screen_write_str(0,'  Output: ',10);
          file_name(files[output_file],70,fyl_nam,fyl_nam_len);
          screen_write_file_name_str(0,fyl_nam,fyl_nam_len);
          screen_writeln;
          line_count := line_count + 1;
          end;
        end;
      end;
    p := p^.flink;
    end;
  screen_pause;
  end; {span_index}

{#if vms or turbop}
end.
{#endif}
