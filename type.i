!   This source file by:
!
!       Kelvin B. Nicolle (1987, 1989-90);
!       John Warburton (1989);
!       Jeff Blows (1989-90, 2020);
!       Steve Nairn (1990-91);
!       Martin Sandiford (2002, 2018).
!
!  Copyright  1979-81, 1987-89 University of Adelaide
!
!  Permission is hereby granted, free of charge, to any person
!  obtaining a copy of this software and associated documentation
!  files (the "Software"), to deal in the Software without
!  restriction, including without limitation the rights to use, copy,
!  modify, merge, publish, distribute, sublicense, and/or sell copies
!  of the Software, and to permit persons to whom the Software is
!  furnished to do so, subject to the following conditions:
!
!  The above copyright notice and this permission notice shall be}
!  included in all copies or substantial portions of the Software.
!
!  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
!  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
!  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
!  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
!  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
!  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
!  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
!  SOFTWARE.
!++
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/type.i,v 4.10 2002/07/20 08:55:07 martin Exp $
! $Author: martin $
! $Locker:  $
! $Log: type.i,v $
! Revision 4.10  2002/07/20 08:55:07  martin
! Minor tweaks for fpc port
!
! Revision 4.9  1991/02/26 18:07:08  ludwig
! modified the type definition of a frame object to include information on
! the extent of the mouse specified selection (in the form of a new mark) SN.
!
! Revision 4.8  91/02/22  12:50:59  ludwig
! Added prefix command for X mouse handling commands. SN
! 
! Revision 4.7  91/02/21  13:36:33  ludwig
! Added commands to handle mouse events and accessing the cut/paste buffer
! for the X version.  SN
! 
! Revision 4.6  90/02/08  10:38:25  ludwig
! fixed pcc #if syntax
! 
! Revision 4.5  90/02/05  13:32:45  ludwig
! Steven Nairn.
! Added cmd_resize_window to type commands.
! 
! Revision 4.4  90/01/18  17:20:13  ludwig
! Entered into RCS at revision level 4.3.
!
!
!---
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-003 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
! 4-004 Kelvin B. Nicolle                                    17-Jan-1990
!       Add cmd_file_save to type commands.
!--}

type

