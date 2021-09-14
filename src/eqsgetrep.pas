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
{       Chris J. Barter (1987);                                        }
{       Mark R. Prior (1988);                                          }
{       Jeff Blows (1989);                                             }
{       Kelvin B. Nicolle (1989); and                                  }
{       Martin Sandiford (2002).                                       }
{                                                                      }
{  Copyright  1987-89, 2002 University of Adelaide                     }
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
! Name:         EQSGETREP
!
! Description:  The EQS, GET and REPLACE commands.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/eqsgetrep.pas,v 4.8 2002/07/15 13:15:14 martin Exp $
! $Author: martin $
! $Locker:  $
! $Log: eqsgetrep.pas,v $
! Revision 4.8  2002/07/15 13:15:14  martin
! Fixed 8 char name issues for fpc
!
! Revision 4.7  1990/01/18 18:17:06  ludwig
! Entered into RCS at revision level 4.7
!
!
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Mark R. Prior                                        26-Jan-1988
!       Add code to eqsretrep_rep to ensure that the temporary copies
!       of marks Dot and Equals are disposed of.
! 4-003 Mark R. Prior                                        20-Feb-1988
!       Strings passed to ch routines are now passed using conformant
!         arrays, or as type str_object.
!               string[offset],length -> string,offset,length
!       In all calls of ch_length, ch_upcase_str, ch_locase_str, and
!         ch_reverse_str, the offset was 1 and is now omitted.
! 4-004 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-005 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
! 4-006 Kelvin B. Nicolle                                    13-Sep-1989
!       Add includes etc. for Tower version.
! 4-007 Kelvin B. Nicolle                                    25-Oct-1989
!       Correct the includes for the Tower version.
!--}

