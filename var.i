{   This source file by:                                               }
{                                                                      }
{       Chris J. Barter (1979-81, 1987);                               }
{       Wayne N. Agutter (1979-81, 1987);                              }
{       Bevin R. Brett (1979-81, 1987);                                }
{       Kelvin B. Nicolle (1987-89);                                   }
{       Mark R. Prior (1987);                                          }
{       Jeff Blows (1989);                                             }
{       Martin Sandiford (1990); and                                   }
{       Steve Nairn (1990).                                            }
{                                                                      }
{  Copyright  1979-81, 1987-90 University of Adelaide                  }
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
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/var.i,v 4.8 1990/01/22 18:55:12 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: var.i,v $
! Revision 4.8  1990/01/22 18:55:12  ludwig
! Steven Nairn.
! removed the declarations of tt_height and tt_width.
!
Revision 4.7  90/01/19  10:46:42  ludwig
Declaration of global variable "tt_winchanged" to indicate that the window
size has been modified. Gets set to true by signal handler for SIGWINCH,
or resize event from X.

Revision 4.6  90/01/18  17:09:25  ludwig
Entered into RCS at revision level 4.6

!
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                     5-May-1987
!       Add ludwig_version.
! 4-003 Mark R. Prior                                        22-Jun-1987
!   Version 4.1 developments incorporated into main source code:
!   . Replace the global variables tt_width and tt_height by
!     terminal_info.
! 4-004 Kelvin B. Nicolle                                    11-Nov-1988
!       Add hangup.
! 4-005 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-006 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
!--}

var
  ludwig_version : name_str;
{#if vms}
{##                #<VMS DEPENDENT VARIABLES.#>}
{##}
{##  exit_ctrl_blk : vms_desblk;   #< Exit control block, used to terminate nicely.#>}
{#elseif turbop}
  program_directory : string;   {Used to determine program startup directory.}
{#endif}
  tt_capabilities : terminal_capabilities;      { H/W abilities of terminal.   }
  tt_controlc   : boolean;      { User has typed CNTRL/C.                      }
  tt_winchanged : boolean;	{ Window size has changed                      }

  { Keyboard interface. }
  nr_key_names  : key_names_range;
  key_name_list_ptr : key_name_array_ptr;
  key_introducers : accept_set_type;

		{SPECIAL FRAMES.}

  current_frame : frame_ptr;    { Compiler/Interpreter use as focal frame.     }
  frame_oops    : frame_ptr;    { Pointer to frame OOPS.                       }
  frame_cmd     : frame_ptr;    { Pointer to frame COMMAND.                    }
  frame_heap    : frame_ptr;    { pointer to frame HEAP.                       }

		{GLOBAL VARIABLES.}

  ludwig_aborted: boolean;      { Something terrible has happened....          }
  exit_abort    : boolean;      { Set for doing XA commands.                   }
  vdu_free_flag : boolean;      { Set if vdu_free has been called already      }
  hangup        : boolean;      { Ludwig has received a hangup signal.         }

  edit_mode,
  previous_mode : (mode_overtype, { User selectable editing mode.              }
		   mode_insert,
		   mode_command);

  files         : array [file_range] of file_ptr;       { I/O file pointers.   }
  files_frames  : array [file_range] of frame_ptr;
  fgi_file      : slot_range;
  fgo_file      : slot_range;

  first_span    : span_ptr;     { Pointer to first in the list of spans.       }
  ludwig_mode   : (ludwig_batch,
		   ludwig_hardcopy,
		   ludwig_screen);
  command_introducer : key_code_range;{ Key used to prefix immediate commands. }

  prompt_region : array [1..max_tpcount] of prompt_region_attrib;
  scr_frame     : frame_ptr;    { Frame that screen currently mapped into.     }
  scr_top_line  : line_ptr;     { Pointer to first line mapped on screen.      }
  scr_bot_line  : line_ptr;     { Pointer to last line mapped on screen.       }
  scr_msg_row   : 1..maxint;    { First (highest) msg on scr, 0 if none.       }
  scr_needs_fix : boolean;      { Set when user is viewing a corrupt screen.   }

		{COMPILER VARIABLES.}

  compiler_code : array [1..max_code] of code_object;
  code_list     : code_ptr;
  code_top      : 0..max_code;

		{ VARIABLES USED IN INTERPRETING A COMMAND }

  repeatsyms    : set of char;
  prefixes      : set of commands;
  lookup        : array [key_code_range] of command_object;
  lookupexp     : array [1..expand_lim] of
		    record
		    extn    : char;
		    command : commands
		    end;
  lookupexp_ptr : array [prefix_plus] of 1..expand_lim;
  cmd_attrib    : array [user_commands] of cmd_attrib_rec;
  dflt_prompts  : array [prompt_type] of prompt_str;
  exec_level    : 0..max_exec_recursion;

		{INITIAL FRAME SETTINGS.}

  initial_marks         : mark_array;
  initial_scr_height    : scr_row_range;
  initial_scr_width     : scr_col_range;
  initial_scr_offset    : col_offset_range;
  initial_margin_left   : col_range;
  initial_margin_right  : col_range;
  initial_margin_top    : scr_row_range;
  initial_margin_bottom : scr_row_range;
  initial_tab_stops     : tab_array;
  initial_options       : frame_options;

		{USEFUL STUFF.}

  blank_string          : str_object;
  initial_verify        : verify_array;
  default_tab_stops     : tab_array;

	      {STRUCTURE POOLS}

  free_group_pool : group_ptr;
  free_line_pool  : line_ptr;
  free_mark_pool  : mark_ptr;

	      { Pattern matcher parser stuff }

  printable_set     :   accept_set_type;
  space_set         :   accept_set_type;
  alpha_set         :   accept_set_type;
  lower_set         :   accept_set_type;
  upper_set         :   accept_set_type;
  numeric_set       :   accept_set_type;
  punctuation_set   :   accept_set_type;

	      { Output file actions }

  file_data : file_data_type;

	      { Info about the terminal }

  terminal_info : terminal_info_type;

	      { Word definition sets }

  word_elements : array [word_set_range] of accept_set_type;
