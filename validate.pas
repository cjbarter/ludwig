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
{       Kelvin B. Nicolle (1987, 1989-90); and                         }
{       Jeff Blows (1989).                                             }
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
! Name:         VALIDATE
!
! Description:  Validation of entire Ludwig data structure.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/validate.pas,v 4.6 1990/10/19 14:35:30 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: validate.pas,v $
! Revision 4.6  1990/10/19 14:35:30  ludwig
! Make body of validate_command conditional on debug flag.  KBN
!
! Revision 4.5  90/01/18  17:16:22  ludwig
! Entered into RCS at revision level 4.5
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
{##[ident('4-006'),}
{## overlaid]}
{##module validate (output);}
{#elseif turbop}
unit validate;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'validate.fwd'}
{##%include 'screen.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "validate.h"}
{####include "screen.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=validate.h#>}
{###<$F=screen.h#>}
{#elseif turbop}
interface
  uses value;
  {$I validate.i}

implementation
  uses screen;
{#endif}


function validate_command 
	: boolean;

  { Purpose  : Validate the data structure.
    Inputs   : none.
    Outputs  : none.
    Bugchecks: .lots and lots of them!
  }
  label 99;
  var
    this_span, prev_span : span_ptr;
    this_frame : frame_ptr;
    this_group, prev_group, end_group : group_ptr;
    this_line, prev_line, end_line : line_ptr;
    line_nr : line_range;
    line_count : group_line_range;
    this_mark : mark_ptr;
    mark_nr : mark_range;
    scr_row : scr_row_range;
    frame_list : set of (oops,cmd,heap);

  begin {validate_command}
{#if debug}
  validate_command := false;

  if (current_frame = nil) or (frame_oops = nil) or (frame_cmd = nil)
  or (frame_heap = nil)
  then
    begin screen_message(dbg_invalid_frame_ptr); goto 99; end;

  if first_span = nil then
    begin screen_message(dbg_invalid_span_ptr); goto 99; end;
		{???}

  { Validate the data structure. }
  frame_list := [];
  scr_row := 0;
  this_span := first_span;
  prev_span := nil;
  while this_span <> nil do
    with this_span^ do
      begin
      if blink <> prev_span then
	begin screen_message(dbg_invalid_blink); goto 99; end;
      if (mark_one = nil) or (mark_two = nil) then
	  begin screen_message(dbg_mark_ptr_is_nil); goto 99; end;
      if code <> nil then
	if code^.ref = 0 then
	  begin screen_message(dbg_ref_count_is_zero); goto 99; end;
      if frame <> nil then
	begin
	this_frame := frame;
	if this_frame = frame_cmd then
	  frame_list := frame_list + [cmd]
	else
	  if this_frame = frame_oops then
	    frame_list := frame_list + [oops];
	if this_frame = frame_heap then
	  frame_list := frame_list + [heap];
	with this_frame^ do
	  begin
	  if (first_group = nil) or (last_group = nil) then
	    begin screen_message(dbg_invalid_group_ptr); goto 99; end;
	  if first_group^.blink <> nil then
	    begin screen_message(dbg_first_not_at_top); goto 99; end;
	  end_group := last_group^.flink;
	  if end_group <> nil then
	    begin screen_message(dbg_last_not_at_end); goto 99; end;
	  this_group := first_group;
	  prev_group := nil;
	  this_line := first_group^.first_line;
	  prev_line := nil;
	  line_nr := 1;
	  while this_group <> end_group do
	    with this_group^ do
	      begin
	      if blink <> prev_group then
		begin screen_message(dbg_invalid_blink); goto 99; end;
	      if frame <> this_frame then
		begin screen_message(dbg_invalid_frame_ptr); goto 99; end;
	      if (first_line = nil) or (last_line = nil) then
		begin screen_message(dbg_line_ptr_is_nil); goto 99; end;
	      if first_line <> this_line then
		begin screen_message(dbg_first_not_at_top); goto 99; end;
	      line_count := 0;
	      end_line := last_line^.flink;
	      while this_line <> end_line do
		with this_line^ do
		  begin
		  if blink <> prev_line then
		    begin screen_message(dbg_invalid_blink); goto 99; end;
		  if group <> this_group then
		    begin screen_message(dbg_invalid_group_ptr); goto 99; end;
		  if offset_nr <> line_count then
		    begin screen_message(dbg_invalid_offset_nr); goto 99; end;
		  this_mark := mark;
		  while this_mark <> nil do
		    with this_mark^ do
		      begin
		      if line <> this_line then
			begin screen_message(dbg_invalid_line_ptr); goto 99; end;
		      this_mark := next;
		      end;
		  if (str = nil) and (len <> 0) then
		    begin screen_message(dbg_invalid_line_length); goto 99; end;
		  if used > len then
		    begin screen_message(dbg_invalid_line_used_length); goto 99; end;
		  if scr_row_nr <> scr_row then
		    if this_line = scr_top_line then
		      scr_row := scr_row_nr
		    else
		      begin screen_message(dbg_invalid_scr_row_nr); goto 99; end;
		  if scr_row <> 0 then
		    if this_line <> scr_bot_line then
		      scr_row := scr_row + 1
		    else
		      scr_row := 0;
		  line_count := line_count + 1;
		  prev_line := this_line;
		  this_line := flink;
		  end;
	      if last_line <> prev_line then
		begin screen_message(dbg_last_not_at_end); goto 99; end;
	      if first_line_nr <> line_nr then
		begin screen_message(dbg_invalid_line_nr); goto 99; end;
	      if nr_lines <> line_count then
		begin screen_message(dbg_invalid_nr_lines); goto 99; end;
	      line_nr := line_nr + nr_lines;
	      prev_group := this_group;
	      this_group := flink;
	      end;
	  if first_group^.first_line^.blink <> nil then
	    begin screen_message(dbg_first_not_at_top); goto 99; end;
	  if end_line <> nil then
	    begin screen_message(dbg_last_not_at_end); goto 99; end;
	  if dot = nil then
	    begin screen_message(dbg_mark_ptr_is_nil); goto 99; end;
	  if dot^.line^.group^.frame <> this_frame then
	    begin screen_message(dbg_mark_in_wrong_frame); goto 99; end;
	  for mark_nr := min_mark_number to max_mark_number do
	    if marks[mark_nr] <> nil then
	      if marks[mark_nr]^.line^.group^.frame <> this_frame then
		begin screen_message(dbg_mark_in_wrong_frame); goto 99; end;
	  if (scr_height = 0) or (scr_height > terminal_info.height) then
	    begin screen_message(dbg_invalid_scr_param); goto 99; end;
	  if (scr_width = 0) or (scr_width > terminal_info.width) then
	    begin screen_message(dbg_invalid_scr_param); goto 99; end;
	  if span <> this_span then
	    begin screen_message(dbg_invalid_span_ptr); goto 99; end;
	  if margin_left >= margin_right then
	    begin screen_message(msg_left_margin_ge_right); goto 99; end;
	  end;
	if (mark_one^.line^.group^.frame <> this_frame) or
	   (mark_two^.line^.group^.frame <> this_frame) then
	  begin screen_message(dbg_mark_in_wrong_frame); goto 99; end;
	end
      else
	if mark_one^.line^.group^.frame <> mark_two^.line^.group^.frame then
	  begin screen_message(dbg_marks_from_diff_frames); goto 99; end;
      prev_span := this_span;
      this_span := flink;
      end; { with this_span^ do }
  if not (cmd  in frame_list) then begin screen_message(dbg_needed_frame_not_found); goto 99; end;
  if not (oops in frame_list) then begin screen_message(dbg_needed_frame_not_found); goto 99; end;
  if not (heap in frame_list) then begin screen_message(dbg_needed_frame_not_found); goto 99; end;

{#endif}
  validate_command := true;
 99:
  end; {validate_command}

{#if vms or turbop}
end.
{#endif}