{#if vms}
{##[ident('4-007'),}
{## overlaid]}
{##module eqsgetrep (output);}
{#elseif turbop}
unit eqsgetrep;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'eqsgetrep.fwd'}
{##%include 'ch.h'}
{##%include 'charcmd.h'}
{##%include 'mark.h'}
{##%include 'screen.h'}
{##%include 'text.h'}
{##%include 'patparse.h'}
{##%include 'dfa.h'}
{##%include 'recognize.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "eqsgetrep.h"}
{####include "ch.h"}
{####include "charcmd.h"}
{####include "mark.h"}
{####include "screen.h"}
{####include "text.h"}
{####include "patparse.h"}
{####include "dfa.h"}
{####include "recognize.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=eqsgetrep.h#>}
{###<$F=ch.h#>}
{###<$F=charcmd.h#>}
{###<$F=mark.h#>}
{###<$F=screen.h#>}
{###<$F=text.h#>}
{###<$F=patparse.h#>}
{###<$F=dfa.h#>}
{###<$F=recognize.h#>}
{#elseif turbop}
interface
  uses value;
{#if fpc}
  {$I eqsgetrep.i}
{#else}
{##  #<$I eqsgetre.h#>}
{#endif}

implementation
  uses ch, charcmd, mark, screen, text, patparse, dfa, recognize;
{#endif}


{}function eqsgetrep_exactcase (var target:tpar_object) : boolean;

    label 99;
    var
      i : integer;

    begin {eqsgetrep_exactcase}
    eqsgetrep_exactcase := true;
    with target do
      begin
      if dlm <> '"' then { only use non-exact if necessary }
	for i:=1 to len do
	  if ord(str[i]) in alpha_set then
	    begin
	    ch_upcase_str(str,len);
	    eqsgetrep_exactcase:=false;
	    goto 99;
	    end;
      end;
   99:
    end; {eqsgetrep_exactcase}


{}function eqsgetrep_pattern_build(
		tpar        : tpar_object;
	var     pattern_ptr : dfa_table_ptr)
	: boolean;

    label 99;
    var
      already_built : boolean;
      pattern_definition : pattern_def_type;
      dfa_start,dfa_end  : dfa_state_range;   { may well go in final version }
      nfa_table          : nfa_table_type;
      first_pattern_start,
      pattern_final_state,
      left_context_end,
      middle_context_end : nfa_state_range;
      states_used  : nfa_state_range;         { DUMMY Will go }

    function eqsgetrep_same_pattern_def( pattern_1,pattern_2: pattern_def_type)
							       : boolean;

      label 1;
      var
	count : integer;

      begin {eqsgetrep_same_pattern_def}
      eqsgetrep_same_pattern_def := false;
      if (pattern_1.length <> 0) and (pattern_2.length <> 0) and
	 (pattern_1.length = pattern_2.length)   then
	  begin
	  for count := 1 to  pattern_1.length do
	    if pattern_1.strng[count] <> pattern_2.strng[count] then
	      goto 1;
	  eqsgetrep_same_pattern_def := true;
	  end;
      1:
      end; {eqsgetrep_same_pattern_def}

    begin {eqsgetrep_pattern_build}
    eqsgetrep_pattern_build := false;
    if pattern_parser(tpar,nfa_table,first_pattern_start,
		     pattern_final_state,left_context_end,
		     middle_context_end,
		     pattern_definition,
		     states_used)       then
      begin
      if (pattern_ptr <> nil) then
	already_built :=  eqsgetrep_same_pattern_def(pattern_definition,
						 pattern_ptr^.definition)
      else
	already_built := false;
      if not already_built then
	begin
	if not pattern_dfa_table_initialize(pattern_ptr,
					pattern_definition) then goto 99;
	if not pattern_dfa_convert(nfa_table,
			    pattern_ptr,
			    first_pattern_start,
			    pattern_final_state,
			    left_context_end,
			    middle_context_end,
			    dfa_start,
			    dfa_end)      then  goto 99;
	end;
      end
    else
      goto 99;
    eqsgetrep_pattern_build := true;
   99:
    end; {eqsgetrep_pattern_build}


function eqsgetrep_eqs (
		rept      : leadparam;
		count     : integer;
		tpar      : tpar_object;
		from_span : boolean)
	: boolean;

  label 99;
  var
    exactcase : boolean;
    start_col : col_range;
    length    : strlen_range;
    result    : integer;
    nch_ident : strlen_range;
    success   : boolean;
    end_pos   : col_range;
    mark_flag : boolean;
    found     : boolean;

  begin {eqsgetrep_eqs}
  success := false;
  with current_frame^,dot^,line^ do
    begin
    if tpar.dlm = tpd_smart then
      begin
      if not eqsgetrep_pattern_build(tpar,eqs_pattern_ptr) then goto 99;
      mark_flag := false;
      found := pattern_recognize(eqs_pattern_ptr,line,col,
				 mark_flag,start_col,end_pos);
      case rept of
	none,plus : success := (col = start_col) and found;
	minus     : success := not ((col = start_col) and found);
	pindef    : success := (end_pos <= used) and found;
	nindef    : success := (end_pos >= used) and found;
      end{case};
      if success and not (rept = minus) then
	success := mark_create(line,end_pos,marks[mark_equals]);
      end
    else
      begin
      exactcase := eqsgetrep_exactcase(tpar);   { Decide if exact case. }
      start_col := col;
      if col > used then
	begin
	length := 0;
	start_col := 1; { in case col off end of string }
	end
      else
	length := used+1-col;
      if length > tpar.len then
	length := tpar.len;

      { Compare string. }
      result := ch_compare_str(tpar.str,1,tpar.len,
			       str^,start_col,length,
			       exactcase,
			       nch_ident);
      case rept of
	none,plus : success := (result = 0);
	minus     : success := (result <> 0);
	pindef    : success := (result <= 0);
	nindef    : success := (result >= 0);
      end{case};
      if success and not (rept = minus) then
	success := mark_create(line,col+nch_ident,marks[mark_equals]);
      end;
    end;
99:
  eqsgetrep_eqs := success;
  end; {eqsgetrep_eqs}


{}function eqsgetrep_dumb_get(rept      : leadparam;
			count     : integer;
			tpar      : tpar_object;
			from_span : boolean) : boolean;

  label 1,2,99;
  var
    backwards : boolean;
    dot_col   : col_range;
    dot_line  : line_ptr;
    exactcase : boolean;
    line      : line_ptr;
    length    : strlen_range;
    newlen    : strlen_range;
    newstr    : str_object;
    tail_char : char;
    tail_space,
    result    : boolean;
    start_col : col_range;
    offset    : strlen_range;
    found     : boolean;
{#if turbop}
    tmp_str   : string;
{#endif}
    buffer    : str_object;

  begin {eqsgetrep_dumb_get}
  result := count = 0;
  with current_frame^ do
    begin
    { Initialize the search variables. }
    dot_line := dot^.line;                    { Remember initial dot. }
    dot_col  := dot^.col;
    exactcase := eqsgetrep_exactcase(tpar);   { Decide if exact case. }
    line     := dot_line;                     { Line to start on.     }
    newlen := tpar.len;
    if (newlen > 1) and (tpar.str[newlen] = ' ') then
      begin
      tail_space := true;
      newlen     := newlen-1;
      end
    else
      tail_space := false;
    if count<0 then
      begin
      count     := -count;
      with tpar do ch_reverse_str(str,newstr,newlen);
      backwards := true;
      start_col := 1;
      length    := dot^.col-1;
      if length > line^.used then
	length := line^.used;
      end
    else
      begin
      newstr    := tpar.str;
      backwards := false;
      start_col := dot^.col;
      if start_col > line^.used then
	length := 0
      else
	length := line^.used+1-start_col;
      end;
    { Search for target. }
    while (count>0) and (not tt_controlc) do
      begin
      if length = 0 then
	found := false
      else
	found := ch_search_str(newstr,1,newlen,
			       line^.str^,start_col,length,
			       exactcase,backwards,offset);
      if found then
	begin { Found AN instance, except maybe for TAIL_SPACE. }
	{ Check that matched string is followed by a space, or EOL space. }
	if tail_space then
	  begin
	  with line^ do
	    begin
	    if start_col+offset+newlen <= used then
	      tail_char := str^[start_col+offset+newlen]
	    else
	    if start_col+offset+newlen  = used+1 then
	      if used+1 = max_strlenp then    { DON'T FIND VERY LAST SPACE  }
		tail_char := chr(0)           { BECAUSE THEN DOT WOULD NEED }
	      else                            { TO GO BEYOND END OF LINE!   }
		tail_char := ' '
	    else
	      tail_char := chr(0);
	    end;
	  if tail_char <> ' ' then
	    begin
	    if backwards then
	      start_col := start_col+offset+newlen-1
	    else
	      start_col := start_col+1;
	    goto 2;
	    end;
	  end;
	{ Step to end of matched string. }
	start_col := start_col+offset;
	if not backwards then start_col := start_col+tpar.len;
	{ Check if found THE instance. }
	count := count-1;
	if count = 0 then
	  begin
	  { Place the dot in the right place. }
	  if not mark_create(line,start_col,dot) then goto 99;
	  if not from_span then
	    begin
{#if turbop}
	    tmp_str := 'This one?';
	    fillchar(buffer[1], sizeof(buffer), ' ');
	    move(tmp_str[1], buffer[1], system.length(tmp_str));
{#else}
{##            buffer := 'This one?';}
{#endif}
	    case screen_verify(buffer, 9) of
	      verify_reply_always,
	      verify_reply_yes : ;
	      verify_reply_quit,
	      verify_reply_no  :
		begin
		{ Pretend we never found it. }
		count := 1;
		if not mark_create(dot_line,dot_col,dot) then goto 99;
		if exit_abort then goto 99 else goto 1;
		end;
	    end{case};
	    end;
	  { Place the equals in the right place. }
	  if backwards then
	    begin
	    if not mark_create(line,start_col+tpar.len,marks[mark_equals]) then goto 99
	    end
	  else
	    begin
	    if not mark_create(line,start_col-tpar.len,marks[mark_equals]) then goto 99;
	    end;
	  result := true;
	  goto 99;
	1:
	  end;
	{ Search the rest of this line. }
	2:
	if backwards then
	  begin
	  length    := start_col-1;
	  start_col := 1;
	  end
	else
	  if start_col > line^.used then
	    length := 0
	  else
	    length    := line^.used+1-start_col;
	end
      else
	begin { No more instances on this line, move to next line. }
	if backwards then
	  line := line^.blink
	else
	  line := line^.flink;
	if line = nil then goto 99;
	start_col := 1;
	length := line^.used;
	end;
      end;
    end;
99:
  eqsgetrep_dumb_get := result;
  end; {eqsgetrep_dumb_get}


{}function eqsgetrep_pattern_get(
		rept         : leadparam;
		count        : integer;
		tpar         : tpar_object;
		from_span    : boolean;
		replace_flag : boolean)
	: boolean;

    label 1,2,99;
    var
      backwards : boolean;
      dot_col   : col_range;
      dot_line  : line_ptr;
      line      : line_ptr;
      result    : boolean;
      start_col : strlen_range;
      pattern_ptr : dfa_table_ptr;
      matched_start_col   : col_range;
      matched_finish_col   : col_range;
      mark_flag         : boolean;
{#if turbop}
      tmp_str : string;
{#endif}
      buffer : str_object;

    begin {eqsgetrep_pattern_get}
    result := count = 0;
    with current_frame^ do
      begin
      if not replace_flag then
	begin
	if not eqsgetrep_pattern_build(tpar,get_pattern_ptr) then goto 99;
	pattern_ptr := get_pattern_ptr;
	end
      else    { is a get within a replace ,pattern table already exists}
	pattern_ptr := rep_pattern_ptr;
      { Initialize the search variables. }
      dot_line := dot^.line;                    { Remember initial dot. }
      dot_col  := dot^.col;
      line     := dot_line;                     { Line to start on.     }
      mark_flag := false;               { search for marks at start pos }
      backwards := count < 0;
      if backwards then                { Since the matcher can only search }
	start_col := 1                 { forward it must start in col 1 when }
      else                             { going backwards. }
	start_col := dot_col;          { Otherwise start at the dot.  }
      count := abs(count);
      if start_col > line^.used then
	start_col := line^.used +1;
      { Search for target. }
      while (count>0) and (not tt_controlc) do
	begin
	if pattern_recognize(pattern_ptr,line,start_col,mark_flag,
			     matched_start_col,matched_finish_col) then
	  begin
	  if not ((line=dot_line) and
		  (matched_finish_col >= dot_col) and backwards) then
	    begin             { so long as not somewhere we are not allowed }
	    count := count-1;
	    if count = 0 then
	      begin
	      { Place the dot in the right place. }
	      if backwards then
		begin
		if not mark_create(line,matched_start_col,dot) then goto 99;
		end
	      else
		if not mark_create(line,matched_finish_col,dot) then goto 99;
	      if not from_span then
		begin
{#if turbop}
		tmp_str := 'This one?';
		fillchar(buffer[1], sizeof(buffer), ' ');
		move(tmp_str[1], buffer[1], system.length(tmp_str));
{#else}
{##                buffer := 'This one?';}
{#endif}
		case screen_verify(buffer, 9) of
		  verify_reply_always,
		  verify_reply_yes : ;
		  verify_reply_quit,
		  verify_reply_no  :
		    begin
		    { Pretend we never found it. }
		    count := 1;
		    if not mark_create(dot_line,dot_col,dot) then goto 99;
		    if exit_abort then goto 99 else goto 1;
		    end;
		end{case};
		end;
	      { Place the equals in the right place. }
	      if backwards then
		begin
		if not mark_create(line,matched_finish_col,marks[mark_equals]) then goto 99;
		end
	      else
		if not mark_create(line,matched_start_col,marks[mark_equals]) then goto 99;
	      result := true;
	      goto 99;  { been there, done that, moving on }
	    1:
	      end;      { finished code for having found it }
	    { Search the rest of this line. }
	    2:    { found one but not the right count }
	    start_col := matched_finish_col;
		  { search rest of line }
	    if (start_col = matched_start_col) then {occurs if only match mark }
	      mark_flag := true;       { stop it matching the mark on this col.}
	    if start_col > line^.used then    { Finished this line, move on.  }
	      begin                           { since strictly greater than   }
	      if backwards then               { must have prosessed }
		line := line^.blink           { the end of line & white space }
	      else
		line := line^.flink;
	      if line = nil then goto 99;
	      mark_flag := false;
	      start_col := 1;
	      end;
	    end   { of we are not outside the allowed search bounds }
	  else
	    begin  { we found one but outside bounds }
	    line := line^.blink;   { must be backwards, as that is a criterion }
	    if line = nil then goto 99;   { for out of bounds }
	    mark_flag := false;
	    start_col := 1;
	    end;
	  end   { of if found one }
	else
	  begin { No more instances on this line, move to next line. }
	  if backwards then
	    line := line^.blink
	  else
	    line := line^.flink;
	  if line = nil then goto 99;
	  mark_flag := false;
	  start_col := 1;
	  end;
	end;  { of while not count > 0 }
      end;  { of with current_frame^ do }
   99:
    eqsgetrep_pattern_get := result;
    end; {eqsgetrep_pattern_get}


function eqsgetrep_get (
		rept      : leadparam;
		count     : integer;
		tpar      : tpar_object;
		from_span : boolean)
	: boolean;

  begin {eqsgetrep_get}
  if tpar.dlm = tpd_smart then
    eqsgetrep_get := eqsgetrep_pattern_get(rept,count,tpar,from_span,false)
  else
    eqsgetrep_get := eqsgetrep_dumb_get(rept,count,tpar,from_span);
  end; {eqsgetrep_get}


function eqsgetrep_rep (
		rept      : leadparam;
		count     : integer;
		tpar      : tpar_object;
		tpar2     : tpar_object;
		from_span : boolean)
	: boolean;

  label 1,99;
  var
    getcount  : -1..1;
    getrept   : leadparam;
    length    : integer;
    delta     : integer;
    start_col : col_range;
    okay      : boolean;
    old_equals,
    old_dot   : mark_ptr;
{#if turbop}
    tmp_str : string;
{#endif}
    buffer : str_object;

  begin {eqsgetrep_rep}
  old_dot := nil;
  old_equals := nil;
  eqsgetrep_rep := false;
  with current_frame^ do
    begin
    if not mark_create(dot^.line,dot^.col,old_dot) then goto 99;
    if marks[mark_equals] <> nil then
      if not mark_create(marks[mark_equals]^.line,marks[mark_equals]^.col,old_equals) then goto 99;
    if tpar.dlm = tpd_smart then
      if not eqsgetrep_pattern_build(tpar,rep_pattern_ptr) then goto 99;
    getrept  := pint;
    getcount := 1;
    if rept in [minus,nindef,nint] then
      begin
      getrept  := nint;
      getcount := -1;
      end;
    if rept in [pindef,nindef] then count := maxint
    else
    if count < 0 then count := -count;
    while count > 0 do
      begin
      repeat
	okay := true;
	if tt_controlc or exit_abort then goto 1;
	if tpar.dlm = tpd_smart then
	  begin
	  if not eqsgetrep_pattern_get
		 (getrept,getcount,tpar,true,true) then goto 1;
	  end
	else
	  if not eqsgetrep_dumb_get(getrept,getcount,tpar,true) then goto 1;
	if tt_controlc or exit_abort then goto 1;
	if not from_span then
	  begin
{#if turbop}
	  tmp_str := 'Replace this one?';
	  fillchar(buffer[1], sizeof(buffer), ' ');
	  move(buffer[1], tmp_str[1], system.length(tmp_str));
{#else}
{##          buffer := 'Replace this one?';}
{#endif}
	  case screen_verify(buffer,18) of
	    verify_reply_always : from_span := true;
	    verify_reply_yes    : ;
	    verify_reply_quit,
	    verify_reply_no     : okay := false;
	  end{case};
	  end;
      until okay;
      length := marks[mark_equals]^.col-dot^.col;
      { If EQUALS < DOT then REVERSE THEM. }
      if length < 0 then
	begin
	dot^.col                := marks[mark_equals]^.col;
	marks[mark_equals]^.col := dot^.col-length;
	length                  := -length;
	end;
      if tpar2.con = nil then
	begin
	start_col := dot^.col;
	{ Make exactly right size for replacement text. }
	delta := length-tpar2.len;
	if delta > 0 then
	  begin
	  if dot^.col+delta > dot^.line^.used+1 then
	    delta := dot^.line^.used+1-dot^.col;
	  if delta > 0 then
	    if not charcmd_delete(cmd_delete_char,pint,delta,true) then
	      goto 99;
	  end
	else
	if delta < 0 then
	  begin
	  if not charcmd_insert(cmd_insert_char,pint,-delta,true) then
	     goto 99;
	  dot^.col := start_col;
	  end;
	{ Overtype the replacement text and place DOT and EQUALS correctly. }
	if not text_overtype(true,1,tpar2.str,tpar2.len,dot) then goto 99;
	with dot^ do
	  if getcount > 0 then
	    begin
	    if not mark_create(line,start_col,marks[mark_equals]) then goto 99;
	    end
	  else
	    begin
	    if not mark_create(line,start_col+tpar2.len,marks[mark_equals]) then
	      goto 99;
	    col := start_col;
	    end;
	end
      else
	begin
	if not charcmd_delete(cmd_delete_char,pint,length,true) then
	  goto 99;
	if not text_insert_tpar(tpar2,dot,marks[mark_equals]) then
	  goto 99;
	end;
      if not mark_create(dot^.line,dot^.col,old_dot) then goto 99;
      if not mark_create(marks[mark_equals]^.line,marks[mark_equals]^.col,old_equals) then goto 99;
      text_modified := true;
      if not mark_create(dot^.line,dot^.col,marks[mark_modified]) then goto 99;
      { Decrement the count remaining. }
      count := count-1;
      end;
1:
    if not mark_create(old_dot^.line,old_dot^.col,dot) then goto 99;
    if not mark_destroy(old_dot) then goto 99;
    if old_equals <> nil then
      begin
      if not mark_create(old_equals^.line,old_equals^.col,marks[mark_equals]) then goto 99;
      if not mark_destroy(old_equals) then goto 99;
      end
    else
      if marks[mark_equals] <> nil then
	if not mark_destroy(marks[mark_equals]) then goto 99;
    eqsgetrep_rep := (count=0) or (rept in [pindef,nindef]);
    end;
99:
  { Just in case these marks are still hanging around ... }
  if old_dot <> nil then
    if not mark_destroy(old_dot) then
      ;
  if old_equals <> nil then
    if not mark_destroy(old_equals) then
      ;
  end; {eqsgetrep_rep}

{#if vms or turbop}
end.
{#endif}
