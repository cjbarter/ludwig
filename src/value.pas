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
{       Kelvin B. Nicolle (1987, 1990);                                }
{       Francis Vaughan (1988);                                        }
{       Jeff Blows (1988-89, 2020);                                    }
{       Steve Nairn (1990-91); and                                     }
{       Martin Sandiford (2002).                                       }
{                                                                      }
{  Copyright  1987-91, 2002 University of Adelaide                     }
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
! Name:         VALUE
!
! Description:  Initialization of global variables.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/value.pas,v 4.18 2002/07/21 02:46:58 martin Exp $
! $Author: martin $
! $Locker:  $
! $Log: value.pas,v $
! Revision 4.18  2002/07/21 02:46:58  martin
! Added get_program_directory for fpc port.  Corrected some space
! issues with shared turbop/fpc port.  MPS
!
! Revision 4.17  1991/02/21 17:12:01  ludwig
! Added command table initialisation for the mouse handling functions
! for the X window system version.
! SN.
!
! Revision 4.16  90/10/31  14:58:58  ludwig
! Change initialization of ludwig_aborted to false.   KBN
! 
! Revision 4.15  90/10/24  17:31:31  ludwig
! Initialize some global variables that were not initialized.
! Clean up the method of setting the Ludwig version string.   KBN
!
! Revision 4.14  90/02/08  10:27:16  ludwig
! changed #if for xwindows now I know the correct pcc syntax.
!
! Revision 4.13  90/02/05  13:57:24  ludwig
! Steven Nairn.
! Initialized cmd_resize_window in cmd_attrib.
! Removed reference to tt_winchanged
!
! Revision 4.12  90/01/19  10:58:02  ludwig
! Steven Nairn.
! Initialised the tt_winchanged flag to false.
!
! Revision 4.11  90/01/18  17:11:09  ludwig
! Entered into RCS at revision level 4.11
!
!---
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                     5-May-1987
!       Add the definition of the new variable ludwig_version.
! 4-003 Kelvin B. Nicolle                                    22-May-1987
!       Move the definition of ludwig_version into "version.i".
! 4-004 Kelvin B. Nicolle                                    29-May-1987
!       Change the prompt on the I and O commands from no_prompt to
!       text_prompt.
!       Unix: Allow multi-line tpar on the I command.
! 4-005 Francis A. Vaughan                                    6-Mar-1988
!       Split routine up to prevent exceeding compliler code-tree
!       limits.
! 4-006 Francis Vaughan                                      24-Aug-1988
!       Replace underscores in identifiers.
! 4-007 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-008 Kelvin B. Nicolle                                    12-Jul-1989
!       Change the definition of word_elements to restore the old
!       definition of a word.
! 4-009 Kelvin B. Nicolle                                    13-Sep-1989
!       Add includes etc. for Tower version.
! 4-010 Kelvin B. Nicolle                                    25-Oct-1989
!       Correct the includes for the Tower version.
! 4-011 Kelvin B. Nicolle                                    17-Jan-1990
!       Initialize the command table for the new File Save command.
!--}

