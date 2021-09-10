{   This source file by:                                               }
{                                                                      }
{       Chris J. Barter (1987);                                        }
{       Wayne N. Agutter (1987);                                       }
{       Bevin R. Brett (1987);                                         }
{       Kelvin B. Nicolle (1987-90);                                   }
{       Mark R. Prior (1987-88);                                       }
{       Jeff Blows (1989); and                                         }
{       Martin Sandiford (2002).                                       }
{                                                                      }
{  Copyright  1987-90, 2002 University of Adelaide                     }
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
{++
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/const.i,v 4.15 2002/07/20 16:46:00 martin Exp $
! $Author: martin $
! $Locker:  $
! $Log: const.i,v $
! Revision 4.15  2002/07/20 16:46:00  martin
! Remove special turbop constants.  They are now in the units
! that they are used by.  Changed some constants to be conditional
! on msdos rather than turbop, and added some fpc conditionals
! for use by the fpc port.
!
! Revision 4.15  2002/07/20 15:50:36  martin
! Remove random constants in #if turbop section.
!
! Revision 4.14  1990/10/19 14:32:16  ludwig
! Make dbg messages conditional on debug flag.  KBN
!
! Revision 4.13  90/02/28  10:53:56  ludwig
! Add two messages for File Save command.
!
! Revision 4.12  90/02/17  16:09:16  ludwig
! increaed the maximum number of special keys and key names up to 1000 for
! the XWINDOWS version
!
! Revision 4.11  90/01/18  18:20:29  ludwig
! Entered into RCS at revision level 4.11
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                     5-May-1987
!       Add definition of ascii_vt.
! 4-003 Kelvin B. Nicolle                                     5-May-1987
!       Remove lw_vers--it is now ludwig_version in var.inc.
! 4-004 Mark R. Prior                                        12-Dec-1987
!       Add max_word_sets.
! 4-005 Mark R. Prior                                        19-Feb-1988
!       Add max_word_sets_m1.
! 4-006 Kelvin B. Nicolle                                     9-Dec-1988
!       Move the ascii constants to filesys.pas.
! 4-007 Kelvin B. Nicolle                                     9-Dec-1988
!       Work around a bug in Ultrix pc which does not allow double
!       quotes in string when compiled with the debug option.
! 4-008 Kelvin B. Nicolle                                    16-Dec-1988
!       Expand all message string constants to msg_str_len characters.
! 4-009 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-010 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
! 4-011 Kelvin B. Nicolle                                    12-Jul-1989
!       Set max_word_sets to 2 to revert to old definition of a word.
!--}

const

