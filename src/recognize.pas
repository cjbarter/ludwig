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
{       Francis Vaughan (1987);                                        }
{       Jeff Blows (1989); and                                         }
{       Kelvin B. Nicolle (1989).                                      }
{                                                                      }
{  Copyright  1987, 1989 University of Adelaide                        }
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
{   Copyright (C) 1981, 1987                                           }
{   Department of Computer Science, University of Adelaide, Australia  }
{   All rights reserved.                                               }
{   Reproduction of the work or any substantial part thereof in any    }
{   material form whatsoever is prohibited.                            }
{                                                                      }
{**********************************************************************}

{++
! Name:         RECOGNIZE
!
! Description:  The pattern matcher for EQS, GET and REPLACE.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/recognize.pas,v 4.5 1990/01/18 17:38:33 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: recognize.pas,v $
! Revision 4.5  1990/01/18 17:38:33  ludwig
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
!--}

{#if vms}
{##[ident('4-005'),}
{## overlaid]}
{##module recognize (output);}
{#elseif turbop}
unit recognize;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'recognize.fwd'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "recognize.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=recognize.h#>}
{#elseif turbop}
interface
  uses value;
  {$I recognize.i}

implementation
{#endif}


function pattern_recognize (
		dfa_table_pointer : dfa_table_ptr;
		line              : line_ptr;
		start_col         : col_range;
	var     mark_flag         : boolean;
	var     start_pos         : col_range;
	var     finish_pos        : col_range)
	: boolean;

  var
    state               : dfa_state_range;
    found               : boolean;
    positional_set      : accept_set_type;
    started             : boolean;
    end_of_line         : boolean;
    fail                : boolean;
    flag                : boolean;
    left_flag           : boolean;
    line_counter        : strlen_range;
    ch                  : char;

  procedure pattern_get_input_elt(var ch            : char;
				  var input_set     : accept_set_type;
				  var column        : strlen_range;
				      length        : strlen_range;
				  var mark_flag     : boolean;
				  var end_of_line   : boolean);

    var
      mark_no     : mark_range;
      mark_found  : boolean;

    begin {pattern_get_input_elt}
    input_set := [];
    if length = 0 then
      begin
      ch := pattern_space;  { not 100% corrrect but OK }
      input_set := [pattern_beg_line,pattern_end_line];
      mark_flag := true;
      end_of_line := true;
      end
    else
      begin
      mark_found := false;
      if not mark_flag then    { the last time through was not a mark }
	with current_frame^ do
	begin                  { so look for them this time         }
	if column = 1 then
	  begin
	  input_set := input_set + [pattern_beg_line];
	  mark_found := true;
	  end;
	if column > length then
	  begin
	  input_set := input_set + [pattern_end_line];
	  end_of_line := true;
	  mark_found := true;
	  end;
	if column = margin_left then
	  begin
	  input_set := input_set + [pattern_left_margin];
	  mark_found := true;
	  end;
	if column = margin_right then
	  begin
	  input_set := input_set + [pattern_right_margin];
	  mark_found := true;
	  end;
	if column = dot^.col then
	  begin
	  input_set := input_set + [pattern_dot_column];
	  mark_found := true;
	  end;
	if line^.mark <> nil then         { if any marks on this line }
	  for mark_no := min_mark_number to max_mark_number do
	    { run through user accsesible ones }
	    begin
	    if marks[mark_no] <> nil then
	      if (marks[mark_no]^.line = line) and
		 (marks[mark_no]^.col = column) then
		begin
		input_set := [mark_no + pattern_marks_start] + input_set;
		mark_found := true;
		end;
	    end; { mark_found is true if there is a user mark on this column.}
	mark_flag := mark_found;{ will not test_for a mark next time through }
	end;
      if not mark_found  then
			{ if there is not a mark  or we have }
	begin           { already prossesed it . then get the char }
	mark_flag := false;   { will test for a mark next time through }
	ch := line^.str^[column];
	if column <= length then
	  column := column + 1;
	end;
      end;
    end; {pattern_get_input_elt}

  function pattern_next_state (    ch            : char;
				   input_set     : accept_set_type;
				   mark_flag     : boolean;
			       var state         : dfa_state_range;
			       var started       : boolean   ): boolean;

    var
      found              : boolean;
      transition_pointer : transition_ptr;
      aux_state          : dfa_state_range;

    begin {pattern_next_state}
    found := false;
    transition_pointer := dfa_table_pointer^.dfa_table[state].transitions;
    if mark_flag then    { look for transitions on positionals only }
      begin
      while (transition_pointer <> nil) and not found  do
	begin
	if (transition_pointer^.transition_accept_set * input_set) <> [] then
	  begin
	  found := true;
	  if transition_pointer^.start_flag and not started then
	    aux_state :=pattern_dfa_kill
	  else
	    aux_state := transition_pointer^.accept_next_state;
	  end
	else
	  transition_pointer := transition_pointer^.next_transition;
	end;
      if aux_state = pattern_dfa_kill then
	found := false
      else
	state := aux_state;
      end
    else    { look for transitions on characters }
      while (transition_pointer <> nil) and not found  do
	begin
	if ord(ch) in transition_pointer^.transition_accept_set  then
	  begin
	  found := true;
	  if transition_pointer^.start_flag and not started then
	    state := pattern_dfa_kill
	  else
	    state := transition_pointer^.accept_next_state;
	  end
	else
	  transition_pointer := transition_pointer^.next_transition;
	end;
    started := (started and dfa_table_pointer^.dfa_table[state].pattern_start)
	      or (state = pattern_dfa_fail) or (state = pattern_dfa_kill);
    pattern_next_state := found;
    end; {pattern_next_state}

  begin {pattern_recognize}
  line_counter := start_col;
  start_pos    := start_col;
  finish_pos   := start_col;
  state        := pattern_dfa_start;
  found        := false;
  fail         := false;
  started      := true;
  end_of_line  := false;
  left_flag    := false;
  with dfa_table_pointer^ do
    begin
    repeat
      repeat
      pattern_get_input_elt(ch,positional_set,line_counter,line^.used,
			    mark_flag,end_of_line);
      if pattern_next_state(ch,positional_set,mark_flag,state,started) then
	begin
	if state = pattern_dfa_kill then
	  state := pattern_dfa_start
	else
	  if state = pattern_dfa_fail then
	    begin
	    fail := true;
	    start_col := start_col +1;
	    line_counter := start_col +1;
	    state := pattern_dfa_start;
	    end;
	with dfa_table[state] do
	  begin
	  if left_transition then
	    start_pos := line_counter
	  else
	    if left_context_check then
	      if left_flag then
		start_pos := line_counter -1
	      else
		left_flag := true;
	  if right_transition then
	    finish_pos := line_counter;
	  end;
	end;
      until dfa_table[state].final_accept or end_of_line;
      if not end_of_line then
	repeat
	  pattern_get_input_elt(ch,positional_set,line_counter,line^.used,
				mark_flag,end_of_line);
	  if pattern_next_state(ch,positional_set,mark_flag,state,started)
	  then
	    begin
	    if state = pattern_dfa_kill then
	      found := true
	    else
	      if state = pattern_dfa_fail then
		begin
		fail := true;
		start_col := start_col +1;
		line_counter := start_col +1;
		state := pattern_dfa_start;
		end;
	   with dfa_table[state] do
	     begin
	      if right_transition then
		finish_pos := line_counter;
	      end;
	    end;
	until found or fail or end_of_line;
    until found or end_of_line;
    if not found then   { must also be end of line }
      begin             { push through the white space at end of line }
      flag := dfa_table[state].final_accept;
      if pattern_next_state(' ',[],false,state,started) then
	with dfa_table[state] do
	begin                     { note end of line positional will already }
	if (state = pattern_dfa_kill) and flag then  { have been prossesed }
	  found := true;
	if right_transition then
	  finish_pos := line^.used +1;
	if left_transition then
	  start_pos := line^.used +1;
	if final_accept then
	  found := true;   { does not need to be pushed to the kill state as }
	end;               { there is no more input, so there is no          }
      end;                 { possibility of a fail being generated           }
      pattern_recognize := found;
    end; {with DFA_table_pointer^}
  end; {pattern_recognize}

{#if vms or turbop}
end.
{#endif}