{#if turbop}
unit value;
{#endif}

{#if unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "value.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=value.h#>}
{#elseif turbop}
interface
  {$I const.i}
  {$I type.i}
  {$I var.i}

  {$I value.i}
  function min(x,y:integer):integer;

implementation

{#if fpc}
  uses sysutils;
{#endif}


  procedure set_version;
    {$I version.i}



  function min(x,y:integer):integer;
    begin {min}
    min := y;
    if x < y then
      min := x;
    end; {min}


{#if fpc}

  procedure get_program_directory;

    begin {get_program_directory}
    program_directory := ExtractFilePath(ParamStr(0))
    end; {get_program_directory}

{#else}
{##}
{##  procedure get_program_directory;}
{##    const}
{##      env_ptr_offset = 44;}
{##    var}
{##      index : integer;}
{##      env_seg : word;}
{##      env_offset : word;}
{##    begin #<get_program_directory#>}
{##    program_directory := '';}
{##    env_seg := memw[prefixseg:env_ptr_offset];}
{##    env_offset := 0;}
{##    while mem[env_seg:env_offset] <> 0 do}
{##      begin}
{##      while mem[env_seg:env_offset] <> 0 do}
{##        inc(env_offset);}
{##      inc(env_offset);}
{##      end;}
{##    inc(env_offset);}
{##    env_offset := env_offset+2;}
{##    index := 0;}
{##    while mem[env_seg:env_offset] <> 0 do}
{##      begin}
{##      inc(index);}
{##      program_directory[index] := chr(mem[env_seg:env_offset]);}
{##      inc(env_offset);}
{##      end;}
{##    while (program_directory[index] <> '\') and}
{##          (program_directory[index] <> ':') and}
{##          (index > 0) do}
{##      dec(index);}
{##    program_directory[0] := chr(index);}
{##    end; #<get_program_directory#>}
{##}
{#endif}
{#endif}


{}procedure setup_initial_values;

  var
    i : integer;

  begin {setup_initial_values}
{#if not turbop}
{####include "version.i"}
{#else}
  set_version;
{#endif}
  current_frame       := nil;
  ludwig_aborted      := false;
  exit_abort          := false;
  hangup              := false;
  edit_mode           := mode_insert;
  previous_mode       := mode_insert;
  for i := 1 to max_files do begin
    files[i] := nil;
    files_frames[i] := nil
    end;
  fgi_file            := 0;
  fgo_file            := 0;
  first_span          := nil;
  ludwig_mode         := ludwig_batch;
  command_introducer  := ord('\');
  scr_frame           := nil;
  scr_msg_row         := maxint;
  vdu_free_flag       := false;
  exec_level          := 0;

  { Set up the Free Group/Line/Mark Pools }
  free_group_pool     := nil;
  free_line_pool      := nil;
  free_mark_pool      := nil;

  { Set up all the Default Default characteristics for a frame.}

  for i := min_mark_number to max_mark_number do initial_marks[i] := nil;
  initial_scr_height    := 1;           { Set to tt_height for terminals. }
  initial_scr_width     := 132;         { Set to tt_width  for terminals. }
  initial_scr_offset    := 0;
  initial_margin_left   := 1;
  initial_margin_right  := 132;         { Set to tt_width  for terminals. }
  initial_margin_top    := 0;
  initial_margin_bottom := 0;
  initial_options       := [];

  for i := 1 to max_strlen do blank_string[i] := ' ';
  for i := 1 to max_verify do initial_verify[i] := false;
  default_tab_stops[0]  := true;
  for i := 1 to max_strlen do default_tab_stops[i] := false;
  default_tab_stops[max_strlenp] := true;

  {set up sets for prefixes}

	     { NOTE - this matches prefixcommands }
  prefixes:= [cmd_prefix_ast..cmd_prefix_tilde];

  repeatsyms:= ['+','-','@','<','>','=','0'..'9', ',', '.'];

  dflt_prompts[no_prompt        ] := '        ';
  dflt_prompts[char_prompt      ] := 'Charset:';
  dflt_prompts[get_prompt       ] := 'Get    :';
  dflt_prompts[equal_prompt     ] := 'Equal  :';
  dflt_prompts[key_prompt       ] := 'Key    :';
  dflt_prompts[cmd_prompt       ] := 'Command:';
  dflt_prompts[span_prompt      ] := 'Span   :';
  dflt_prompts[text_prompt      ] := 'Text   :';
  dflt_prompts[frame_prompt     ] := 'Frame  :';
  dflt_prompts[file_prompt      ] := 'File   :';
  dflt_prompts[column_prompt    ] := 'Column :';
  dflt_prompts[mark_prompt      ] := 'Mark   :';
  dflt_prompts[param_prompt     ] := 'Param  :';
  dflt_prompts[topic_prompt     ] := 'Topic  :';
  dflt_prompts[replace_prompt   ] := 'Replace:';
  dflt_prompts[by_prompt        ] := 'By     :';
  dflt_prompts[verify_prompt    ] := 'Verify ?';
  dflt_prompts[pattern_prompt   ] := 'Pattern:';
  dflt_prompts[pattern_set_prompt] := 'Pat Set:';

  space_set     := [ 32];
		   {' '}
		   { the S (space) pattern specifier }

  numeric_set   := [ 48.. 57];
		   {'0'..'9'}
		   { the N (numeric) pattern specifier }

  upper_set     := [ 65.. 90];
		   {'A'..'Z'}
		   { the U (uppercase) pattern specifier }

  lower_set     := [ 97..122];
		   {'a'..'z'}
		   { the L (lowercase) pattern specifier }

  alpha_set     := upper_set + lower_set;
		   {the A (alphabetic) pattern specifier }

  punctuation_set:=[ 33, 34,  39, 40, 41, 44, 46, 58, 59, 63, 96];
		   {'!','"','''','(',')',',','.',':',';','?','`'}
		   { the P (punctuation) pattern specifier }

  printable_set := [ 32..126];
		   {' '..'~'}
		   { the C (printable char) pattern specifier }

  file_data.old_cmds := true;
  file_data.entab := false;
{#if turbop and not fpc}
{##  file_data.space := 50000;}
{##  fillchar(file_data.initial[1], sizeof(file_data.initial), ' ');}
{#else}
  file_data.space := 500000;
  for i := 1 to max_strlen do
    file_data.initial[i] := ' ';
{#endif}
  file_data.purge := false;
  file_data.versions := 1;

  word_elements[0] := space_set;
{ word_elements[1] := alpha_set + numeric_set;}
{ word_elements[2] := printable_set - (word_elements[0] + word_elements[1]);}
  word_elements[1] := printable_set - space_set;
  end; {setup_initial_values}


{}procedure initialize_command_table_part1;

  begin {initialize_command_table_part1}
  with cmd_attrib[cmd_noop            ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef,marker];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_up              ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_down            ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_right           ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_left            ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_home            ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_return          ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_tab             ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_backtab         ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_rubout          ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_jump            ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef,marker];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_advance         ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef,marker];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_position_column  ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_position_line    ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_op_sys_command    ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := cmd_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_window_forward   ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_window_backward  ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_window_right     ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_window_left      ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_window_scroll    ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef       ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_window_top       ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_window_end       ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_window_new       ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_window_middle    ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_window_setheight ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_window_update    ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_get             ] do begin
    lp_allowed := [none,plus,minus,pint,nint                     ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := get_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_next            ] do begin
    lp_allowed := [none,plus,minus,pint,nint                     ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := char_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_bridge          ] do begin
    lp_allowed := [none,plus,minus                               ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := char_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_replace         ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef       ];
    eq_action := eqnil; tpcount := 2;
    with tpar_info[1] do
      begin
      prompt_name := replace_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := by_prompt;  trim_reply := false;
      ml_allowed := true;
      end;
    end;
  with cmd_attrib[cmd_equal_string     ] do begin
    lp_allowed := [none,plus,minus,          pindef,nindef       ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := equal_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_equal_column     ] do begin
    lp_allowed := [none,plus,minus,          pindef,nindef       ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := column_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_equal_mark       ] do begin
    lp_allowed := [none,plus,minus,          pindef,nindef       ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := mark_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_equal_eol        ] do begin
    lp_allowed := [none,plus,minus,          pindef,nindef       ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_equal_eop        ] do begin
    lp_allowed := [none,plus,minus                               ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_equal_eof        ] do begin
    lp_allowed := [none,plus,minus                               ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_overtype_mode    ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_insert_mode      ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_overtype_text    ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqold; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := text_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_insert_text      ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqold; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := text_prompt;  trim_reply := false;
      ml_allowed := true;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_type_text        ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqold; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := text_prompt;  trim_reply := false;
      ml_allowed := true;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_insert_line      ] do begin
    lp_allowed := [none,plus,minus,pint,nint                     ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_insert_char      ] do begin
    lp_allowed := [none,plus,minus,pint,nint                     ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_insert_invisible ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_delete_line      ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef,marker];
    eq_action := eqdel; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_delete_char      ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef,marker];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  end; {initialize_command_table_part1}


{}procedure initialize_command_table_part2;

  begin {initialize_command_table_part2}
  with cmd_attrib[cmd_swap_line        ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef,marker];
    eq_action := eqdel; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_split_line       ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_ditto_up         ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef       ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_ditto_down       ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef       ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_case_up          ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef       ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_case_low         ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef       ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_case_edit        ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef       ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_set_margin_left   ] do begin
    lp_allowed := [none,plus,minus                               ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_set_margin_right  ] do begin
    lp_allowed := [none,plus,minus                               ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_line_fill        ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_line_justify     ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_line_squash      ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_line_centre      ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_line_left        ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_line_right       ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_word_advance     ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef,marker];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_word_delete      ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef,marker];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_advance_paragraph] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef,marker];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_delete_paragraph ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef,marker];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_span_define      ] do begin
    lp_allowed := [none,plus,minus,pint,                   marker];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := span_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_span_transfer    ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := span_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_span_copy        ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := span_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_span_compile     ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := span_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_span_jump        ] do begin
    lp_allowed := [none,plus,minus                               ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := span_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_span_index       ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_span_assign      ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef              ];
    eq_action := eqnil; tpcount := 2;
    with tpar_info[1] do
      begin
      prompt_name := span_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := text_prompt;  trim_reply := false;
      ml_allowed := true;
      end;
    end;
  with cmd_attrib[cmd_block_define     ] do begin
    lp_allowed := [none,plus,minus,pint,                   marker];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_block_transfer   ] do begin
    lp_allowed := [none                                         ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_block_copy       ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_frame_kill       ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := frame_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_frame_edit       ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := frame_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_frame_return     ] do begin
    lp_allowed := [none,plus,      pint                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_span_execute     ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := span_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_span_execute_no_recompile] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := span_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_frame_parameters ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := param_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_input       ] do begin
    lp_allowed := [none,plus,minus                               ];
    eq_action := eqnil; tpcount := -1;
    with tpar_info[1] do
      begin
      prompt_name := file_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_output      ] do begin
    lp_allowed := [none,plus,minus                               ];
    eq_action := eqnil; tpcount := -1;
    with tpar_info[1] do
      begin
      prompt_name := file_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_edit        ] do begin
    lp_allowed := [none,plus,minus                               ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := file_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_read        ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_write       ] do begin
    lp_allowed := [none,plus,minus,pint,nint,pindef,nindef,marker];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_close       ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_rewind      ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_kill        ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_execute     ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := file_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_save        ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_table       ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_global_input ] do begin
    lp_allowed := [none,plus,minus                               ];
    eq_action := eqnil; tpcount := -1;
    with tpar_info[1] do
      begin
      prompt_name := file_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_global_output] do begin
    lp_allowed := [none,plus,minus                               ];
    eq_action := eqnil; tpcount := -1;
    with tpar_info[1] do
      begin
      prompt_name := file_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_global_rewind] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_file_global_kill  ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_user_command_introducer] do begin
    lp_allowed := [none                                          ];
    eq_action := eqold; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_user_key         ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 2;
    with tpar_info[1] do
      begin
      prompt_name := key_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := cmd_prompt;  trim_reply := false;
      ml_allowed := true;
      end;
    end;
  with cmd_attrib[cmd_user_parent      ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_user_subprocess  ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_user_undo        ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_help            ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := topic_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_verify          ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := verify_prompt;  trim_reply := true;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_command         ] do begin
    lp_allowed := [none,plus,minus                               ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_mark            ] do begin
    lp_allowed := [none,plus,minus,pint,nint                     ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_page            ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_quit            ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_dump            ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_validate        ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_execute_string   ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := cmd_prompt;  trim_reply := false;
      ml_allowed := true;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_do_last_command   ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_extended        ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_exit_abort       ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_exit_fail        ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_exit_success     ] do begin
    lp_allowed := [none,plus,      pint,     pindef              ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_pattern_dummy_pattern] do begin
    lp_allowed := [                                              ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := pattern_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
  with cmd_attrib[cmd_pattern_dummy_text] do begin
    lp_allowed := [                                              ];
    eq_action := eqnil; tpcount := 1;
    with tpar_info[1] do
      begin
      prompt_name := text_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
{#if WINDOWCHANGE or XWINDOWS}
  with cmd_attrib[cmd_resize_window     ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
{#endif}
{#if XWINDOWS}
{##  with cmd_attrib[cmd_handle_mouse_event] do begin}
{##    lp_allowed := [none                                          ];}
{##    eq_action := eqnil; tpcount := 0;}
{##    with tpar_info[1] do}
{##      begin}
{##      prompt_name := no_prompt;  trim_reply := false;}
{##      ml_allowed := false;}
{##      end;}
{##    with tpar_info[2] do}
{##      begin}
{##      prompt_name := no_prompt;  trim_reply := false;}
{##      ml_allowed := false;}
{##      end;}
{##    end;}
{##  with cmd_attrib[cmd_cut_X_span        ] do begin}
{##    lp_allowed := [none                                          ];}
{##    eq_action := eqnil; tpcount := 0;}
{##    with tpar_info[1] do}
{##      begin}
{##      prompt_name := no_prompt;  trim_reply := false;}
{##      ml_allowed := false;}
{##      end;}
{##    with tpar_info[2] do}
{##      begin}
{##      prompt_name := no_prompt;  trim_reply := false;}
{##      ml_allowed := false;}
{##      end;}
{##    end;}
{##  with cmd_attrib[cmd_paste_X_span      ] do begin}
{##    lp_allowed := [none                                          ];}
{##    eq_action := eqnil; tpcount := 0;}
{##    with tpar_info[1] do}
{##      begin}
{##      prompt_name := no_prompt;  trim_reply := false;}
{##      ml_allowed := false;}
{##      end;}
{##    with tpar_info[2] do}
{##      begin}
{##      prompt_name := no_prompt;  trim_reply := false;}
{##      ml_allowed := false;}
{##      end;}
{##    end;  }
{#endif}
{#if NCURSESMOUSE}
  with cmd_attrib[cmd_ncurses_mouse_event   ] do begin
    lp_allowed := [none                                          ];
    eq_action := eqnil; tpcount := 0;
    with tpar_info[1] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    with tpar_info[2] do
      begin
      prompt_name := no_prompt;  trim_reply := false;
      ml_allowed := false;
      end;
    end;
{#endif}
 end; {initialize_command_table_part2}


procedure value_initializations{};

  begin {value_initializations}
{#if turbop}
  get_program_directory;
{#endif}
  setup_initial_values;
  initialize_command_table_part1;
  initialize_command_table_part2;
  end; {value_initializations}

{#if turbop}
end.
{#endif}
