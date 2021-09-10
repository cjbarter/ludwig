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
{       Jeff Blows (1989); and                                         }
{       Kelvin B. Nicolle (1989).                                      }
{                                                                      }
{  Copyright  1987-89 University of Adelaide                           }
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
! Name:         DFA
!
! Description:  Builds the deterministic FSA for the pattern recognizer.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/dfa.pas,v 4.5 1990/01/18 18:18:42 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: dfa.pas,v $
! Revision 4.5  1990/01/18 18:18:42  ludwig
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
{##[ident('4-005')]}
{##module dfa (output);}
{#elseif turbop}
unit dfa;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##  partition_ptr_type = ^accept_set_partition_type;}
{##  accept_set_partition_type =}
{##    record}
{##    accept_set_partition : accept_set_type;}
{##    nfa_transition_list  : nfa_attribute_type;}
{##    flink,blink          : partition_ptr_type;}
{##    end;}
{##%include 'var.i'}
{##}
{##%include 'dfa.fwd'}
{##%include 'screen.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{##  partition_ptr_type = ^accept_set_partition_type;}
{##  accept_set_partition_type =}
{##    record}
{##    accept_set_partition : accept_set_type;}
{##    nfa_transition_list  : nfa_attribute_type;}
{##    flink,blink          : partition_ptr_type;}
{##    end;}
{####include "var.i"}
{##}
{####include "dfa.h"}
{####include "screen.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{##  partition_ptr_type = ^accept_set_partition_type;}
{##  accept_set_partition_type =}
{##    record}
{##    accept_set_partition : accept_set_type;}
{##    nfa_transition_list  : nfa_attribute_type;}
{##    flink,blink          : partition_ptr_type;}
{##    end;}
{###<$F=var.i#>}
{##}
{###<$F=dfa.h#>}
{###<$F=screen.h#>}
{#elseif turbop}
interface
  uses value;
  {$I dfa.i}

implementation
  uses screen;

type
  partition_ptr_type = ^accept_set_partition_type;
  accept_set_partition_type =
    record
    accept_set_partition : accept_set_type;
    nfa_transition_list  : nfa_attribute_type;
    flink,blink          : partition_ptr_type;
    end;
{#endif}


{}procedure closure_kill (var closure  : nfa_attribute_type);

    var
      pointer_1 : state_elt_ptr_type;
      pointer_2 : state_elt_ptr_type;

    begin {closure_kill}
    pointer_1 := closure.equiv_list;
    while pointer_1 <> nil do
      begin
      pointer_2 := pointer_1^.next_elt;
      dispose(pointer_1);
      pointer_1 := pointer_2;
      end;
    closure.equiv_list := nil;
    end; {closure_kill}


{}procedure transition_kill (var pointer_1 : transition_ptr);

    var
      pointer_2 : transition_ptr;

    begin {transition_kill}
    while pointer_1 <> nil do
      begin
      pointer_2 := pointer_1^.next_transition;
      dispose(pointer_1);
      pointer_1 := pointer_2;
      end;
    end; {transition_kill}


function pattern_dfa_table_kill (
	var     pattern_ptr : dfa_table_ptr)
	: boolean;

    var
      count : dfa_state_range;

    begin {pattern_dfa_table_kill}
    if pattern_ptr <> nil then
      begin
      with pattern_ptr^ do
	for count := 0 to dfa_states_used do
	  with dfa_table[count] do
	    begin
	    transition_kill(transitions);
	    closure_kill(nfa_attributes);
	    end;
      dispose(pattern_ptr);
      pattern_ptr := nil;
      end;
    pattern_dfa_table_kill := true;
    end; {pattern_dfa_table_kill}


function pattern_dfa_table_initialize (
	var     pattern_ptr        : dfa_table_ptr;
		pattern_definition : pattern_def_type)
	:  boolean;

    var
      count : dfa_state_range;

    begin {pattern_dfa_table_initialize}
    if pattern_ptr <> nil then
      with pattern_ptr^ do
	begin
	for count := 0 to dfa_states_used do
	  with dfa_table[count] do
	    begin
	    transition_kill(transitions);
	    closure_kill(nfa_attributes);
	    end;
	dfa_states_used := 0;
	end
    else
      begin
      new(pattern_ptr);
      with pattern_ptr^ do
	begin
	dfa_states_used := 0;
	for count := 0 to max_dfa_state_range do
	  with dfa_table[count] do
	    begin
	    transitions := nil;
	    nfa_attributes.equiv_list := nil;
	    end;
	end;
      end;
    pattern_ptr^.definition := pattern_definition;
    pattern_dfa_table_initialize := true;
    end; {pattern_dfa_table_initialize}


function pattern_dfa_convert (
	var     nfa_table            : nfa_table_type;
		dfa_table_pointer    : dfa_table_ptr;
	var     nfa_start,
		nfa_end              : nfa_state_range;
		middle_context_start,
		right_context_start  : nfa_state_range;
	var     dfa_start,
		dfa_end              : dfa_state_range)
	: boolean;

    label 99;
    var
      aux_elt       : state_elt_ptr_type;
      state,
      current_state : dfa_state_range;
      closure_set   : nfa_set_type;
      transfer_state: nfa_attribute_type;
      transition_set: nfa_attribute_type;
      aux_state_ptr : state_elt_ptr_type;
      states_used   : dfa_state_range;
      aux_count,
      aux_count_2   : dfa_state_range;
      incoming_tran_ptr,
      kill_tran_ptr,
      aux_tran_ptr_2,
      aux_tran_ptr  : transition_ptr;
      found         : boolean;
      aux_set                :  nfa_set_type;
      aux_transition_set     :  accept_set_type;
      mask                   :  nfa_set_type;
      kill_set               :  accept_set_type;
      intersection_set       :  accept_set_type;
      partition_ptr          :  partition_ptr_type;
      aux_partition_ptr      :  partition_ptr_type;
      current_partition_ptr  :  partition_ptr_type;
      follower_ptr           :  partition_ptr_type;
      killer_ptr             :  partition_ptr_type;
      insert_partition       :  partition_ptr_type;
      aux_equiv_ptr  : state_elt_ptr_type;
      aux_closure    :  nfa_attribute_type;


    function epsilon_closures(    state_set : nfa_attribute_type;
			      var closure   : nfa_attribute_type)
	     : boolean;

      label 99;
      const
	max_stack_size = 50;
      type
	stack_range = 0.. max_stack_size;
      var
	stack           : array [stack_range] of nfa_state_range;
	stack_top       : stack_range;
	kill_ptr,
	state_elt_ptr   : state_elt_ptr_type;
	aux_state       : nfa_state_range;
	fail_equivalent : boolean;

      function push_stack(state : nfa_state_range) : boolean;

	label 99;

	begin {push_stack}
	push_stack := false;
	if stack_top < max_stack_size then
	  begin
	  stack_top := stack_top + 1;
	  stack[stack_top] := state;
	  closure.equiv_set := closure.equiv_set + [state];
	  end
	else
	  begin screen_message(msg_pat_pattern_too_complex); goto 99 end;
	push_stack := true;
      99:
	end; {push_stack}

      begin {epsilon_closures}
      epsilon_closures := false;
      stack_top := 0;
      closure.equiv_set := [];
      closure.generator_set := [];
      fail_equivalent := false;
      state_elt_ptr := state_set.equiv_list;
      while state_elt_ptr <> nil do
	begin
	if not push_stack(state_elt_ptr^.state_elt) then goto 99;
	kill_ptr := state_elt_ptr;
	state_elt_ptr := state_elt_ptr^.next_elt;
	dispose(kill_ptr);
	end;
      while (stack_top <> 0) and not fail_equivalent do
	begin
	aux_state := stack[stack_top];    { pop off stack }
	stack_top := stack_top -1;
	with nfa_table[aux_state] do
	  begin
	  if fail then fail_equivalent := true;
	  if epsilon_out then
	    begin
	    if first_out <> pattern_null then
	      if not (first_out in closure.equiv_set) then
		if not push_stack(first_out) then goto 99;
	    if second_out <> pattern_null then
	      if not (second_out in closure.equiv_set) then
		if not push_stack(second_out) then goto 99;
	    end;
	  end;
	end;
      if fail_equivalent then
	begin
	closure.equiv_list := nil;  { Naughty }  { fix later }
	closure.equiv_set := [pattern_dfa_fail];
	end;
      epsilon_closures := true;
    99:
      end; {epsilon_closures}

    function epsilon_and_mask(    state   : nfa_state_range;
			      var closure : nfa_set_type;
			      var mask    : nfa_set_type;
				  maxim   : boolean   )
	     : boolean;

      label 99;
      var
	aux_elt     : nfa_state_range;
	aux_elt_ptr : state_elt_ptr_type;
	transition_set : nfa_attribute_type;

      begin {epsilon_and_mask}
      epsilon_and_mask := false;
      new(aux_elt_ptr);
      aux_elt_ptr^.next_elt := nil;
      aux_elt_ptr^.state_elt := state ;
      transition_set.equiv_list := aux_elt_ptr;
      transition_set.equiv_set := [state] ;
      if not epsilon_closures(transition_set,transition_set) then goto 99;
      closure := transition_set.equiv_set;
      if maxim then
	begin
	aux_elt := max_nfa_state_range;  { the elt corr to M-C is always present }
	while not (aux_elt in closure) do
	  aux_elt := aux_elt -1;
	mask := [0..aux_elt];
	end
      else
	begin
	aux_elt := pattern_nfa_start ;
	while not (aux_elt in closure) do
	  aux_elt := aux_elt +1;
	mask := [0..aux_elt-1];
	end;
      epsilon_and_mask := true;
    99:
      end; {epsilon_and_mask}


    function pattern_new_dfa(    equivalent_set : nfa_attribute_type;
			     var state_count : dfa_state_range)
	     : boolean;

      label 99;
      var
	i       : nfa_state_range;
	aux_elt : state_elt_ptr_type;

      begin {pattern_new_dfa}
      pattern_new_dfa := false;
      if states_used < max_dfa_state_range then
	begin
	states_used := states_used +1;
	with dfa_table_pointer^.dfa_table[states_used] do
	  begin
	  nfa_attributes := equivalent_set;     { gets equiv set and generator set }
	  nfa_attributes.equiv_list := nil;
	  for i := 0 to max_nfa_state_range do            { build list }
	    if i in equivalent_set.equiv_set then
	      begin
	      new(aux_elt);
	      aux_elt^.next_elt := nfa_attributes.equiv_list;
	      aux_elt^.state_elt := i;
	      nfa_attributes.equiv_list := aux_elt;
	      end;
	  transitions := nil;
	  marked := false;
	  pattern_start := false;
	  left_transition := false;
	  right_transition := false;
	  left_context_check := false;
	  final_accept := false;
	  end;
	end
      else
	begin screen_message(msg_pat_pattern_too_complex); goto 99 end;
      state_count := states_used;
      pattern_new_dfa := true;
    99:
      end; {pattern_new_dfa}


    function pattern_add_dfa(transfer_state : nfa_attribute_type;
			     accept_set     : accept_set_type;
			     from_state     : dfa_state_range)
	     : boolean;

      { if a DFA state with tranfer_state as its NFA_attributes does not exist  }
      { then create it and add a transition from from_state on the accept_set   }
      { to transfer_state.                                                      }
      { if the DFA_state already exists then just add the transition to the     }
      { from_states transition list      }

      label 99;
      var
	position       : dfa_state_range;
	aux_transition : transition_ptr;


      function dfa_search (    state_head : nfa_set_type;
			   var position   : dfa_state_range ) : boolean;

	{ finds the position in DFA_table of the state that has an NFA_equivalent }
	{ of state_head  }

	label 1;
	var
	  i : dfa_state_range;

	begin {dfa_search}
	dfa_search := false;
	with dfa_table_pointer^ do
	  begin
	  for i := 0 to states_used do
	    if state_head = dfa_table[i].nfa_attributes.equiv_set then
	      begin
	      dfa_search := true;
	      position := i;
	      goto 1;
	      end;
	  end;
      1:
	end; {dfa_search}

      begin {pattern_add_dfa}
      pattern_add_dfa := false;
      if not dfa_search(transfer_state.equiv_set,position) then
	{ create new DFA state }
	if not pattern_new_dfa(transfer_state,position) then goto 99;
      with dfa_table_pointer^.dfa_table[from_state] do
	begin
	new(aux_transition);          { create a new transition in from_state }
	with aux_transition^ do       { to position on input accept_elt       }
	  begin
	  next_transition := transitions;
	  transitions := aux_transition;
	  transition_accept_set := accept_set;
	  accept_next_state := position;
	  start_flag := false;
	  end;
	end;
      pattern_add_dfa := true;
    99:
      end; {pattern_add_dfa}

    function unmarked_states(var unmarked_state : dfa_state_range) : boolean;

      label 1;
      var
	i : integer;

      begin {unmarked_states}
      unmarked_states := false;
      for i :=  dfa_start to states_used do
	  if not dfa_table_pointer^.dfa_table[i].marked then
	    begin
	    unmarked_states := true;
	    unmarked_state := i;
	    goto 1;
	    end;
      1:
      end; {unmarked_states}

    function transition_list_merge(list_1,list_2 : state_elt_ptr_type)
						   : state_elt_ptr_type;

      { makes a copy of 2 lists and concatenates them }
      var
	aux_1,aux_2 : state_elt_ptr_type;

      begin {transition_list_merge}
      aux_1 := nil;
      while list_1 <> nil do
	begin
	aux_2 := aux_1;
	new(aux_1);
	aux_1^.state_elt := list_1^.state_elt;
	aux_1^.next_elt := aux_2;
	list_1 := list_1^.next_elt;
	end;
      while list_2 <> nil do
	begin
	aux_2 := aux_1;
	new(aux_1);
	aux_1^.state_elt := list_2^.state_elt;
	aux_1^.next_elt := aux_2;
	list_2 := list_2^.next_elt;
	end;
      transition_list_merge := aux_1;
      end; {transition_list_merge}

    function transition_list_append(list_1,list_2 : state_elt_ptr_type)
						    : state_elt_ptr_type;

      { makes a copy of list_2 and concatenates it to list_1 }
      { on the front }
      var
	aux_1,aux_2 : state_elt_ptr_type;

      begin {transition_list_append}
      aux_1 := list_1;
      while list_2 <> nil do
	begin
	aux_2 := aux_1;
	new(aux_1);
	aux_1^.state_elt := list_2^.state_elt;
	aux_1^.next_elt := aux_2;
	list_2 := list_2^.next_elt;
	end;
      transition_list_append := aux_1;
      end; {transition_list_append}

    begin {pattern_dfa_convert}
    pattern_dfa_convert := false;
    exit_abort := true; { true in case we blow the dfa table or something }
    with dfa_table_pointer^ do
      begin
      with dfa_table[pattern_dfa_kill] do
	begin
	transitions := nil;
	marked := true;
	nfa_attributes.equiv_set := [];
	pattern_start := false;
	left_transition := false;
	right_transition := false;
	left_context_check := false;
	final_accept := false;
	end;
      with dfa_table[pattern_dfa_fail] do
	begin
	transitions := nil;
	marked := true;
	nfa_attributes.equiv_set := [pattern_dfa_fail];
	pattern_start := false;
	left_transition := false;
	right_transition := false;
	left_context_check := false;
	final_accept := false;
	end;
      states_used := 1;         { build initial state }
      new(aux_elt);
      aux_elt^.next_elt := nil;
      aux_elt^.state_elt := nfa_start ;
      transition_set.equiv_list := aux_elt;
      transition_set.equiv_set := [nfa_start] ;
      if not epsilon_closures(transition_set,aux_closure) then goto 99;
      if not pattern_new_dfa(aux_closure,dfa_start) then goto 99;
      while unmarked_states(current_state) do
	begin
	if tt_controlc then  { a reasonable place for it, gets tested once }
	  begin              { per state, = about 0.03 seconds actual cp }
	  dfa_table_pointer^.definition.length := 0; { invalidate the table }
	  goto 99;           { DFA_table will be disposed on next call to DFA }
	  end;
	kill_set := [0..max_set_range];
	partition_ptr := nil;
	with dfa_table[current_state] do
	  begin
	  marked := true;
	  aux_equiv_ptr := nfa_attributes.equiv_list;
	  while aux_equiv_ptr <> nil do
	    begin                         { for transitions in equiv NFA elts }
	    with nfa_table[aux_equiv_ptr^.state_elt] do
	      if not epsilon_out then       { for all SIGNIFICANT }
		begin
		aux_partition_ptr := partition_ptr;
		new(partition_ptr);
		with partition_ptr^ do
		  begin         { build list of transitions with accept sets }
		  accept_set_partition := accept_set;
		  kill_set := kill_set - accept_set;  { update kill set }
		  flink := aux_partition_ptr;         { link forward }
		  blink := nil;                       { top of list so no blink }
		  if flink <> nil then             { if there is a next one down }
		    flink^.blink := partition_ptr;    { link it back here }
		  new(nfa_transition_list.equiv_list);   { create the NFA state }
		  nfa_transition_list.equiv_list^.next_elt := nil; { (only one) }
		  nfa_transition_list.equiv_list^.state_elt := next_state;
		  end;
		end;
	    aux_equiv_ptr := aux_equiv_ptr^.next_elt;
	    end;
	  end; {with dfa_table[current_state]}
	{ OK kiddies we now have a partitionable list }
	if (partition_ptr <> nil) then
	if (partition_ptr^.flink <> nil) then
	  begin
	  current_partition_ptr := partition_ptr;
	  follower_ptr := current_partition_ptr^.flink;
	  while current_partition_ptr <> nil do
	    begin
	    if follower_ptr = current_partition_ptr then
	      follower_ptr := follower_ptr^.flink;
	    aux_partition_ptr := follower_ptr;
	    while aux_partition_ptr <> nil do
	      begin
	      if current_partition_ptr^.accept_set_partition =
		 aux_partition_ptr^.accept_set_partition   then
		begin  { merge entrys }
		aux_state_ptr :=
		  current_partition_ptr^.nfa_transition_list.equiv_list;
		while aux_state_ptr^.next_elt <> nil do   { run to the end }
		  aux_state_ptr := aux_state_ptr^.next_elt;
		aux_state_ptr^.next_elt :=        { patch list on }
			   aux_partition_ptr^.nfa_transition_list.equiv_list;
		{ remove aux entry }
		{ the partition being removed has no encumberences }
		with aux_partition_ptr^ do
		  begin
		  blink^.flink := flink;
		  if flink <> nil then
		    flink^.blink := blink;
		  killer_ptr := aux_partition_ptr;
		  if follower_ptr = aux_partition_ptr then
		    follower_ptr := flink;
		  aux_partition_ptr := flink;
		  dispose(killer_ptr);
		  end;
		end
	      else    { form partition }
		begin
		intersection_set := current_partition_ptr^.accept_set_partition *
				    aux_partition_ptr^.accept_set_partition ;
		if intersection_set <> [] then    { preeety worthless if [] }
		  begin
		  if intersection_set = current_partition_ptr^.
					accept_set_partition   then
		    begin
		    current_partition_ptr^.nfa_transition_list.equiv_list :=
		    transition_list_append (
		    current_partition_ptr^.nfa_transition_list.equiv_list,
		    aux_partition_ptr^.nfa_transition_list.equiv_list);
		    aux_partition_ptr^.accept_set_partition :=
		      aux_partition_ptr^.accept_set_partition - intersection_set;
		    end
		  else
		    if intersection_set = aux_partition_ptr^.
					   accept_set_partition   then
		      begin
		      aux_partition_ptr^.nfa_transition_list.equiv_list :=
		      transition_list_append (
		      aux_partition_ptr^.nfa_transition_list.equiv_list,
		      current_partition_ptr^.nfa_transition_list.equiv_list);
		      current_partition_ptr^.accept_set_partition :=
			current_partition_ptr^.accept_set_partition -
							intersection_set;
		      end
		    else
		      begin    { need to do a full partition }
		      new(insert_partition);
		      with insert_partition^ do
			begin
			accept_set_partition := intersection_set;
			flink := follower_ptr;
			{ insert above follower ptr (<> nil)}
			blink := follower_ptr^.blink;
			flink^.blink := insert_partition;
			blink^.flink := insert_partition;
			nfa_transition_list.equiv_list := transition_list_merge(
			    current_partition_ptr^.nfa_transition_list.equiv_list,
			    aux_partition_ptr^.nfa_transition_list.equiv_list);
			end;
		      current_partition_ptr^.accept_set_partition :=
		      current_partition_ptr^.accept_set_partition -
							   intersection_set;
		      aux_partition_ptr^.accept_set_partition :=
		      aux_partition_ptr^.accept_set_partition - intersection_set;
		      end;    { of full partition }
		  end;
		aux_partition_ptr := aux_partition_ptr^.flink;
		end;  { of else }
	      end;  { of while aux_partition_ptr <> nil }
	    current_partition_ptr := current_partition_ptr^.flink;
	    end; { of while current_partition_ptr^.flink <> nil }
	  end;
	{ OK people we now have a partitioned list }
	{ now we use it to form DFA }
	with dfa_table[current_state] do
	  begin                             { bung in the kill transitions }
	  new(transitions);
	  with transitions^ do
	    begin
	    accept_next_state := pattern_dfa_kill;
	    start_flag := false;
	    next_transition := nil;
	    transition_accept_set:= kill_set;
	    end;
	  end;
	while partition_ptr <> nil do
	  begin
	  aux_partition_ptr := partition_ptr;
	  with aux_partition_ptr^ do
	    begin
	    if not epsilon_closures(nfa_transition_list,transfer_state) then goto 99;
	    if not pattern_add_dfa(transfer_state,accept_set_partition,current_state) then goto 99;
	    partition_ptr := flink;
	    { the NFA equiv list is disposed of by epsilon_closures }
	    dispose(aux_partition_ptr);
	    { we should now have no dangling objects }
	    end;
	{ run down list , use NFA_transition_list.equiv_list to form e-c }
	{ to specify  state to transfer to. Then add transition }
	  end;
	end;
      { END OF DFA GENERATION  }
      { Now we fix it up so it will drive the recognizer }
				       { find all final states }
      for aux_count := 0 to states_used do
	if nfa_end  in dfa_table[aux_count].nfa_attributes.equiv_set then
	  with dfa_table[aux_count] do
	    final_accept := true;
				 { start pattern flag creation }
      incoming_tran_ptr := dfa_table[pattern_dfa_start].transitions;
      while incoming_tran_ptr <> nil do    { find all transitions out of start }
	with incoming_tran_ptr^ do
	  begin
	  if (accept_next_state <> pattern_dfa_kill) and
	     (accept_next_state <> pattern_dfa_fail) and
	      not dfa_table[accept_next_state].final_accept   then
	    with dfa_table[accept_next_state] do
	      begin
	      pattern_start := true;
	      kill_tran_ptr := transitions;    { find transition to kill state }
	      while (kill_tran_ptr <> nil) and
		    (kill_tran_ptr^.accept_next_state <> pattern_dfa_kill) do
		kill_tran_ptr := kill_tran_ptr^.next_transition;
	      if kill_tran_ptr <> nil then
		begin
		aux_transition_set := incoming_tran_ptr^.transition_accept_set
				       * kill_tran_ptr^.transition_accept_set;
		if aux_transition_set <> [] then
		  begin
		  new(aux_tran_ptr);
		  with aux_tran_ptr^ do
		    begin
		    transition_accept_set :=  aux_transition_set;
		    accept_next_state := incoming_tran_ptr^.accept_next_state;
			{ point back to self all those transitions that are killed }
			{ and are the same as the transitions leading in to state  }
		    next_transition := nil;
		    start_flag := true;
		    end;
		  kill_tran_ptr^.transition_accept_set :=
		    kill_tran_ptr^.transition_accept_set
		    - aux_tran_ptr^.transition_accept_set;
		  kill_tran_ptr^.next_transition := aux_tran_ptr;
		  end;
		end;
	      end;
	  incoming_tran_ptr := incoming_tran_ptr^.next_transition;
	  end;
			       { find all end of left context states }
      if not epsilon_and_mask(middle_context_start,closure_set,mask,true) then goto 99;
      for aux_count := pattern_dfa_start to states_used do
	with dfa_table[aux_count],nfa_attributes do
	  if (middle_context_start in equiv_set) and
	       not ((equiv_set - mask) <> []  )       then
	     left_transition := true;
      aux_set := closure_set *
		 [middle_context_start..right_context_start];
      for aux_count_2 := pattern_dfa_start to states_used do
	if dfa_table[aux_count_2].left_transition then
	  begin          { is a context start }
	  aux_tran_ptr_2 := dfa_table[aux_count_2].transitions;
	  while aux_tran_ptr_2 <> nil do
	    begin        { for all members of head of context }
	    state :=  aux_tran_ptr_2^.accept_next_state;
	    if state > aux_count_2 then
	      begin     { stop it messing up previous contexts }
	      aux_tran_ptr := dfa_table[state].transitions;
	      found := false;      { find self transiting context head states }
	      while (aux_tran_ptr <> nil) and not found do
		if (aux_tran_ptr^.accept_next_state = state) then
			{ has a transition to itself }
		  found := true
		else
		  aux_tran_ptr := aux_tran_ptr^.next_transition;
	      if found then
		begin
		dfa_table[state].left_context_check := true; { assume the worst}
		for aux_count := middle_context_start to right_context_start do
		  { find those NFA states that are on the front of context }
		  { and are within the scope of an indefinte repetition }
		  { but within the context under consideration }
		  if nfa_table[aux_count].indefinite and (aux_count in aux_set)
		    and (aux_count in dfa_table[state].nfa_attributes.equiv_set)
		  then
		    dfa_table[state].left_context_check := false;
		end;
	      end;
	    aux_tran_ptr_2 := aux_tran_ptr_2^.next_transition;
	    end;
	  end;
			       { find all end of middle context states }
      if not epsilon_and_mask(right_context_start,closure_set,mask,true) then goto 99;
      for aux_count := 0 to states_used do
	with dfa_table[aux_count],nfa_attributes do
	  if (right_context_start in equiv_set) and
	       not ((equiv_set - mask) <> [] )        then
	     right_transition := true;
{     if states_used = pattern_dfa_start then
!       if dfa_table[pattern_dfa_start].transitions^.accept_next_state =
!            pattern_dfa_kill         then
!         begin screen_message( msg_pat_null_pattern ); goto 99; end;
!}
      dfa_end := states_used;  { for debugging }
      dfa_states_used := states_used;  { most important, for disposal of things }
      end; {with dfa_table_pointer^}
    exit_abort := false; { set them safe again now we are finished }
    pattern_dfa_convert := true;
  99:
    end; {pattern_dfa_convert}

{#if vms or turbop}
end.
{#endif}
