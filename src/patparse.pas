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
{       Mark R. Prior (1988);                                          }
{       Kelvin B. Nicolle (1988-89);                                   }
{       Jeff Blows (1989); and                                         }
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
! Name:         PATPARSE
!
! Description:  This is the parser for the pattern matcher for EQS, Get
!               and Replace.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/patparse.pas,v 4.8 2002/07/15 10:19:21 martin Exp $
! $Author: martin $
! $Locker:  $
! $Log: patparse.pas,v $
! Revision 4.8  2002/07/15 10:19:21  martin
! Allow patparse to compile when using fpc
!
! Revision 4.8  2002/07/15 10:18:04  martin
! patparse compiles when using fpc
!
! Revision 4.8  2002/07/15 10:08:28  martin
! Make patparse compile when using fpc
!
! Revision 4.8  2002/07/15 09:58:59  martin
! Compile patparse when using fpc
!
! Revision 4.7  1990/01/18 17:41:29  ludwig
! Entered into RCS at revision level 4.7
!
!
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Mark R. Prior                                        20-Feb-1988
!       Use conformant arrays to pass string parameters to ch routines.
!               string[offset],length -> string,offset,length
!       In all calls of ch_length, ch_upcase_str, ch_locase_str,
!         ch_reverse_str, ch_compare_str, and ch_search_str the offset
!         was 1 and is now omitted.
! 4-003 Kelvin B. Nicolle                                    25-Nov-1988
!       Change set expressions of the form [...] + [...] to [...,...] to
!       avoid a bug in Ultrix pc.
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
{##module patparse (output);}
{#elseif turbop}
unit patparse;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'patparse.fwd'}
{##%include 'ch.h'}
{##%include 'screen.h'}
{##%include 'tpar.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "patparse.h"}
{####include "ch.h"}
{####include "screen.h"}
{####include "tpar.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=patparse.h#>}
{###<$F=ch.h#>}
{###<$F=screen.h#>}
{###<$F=tpar.h#>}
{#elseif turbop}
interface
  uses value;
  {$I patparse.i}

implementation
  uses ch, screen, tpar;
{#endif}


function pattern_parser (
	var     pattern             : tpar_object;
	var     nfa_table           : nfa_table_type;
	var     first_pattern_start,
		pattern_final_state,
		left_context_end,
		middle_context_end  : nfa_state_range;
	var     pattern_definition  : pattern_def_type;
	var     states_used         : nfa_state_range)
	: boolean;

{#if not turbop or fpc}
{#if fpc}
  label 0;
{#endif}
  label 99,100;
  var
    first_pattern_end : nfa_state_range;
    parse_count : strlen_range;
    pat_ch : char;
    aux_set   : accept_set_type;
{#if fpc}
    jmpb : jmp_buf;
{#endif}

  function pattern_new_nfa : nfa_state_range;

    begin {pattern_new_nfa}
    if states_used < max_nfa_state_range then
      begin
      pattern_new_nfa := states_used;
      with nfa_table[states_used] do
	begin
	fail := false;
	indefinite := false;
	end;
      states_used := states_used + 1;
      end
    else
      begin
      screen_message(msg_pat_pattern_too_complex);
{#if fpc}
      longjmp(jmpb, 99);
{#else}
{##      goto 99;}
{#endif}
      end;
    end; {pattern_new_nfa}

  function pattern_duplicate_nfa(    copy_this_start,
				     copy_this_finish,
				     current_state     : nfa_state_range;
				 var duplicate_finish  : nfa_state_range
				   ) : boolean;

    { duplicates the NFA between states copy_this_start and finish inclusive }
    { and splices the duplicated path onto the end of the current_state }
    { current_state must be an epslion transition }
    { The duplicates are patched using first_out, second_out = pattern_null}
    { Returns in duplicate_finish the last of the duplicated states }
    { which will be an uninitialized state }
    { Note : this function is hacky and tailor made for the job of making }
    { paramterized PATTERNs }
    { Hack. As states are allocated in   }
    { sequence, just duplicate block with offsets.  }
    { the syntax ensures that there are no transitions out }
    { of the block being duplicated when used on a single PATTERN }
    var
      offset            : nfa_state_range;
      aux_state         : nfa_state_range;
      aux               : nfa_state_range;
      duplicate_start   : nfa_state_range;

    begin {pattern_duplicate_nfa}
    offset := (current_state - copy_this_start) + 1;
    if (states_used + offset) > max_nfa_state_range then
      begin
      screen_message(msg_pat_pattern_too_complex);
{#if fpc}
      longjmp(jmpb, 99);
{#else}
{##      goto 99;}
{#endif}
    end;
    duplicate_start := states_used;   { states_used private to NFA utilities }
				{ states_used = next state to be allocated   }
    for aux := copy_this_start to copy_this_finish do
      begin
      aux_state := pattern_new_nfa;   { get new state }
      with nfa_table[aux_state] do
	begin
	fail := nfa_table[aux].fail;
	if not fail then
	  begin
	  epsilon_out := nfa_table[aux].epsilon_out;
	  if epsilon_out then
	    begin
	    if nfa_table[aux].first_out = pattern_null then
	      first_out := nfa_table[aux].first_out
	    else
	      first_out := nfa_table[aux].first_out + offset;
	    if nfa_table[aux].second_out = pattern_null then
	      second_out := nfa_table[aux].second_out
	    else
	      second_out := nfa_table[aux].second_out + offset;
	    end
	  else
	    begin
	    if nfa_table[aux].next_state = pattern_null then
	      next_state := nfa_table[aux].next_state
	    else
	      next_state := nfa_table[aux].next_state + offset;
	    accept_set := nfa_table[aux].accept_set;
	    end;
	  end;
	end;
      end;
    with nfa_table[current_state] do
      begin
      epsilon_out := true;
      first_out := duplicate_start;
      { second_out  is left untouched  }
      end;
    duplicate_finish := aux_state;
    pattern_duplicate_nfa := true;
    end; {pattern_duplicate_nfa}

  function pattern_getch(var parse_count : strlen_range;
			 var ch          : char;
			     in_string   : tpar_object) : boolean;

    begin {pattern_getch}
    pattern_getch := true;
    if parse_count < in_string.len then
      begin
      parse_count := parse_count + 1;
      ch := in_string.str[parse_count];
      with pattern_definition do
	begin
	length := length + 1;
	if length > max_strlen then
	  begin
	  screen_message(msg_pat_pattern_too_complex);
{#if fpc}
	  longjmp(jmpb, 99);
{#else}
{##	  goto 99;}
{#endif}
	  end;
	strng[length] := ch;
	end;
      end
    else
      begin
      ch := chr(0); { a null }
      pattern_getch := false;
      end;
    end; {pattern_getch}

  function pattern_getnumb(var parse_count : strlen_range;
			   var number      : integer;
			   var ch          : char;
			       in_string   : tpar_object) : boolean;

    var
      aux_bool : boolean;

    begin {pattern_getnumb}
    aux_bool := pattern_getch(parse_count,ch,in_string);
    pattern_getnumb := (ch in ['0'..'9']) and aux_bool;
    number :=  0;
    while aux_bool and (ch in ['0'..'9']) do
      begin
      number := (number * 10)+(ord(ch)-ord('0'));
      aux_bool := pattern_getch(parse_count,ch,in_string);
      end;
    if aux_bool then { we are not at the end of the string }
      parse_count := parse_count -1;
    end; {pattern_getnumb}

  procedure pattern_compound(    first       : nfa_state_range;
			     var finish      : nfa_state_range;
			     var parse_count : strlen_range;
				 in_string   : tpar_object;
			     var pat_ch      : char;
				 depth       : integer);

    var
      compound_finish : nfa_state_range;
      current_e_start  : nfa_state_range;
      dummy : boolean;

    procedure pattern_pattern(    first       : nfa_state_range;
			      var finish      : nfa_state_range;
			      var parse_count : strlen_range;
				  in_string   : tpar_object;
			      var pat_ch      : char;
				  depth       : integer);

      var
	leading_param : parameter_type;
	aux           : integer;
	aux_count     : strlen_range;
	temporary     : strlen_range;
	delimiter     : char;
	aux_ch_1      : char;
	aux_ch_2      : char;
	aux_pat_ch    : char;
	deref_tpar_ptr: tpar_ptr;
	deref_span    : tpar_object;
	tpar_sort     : commands;
	current_state : nfa_state_range;
	aux_state     : nfa_state_range;
	begin_state   : nfa_state_range;
	end_of_input  : boolean;
	negate        : boolean;
	no_dereference: boolean;
	range_patch   : nfa_state_range;
	range_start   : integer;
	range_end     : integer;
	range_indefinite : boolean;

      procedure pattern_range_delimgen(var range_patch : nfa_state_range;
				       var range_start : integer;
				       var range_end   : integer;
				       var range_indefinite : boolean;
				       var leading_param    : parameter_type);

	begin {pattern_range_delimgen}
	range_indefinite := false;
	leading_param := pattern_range;
	case pat_ch of
	  pattern_kstar:
	    begin
	    range_start := 0;
	    range_end := 0;
	    range_indefinite := true;
	    end;
	  pattern_plus:
	    begin
	    range_start := 1;
	    range_end := 0;
	    range_indefinite := true;
	    end;
	  '0','1','2','3','4','5','6','7','8','9':
	    begin
	    parse_count := parse_count - 1;    { back up YECH!! }
	    dummy := pattern_getnumb(parse_count,range_start,
				     pat_ch,in_string);
	    range_end := range_start;
	    end;
	  pattern_lrange_delim:
	    begin
	    if not pattern_getch(parse_count,pat_ch,in_string) then
	      begin
	      screen_message(msg_pat_no_matching_delim);
{#if fpc}
              longjmp(jmpb, 99);
{#else}
{##              goto 99;}
{#endif}
	      end;
	    if pat_ch in ['0'..'9'] then
	      begin
	      parse_count := parse_count -1;
	      dummy := pattern_getnumb(parse_count,range_start,pat_ch,
					  in_string);
	      dummy := pattern_getch(parse_count,pat_ch,in_string);
	      end
	    else
	      { therefore no start no. default to 0 }
	      range_start := 0;
	    if pat_ch = pattern_comma then
	      begin   { eat comma }
	      if not pattern_getch(parse_count,pat_ch,in_string) then
	        begin
		screen_message(msg_pat_no_matching_delim);
{#if fpc}
                longjmp(jmpb, 99);
{#else}
{##               goto 99;}
{#endif}
		end;
	      end
	    else
	      begin
	      screen_message(msg_pat_error_in_range);
{#if fpc}
              longjmp(jmpb, 99);
{#else}
{##             goto 99;}
{#endif}
	      end;
	    if pat_ch in ['0'..'9'] then
	      begin
	      parse_count := parse_count -1;
	      dummy := pattern_getnumb(parse_count,range_end,
					 pat_ch,in_string);
	      dummy := pattern_getch(parse_count,pat_ch,in_string);
	      end
	    else
	      begin
	      range_indefinite := true;
	      range_end := 0;
	      end;
	    if pat_ch <> pattern_rrange_delim then
	      begin
	      screen_message(msg_pat_no_matching_delim);
{#if fpc}
              longjmp(jmpb, 99);
{#else}
{##             goto 99;}
{#endif}
	      end;
	    end;
	end{case};
	if range_start = 0 then   { if 0 we need to have a diversion state }
	  begin
	  range_patch := current_state;
	  with nfa_table[range_patch] do
	    begin
	    epsilon_out := true;
	    first_out := pattern_new_nfa;
	    second_out := pattern_null;
	    current_state := first_out;
	    end;
	  end
	else
	  range_patch := pattern_null;
	end; {pattern_range_delimgen}

      procedure pattern_range_build(  range_start,
				      range_end   : integer;
				      range_patch : nfa_state_range;
				      indefinite  : boolean);

	var
	  aux       : integer;
	  end_state : nfa_state_range;
	  divert_ptr: nfa_state_range;
	  aux_ptr   : nfa_state_range;
	  indefinite_patch : nfa_state_range;

	begin {pattern_range_build}
	end_state  := current_state;
	indefinite_patch := begin_state;
	divert_ptr := range_patch; { = null if no divert state created }
	with nfa_table[current_state] do
	  begin
	  epsilon_out := true;
	  first_out := pattern_null;
	  second_out := pattern_null;
	  end;
	for aux := 2 to range_start  do
	  begin    { duplicates without diversions }
	  indefinite_patch := current_state;
	  dummy := pattern_duplicate_nfa(begin_state,end_state,
					 current_state,current_state);
	  end;
	if range_start > 0 then    { HACK !! (sort of) }
	  range_start := range_start -1;
	for aux := range_start +2 to range_end do
	  begin    { duplicates with diversions }
	  nfa_table[current_state].second_out := divert_ptr;
	  divert_ptr := current_state;
	  dummy := pattern_duplicate_nfa(begin_state,end_state,
					 current_state,current_state);
	  end;
	nfa_table[current_state].second_out := pattern_null;
	{ now fixup the diversions }
	while divert_ptr <> pattern_null do
	  begin
	  aux_ptr := nfa_table[divert_ptr].second_out;
	  nfa_table[divert_ptr].second_out := current_state;
	  divert_ptr := aux_ptr;
	  end;
	if indefinite then
	  begin  { send a pointer back to the begining of the last duplicate }
	  with nfa_table[current_state] do
	    begin
	    epsilon_out := true;
	    first_out   := indefinite_patch;
	    second_out  := pattern_new_nfa;
	    current_state := second_out;
	    end;
	  nfa_table[indefinite_patch].indefinite := true;
	  end;
	end; {pattern_range_build}

      begin {pattern_pattern}
      with deref_span do
	begin
	nxt:= nil;  con:= nil;
	end;
      if depth > pattern_max_depth then
        begin
	screen_message(msg_pat_pattern_too_complex);
{#if fpc}
        longjmp(jmpb, 99);
{#else}
{##       goto 99;}
{#endif}
	end;
      end_of_input := false;
      current_state := first;
      end_of_input := false;
      while not end_of_input and (pat_ch = pattern_space) do
	end_of_input := not pattern_getch(parse_count,pat_ch,in_string);
	{ eat any preceeding spaces }
      while not (pat_ch in [pattern_comma,pattern_rparen,pattern_bar])
		 and not end_of_input do
	begin
	if not (pat_ch in [tpd_span, tpd_prompt, tpd_exact, tpd_lit,{ strings }
			   pattern_lparen, pattern_lrange_delim,
			   pattern_kstar,
			   pattern_plus, pattern_negate,
			   pattern_mark,
			   pattern_equals, pattern_modified,
			   '0','1','2','3','4','5','6','7','8','9',
			   pattern_define_set_u,
			   pattern_define_set_l,
			   'a', 'b', 'c', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
			   'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u',
			   'v', 'w', 'x', 'y', 'z',
			   'A', 'B', 'C', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
			   'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U',
			   'V', 'W', 'X', 'Y', 'Z',
			   '{', '}', '<', '>', '^'])
	then { pat_ch not in syntax }
	  begin
	  screen_message(msg_pat_illegal_symbol);
{#if fpc}
          longjmp(jmpb, 99);
{#else}
{##         goto 99;}
{#endif}
	  end;
	case pat_ch of
	  tpd_span,tpd_prompt:
	    begin
	    delimiter := pat_ch;
	    new(deref_tpar_ptr);
	    aux:= 0;
	    if not pattern_getch(parse_count,pat_ch,in_string) then
	      begin
	      screen_message(msg_pat_no_matching_delim);
{#if fpc}
              longjmp(jmpb, 99);
{#else}
{##             goto 99;}
{#endif}
	      end;
	    while pat_ch <> delimiter do
	      begin
	      aux:= aux+ 1;
	      deref_tpar_ptr^.str[aux] := pat_ch;
	      if not pattern_getch(parse_count,pat_ch,in_string) then
	        begin
		screen_message(msg_pat_no_matching_delim);
{#if fpc}
                longjmp(jmpb, 99);
{#else}
{##               goto 99;}
{#endif}
		end;
	      end;
	    pattern_definition.length := pattern_definition.length-(aux+2);
	    tpar_sort := cmd_pattern_dummy_pattern;    { back up over delims and string }
	    deref_tpar_ptr^.len := aux;
	    deref_tpar_ptr^.dlm := delimiter;
	    if not tpar_get_1(deref_tpar_ptr,tpar_sort,deref_span) then
{#if fpc}
              longjmp(jmpb, 100);
{#else}
{##             goto 100;}
{#endif}
	    { get the dereferenced span or whatever else it is }
	    dispose(deref_tpar_ptr);
	    if deref_span.dlm in [tpd_lit,tpd_exact] then
	      with deref_span do
		begin                       { H A C K !!!!!!!!! }
		ch_move(str,1,str,2,len);   { Tpar_get strips off the quotes }
		len := len + 2;             { so we've got to put them back  }
		str[len] := dlm;
		str[1] := dlm;
		end;
	    aux_count := 0;
	    if pattern_getch(aux_count,aux_pat_ch,deref_span) then
	      begin  { if span not empty }
	      pattern_compound(current_state,current_state,
			    aux_count,deref_span,aux_pat_ch,depth+1);
		       { parse the span as a pattern  }   { ###### }
	      if (aux_count <> deref_span.len) or
		(deref_span.str[aux_count] = pattern_comma) then
	        begin
		screen_message(msg_pat_error_in_span);
{#if fpc}
                longjmp(jmpb, 99);
{#else}
{##               goto 99;}
{#endif}
		end;
	      end;
	    end;

	  { ALL PARAMETERIZED CLAUSES }
	  tpd_exact,tpd_lit,       { strings }
	  pattern_lparen,          { compounds }
	  pattern_lrange_delim,    { ranges }
	  pattern_kstar,           { leading parameters }
	  pattern_plus,pattern_negate,
	  pattern_mark,            { marks }
	  pattern_equals,          { Equals mark }
	  pattern_modified,        { Modified mark }
	  '0','1','2','3','4','5','6','7','8','9', { numeric repeat counts }
	  pattern_define_set_u,pattern_define_set_l,   { set definitions }
	  'a','b','c','e','f','g','h','i','j','k','l','m','n',  { Sets }
	  'o','p','q','r','s','t','u','v','w','x','y','z',      { D,d, out }
	  'A','B','C','E','F','G','H','I','J','K','L','M','N',
	  'O','P','Q','R','S','T','U','V','W','X','Y','Z',
	  '{','}','<','>','^'    { positionals }:
	    begin   { get the parameter if any }
	    leading_param := null_param;
	    if pat_ch in [pattern_kstar,
			  '0','1','2','3','4','5','6','7','8','9',
			  pattern_lrange_delim,
			  pattern_plus] then
	      begin
	      pattern_range_delimgen(range_patch, range_start,range_end,
				     range_indefinite,leading_param);
	      if not pattern_getch(parse_count,pat_ch,in_string) then
	        begin
		screen_message(msg_pat_premature_pattern_end);
{#if fpc}
                longjmp(jmpb, 99);
{#else}
{##               goto 99;}
{#endif}
		end;
	      begin_state := current_state;
	      end;
	    if pat_ch in [tpd_exact, tpd_lit,
			  pattern_lparen, pattern_mark,
			  pattern_equals, pattern_modified] then
	      case pat_ch of
		tpd_exact,tpd_lit:
		  begin
		  aux_ch_1 := pat_ch;
		  aux_count := parse_count;
		  if not pattern_getch(parse_count,pat_ch,in_string) then
		    begin
		    screen_message(msg_pat_no_matching_delim);
{#if fpc}
                    longjmp(jmpb, 99);
{#else}
{##                   goto 99;}
{#endif}
		    end;
		  if pat_ch in [tpd_span,tpd_prompt] then
		    begin
		    no_dereference := false;
		    delimiter := pat_ch;
		    new(deref_tpar_ptr);
		    aux := 0;
		    repeat           { build potential deref tpar }
		      if not pattern_getch(parse_count,pat_ch,in_string) then
		        begin
			screen_message(msg_pat_no_matching_delim);
{#if fpc}
                        longjmp(jmpb, 99);
{#else}
{##                       goto 99;}
{#endif}
			end;
		      aux := aux +1;
		      deref_tpar_ptr^.str[aux] := pat_ch;
		    until ( pat_ch = aux_ch_1 );
		    if aux >= 2 then  { one $ plus one " }
		      begin
		      if (deref_tpar_ptr^.str[aux-1] = delimiter) then
			begin          { criterion for a correct  deref }
			pattern_definition.length := pattern_definition.length -
			  ( aux + 2);    { wipe out the deref stuff and quotes }
			tpar_sort := cmd_pattern_dummy_text;  { so prompts "text  :" ## }
			deref_tpar_ptr^.len := aux-2;{ wipe out delim and quote}
			deref_tpar_ptr^.dlm := delimiter;
			if not tpar_get_1(deref_tpar_ptr,tpar_sort,deref_span)
									    then
{#if fpc}
                              longjmp(jmpb, 100); { get the dereferenced span }
{#else}
{##                             goto 100;  #< get the dereferenced span #>}
{#endif}
			with deref_span do
			  begin                        { wrap it in quotes }
			  ch_move(str,1,str,2,len);
			  len := len +2;
			  str[len] := aux_ch_1;
			  str[1] := aux_ch_1;
			  end;
			aux_count := 0;        { recur }
			if pattern_getch(aux_count,aux_pat_ch,deref_span) then
			   pattern_pattern(current_state,current_state,
				     aux_count,deref_span,aux_pat_ch,depth+1);
			end
		      else  { its just looking for a string that happened to }
			    {  start with a Dereference delimiter }
			begin           { put it all back }
			pat_ch := delimiter;
			pattern_definition.length := pattern_definition.length +
			  ( aux + 2 );
			parse_count := aux_count+1;
			no_dereference := true;   { ok we drop out and let }
			end;               { the normal processing take it }
		      end
		    else
		      begin   { was just a single $ or & }
		      pat_ch := delimiter;
		      pattern_definition.length := pattern_definition.length +
			( aux + 2 );
		      parse_count := aux_count+1;
		      no_dereference := true;
		      end;
		    dispose(deref_tpar_ptr);
		    end {if it's a deref}
		  else
		    no_dereference := true;
		  if no_dereference then
		    if aux_ch_1 = tpd_exact then
		      begin
		      while pat_ch <> tpd_exact do
			begin
			with nfa_table[current_state] do
			  begin
			  epsilon_out := false;
			  accept_set  :=  [ord(pat_ch)];
			  next_state  := pattern_new_nfa;
			  current_state := next_state;
			  end;
			if not pattern_getch(parse_count,pat_ch,in_string) then
			  begin
			  screen_message(msg_pat_no_matching_delim);
{#if fpc}
                          longjmp(jmpb, 99);
{#else}
{##                         goto 99;}
{#endif}
			  end;
			end;
		      end
		    else  { must be tpd_lit }
		      begin
		      while pat_ch <> tpd_lit do
			begin
			with nfa_table[current_state] do
			  begin
			  epsilon_out := false;
			  if pat_ch in ['a'..'z'] then
			    accept_set := [ord(pat_ch),ord(pat_ch)-32]
			  else
			  if pat_ch in ['A'..'Z'] then
			    accept_set := [ord(pat_ch),ord(pat_ch)+32]
			  else
			   accept_set := [ord(pat_ch)];
			  next_state := pattern_new_nfa;
			  current_state := next_state;
			  end;
			if not pattern_getch(parse_count,pat_ch,in_string) then
			  begin
			  screen_message(msg_pat_no_matching_delim);
{#if fpc}
                          longjmp(jmpb, 99);
{#else}
{##                         goto 99;}
{#endif}
			  end;
			end;
		      end;
		  end; {tpd_lit,tpd_exact}
		pattern_lparen:
		  begin
		  dummy := pattern_getch(parse_count,pat_ch,in_string);
		  pattern_compound(current_state,aux_state,parse_count,
				   in_string,pat_ch,depth+1);
		  current_state := aux_state;
		  if pat_ch <> pattern_rparen then
		    begin
		    screen_message(msg_pat_no_matching_delim);
{#if fpc}
                    longjmp(jmpb, 99);
{#else}
{##                   goto 99;}
{#endif}
		    end;
		  end;
		pattern_mark:
		  begin
		  if pattern_getnumb(parse_count,aux,pat_ch,in_string) then
		    begin
		    if (aux = 0) or (aux > max_mark_number) then
		      begin
		      screen_message(msg_pat_illegal_mark_number);
{#if fpc}
                      longjmp(jmpb, 99);
{#else}
{##                     goto 99;}
{#endif}
		      end;
		    with nfa_table[current_state] do
		      begin
		      epsilon_out := false;
		      accept_set := [ aux + pattern_marks_start ];
		      next_state := pattern_new_nfa;
		      current_state := next_state;
		      end;
		    end
		  else
		    begin
		    screen_message(msg_pat_illegal_mark_number);
{#if fpc}
                    longjmp(jmpb, 99);
{#else}
{##                   goto 99;}
{#endif}
		    end;
		  end;
		pattern_equals, pattern_modified:
		  begin
		  with nfa_table[current_state] do
		    begin
		    epsilon_out := false;
		    if pat_ch = pattern_equals then
		      accept_set := [ pattern_marks_equals ]
		    else
		      accept_set := [ pattern_marks_modified ];
		    next_state := pattern_new_nfa;
		    current_state := next_state;
		    end;
		  end;
	      end{case}
	    else             { any alpha and '-' }
	      begin          {  SET  }
	      negate := false;
	      if  pat_ch = pattern_negate then
		begin
		negate := true;
		if not pattern_getch(parse_count,pat_ch,in_string) then
		  begin
		  screen_message(msg_pat_premature_pattern_end);
{#if fpc}
                  longjmp(jmpb, 99);
{#else}
{##                 goto 99;}
{#endif}
		  end;
		end;
	      { have eaten any '-' therefore only have alpha }
	      if (pat_ch = pattern_define_set_u)
		 or (pat_ch = pattern_define_set_l) then   {make a set}
		begin
		aux_set := [];
		if not pattern_getch(parse_count,pat_ch,in_string) then
		  begin
		  screen_message(msg_pat_premature_pattern_end);
{#if fpc}
                  longjmp(jmpb, 99);
{#else}
{##                 goto 99;}
{#endif}
		  end;
		   { eat the define symbol }
		delimiter := pat_ch;
		temporary := pattern_definition.length;
		pattern_definition.strng[temporary] := chr(0);
		  { a null, so that all delimiters become the same }
		if delimiter in [tpd_span,tpd_prompt] then
		  begin   { is a $ or &, therefore build tpar }
		  new(deref_tpar_ptr);
		  deref_tpar_ptr^.dlm := delimiter;
		  if not pattern_getch(parse_count,pat_ch,in_string) then
		    begin
		    screen_message(msg_pat_premature_pattern_end);
{#if fpc}
                    longjmp(jmpb, 99);
{#else}
{##                   goto 99;}
{#endif}
		    end;
		  { eat the delimiter }
		  aux := 0;
		  while pat_ch <> delimiter do
		    begin
		    aux:= aux+ 1;
		    deref_tpar_ptr^.str[aux] := pat_ch;
		    if not pattern_getch(parse_count,pat_ch,in_string)
		    then
		      begin
		      screen_message(msg_pat_no_matching_delim);
{#if fpc}
                      longjmp(jmpb, 99);
{#else}
{##                     goto 99;}
{#endif}
		      end;
		    end;
		  pattern_definition.length := pattern_definition.length -
		    ( aux + 1);  { wipe the deref but leave the NULL }
		  deref_tpar_ptr^.len := aux;
		  if not tpar_get_1(deref_tpar_ptr,tpar_sort,deref_span)then
{#if fpc}
                    longjmp(jmpb, 100);
{#else}
{##                   goto 100;}
{#endif}
		    { get the dereferenced span or whatever else it is }
		    { set is returned in deref_span }
		  dispose(deref_tpar_ptr);
		  end
		else     { a user defined set string }
		  begin  { build set specifier in deref_span }
		  aux := 0;
		  if not pattern_getch(parse_count,pat_ch,in_string) then
		    begin
		    screen_message(msg_pat_premature_pattern_end);
{#if fpc}
                    longjmp(jmpb, 99);
{#else}
{##                   goto 99;}
{#endif}
		    end;
		  pattern_definition.strng[pattern_definition.length] :=
		    chr(0);
		  while pat_ch <> delimiter do
		    begin
		    aux:= aux+ 1;
		    deref_span.str[aux] := pat_ch;
		    if not pattern_getch(parse_count,pat_ch,in_string) then
		      begin
		      screen_message(msg_pat_no_matching_delim);
{#if fpc}
                      longjmp(jmpb, 99);
{#else}
{##                     goto 99;}
{#endif}
		      end;
		    end;
		  deref_span.len := aux;
		  end; {user defined set string}
		aux_set := [];
		with deref_span do      { Form the character set. }
		  begin
		  aux := 1;
		  while aux <= len do
		    begin
		    aux_ch_1 := str[aux];
		    aux_ch_2 := aux_ch_1;
		    aux := aux+1;
		    if aux + 2 <= len then
		      if (str[aux] = '.') and (str[aux+1] = '.') then
			begin
			aux_ch_2 := str[aux+2];
			aux := aux+3;
			end;
		    aux_set := aux_set + [ord(aux_ch_1)..ord(aux_ch_2)];
		    end;
		  end;
		with pattern_definition do
		  begin      { put set definition into Pattern_definition }
		  for aux_count := 1 to deref_span.len do
		    strng[temporary + aux_count] :=
						  deref_span.str[aux_count];
		    length := temporary + deref_span.len+1;
							{plus room for null}
		    strng[length] := chr(0);  { put in other delimiter }
		  end;
		if negate then
		  aux_set := [pattern_alpha_start..max_set_range]
			      - aux_set;
		with nfa_table[current_state] do
		  begin
		  epsilon_out := false;
		  accept_set := aux_set;
		  next_state := pattern_new_nfa;
		  current_state := next_state;
		  end;
		end
	      else
		if pat_ch in ['s','S','a','A','c','C','l','L','u','U',
			      'n','N','p','P','<','>','{','}','^'] then
		  begin
		  with nfa_table[current_state] do
		    begin
		    epsilon_out := false;
		    if pat_ch in ['<','>','{','}','^'] then
		      begin { predefined positional sets }
		      if negate then
		        begin
			screen_message(msg_pat_illegal_parameter);
{#if fpc}
                        longjmp(jmpb, 99);
{#else}
{##                       goto 99;}
{#endif}
			end;
		      case pat_ch of
			'<' : accept_set := [pattern_beg_line ];
			'>' : accept_set := [pattern_end_line ];
			'{' : accept_set := [pattern_left_margin];
			'}' : accept_set := [pattern_right_margin];
			'^' : accept_set := [pattern_dot_column];
		      end{case};
		      end
		    else    { predefined char sets }
		      begin
		      case pat_ch of
			's','S'   : accept_set := space_set;
			'c','C'   : accept_set := printable_set;
			'a','A'   : accept_set := alpha_set;
			'l','L'   : accept_set := lower_set;
			'u','U'   : accept_set := upper_set;
			'n','N'   : accept_set := numeric_set;
			'p','P'   : accept_set := punctuation_set;
		      end{case}; {pat_ch}
		      if negate then
			accept_set :=
				    [pattern_alpha_start..max_set_range]
				    - accept_set;
		      end;
		    next_state := pattern_new_nfa;
		    current_state := next_state;
		    end; {with NFA_table[current_state]}
		  end
		else
		  begin
		  screen_message(msg_pat_set_not_defined);
{#if fpc}
                  longjmp(jmpb, 99);
{#else}
{##                 goto 99;}
{#endif}
		  end;
	      end;
	    if leading_param = pattern_range then
	      begin
	      nfa_table[current_state].epsilon_out := true;
	      nfa_table[current_state].first_out := pattern_null;
	      pattern_range_build(range_start,range_end,
				  range_patch,range_indefinite);
	      end;
	    end; {processing of parameterized clauses}
	end{case};
	{ get next char and eat trailing blanks }
	repeat
	  end_of_input := not pattern_getch(parse_count,pat_ch,in_string);
	until  end_of_input  or (pat_ch <> pattern_space);
	end; {while}
      finish := current_state;
      tpar_clean_object(deref_span);
      end; {pattern_pattern}

    begin {pattern_compound}
    if depth > pattern_max_depth then
      begin
      screen_message(msg_pat_pattern_too_complex);
{#if fpc}
      longjmp(jmpb, 99);
{#else}
{##     goto 99;}
{#endif}
      end;
    current_e_start := first;
    with nfa_table[current_e_start] do
      begin
      epsilon_out := true;
      second_out := pattern_null;
      first_out  := pattern_new_nfa;
      pattern_pattern(first_out,finish,parse_count,in_string,pat_ch,depth+1);
      compound_finish := finish;
      if (pat_ch = pattern_bar) then
	begin
	if pattern_getch (parse_count,pat_ch,in_string) then
	  begin
	  second_out := pattern_new_nfa;
	  pattern_compound(second_out,finish,parse_count,
			   in_string,pat_ch,depth+1);
	  with nfa_table[compound_finish] do
	    begin
	    epsilon_out := true;
	    first_out := pattern_null;
	    second_out := finish;
	    end;
	  end
	else
	  second_out := finish;
	end;
      end; {with}
    end; {pattern_compound}

{#endif}
  begin {pattern_parser}
{#if not turbop or fpc}
{#if fpc}
  case setjmp(jmpb) of
    0	: goto 0;
    99	: goto 99;
    100	: goto 100;
  end;
0:
{#endif}
  pattern_parser := false;
  exit_abort := true;  { set true in case of syntax error }
  pattern_definition.length := 0;
  with nfa_table[pattern_null] do
    begin
    epsilon_out := true;
    first_out   := pattern_null;
    second_out  := pattern_null;
    end;
  states_used         := pattern_nfa_start;
  first_pattern_start := pattern_new_nfa;
  parse_count := 0;
  if pattern_getch(parse_count,pat_ch,pattern) then
    begin
    pattern_compound(first_pattern_start,first_pattern_end,
		     parse_count,pattern,pat_ch,1);        { 1st }
    if pat_ch = pattern_comma then             { we have a second pattern }
      if pattern_getch(parse_count,pat_ch,pattern)
      then  { otherwise pattern null }
	begin
	left_context_end   := first_pattern_end;
	pattern_compound(left_context_end,middle_context_end,
			 parse_count,pattern,pat_ch,1);    { 2nd }
	end
      else
	begin
	{ null middle }
	middle_context_end   := first_pattern_end;
	pattern_final_state  := first_pattern_end;
	end
    else   { no further input so pattern is middle context }
      begin
      left_context_end     := first_pattern_start;
      pattern_final_state  := first_pattern_end;
      middle_context_end   := first_pattern_end;
      end;
    if pat_ch = pattern_comma then       { we have a third pattern }
      if pattern_getch(parse_count,pat_ch,pattern) then
	begin
	pattern_compound(middle_context_end,pattern_final_state,
			 parse_count,pattern,pat_ch,1);   { 3rd }
	end
      else
	{ null right context }
	pattern_final_state := middle_context_end
    else             { no right context }
      pattern_final_state := middle_context_end;
    end  { of begin of if Pattern_getch }
  else   { not Pattern_getch }
    begin screen_message(msg_pat_null_pattern); goto 99; end;
  with nfa_table[pattern_final_state] do
    begin
    epsilon_out := true;
    first_out   := pattern_null;
    second_out  := pattern_null;
    end;
  pattern_parser := true;
99:  { exit with a pattern error }
			 { hey wow ! we got through the parser, guess we'd }
  exit_abort := false;   { better not crunge out then }
100: { exit with someone else's error }
{#endif}
  end; {pattern_parser}

{#if vms or turbop}
end.
{#endif}