{#if turbop}
  integer = longint;
{#endif}

  char_set         = set of char;

{POINTERS TO ALL DYNAMIC OBJECTS.}

  code_ptr         = ^code_header;
  file_ptr         = ^file_object;
  frame_ptr        = ^frame_object;
  group_ptr        = ^group_object;
  line_ptr         = ^line_hdr_object;
  mark_ptr         = ^mark_object;
  span_ptr         = ^span_object;
  str_ptr          = ^str_object;
  tpar_ptr         = ^tpar_object;
  dfa_table_ptr    = ^dfa_table_object;
  transition_ptr   = ^transition_object;
  state_elt_ptr_type = ^state_elt_object;

{VAX/VMS DEPENDENT STUFF.}

{#if vms}
{##  byte             = [byte] 0..255;}
{##  word             = [word] 0..65535;}
{##  long             = integer;}
{##  vms_status_code  = integer;}
{##  string_descriptor= packed record}
{##                       len : word;}
{##                       typ : word;}
{##                       str : str_ptr;}
{##                     end;}
{##  vms_desblk       = record}
{##                       flink    : long;}
{##                       exh_addr : long;}
{##                       argcnt   : integer;}
{##                       sts_ptr  : ^ vms_status_code;}
{##                     end;}
{##  vms_mchargs      = record                      #<Mechanism Array              #>}
{##                       chf$l_mch_args  : integer;#< ## of arguments              #>}
{##                       chf$l_mch_frame : integer;#< Establisher Frame Address   #>}
{##                       chf$l_mch_depth : integer;#< Frame Depth Of Establisher  #>}
{##                       chf$l_mch_savr0 : integer;#< Saved Register R0           #>}
{##                       chf$l_mch_savr1 : integer;#< Saved Register R1           #>}
{##                     end;}
{##}
{##  #<THE FOLLOWING ARE ALSO USED BY BLISS-32 ROUTINES, DO NOT CHANGE.#>}
{##  vms_fab          = array [1..vms_fab$c_bln] of byte;}
{##  vms_nam          = array [1..vms_nam$c_bln] of byte;}
{##  vms_rab          = array [1..vms_rab$c_bln] of byte;}
{##  #<THE PRECEDING ARE ALSO USED BY BLISS-32 ROUTINES, DO NOT CHANGE.#>}
{##}
{##  vms_sigargs      = record                      #<Signal Array                 #>}
{##                       chf$l_sig_args  : integer;        #< ## of arguments      #>}
{##                       chf$l_sig_name  : vms_status_code;#< Signal name         #>}
{##                       chf$l_sig_arg1  : integer;        #< 1st sig specific arg#>}
{##                     end;}
{#endif}

{MISCELLANEOUS ENTITIES.}

  verify_response       = (verify_reply_yes
			  ,verify_reply_no
			  ,verify_reply_always
			  ,verify_reply_quit
			  );

  parse_type            = (parse_command
			  ,parse_input
			  ,parse_output
			  ,parse_edit
			  ,parse_stdin
			  ,parse_execute
			  );

  format_type           = (same_format
			  ,variable
			  ,stream_lf
			  ,numbered
			  );

  attribute_type        = (same_attribute
			  ,carriage_return
			  ,fortran_attribute
			  );

{SUBRANGES.}

  code_idx         = 0..max_code;
  col_offset_range = 0..max_strlen;
  col_range        = 1..max_strlenp;
  col_width_range  = 0..max_strlenp;
  file_range       = 1..max_files;
  slot_range       = 0..max_files;
  group_line_range = 0..max_grouplines;
  line_offset_range= 0..max_grouplineoffset;
  line_range       = 0..max_lines;
  mark_range       = min_mark_number..max_mark_number;
  space_range      = integer;
  scr_col_range    = 0..max_scr_cols;
  scr_row_range    = 0..max_scr_rows;
  strlen_range     = 0..max_strlen;
  nfa_state_range  = 0..max_nfa_state_range;
  dfa_state_range  = 0..max_dfa_state_range;
  accept_set_range = 0..max_set_range;
  word_set_range   = 0..max_word_sets_m1;

{SETS.}

  terminal_capabilities = set of        (trmflags_v_clsc
					,trmflags_v_cles
	(************************)      ,trmflags_v_clel
	(*                      *)      ,trmflags_v_inln
	(* This set is actually *)      ,trmflags_v_inch
	(* defined by TRMHND and*)      ,trmflags_v_dlln
	(* hence the definition *)      ,trmflags_v_dlch
	(* is set in concrete,  *)      ,trmflags_v_scdn
	(* and CAN'T BE CHANGED *)      ,trmflags_v_inmd
	(* by Ludwig.           *)      ,trmflags_v_wrap
	(*                      *)      ,trmflags_v_hard
	(************************)      );

  frame_options    = set of (opt_auto_indent,
			     opt_auto_wrap,
			     opt_new_line,
			     opt_special_frame {OOPS,COMMAND,HEAP});

  nfa_set_type     = set of nfa_state_range;
  dfa_set_type     = set of dfa_state_range;
  accept_set_type  = set of accept_set_range;

  { Arrays }
  mark_array       = array [mark_range] of mark_ptr;
  tab_array        = packed array [col_width_range] of boolean;
  verify_array     = packed array [1..max_verify] of boolean;

  { Strings }
  name_str         = packed array [1..name_len] of char;
  file_name_str    = packed array [1..file_name_len] of char;
  prompt_str       = packed array [1..tpar_prom_len] of char;
  write_str        = packed array [1..write_str_len] of char;
  msg_str          = packed array [1..msg_str_len] of char;
  number_str       = packed array [1..20] of char;
  key_str          = packed array [1..key_len] of char; {Help File stuff}

  { Keyboard interface. }
  key_code_range   = -max_special_keys..ord_maxchar;
  key_name_len_range = 2..key_name_len;
  key_names_range  = 0..max_nr_key_names;
  key_name_str     = packed array [1..key_name_len] of char;
  key_name_record  =  packed record
		      key_name : key_name_str;
		      key_code : key_code_range;
		      end;
  key_name_array   = array [key_names_range] of key_name_record;
  key_name_array_ptr = ^ key_name_array;
{#if vms}
{##  parse_table_index = 0..max_parse_table;}
{##  parse_table_record = packed record}
{##                       ch : char;}
{##                       key_code : [word] key_code_range;}
{##                       index : parse_table_index;}
{##                       end;}
{##  parse_table_array = array [parse_table_index] of parse_table_record;}
{##  parse_table_ptr  = ^ parse_table_array;}
{#elseif turbop}
  parse_table_index = 0..max_parse_table;
  parse_table_record = packed record
                       ch : char;
                       key_code : key_code_range;
                       index : parse_table_index;
                       end;
  parse_table_array = array [parse_table_index] of parse_table_record;
  parse_table_ptr  = ^ parse_table_array;
{#endif}

  { Objects }
  str_object       = packed array [1..max_strlen] of char;
{#if msdos}
{##  buffer_object    = packed array [1..max_buffer_len] of char;}
{#endif}

  tpar_object      = record             {trailing parameter for command}
		       len : strlen_range;
		       dlm : char;
		       str : str_object;
		       nxt : tpar_ptr;
		       con : tpar_ptr;
		     end;

  code_header      = record
		       flink,blink : code_ptr;  { Links into code_list }
		       ref  : 0..maxint;        { Reference count }
		       code : 1..max_code;    { Pointer into code array }
		       len  : 0..max_code;    { Length of segment }
		     end;

  file_object      = record

		       (***************************************)
		       (* THIS STRUCTURE MUST AGREE WITH ANY  *)
		       (*    EXTERNAL DEFINITION OF IT.       *)
		       (***************************************)

		       (* FIELDS FOR "FILE.PAS" ONLY.              *)

		       valid      : boolean;
{#if ns32000}
{##                       d1,d2,d3   : char;}
{#endif}
		       first_line : line_ptr;   {List of lines read in so far,}
		       last_line  : line_ptr;   {but not yet handed on to any }
		       line_count : line_range; {other place. # lines in list.}

		       (* FIELDS SET BY "FILESYS", READ BY "FILE". *)

		       output_flag: boolean;    {Is this an output file?       }
		       eof        : boolean;    {Set when inp file reaches eof.}
{#if ns32000}
{##                       d4,d5      : char;}
{#endif}
		       fns        : integer;    {Length of file name.          }
		       fnm        : file_name_str;
		       l_counter  : integer;

		       (* FIELDS FOR "FILESYS" ONLY.               *)

		       memory     : file_name_str;
		       tnm        : file_name_str;
		       entab      : boolean;
		       create     : boolean;
{#if ns32000}
{##                       d6,d7      : char;}
{#endif}
{#if vms}
{##                       buf_dsc    : string_descriptor; #<Both read & write  #>}
{##                       format     : format_type;}
{##                       attribute  : attribute_type;}
{##                       prn, prn_default : packed record}
{##                                          prefix, postfix : byte;}
{##                                          end;}
{##                       lf_count   : byte;}
{##                       skipping_after_cr : boolean;}
{##                       rbf_ind    : word;}
{##                       tns        : integer;}
{##                       dnm        : file_name_str;}
{##                       dns        : integer;}
{##                       fab        : vms_fab;}
{##                       rab        : vms_rab;}
{##                       nam        : vms_nam;}
{##                       directory_structured : boolean;}
{##                       previous_file_id : record}
{##                                          l0 : unsigned;}
{##                                          l1 : integer;}
{##                                          end;}
{#elseif unix or fpc}
		       fd         : integer;
		       mode       : integer;
		       idx        : integer;
		       len        : integer;
		       buf        : str_object;
		       previous_file_id_1 : integer;
		       previous_file_id_2 : integer;

		       (* Fields for controlling version backup *)

		       purge      : boolean;
{#if ns32000}
{##                       d8,d9,d10  : char;}
{#endif}
		       versions   : integer;
{#elseif msdos}
{##                       tns             : integer;}
{##                       memory_size     : integer;}
{##                       fd              : file;}
{##                       idx             : word;}
{##                       len             : word;}
{##                       buf             : buffer_object;}
{##}
{##                       #< Fields for controlling version backup #>}
{##}
{##                       purge      : boolean;}
{##                       versions   : integer;}
{#endif}

		       (* THE FOLLOWING FIELD SHOULD BE SET TO 'Z' BY "FILE", *)
		       (* IT IS CHECKED BY "FILESYS" AS A CONSISTENCY CHECK.  *)

		       zed        : char; {MUST BE 'Z'}
		     end;

   frame_object    = record
		       first_group      : group_ptr;
		       last_group       : group_ptr;
		       dot              : mark_ptr;
{#if XWINDOWS}
{##                       x_selection_end  : mark_ptr;}
{##                       selection_valid  : boolean;}
{#if ns3200}
{##                       d1, d2, d3        : char;}
{#endif}
{#endif}
		       marks            : mark_array;
		       scr_height       : scr_row_range;
		       scr_width        : scr_col_range;
		       scr_offset       : col_offset_range;
		       scr_dot_line     : scr_row_range;
		       span             : span_ptr;
		       return_frame     : frame_ptr;
		       input_count      : 0..maxint;
		       space_limit      : space_range;
		       space_left       : space_range;
		       text_modified    : boolean;
		       margin_left      : col_range;
		       margin_right     : col_range;
		       margin_top       : scr_row_range;
		       margin_bottom    : scr_row_range;
		       tab_stops        : tab_array;
		       options          : frame_options;
		       input_file       : slot_range;
		       output_file      : slot_range;
		       get_tpar         : tpar_object;   {Default search targ.}
		       get_pattern_ptr  : dfa_table_ptr;    { and pattern }
		       eqs_tpar         : tpar_object;   {Default equals targ.}
		       eqs_pattern_ptr  : dfa_table_ptr;
		       rep1_tpar        : tpar_object;   {Default replace targ.}
		       rep_pattern_ptr  : dfa_table_ptr;
		       rep2_tpar        : tpar_object;   {Default replace new.}
		       verify_tpar      : tpar_object;   {Default verify answer}
		     end;


  group_object     = record
		       flink,blink   : group_ptr;
		       frame         : frame_ptr;
		       first_line    : line_ptr;
		       last_line     : line_ptr;
		       first_line_nr : line_range;
		       nr_lines      : group_line_range;
		     end;
  line_hdr_object  = record
		       flink,blink   : line_ptr;
		       group         : group_ptr;
		       offset_nr     : line_offset_range;
		       mark          : mark_ptr;
		       str           : str_ptr;
		       len           : strlen_range;
		       used          : strlen_range;
		       scr_row_nr    : scr_row_range;
		     end;
  mark_object      = record
		       next          : mark_ptr;
		       line          : line_ptr;
		       col           : integer;
		     end;
  span_object      = record
		       flink,blink   : span_ptr;
		       frame         : frame_ptr;
		       mark_one      : mark_ptr;
		       mark_two      : mark_ptr;
		       name          : name_str;
		       code          : code_ptr;
		     end;

  prompt_region_attrib =
		     record
		       line_nr : scr_row_range;
		       redraw  : line_ptr;
		     end;

    transition_object =
      record
	transition_accept_set : accept_set_type;      { on this input set }
	accept_next_state     : dfa_state_range;      { goto this dfa state }
	next_transition       : transition_ptr;       { link to next object }
	start_flag            : boolean;              { special case flag for }
      end;                                            { starting patterns }


    nfa_attribute_type =
      record
	generator_set : nfa_set_type;
	equiv_list    : state_elt_ptr_type;
	equiv_set     : nfa_set_type;
      end;

    state_elt_object =
      record
	state_elt : nfa_state_range;
	next_elt  : state_elt_ptr_type;
      end;

    dfa_state_type =
      record
	transitions        : transition_ptr;
	marked             : boolean;
	nfa_attributes     : nfa_attribute_type;
	pattern_start,
	final_accept,
	left_transition,
	right_transition,
	left_context_check : boolean;
      end;

    pattern_def_type =
      record
	strng  : str_object;
	length : integer;
      end;

    dfa_table_object =
      record
	dfa_table          : array [dfa_state_range] of dfa_state_type;
	dfa_states_used    : dfa_state_range;
	definition         : pattern_def_type;
      end;

  { The following are the Structures that the outer level Ludwig Routines      }
  { use. These include the structures used by the compiler                     }

  commands = (
	cmd_noop,

	cmd_up,                    { cursor movement }
	cmd_down,
	cmd_left,
	cmd_right,
	cmd_home,
	cmd_return,
	cmd_tab,
	cmd_backtab,

	cmd_rubout,
	cmd_jump,
	cmd_advance,
	cmd_position_column,
	cmd_position_line,
	cmd_op_sys_command,

	cmd_window_forward,              { window control }
	cmd_window_backward,
	cmd_window_left,
	cmd_window_right,
	cmd_window_scroll,
	cmd_window_top,
	cmd_window_end,
	cmd_window_new,
	cmd_window_middle,
	cmd_window_setheight,
	cmd_window_update,

	cmd_get,                   { search and comparison }
	cmd_next,
	cmd_bridge,
	cmd_replace,
	cmd_equal_string,
	cmd_equal_column,
	cmd_equal_mark,
	cmd_equal_eol,
	cmd_equal_eop,
	cmd_equal_eof,

	cmd_overtype_mode,
	cmd_insert_mode,

	cmd_overtype_text,         { text insertion/deletion }
	cmd_insert_text,
	cmd_type_text,
	cmd_insert_line,
	cmd_insert_char,
	cmd_insert_invisible,
	cmd_delete_line,
	cmd_delete_char,

	cmd_swap_line,             { text manipulation }
	cmd_split_line,
	cmd_ditto_up,
	cmd_ditto_down,
	cmd_case_up,
	cmd_case_low,
	cmd_case_edit,
	cmd_set_margin_left,
	cmd_set_margin_right,

	cmd_line_fill,              { word processing }
	cmd_line_justify,
	cmd_line_squash,
	cmd_line_centre,
	cmd_line_left,
	cmd_line_right,
	cmd_word_advance,
	cmd_word_delete,
	cmd_advance_paragraph,
	cmd_delete_paragraph,

	cmd_span_define,            { span commands }
	cmd_span_transfer,
	cmd_span_copy,
	cmd_span_compile,
	cmd_span_jump,
	cmd_span_index,
	cmd_span_assign,

	cmd_block_define,           { block commands }
	cmd_block_transfer,
	cmd_block_copy,

	cmd_frame_kill,             { frame commands }
	cmd_frame_edit,
	cmd_frame_return,
	cmd_span_execute,               {###}
	cmd_span_execute_no_recompile,  {###}
	cmd_frame_parameters,

	cmd_file_input,     {open and attach input file   }
	cmd_file_output,    {create and attach output file}
	cmd_file_edit,      {open files for input and output }
	cmd_file_read,      {read from global input       }
	cmd_file_write,     {write to global output       }
	cmd_file_close,     {close a file -- only used internally}
	cmd_file_rewind,    {rewind input file}
	cmd_file_kill,      {delete output file }
	cmd_file_execute,   {execute a file of commands }
	cmd_file_save,      {save a file without clearing the frame}
	cmd_file_table,     {displays current filetable   }
	cmd_file_global_input,  {declare a global input file  }
	cmd_file_global_output, {declare a global output file }
	cmd_file_global_rewind, {rewind global input file }
	cmd_file_global_kill,   {delete global output file }

	cmd_user_command_introducer,
	cmd_user_key,
	cmd_user_parent,
	cmd_user_subprocess,
	cmd_user_undo,
	cmd_user_learn,
	cmd_user_recall,

{#if WINDOWCHANGE or XWINDOWS}
	cmd_resize_window,         { window size has changed, so handle it }
{#endif}
{#if XWINDOWS}
{##        cmd_handle_mouse_event,           #< mouse button pressed. position cursor #>}
{##        cmd_cut_X_span,                   #< or mark out span and make it available#>}
{##        cmd_paste_X_span,}
{#endif}
{#if NCURSESMOUSE}
    cmd_ncurses_mouse_event,
{#ENDIF}
	cmd_help,                  { miscellaneous }
	cmd_verify,
	cmd_command,
	cmd_mark,
	cmd_page,
	cmd_quit,
	cmd_dump,               { ~D in debug version. }
	cmd_validate,           { ~V in debug version. }
	cmd_execute_string,
	cmd_do_last_command,

	cmd_extended,

	cmd_exit_abort,        {exit back to immediate mode}
	cmd_exit_fail,         {exit with failure}
	cmd_exit_success,      {exit with success}


	{-----End of user commands-----}

			       { Dummy commands for pattern matcher }
	cmd_pattern_dummy_pattern,
	cmd_pattern_dummy_text,

			{ compiler commands }
	cmd_pcjump,         {Intermediate code jump}
	cmd_exitto,         {Set exit point from loop}
	cmd_failto,         {Set fail point from loop}
	cmd_iterate,        {Repeat loop n times}

	cmd_prefix_ast,           { prefix commands }
	cmd_prefix_a,
	cmd_prefix_b,
	cmd_prefix_c,
	cmd_prefix_d,
	cmd_prefix_e,
	cmd_prefix_eo,
	cmd_prefix_eq,
	cmd_prefix_f,
	cmd_prefix_fg,      {global files}
	cmd_prefix_i,
	cmd_prefix_k,
	cmd_prefix_l,
	cmd_prefix_o,
	cmd_prefix_p,
	cmd_prefix_s,
	cmd_prefix_t,
	cmd_prefix_tc,
	cmd_prefix_tf,
	cmd_prefix_u,
	cmd_prefix_w,
	cmd_prefix_x,
{#if XWINDOWS}
{##        cmd_prefix_xm,}
{#endif}
	cmd_prefix_y,
	cmd_prefix_z,
	cmd_prefix_tilde,

	cmd_nosuch         { sentinel }
       );

  user_commands   = cmd_noop..cmd_pattern_dummy_text;
  comp_commands   = cmd_pcjump..cmd_iterate;
  prefix_commands = cmd_prefix_ast..cmd_prefix_tilde;
  prefix_plus     = cmd_prefix_ast..cmd_nosuch;
  leadparam=   (none,           { no leading paramter }
		plus,           { + without integer }
		minus,          { - without integer }
		pint,           { +ve integer }
		nint,           { -ve integer }
		pindef,         { > }
		nindef,         { < }
		marker);        { @ or = or % }

		{ equalaction is a command attribute type used to control the }
		{ behaviour of mark Equals.                                   }
  equalaction= (eqnil,          { leave mark alone (N.B. action routine may }
				{ shift mark e.g. get and replace }
		eqdel,          { delete mark e.g. delete and kill }
		eqold);         { set mark to cursor posn. before cmd }
				{ normal for cmds which shift cursor }

	{ tpcount_type indicates the number of trailing parameters required }
	{ for the command. }
	{ if -ve, means the command requires no tp's iff leading parameter }
	{ is -ve (used for -FI) }
  tpcount_type = -max_tpcount..max_tpcount;

  prompt_type  = (no_prompt,
		 char_prompt,
		 get_prompt,
		 equal_prompt,
		 key_prompt,
		 cmd_prompt,
		 span_prompt,
		 text_prompt,
		 frame_prompt,
		 file_prompt,
		 column_prompt,
		 mark_prompt,
		 param_prompt,
		 topic_prompt,
		 replace_prompt,
		 by_prompt,
		 verify_prompt,
		 pattern_prompt,
		 pattern_set_prompt);

  tpar_attribute = record            { used for default prompt strings }
		     prompt_name : prompt_type;
		     trim_reply  : boolean;
		     ml_allowed  : boolean;
		   end;

  cmd_attrib_rec = record
{#if fpc}
		     lp_allowed : set of leadparam;
{#else}
{##                     lp_allowed : packed set of leadparam;}
{#endif}
		     eq_action  : equalaction;
		     tpcount    : tpcount_type;
		     tpar_info  : packed array [1..max_tpcount] of tpar_attribute;
		   end;

  help_record    = record
		     key : key_str;
		     txt : write_str;
		   end;

  msg_class      = (msg_internal, msg_success, msg_information,
		    msg_warning, msg_error, msg_fatal);

{ more Pattern Matcher stuff }

    nfa_transition_type =
      record
	indefinite : boolean;
	fail       : boolean;
	case epsilon_out : boolean of
	  true  : (first_out,second_out : nfa_state_range);
	  false : (next_state : nfa_state_range;
		   accept_set : accept_set_type);
      end;

    nfa_table_type = array [nfa_state_range] of nfa_transition_type;

    parameter_type = (pattern_fail,
		      pattern_range,
		      null_param);

{ global file defaults and other things filesys_parse would like to know }

    file_data_type = record
      old_cmds  : boolean;
      entab     : boolean;
{#if ns32000}
{##      d1,d2     : char;}
{#endif}
      space     : integer;
      initial   : str_object;
      purge     : boolean;
{#if ns32000}
{##      d3,d4,d5  : char;}
{#endif}
      versions  : integer;
    end;

    code_object = record
      rep  : leadparam;        { Repeat type }
      cnt  : integer;          { Repeat count }
      op   : commands;         { Opcode }
      tpar : tpar_ptr;         { Trailing param }
      code : code_ptr;         { Code for cmd_extended }
      lbl  : code_idx;         { Label field }
    end;

    command_object = record
      command : commands;
      code    : code_ptr;
      tpar    : tpar_ptr;
    end;

   terminal_info_type = record
     name     : str_ptr;
     namelen  : strlen_range;
     width    : scr_col_range;
     height   : scr_row_range;
{#if ns32000}
{##     d1,d2,d3 : char;}
{#endif}
     speed    : integer;
     keypad   : boolean;
{#if ns32000}
{##     d4,d5,d6 : char;}
{#endif}
     f_min    : integer;
     f_max    : integer;
     f_key    : boolean;
     sf_key   : boolean;
     cf_key   : boolean;
     csf_key  : boolean;
     mf_key   : boolean;
     msf_key  : boolean;
     mcf_key  : boolean;
     mcsf_key : boolean;
   end;