{#if vms or turbop}
  ord_maxchar = 255;
{#elseif unix}
{##  ord_maxchar = 127;}
{#endif}
  max_files             =  100;                 { Max files                    }
  max_grouplines        =  64;                  { Max lines per group          }
  max_grouplineoffset   =  63; {max_grouplines-1}
{#if fpc}
  max_lines             = maxlongint;           { Max lines per frame          }
{#else}
{##  max_lines             = maxint;               #< Max lines per frame          #>}
{#endif}
  min_mark_number       = -1;
  max_mark_number       = 9;                    { Highest User Mark number     }
  mark_equals           = 0;
  mark_modified         = -1;
{#if msdos}
{##  max_space             = 100000;               #< Max chars allowed per frame  #>}
{#else}
  max_space             = 1000000;              { Max chars allowed per frame  }
{#endif}
  max_rec_size          = 512;                  { Max length rec. in inp file  }
  max_strlen            = 400;                  { Max length of a string       }
  max_strlenp           = 401; {max_strlen+1}   { Max length of a string+1;    }
  max_scr_rows          = 100;                  { Max nr of rows on screen     }
  max_scr_cols          = 255;                  { Max nr of cols on screen     }
{#if msdos}
{##  max_buffer_len        = 2048;                 #< Length of buffer array       #>}
{##  max_code              = 2000;                 #< Length of code array         #>}
{#else}
  max_code              = 4000;                 { Length of code array         }
{#endif}
  max_verify            = 256;                  { Max nr of V commands in span }
  max_tpar_recursion    = 100;
  max_tpcount           = 2;
  max_exec_recursion    = 100;
  max_word_sets         = 2;                    { Max nr of word element sets  }
  max_word_sets_m1      = 1;                    {             "             -1 }
  blank_frame_name      = '                               ';
  default_frame_name    = 'LUDWIG                         ';

{#if vms}
{###<*******************************************************************************}
{##*                                                                              *}
{##* W A R N I N G !!                                                             *}
{##*                                                                              *}
{##*  The following constants(?) ARE VERY MUCH VMS DEPENDENT.                     *}
{##*                                                                              *}
{##*                         B E W A R E!                                         *}
{##*******************************************************************************#>}
{##}
{##  vms_fab$c_bln         = 80;                   #< Length of a FAB Block #>}
{##  vms_nam$c_bln         = 96;                   #< Length of a NAM Block #>}
{##  vms_rab$c_bln         = 68;                   #< Length of a RAB Block #>}
{#endif}

  tpd_lit               = '''';     { don't do fancy processing on this one }
  tpd_smart             = '`';      { search target is a pattern }
  tpd_exact             = '"';      { use exact case during search }
  tpd_span              = '$';      { span substitution }
  tpd_prompt            = '&';      { get parameter from user terminal }
  tpd_environment       = '?';      { environment enquiry }
  expand_lim            = 130;      { at least # of multi-letter commands + 1 }
  t                     = true;
  f                     = false;


  { String lengths }
  name_len              =  31;                  { Max length of a spn/frm name }
{#if vms}
{##  file_name_len         = 255;                  #< Max length of VMS file name  #>}
{#elseif unix}
{##  file_name_len         = 252;}
{#elseif msdos}
{##  file_name_len         = 80;}
{#else}
  file_name_len         = 255;                  { Default length of file ame }
{#endif}
  tpar_prom_len         = 8;
  write_str_len         = 80;
  msg_str_len           = 70;
  key_len               = 4;        { Key length for HELP FILE  }

  { Keyboard interface. }
{#if turbop}
  max_special_keys      = 200;
{#elseif XWINDOWS}
{##  max_special_keys      = 1000;}
{#else}
{##  max_special_keys      = 100;}
{#endif}
  key_name_len          = 40;   { WARNING - this value is assumed in USER.PAS }
{#if XWINDOWS}
{##  max_nr_key_names      = 1000;}
{#else}
  max_nr_key_names      = 200;
{#endif}

{#if not XWINDOWS}
  max_parse_table       = 300;
{#endif}

{#if vms}
{##  normal_exit           = 1;            #< ss$_normal #>}
{##  abnormal_exit         = %x10000044;   #< ss$_abort+sts$m_inhib_msg #>}
{#elseif unix or turbop}
  normal_exit           = 0;
  abnormal_exit         = 1;
{#endif}

  max_nfa_state_range     =  200;    { no of states in NFA }
  max_dfa_state_range     =  255;    { no of states in DFA }
				     { as big as VAX v2 pascal allows }
  max_set_range      =  ord_maxchar; { no of elts in accept sets }
  pattern_null            =  0;      { acts as nil in array ptrs }
  pattern_nfa_start       =  1;      { the first NFA state allocated }
  pattern_dfa_kill        =  0;      { the dfa killer state }
  pattern_dfa_fail        =  0;      { To keep old versions happy }
  pattern_dfa_start       =  2;      { The DFA starting state }
  pattern_max_depth       =  20;     { maximum recursion depth in parser }

  { Symbols used in pattern specification }
  pattern_kstar             = '*';   { Kleene star }
  pattern_comma             = ',';   { The context Delimiter }
  pattern_rparen            = ')';
  pattern_lparen            = '(';
  pattern_define_set_u      = 'D';   { these two used as a pair}
  pattern_define_set_l      = 'd';   {} { The define a char set symbol }
  pattern_mark              = '@';   { match the numbered mark }
  pattern_equals            = '=';   { match the Equals mark }
  pattern_modified          = '%';   { match the Modified mark }
  pattern_plus              = '+';   { Kleene Plus }
  pattern_negate            = '-';   { To negate a char set }
  pattern_bar               = '|';   { Alternation ( OR ) }
  pattern_lrange_delim      = '[';   { For specification of a range of }
  pattern_rrange_delim      = ']';   { repetitions }
  pattern_space             = ' ';

  { set locations for line end specifiers }

  pattern_beg_line          = 0;   { the <  (beginning of line) specifier }
  pattern_end_line          = 1;   { the >  (end of line) specifier }
  pattern_left_margin       = 3;   { l.brace( left margin ) specifier }
  pattern_right_margin      = 4;   { r.brace( right margin ) specifier }
  pattern_dot_column        = 5;   { the ^  ( dots column)   specifier }

  pattern_marks_start       = 20;  { mark 1 = 21, 2 = 22, etc }
  pattern_marks_modified    = 19;  { marks_start + mark_modified }
  pattern_marks_equals      = 20;  { marks_start + mark_equals }

  pattern_alpha_start       = 32;   { IE. ASCII }

  msg_blank                      = '                                                                      ';
  msg_abort                      = 'Aborted. Output Files may be CORRUPTED                                ';
  msg_bad_format_in_tab_table    = 'Bad Format for list of Tab stops.                                     ';
  msg_cant_kill_frame            = 'Can''t Kill Frame.                                                     ';
  msg_cant_split_null_line       = 'Can''t split the Null line.                                            ';
  msg_command_not_valid          = 'No Command starts with this character.                                ';
  msg_command_recursion_limit    = 'Command recursion limit exceeded.                                     ';
  msg_comments_illegal           = 'Immediate mode comments are not allowed.                              ';
  msg_compiler_code_overflow     = 'Compiler code overflow, too many compiled spans.                      ';
  msg_copyright_and_loading_file = 'Copyright (C) 1981, 1987,  University of Adelaide.                    ';
  msg_count_too_large            = 'Count too large.                                                      ';
  msg_decommitted                = 'Warning - Decommitted feature.                                        ';
  msg_empty_span                 = 'Span is empty.                                                        ';
  msg_equals_not_set             = 'The Equals mark is not defined.                                       ';
  msg_error_opening_keys_file    = 'Error opening keys definitions file.                                  ';
  msg_executing_init_file        = 'Executing initialization file.                                        ';
  msg_file_already_in_use        = 'File already in use.                                                  ';
  msg_file_already_open          = 'File already open.                                                    ';
  msg_frame_has_files_attached   = 'Frame Has Files Attached.                                             ';
  msg_frame_of_that_name_exists  = 'Frame of that Name Already Exists.                                    ';
  msg_illegal_leading_param      = 'Illegal leading parameter.                                            ';
  msg_illegal_mark_number        = 'Illegal mark number.                                                  ';
  msg_illegal_param_delimiter    = 'Illegal parameter delimiter.                                          ';
  msg_incompat                   = 'Incompatible switches specified.                                      ';
  msg_interactive_mode_only      = 'Allowed in interactive mode only.                                     ';
  msg_invalid_cmd_introducer     = 'Invalid command introducer.                                           ';
  msg_invalid_integer            = 'Trailing parameter integer is invalid.                                ';
  msg_invalid_keys_file          = 'Invalid keys definition file.                                         ';
  msg_invalid_screen_height      = 'Invalid height for screen.                                            ';
  msg_invalid_slot_number        = 'Invalid file slot number.                                             ';
  msg_invalid_t_option           = 'Invalid Tab Option.                                                   ';
  msg_invalid_ruler              = 'Invalid Ruler.                                                        ';
  msg_invalid_parameter_code     = 'Invalid Parameter Code.                                               ';
  msg_left_margin_ge_right       = 'Specified Left Margin is not less than Right Margin.                  ';
  msg_long_input_line            = 'Long input line has been split.                                       ';
  msg_margin_out_of_range        = 'Margin out of Range.                                                  ';
  msg_margin_syntax_error        = 'Margin Syntax Error.                                                  ';
  msg_mark_not_defined           = 'Mark Not Defined.                                                     ';
  msg_missing_trailing_delim     = 'Missing trailing delimiter.                                           ';
  msg_no_default_str             = 'No default for trailing parameter string.                             ';
  msg_no_file_open               = 'No file open.                                                         ';
  msg_no_more_files_allowed      = 'No more files are allowed.                                            ';
  msg_no_room_on_line            = 'Operation would cause a line to become too long.                      ';
  msg_no_such_frame              = 'No such frame.                                                        ';
  msg_no_such_span               = 'No such span.                                                         ';
  msg_nonprintable_introducer    = 'Command Introducer is not printable                                   ';
  msg_not_enough_input_left      = 'Not enough input left to satisfy request.                             ';
  msg_not_implemented            = 'Not implemented.                                                      ';
  msg_not_input_file             = 'File is not an input file.                                            ';
  msg_not_output_file            = 'File is not an output file.                                           ';
  msg_not_while_editing_cmd      = 'Operation not allowed while editing frame COMMAND.                    ';
  msg_not_allowed_in_insert_mode = 'Command not allowed in insert mode.                                   ';
  msg_options_syntax_error       = 'Syntax error in options.                                              ';
  msg_out_of_range_tab_value     = 'Invalid value for tab stop.                                           ';
  msg_parameter_too_long         = 'Parameter is too long.                                                ';
  msg_prompts_are_one_line       = 'A prompt string must be on one line.                                  ';
  msg_screen_mode_only           = 'Command allowed in screen mode only.                                  ';
  msg_screen_width_invalid       = 'Invalid screen width specified.                                       ';
  msg_span_must_be_one_line      = 'A span used as a trailing parameter for this command must be one line.';
  msg_span_names_are_one_line    = 'A span name must be on one line.                                      ';
  msg_span_of_that_name_exists   = 'Span of that name already exists.                                     ';
  msg_enquiry_must_be_one_line   = 'An enquiry item must be on one line.                                  ';
  msg_unknown_item               = 'Unknown enquiry item.                                                 ';
  msg_syntax_error               = 'Syntax error.                                                         ';
  msg_syntax_error_in_options    = 'Syntax error in options.                                              ';
  msg_syntax_error_in_param_cmd  = 'Syntax error in parameter command.                                    ';
  msg_top_margin_lss_bottom      = 'Top margin must be less than or equal to bottom margin.               ';
  msg_tpar_too_deep              = 'Trailing parameter translation has gone too deep.                     ';
  msg_unknown_option             = 'Not a valid option.                                                   ';
  msg_pat_no_matching_delim      = 'Pattern - No matching delimiter in pattern.                           ';
  msg_pat_illegal_parameter      = 'Pattern - Illegal parameter in pattern.                               ';
  msg_pat_illegal_mark_number    = 'Pattern - Illegal mark number in pattern.                             ';
  msg_pat_premature_pattern_end  = 'Pattern - Premature pattern end.                                      ';
  msg_pat_set_not_defined        = 'Pattern - Set not defined.                                            ';
  msg_pat_illegal_symbol         = 'Pattern - Illegal symbol in pattern.                                  ';
  msg_pat_syntax_error           = 'Pattern - Syntax error in pattern.                                    ';
  msg_pat_null_pattern           = 'Pattern - Null pattern.                                               ';
  msg_pat_pattern_too_complex    = 'Pattern - Pattern too complex.                                        ';
  msg_pat_error_in_span          = 'Pattern - Error in dereferenced span.                                 ';
  msg_pat_error_in_range         = 'Pattern - Error in range specification.                               ';
  msg_reserved_tpd               = 'Delimiter reserved for future use.                                    ';
  msg_integer_not_in_range       = 'Integer not in range                                                  ';
  msg_mode_error                 = 'Illegal Mode specification -- must be O,C or I                        ';
  msg_writing_file               = 'Writing File.                                                         ';
  msg_loading_file               = 'Loading File.                                                         ';
  msg_saving_file                = 'Saving File.                                                          ';
  msg_paging                     = 'Paging.                                                               ';
  msg_searching                  = 'Searching.                                                            ';
  msg_quitting                   = 'Quitting.                                                             ';
  msg_no_output                  = 'This Frame has no Output File attached.                               ';
  msg_not_modified               = 'This Frame has not been modified.                                     ';
{#if vms}
{##  msg_not_renamed                = 'Output Files have "-LW" appended to file type                         ';}
{#elseif unix or fpc}
{#if vax and debug}
{##  msg_not_renamed                = 'Output Files have `-lw*` appended to filename                         ';}
{#else}
  msg_not_renamed                = 'Output Files have "-lw*" appended to filename                         ';
{#endif}
{#elseif turbop}
{##  msg_not_renamed                = 'Output Files have file type of "-LW"                                  ';}
{#endif}
  msg_cant_invoke                = 'Character cannot be invoked by a key                                  ';
  msg_exceeded_dynamic_memory    = 'Exceeded dynamic memory limit.                                        ';
  msg_inconsistent_qualifier     = 'Use of this qualifier is inconsistent with file operation             ';
  msg_unrecognized_key_name      = 'Unrecognized key name                                                 ';
  msg_key_name_truncated         = 'Key name too long, name truncated                                     ';
  dbg_internal_logic_error       = 'Internal logic error.                                                 ';
{#if debug}
  dbg_badfile                    = 'FILE and FILESYS definition of file_object disagree.                  ';
  dbg_cant_mark_scr_bot_line     = 'Can''t mark scr bot line.                                             ';
  dbg_code_ptr_is_nil            = 'Code ptr is nil.                                                      ';
  dbg_failed_to_unload_all_scr   = 'Failed to unload all scr.                                             ';
  dbg_fatal_error_set            = 'Fatal error set.                                                      ';
  dbg_first_follows_last         = 'First follows last.                                                   ';
  dbg_first_not_at_top           = 'First Not at Top.                                                     ';
  dbg_flink_or_blink_not_nil     = 'Flink or blink not nil.                                               ';
  dbg_frame_creation_failed      = 'Frame creation failed.                                                ';
  dbg_frame_ptr_is_nil           = 'Frame ptr is nil.                                                     ';
  dbg_group_has_lines            = 'Group has lines.                                                      ';
  dbg_group_ptr_is_nil           = 'Group ptr is nil.                                                     ';
  dbg_illegal_instruction        = 'Illegal Instruction.                                                  ';
  dbg_invalid_blink              = 'Incorrect blink.                                                      ';
  dbg_invalid_column_number      = 'Invalid column number.                                                ';
  dbg_invalid_flags              = 'Invalid flags.                                                        ';
  dbg_invalid_frame_ptr          = 'Invalid frame ptr.                                                    ';
  dbg_invalid_group_ptr          = 'Invalid group ptr.                                                    ';
  dbg_invalid_line_length        = 'Invalid line length.                                                  ';
  dbg_invalid_line_nr            = 'Invalid line nr.                                                      ';
  dbg_invalid_line_ptr           = 'Invalid line ptr.                                                     ';
  dbg_invalid_line_used_length   = 'Invalid line used length.                                             ';
  dbg_invalid_nr_lines           = 'Invalid nr lines.                                                     ';
  dbg_invalid_offset_nr          = 'Invalid offset nr.                                                    ';
  dbg_invalid_scr_param          = 'Invalid SCR Parameter.                                                ';
  dbg_invalid_scr_row_nr         = 'Invalid scr row nr.                                                   ';
  dbg_invalid_span_ptr           = 'Invalid span ptr.                                                     ';
  dbg_last_not_at_end            = 'Last not at end.                                                      ';
  dbg_library_routine_failure    = 'Library routine call failed.                                          ';
  dbg_line_from_number_failed    = 'Line from number failed.                                              ';
  dbg_line_has_marks             = 'Line has marks.                                                       ';
  dbg_line_is_eop                = 'Line is eop.                                                          ';
  dbg_line_not_in_scr_frame      = 'Line not in scr frame.                                                ';
  dbg_line_on_screen             = 'Line on screen.                                                       ';
  dbg_line_ptr_is_nil            = 'Line ptr is nil.                                                      ';
  dbg_line_to_number_failed      = 'Line to number failed.                                                ';
  dbg_lines_from_diff_frames     = 'Lines from diff frames.                                               ';
  dbg_mark_in_wrong_frame        = 'Mark in wrong frame.                                                  ';
  dbg_mark_move_failed           = 'Mark move failed.                                                     ';
  dbg_mark_ptr_is_nil            = 'Mark ptr is nil.                                                      ';
  dbg_marks_from_diff_frames     = 'Marks from diff frames.                                               ';
  dbg_needed_frame_not_found     = 'Frame C or OOPS is not in the span list                               ';
  dbg_not_immed_cmd              = 'Not immed cmd.                                                        ';
  dbg_nxt_not_nil                = 'Nxt should be nil here.                                               ';
  dbg_pc_out_of_range            = 'PC is out of Range.                                                   ';
  dbg_ref_count_is_zero          = 'Reference count is zero.                                              ';
  dbg_repeat_negative            = 'Repeat Negative.                                                      ';
  dbg_span_not_destroyed         = 'Span not destroyed.                                                   ';
  dbg_top_line_not_drawn         = 'Top line not drawn.                                                   ';
  dbg_tpar_nil                   = 'Tpar should not be nil.                                               ';
  dbg_wrong_row_nr               = 'Wrong row nr.                                                         ';
{#endif}
