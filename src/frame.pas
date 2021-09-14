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
{       Chris J. Barter (1979-81, 1987);                               }
{       Wayne N. Agutter (1979-81, 1987);                              }
{       Bevin R. Brett (1979-81, 1987);                                }
{       Kevin J. Maciunas (1980-84 )                                   }
{       Kelvin B. Nicolle (1987, 1989);                                }
{       Jeff Blows (1989);                                             }
{       Mark R. Prior (1988); and                                      }
{       Martin Sandiford (1991).                                       }
{                                                                      }
{  Copyright  1979-81, 1987-89, 1991 University of Adelaide            }
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
! Name:         FRAME
!
! Description:  Creation/destruction, manipulation of Frames.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/frame.pas,v 4.8 1991/02/26 18:03:20 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: frame.pas,v $
! Revision 4.8  1991/02/26 18:03:20  ludwig
! Added code to initialise the selection marker when creating frames for
! the X Window System version.
! SN.
!
Revision 4.7  90/01/18  18:53:47  ludwig
Entered into RCS at revision level 4.7

!
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                     5-May-1987
!       In the parameters display, increase the width of the Ludwig
!       version from 6 to 8 characters.
!       Use the variable ludwig_version instead of the constant lw_vers.
!       Tidy up the underlining in the ep/o=s/ display.
! 4-003 Jeff Blows                                            3-Jul-1989
!       Initialize all pointers in tpar_objects in a frame_object.
! 4-004 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-005 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
! 4-006 Kelvin B. Nicolle                                    13-Sep-1989
!       Add includes etc. for Tower version.
! 4-007 Kelvin B. Nicolle                                    25-Oct-1989
!       Correct the includes for the Tower version.
!       Remove the superfluous include of system.h.
!--}

{#if vms}
{##[ident('4-007'),}
{## overlaid]}
{##module frame (output);}
{#elseif turbop}
unit frame;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'frame.fwd'}
{##%include 'ch.h'}
{##%include 'dfa.h'}
{##%include 'line.h'}
{##%include 'span.h'}
{##%include 'mark.h'}
{##%include 'screen.h'}
{##%include 'user.h'}
{##%include 'vdu.h'}
{##%include 'tpar.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "frame.h"}
{####include "dfa.h"}
{####include "ch.h"}
{####include "line.h"}
{####include "span.h"}
{####include "mark.h"}
{####include "screen.h"}
{####include "user.h"}
{####include "vdu.h"}
{####include "tpar.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=frame.h#>}
{###<$F=ch.h#>}
{###<$F=dfa.h#>}
{###<$F=line.h#>}
{###<$F=span.h#>}
{###<$F=mark.h#>}
{###<$F=screen.h#>}
{###<$F=user.h#>}
{###<$F=vdu.h#>}
{###<$F=tpar.h#>}
{#elseif turbop}
interface
  uses value;
  {$I frame.i}

implementation
  uses ch, dfa, line, span, mark, screen, user, vdu, tpar;
{#endif}


function frame_edit (
                frame_name : name_str)
        : boolean;

  {***************************************************************************
   *    D E S C R I P T I O N :-                                             *
   * Input   : frame_name                                                    *
   * Output  : <none>   [ Modifies current_frame ]                           *
   * Purpose : This is the \ED command.  if frame_name doesn't exist,        *
   *           then it is created.                                           *
   * Errors  : Fails if span of that name already exists, or something       *
   *           terrible happens.                                             *
   *                                                                         *
   * Notes   : This routine deals with GROUPS. When a frame is created, it   *
   *           is necessary to pass a Group_ptr to a line routine to create  *
   *           the <eop> line.  Also necessary to delve into the Group       *
   *           structure to pass the first & last lines to create the span.  *
   *           If the input name is blank then this is converted to          *
   *           automatically converted to `LUDWIG', the default name.        *
   **************************************************************************}
  label 99;

  var
    oldp,
    ptr,
    sptr    : span_ptr;
    fptr    : frame_ptr;
    gptr    : group_ptr;                      { See note above        }
    created : set of (spn,frm,mrk1,mrk2,grp,dot);
    dummy   : boolean;                        { ignore status returns }
    i       : integer;

  begin {frame_edit}
  frame_edit := false;
  if frame_name = blank_frame_name then
    frame_name := default_frame_name;
  if span_find(frame_name,ptr,oldp) then
    if ptr^.frame <> nil then
      begin
      if ptr^.frame <> current_frame then
        begin
        ptr^.frame^.return_frame := current_frame;
        current_frame := ptr^.frame;
        end;
      frame_edit := true;
      end
    else
      begin screen_message(msg_span_of_that_name_exists); goto 99; end
  else
    begin { No Span/Frame of that name exists, create one. }
    new(fptr);
    new(sptr);
    created := [frm,spn];
    if line_eop_create(fptr,gptr) then { see note above }
      begin
      created := created + [grp];
      with sptr^ do
        begin
        blink := oldp;
        flink := ptr;
        if oldp = nil then
          first_span  := sptr
        else
          oldp^.flink := sptr;
        if ptr <> nil then
          ptr^.blink  := sptr;
        name  := frame_name;
        frame := fptr;
        mark_one := nil;
        mark_two := nil;
        code := nil;
        if mark_create(gptr^.first_line,1,mark_one) then  { see Note above }
          begin
          created := created + [mrk1];
          if mark_create(gptr^.last_line,1,mark_two) then { see Note above }
            begin
            created := created + [mrk2];
            fptr^.dot := nil;
            if mark_create(gptr^.first_line,initial_margin_left,fptr^.dot) then
              created := created + [dot];
            end;
          end;
         end; { with sptr^ }
        if dot in created then
          begin
          with fptr^ do
            begin
            first_group     := gptr;
            last_group      := gptr;
            {dot created above}
{#if XWINDOWS}
{##            x_selection_end := nil;}
{##            selection_valid := false;}
{#endif}
            marks           := initial_marks;
            scr_height      := initial_scr_height;
            scr_width       := initial_scr_width;
            scr_offset      := initial_scr_offset;
            scr_dot_line    := 1;
            span            := sptr;
            return_frame    := current_frame;
            input_count     := 0;
            space_limit     := file_data.space;
            space_left      := file_data.space;
            text_modified   := false;
            margin_left     := initial_margin_left;
            margin_right    := initial_margin_right;
            margin_top      := initial_margin_top;
            margin_bottom   := initial_margin_bottom;
            tab_stops       := initial_tab_stops;
            options         := initial_options;
            input_file      := 0;
            output_file     := 0;
            get_tpar.len    := 0;
            get_tpar.con    := nil;
            get_tpar.nxt    := nil;
            eqs_tpar.len    := 0;
            eqs_tpar.con    := nil;
            eqs_tpar.nxt    := nil;
            rep1_tpar.len   := 0;
            rep1_tpar.con   := nil;
            rep1_tpar.nxt   := nil;
            rep2_tpar.len   := 0;
            rep2_tpar.con   := nil;
            rep2_tpar.nxt   := nil;
            verify_tpar.len := 0;
            verify_tpar.con := nil;
            verify_tpar.nxt := nil;
            eqs_pattern_ptr := nil;
            get_pattern_ptr := nil;
            rep_pattern_ptr := nil;
            end;{ with fptr^ }
          if line_change_length(gptr^.last_line,name_len + 16) then
            with gptr^.last_line^ do
              begin
              str^[ 1] := '<';
              str^[ 2] := 'E'; str^[ 3] := 'n'; str^[ 4] := 'd';
              str^[ 5] := ' ';
              str^[ 6] := 'o'; str^[ 7]  := 'f';
              str^[ 8] := ' ';
              str^[ 9] := 'F'; str^[10] := 'i'; str^[11] := 'l'; str^[12] := 'e';
              str^[13] := '>';
              str^[14] := ' ';
              str^[15] := ' ';
              str^[16] := ' ';
              for i := 1 to name_len do str^[i + 16] := frame_name[i];
              used := 0; { Special feature of the NULL line ! }
              current_frame := fptr;
              frame_edit    := true;
              goto 99;
              end;
          end;
      end;
    { Something terrible has happened..}
    { This is the failure handler      }
    if mrk1 in created then
      dummy := mark_destroy(sptr^.mark_one);
    if mrk2 in created then
      dummy := mark_destroy(sptr^.mark_two);
    if spn in created then
      begin
      dispose(sptr); dispose(fptr);
      end;
    if grp in created then
      dummy := line_eop_destroy(gptr); { ignore status return }
{#if debug}
    screen_message(dbg_frame_creation_failed);
{#endif}
    end; {Creation of frame}
  99:
  end; {frame_edit}


function frame_kill (
                frame_name : name_str)
        : boolean;

  {***************************************************************************
   *    D E S C R I P T I O N :-                                             *
   * Input   : frame_name                                                    *
   * Output  : <none>   [ Modifies current_frame ]                           *
   * Purpose : Kills the frame specified.  You can't kill frame C or OOPS!   *
   * Errors  : Fails if frame is current_frame, C or OOPS or if something    *
   *           terrible happens.                                             *
   **************************************************************************}
  label 99;
  var
    oldp,
    sptr       : span_ptr;
    this_frame : frame_ptr;
    i          : integer;
    ptr1,ptr2  : line_ptr;

  begin {frame_kill}
  frame_kill := false;
  if not span_find(frame_name,sptr,oldp) then
    begin screen_message(msg_no_such_frame); goto 99; end;
  if sptr^.frame = nil then
    begin screen_message(msg_no_such_frame); goto 99; end;
  this_frame := sptr^.frame;
  if (this_frame = current_frame ) or
     (this_frame = scr_frame) or
     (opt_special_frame in this_frame^.options )
  then
    begin screen_message(msg_cant_kill_frame); goto 99; end;
  with this_frame^ do
    if (input_file <> 0) or (output_file <> 0) then
      begin screen_message(msg_frame_has_files_attached); goto 99; end;

  { We are now free to destroy this frame}
  { Step 1. -- remove all ER's back to this frame}
  {            and all spans into this frame}
  oldp := first_span;
  while oldp <> nil do
    begin
    sptr := oldp^.flink;
    if oldp^.frame <> nil then
      begin
      with oldp^.frame^ do
        if return_frame = this_frame then
          return_frame := nil;
      end
    else
      if oldp^.mark_one^.line^.group^.frame = this_frame then
        if not span_destroy(oldp) then goto 99;
    oldp := sptr;
    end;

  with this_frame^ do
    begin

    { Step 2. -- Destroy the Span}
    {            Zap the frame ptr in the span header}
    {            So that Span_Destroy doesn't crash}
    span^.frame := nil;
    if not span_destroy(span) then goto 99;

    { Step 3a. -- Destroy all internal lines. }
    if not mark_destroy(dot) then
      goto 99;
    for i := min_mark_number to max_mark_number do
      if marks[i] <> nil then
        if not mark_destroy(marks[i]) then
          goto 99;
    ptr2 := last_group^.last_line^.blink;
    if ptr2 <> nil then
      begin
      ptr1 := first_group^.first_line;
      if not lines_extract(ptr1,ptr2) then
        goto 99;
      if not lines_destroy(ptr1,ptr2) then
        goto 99;
      end;

    { Step 3b. -- Destroy the <eop> line.}
    if not line_eop_destroy(first_group) then goto 99;
    end;

  { Step 4. -- Dispose of the frame header (phew!)}
  {            and any pattern tables attatched  }
  with this_frame^ do
    begin
    if not pattern_dfa_table_kill(eqs_pattern_ptr) then goto 99;      { FAV }
    if not pattern_dfa_table_kill(get_pattern_ptr) then goto 99;      { FAV }
    if not pattern_dfa_table_kill(rep_pattern_ptr) then goto 99;      { FAV }
    end;

  dispose(this_frame);
  frame_kill := true;
99:
  end; {frame_kill}


{}function nextchar (var request : tpar_object;
                     var pos     : integer) : char;

    var
      ch : char;

    begin {nextchar}
    with request do
      begin
      while (pos<len) and (str[pos]=' ') do pos := pos+1;
      if (str[pos]=' ') or (pos>len) then ch := chr(0)
      else ch := str[pos];
      nextchar := ch;
      if pos <= len then pos := pos+1;
      end;
    end; {nextchar}


{}function setmemory (sz : integer; set_initial : boolean) : boolean;

    var
      used_storage,min_size: integer;

    begin {setmemory}
    if sz >= max_space then
      sz := max_space;
    if set_initial then
      file_data.space := sz;
    with current_frame^ do
      begin
      used_storage := space_limit - space_left;
      min_size := used_storage + 800;
      if min_size > space_limit then
        min_size := space_limit;
      if sz < min_size then
        sz := min_size;
      space_limit := sz;
      space_left  := sz - used_storage;
      end;
    setmemory := true;
    end; {setmemory}


function frame_setheight (
                sh          : integer;
                set_initial : boolean)
        : boolean;

  var
    band : scr_row_range;

  begin {frame_setheight}
  frame_setheight := false;
  with current_frame^ do
    begin
    if (sh>=1) and (sh<=terminal_info.height) then
      begin
      if set_initial then initial_scr_height := sh;
      scr_height := sh;
      band := sh div 6;
      if trmflags_v_scdn in tt_capabilities then
        begin
        if set_initial then
          initial_margin_top := band;
        margin_top := band
        end
      else
        begin
        if set_initial then
          initial_margin_top := 0;
        margin_top := 0;
        end;
      if set_initial then
        initial_margin_bottom := band;
      margin_bottom := band;
      frame_setheight := true;
      end
    else
      screen_message(msg_invalid_screen_height);
    end;
  end; {frame_setheight}


{}function setwidth (wid : integer; set_initial : boolean) : boolean;

    begin {setwidth}
    setwidth := false;
    if (wid>=10) and (wid<=terminal_info.width) then
      begin
      if set_initial then
        initial_scr_width := wid;
      current_frame^.scr_width := wid;
      setwidth := true;
      end
    else
      screen_message(msg_screen_width_invalid);
    end; {setwidth}


{}procedure show_options;

    begin {show_options}
    screen_unload;
    with current_frame^ do
      begin
      screen_home(true);
      screen_write_str(0,'    Ludwig Option         Code    State',39);
      screen_writeln;
      screen_write_str(0,'    --------------------  ----    -----',39);
      screen_writeln;
      screen_writeln;
      screen_write_str(4,'Show current options  S',23);
      screen_writeln;
      screen_write_str(4,'Auto-indenting        I       ',30);
      if opt_auto_indent in options then
        screen_write_str(0,'On',2)
      else
        screen_write_str(0,'Off',3);
      screen_writeln;
      screen_write_str(4,'New Line              N       ',30);
      if opt_new_line in options then
        screen_write_str(0,'On',2)
      else
        screen_write_str(0,'Off',3);
      screen_writeln;
      screen_write_str(4,'Wrap at Right Margin  W       ',30);
      if opt_auto_wrap in options then
        screen_write_str(0,'On',2)
      else
        screen_write_str(0,'Off',3);
      screen_writeln;
      screen_writeln;
      end;
    screen_pause;
    screen_home(true); { wipe out the display }
    end; {show_options}


{}function set_options (var request     : tpar_object;
                        var pos         : integer;
                            set_initial : boolean) : boolean;

    label 99;
    var
      ch : char;
      seton:boolean;
      ok : boolean;

    function set_opt (var options : frame_options) : boolean;
      { worker module to set 1 option }

      begin {set_opt}
      set_opt := false;
      if ch in ['S', 'I', 'W', 'N'] then
        begin
        case ch of
          'S' : show_options;
          'I' : if seton then
                  options := options + [opt_auto_indent]
                else
                  options := options - [opt_auto_indent];
          'W' : if seton then
                  options := options + [opt_auto_wrap  ]
                else
                  options := options - [opt_auto_wrap  ];
          'N' : if seton then
                  options := options + [opt_new_line]
                else
                  options := options - [opt_new_line];
        end{case};
        set_opt := true;
        end
      else screen_message(msg_unknown_option);
      end; {set_opt}

    begin {set_options}
    set_options := false;
    ch := nextchar(request,pos);
    if ch = '(' then
      repeat
        ch := nextchar(request,pos);
        if ch = '-' then
          begin seton := false; ch := nextchar(request,pos); end
        else
          seton := true;
        if set_initial then
          ok := set_opt(initial_options);
        ok := set_opt(current_frame^.options);
        ch := nextchar(request,pos);
        if (ch<>',') and (ch<>')') then
          begin screen_message(msg_syntax_error_in_options); goto 99; end;
      until (ch=')') or not ok
    else
      begin
      { single option }
      if ch = '-' then
        begin seton := false; ch := nextchar(request,pos); end
      else
        seton := true;
      if set_initial then
        ok := set_opt(initial_options);
      ok := set_opt(current_frame^.options);
      end;
    set_options := ok;
    99:
    end; {set_options}


{}function setcmdintr (var request : tpar_object;
                       var pos     : integer) : boolean;

    var
      i:integer;
      terminate:boolean;
      key_name:key_name_str;
      key_code:key_code_range;

    begin {setcmdintr}
    setcmdintr := false;
    if ludwig_mode = ludwig_screen then
      begin
{#if turbop}
      fillchar(key_name[1], sizeof(key_name), ' ');
{#else}
{##      key_name := '  ';}
{#endif}
      i := 0;
      terminate := false;
      while (pos <= request.len) and not terminate do
        if request.str[pos] = ',' then
          terminate := true
        else
          begin
          i := i + 1;
          key_name[i] := request.str[pos];
          pos := pos + 1;
          end;
      if i = 1 then
        if not (ord(key_name[1]) in alpha_set+numeric_set+space_set) then
          begin
          command_introducer := ord(key_name[1]);
          vdu_new_introducer(command_introducer);
          setcmdintr := true;
          end
        else
          screen_message(msg_invalid_cmd_introducer)
      else
      if user_key_name_to_code(key_name,key_code) then
        if key_code in key_introducers then
          screen_message(msg_invalid_cmd_introducer)
        else
          begin
          command_introducer := key_code;
          vdu_new_introducer(command_introducer);
          setcmdintr := true;
          end
      else
        screen_message(msg_unrecognized_key_name);
      end
    else
      screen_message(msg_screen_mode_only);
    end; {setcmdintr}


{}function set_mode (var request : tpar_object;
                     var pos     : integer) : boolean;

    var
      ch:char;

    begin {set_mode}
    set_mode := false;
    ch := nextchar(request, pos);
    if ch = 'I' then
      edit_mode := mode_insert
    else if ch = 'O' then
      edit_mode := mode_overtype
    else if ch = 'C' then
      edit_mode := mode_command
    else screen_message(msg_mode_error);
    set_mode := true;
    end; {set_mode}


{}function set_tabs (var request     : tpar_object;
                     var pos         : integer;
                         set_initial : boolean) : boolean;

    label 99;
    var
      i,j        : integer;
      ch         : char;
      temptab    : tab_array;
      first_line,
      last_line  : line_ptr;
      last_margin: (lm_none,lm_left,lm_right);
      legal      : boolean;
      dot_col    : col_range;

    begin {set_tabs}
    set_tabs := false;
    with current_frame^ do
      begin
      ch := nextchar(request,pos);
      if ch in ['D', 'T', 'I', 'R', 'S', 'C', '('] then
        case ch of
          'D' : {default tabs}
                begin
                if set_initial then
                  initial_tab_stops := default_tab_stops;
                tab_stops := default_tab_stops;
                end;
          'T' : {template match}
                begin
                with dot^.line^ do
                  begin
                  if used > 0 then
                    begin
                    if set_initial then
                      initial_tab_stops[1] := str^[1]<>' ';
                    tab_stops[1] := str^[1]<>' ';
                    end;
                  for i:= 2 to used do
                    begin
                    if set_initial then
                      initial_tab_stops[i] := (str^[i]<>' ') and (str^[i-1]=' ');
                    tab_stops[i] := (str^[i]<>' ') and (str^[i-1]=' ');
                    end;
                  for i := used+1 to max_strlen do
                    begin
                    if set_initial then
                      initial_tab_stops[i] := false;
                    tab_stops[i] := false;
                    end;
                  end;
                end;
          'I' : { insert tabs }
                begin
                if not lines_create(1,first_line,last_line)       then goto 99;
                if not line_change_length(first_line,max_strlen)  then goto 99;
                with first_line^ do
                  begin
                  if set_initial then
                    begin
                    for i := 1 to max_strlen do
                      if initial_tab_stops[i] then
                        str^[i] := 'T';
                    str^[initial_margin_left] := 'L';
                    str^[initial_margin_right] := 'R';
                    end
                  else
                    begin
                    for i := 1 to max_strlen do
                      if tab_stops[i] then
                        str^[i] := 'T';
                    str^[margin_left] := 'L';
                    str^[margin_right] := 'R';
                    end;
                  used := ch_length(str^,max_strlen);
                  end;
                if not lines_inject(first_line,last_line,dot^.line) then goto 99;
                if not mark_create(first_line,dot^.col,dot)         then goto 99;
                text_modified := true;
                if not mark_create(first_line,dot^.col,marks[mark_modified]) then goto 99;
                end;
          'R' : { Template Ruler }
                with dot^,line^ do
                  begin
                  i           := 1;
                  legal       := true;
                  last_margin := lm_none;
                  while (i <= used) and legal do
                    begin
                    legal := str^[i] in ['T','t','L','l','R','r',' '];
                    if (str^[i] = 'L') or (str^[i] = 'l') then
                      begin
                      legal := legal and (last_margin = lm_none);
                      last_margin := lm_left;
                      end;
                    if (str^[i] = 'R') or (str^[i] = 'r') then
                      begin
                      legal := legal and (last_margin = lm_left);
                      last_margin := lm_right;
                      end;
                    i := i + 1;
                    end;
                  legal := legal and (last_margin = lm_right);
                  if not legal then
                    begin screen_message(msg_invalid_ruler); goto 99; end;
                  i := 1;
                  while i <= used do
                    begin
                    if set_initial then
                      initial_tab_stops[i] := str^[i] <> ' ';
                    tab_stops[i] := str^[i] <> ' ';
                    if (str^[i] = 'L') or (str^[i] = 'l') then
                      begin
                      if set_initial then
                        initial_margin_left := i;
                      margin_left := i;
                      end;
                    if (str^[i] = 'R') or (str^[i] = 'r') then
                      begin
                      if set_initial then
                        initial_margin_right:= i;
                      margin_right:= i;
                      end;
                    i := i + 1;
                    end;
                  for i := used+1 to max_strlen do
                    begin
                    if set_initial then
                      initial_tab_stops[i] := false;
                    tab_stops[i] := false;
                    end;
                  first_line := line;
                  dot_col := col;
                  if not marks_squeeze(first_line,1,first_line^.flink,1) then
                                                                        goto 99;
                  if not lines_extract(first_line,first_line) then goto 99;
                  if not lines_destroy(first_line,first_line) then goto 99;
                  dot^.col := dot_col;
                  end;
          'S' : begin
                if dot^.col = max_strlenp then
                  begin screen_message(msg_out_of_range_tab_value); goto 99; end;
                if set_initial then
                  initial_tab_stops[dot^.col] := true;
                tab_stops[dot^.col] := true;
                end;
          'C' : begin
                if dot^.col = max_strlenp then
                  begin screen_message(msg_out_of_range_tab_value); goto 99; end;
                if set_initial then
                  initial_tab_stops[dot^.col] := false;
                tab_stops[dot^.col] := false;
                end;
          '(' : { multi-columns specified }
                begin
                temptab[0] := true;
                temptab[max_strlenp] := true;
                for i := 1 to max_strlen do temptab[i] := false;
                repeat
                  if not tpar_to_int(request,pos,j) then goto 99;
                  if (1 <= j) and (j <= max_strlen) then
                    temptab[j] := true
                  else
                    begin screen_message(msg_out_of_range_tab_value); goto 99; end;
                  ch := nextchar(request,pos);
                  if (ch <> ',') and (ch <> ')') then
                    begin screen_message(msg_bad_format_in_tab_table); goto 99; end;
                until ch = ')';
                if set_initial then
                  initial_tab_stops := temptab;
                tab_stops := temptab;
                end;
        end{case}
      else begin screen_message(msg_invalid_t_option); goto 99; end;
      end;
    set_tabs := true;
    99:
    end; {set_tabs}


{}function get_margins (    lo_bnd,
                            hi_bnd  : integer;
                        var request : tpar_object;
                        var pos     : integer;
                        var lower,
                            upper   : integer;
                            lr      : boolean) : boolean;

    label 99;
    var
      ch:char;
      syn_err:boolean;

    function get_mar (var margin : integer) : boolean;

      label 99;

      begin {get_mar}
      get_mar := false;
      if ('0' <= ch) and (ch <= '9') then
        begin
        pos := pos-1;
        if not tpar_to_int(request,pos,margin)then
          goto 99;
        if (margin < lo_bnd) or (hi_bnd < margin) then
          begin screen_message(msg_margin_out_of_range); goto 99; end;
        ch := nextchar(request,pos);
        end;
      get_mar := true;
      99:
      end; {get_mar}

    begin {get_margins}
    get_margins := false;
    syn_err := false;
    ch := nextchar(request,pos);
    if ch <> '(' then
      begin syn_err := true;  goto 99 end;
    ch := nextchar(request,pos);
    if ch = '.' then
      begin
      with current_frame^ do
        if lr then
          lower := dot^.col
        else
          lower := dot^.line^.scr_row_nr;
      ch := nextchar(request, pos);
      end
    else
      if not get_mar(lower) then goto 99;
    if ch = ',' then
      begin
      ch := nextchar(request,pos);
      if ch = '.' then
        begin
        with current_frame^ do
          if lr then
            upper := dot^.col
          else
            upper := scr_height - dot^.line^.scr_row_nr;
        ch := nextchar(request, pos);
        end
      else
        if not get_mar(upper) then goto 99;
      end;
    if ch <> ')' then
      begin syn_err := true; goto 99 end;
    get_margins := true;
    99:
    if syn_err then
      screen_message(msg_margin_syntax_error);
    end; {get_margins}


{}function set_lrmargin (var request     : tpar_object;
                         var pos         : integer;
                             set_initial : boolean) : boolean;

    label 99;
    var
      tl,tr:integer;

    begin {set_lrmargin}
    set_lrmargin := false;
    with current_frame^ do
      begin
      if set_initial then
        begin tl := initial_margin_left; tr := initial_margin_right; end
      else
        begin tl := margin_left; tr := margin_right; end;
      if not get_margins(1,max_strlen,request,pos,tl,tr,true) then goto 99;
      if tl < tr then
        begin
        if set_initial then
          begin
          initial_margin_left  := tl;
          initial_margin_right := tr;
          end;
        margin_left  := tl;
        margin_right := tr;
        end
      else
        begin screen_message(msg_left_margin_ge_right); goto 99; end;
      end;
    set_lrmargin := true;
    99:
    end; {set_lrmargin}


{}function set_tbmargin (var request     : tpar_object;
                         var pos         : integer;
                             set_initial : boolean) : boolean;

    label 99;
    var
      tt,tb:integer;

    begin {set_tbmargin}
    set_tbmargin := false;
    with current_frame^ do
      begin
      if set_initial then
        begin
        tt := initial_margin_top;
        tb := initial_margin_bottom;
        end
      else
        begin
        tt := margin_top;
        tb := margin_bottom;
        end;
      if not get_margins(0,scr_height,request,pos,tt,tb,false) then goto 99;
      if tt + tb >= scr_height then
        begin screen_message(msg_margin_out_of_range); goto 99; end; {needs better message--KBN--}
      if set_initial then
        begin
        initial_margin_top    := tt;
        initial_margin_bottom := tb;
        end;
      margin_top    := tt;
      margin_bottom := tb;
      set_tbmargin := true;
      end;
    99:
    end; {set_tbmargin}


{}function setparam (var request : tpar_object) : boolean;

    label 99;
    var
      temp,
      pos : integer;
      ch  : char;
      ok  : boolean;
      set_initial : boolean;

    begin {setparam}
    setparam := false;
    pos := 1;
    ch := nextchar(request,pos);
    while ch <> chr(0) do
      begin
      if ch = '$' then { setting an initial value for a new frame }
        begin
        set_initial := true;
        ch := nextchar(request,pos);
        end
      else
        set_initial := false;
      if nextchar(request,pos) <> '=' then
        begin screen_message(msg_options_syntax_error); goto 99; end;
      ok := false;
      if ch in ['O', 'S', 'H', 'W', 'C', 'T', 'M', 'V', 'K'] then
        case ch of
          'O' : ok := set_options(request,pos,set_initial);
          'S' : if tpar_to_int(request,pos,temp) then
                  ok := setmemory(temp,set_initial);
          'H' : if tpar_to_int(request,pos,temp) then
                  ok := frame_setheight(temp,set_initial);
          'W' : if tpar_to_int(request,pos,temp) then
                  ok := setwidth(temp,set_initial);
          'C' : ok := setcmdintr(request,pos);
          'T' : ok := set_tabs(request,pos,set_initial);
          'M' : ok := set_lrmargin(request,pos,set_initial);
          'V' : ok := set_tbmargin(request,pos,set_initial);
          'K' : ok := set_mode(request,pos);
        end{case}
      else begin screen_message(msg_invalid_parameter_code); goto 99; end;
      if not ok then goto 99;
      ch := nextchar(request,pos);
      if (ch = ',') or (ch = chr(0)) then
        ch := nextchar(request,pos)
      else
        begin screen_message(msg_syntax_error_in_param_cmd); goto 99; end;
      end;
    setparam := true;
    99:
    end; {setparam}


{}procedure display_option (ch : char; var first : boolean);

    begin {display_option}
    if first then screen_write_ch(0,'(')
    else screen_write_ch(0,',');
    screen_write_ch(0,ch);
    first := false;
    end; {display_option}


function frame_parameter (
                tpar : tpar_ptr)
        : boolean;

  label 99;
  var
    i        : integer;
    temp     : line_range;
    request  : tpar_object;
    key_name : key_name_str;
{#if turbop}
    tmp_str : string;
{#endif}
    buffer : str_object;

  procedure print_options (options : frame_options);

    var
      first : boolean;
      count : integer;

    begin {print_options}
    count := 1;
    first := true;
    screen_write_ch(0,' ');
    if opt_auto_indent in options then
      begin
      display_option('I',first);
      count := count + 2;
      end;
    if opt_auto_wrap in options then
      begin
      display_option('W',first);
      count := count + 2;
      end;
    if opt_new_line in options then
      begin
      display_option('N',first);
      count := count + 2;
      end;
    if first then
      begin
      screen_write_str(0,'  None    ',10);
      count := count + 10;
      end
    else
      begin
      screen_write_ch(0,')');
      count := count + 1;
      end;
    screen_write_str(0,'                 ',14-count);
    end; {print_options}

  procedure print_margins (m1,m2 : integer);

    var
      count : integer;

    begin {print_margins}
    screen_write_str(0,' (',2);
    screen_write_int(m1,1); screen_write_ch(0,',');
    screen_write_int(m2,1); screen_write_ch(0,')');
    count := 6;
    if m1 > 99 then
      count := count + 2
    else
      if m1 > 9 then
        count := count + 1;
    if m2 > 99 then
      count := count + 2
    else
      if m2 > 9 then
        count := count + 1;
    screen_write_str(0,'               ',14-count);
    end; {print_margins}

  begin {frame_parameter}
  frame_parameter := false;
  with request do
    begin
    nxt:= nil; con:=nil;
    end;
  if not tpar_get_1(tpar,cmd_frame_parameters,request) then goto 99;
  if request.len > 0 then
    begin frame_parameter := setparam(request); goto 99 end;
  { else display parameters and stats }
  screen_unload;
  screen_home(true);
  with current_frame^ do
  repeat
    screen_home(false); { Don't clear the screen here ! }
    screen_write_str(0,' Ludwig ',8);
    for i := 1 to 8 do
      screen_write_ch(0,ludwig_version[i]);
    screen_write_str(5,'Parameters      Frame: ',23);
    screen_write_name_str(0,span^.name,31);
    screen_writeln_clel;
    screen_write_str(0,' ===============     ==========      =====',42);
    screen_writeln_clel;
    screen_writeln_clel;
    screen_write_str(3,'Unused  memory available in frame    =',38);
    screen_write_int(space_left,9);
    screen_writeln_clel;
    screen_write_str(3,'The number of lines in this frame    =',38);
    if line_to_number(last_group^.last_line,temp) then
      temp := temp -1
    else
      temp := 0;
    screen_write_int(temp,9);
    screen_writeln_clel;
    screen_write_str(3,'Lines read from input file so far    =',38);
    screen_write_int(input_count,9);
    screen_writeln_clel;
    screen_write_str(3,'Current Line number in this frame    =',38);
    if not line_to_number(dot^.line,temp) then
      temp := 0;
    screen_write_int(temp,9);
    screen_writeln_clel;
    screen_writeln_clel;
    screen_write_str(9,'Parameters',10);
    screen_write_str(41,'Defaults',8);
    screen_writeln_clel;
    screen_write_str(9,'----------',10);
    screen_write_str(41,'--------',8);
    screen_writeln_clel;
    screen_write_str(3,'Keyboard Mode                      K =',38);
    case edit_mode of
      mode_overtype: screen_write_str(1,'Overtype Mode',13);
      mode_insert  : screen_write_str(1,'Insert Mode',11);
      mode_command : screen_write_str(1,'Command Mode',12);
    end{case};
    screen_writeln_clel;
    if ludwig_mode = ludwig_screen then
      begin
      screen_write_str(3,'Command introducer                 C = ',39);
      if user_key_code_to_name(command_introducer,key_name) then
        for i := 1 to key_name_len do
          screen_write_ch(0,key_name[i])
      else
        screen_write_ch(0,chr(command_introducer));
      screen_writeln_clel;
      end;
    screen_write_str(3,'Maximum memory available in frame  S =',38);
    screen_write_int(space_limit,9);
    screen_write_str(5,'  --  ',6);
    screen_write_int(file_data.space,9);
    screen_writeln_clel;
    screen_write_str(3,'Screen height  (lines displayed)   H =',38);
    screen_write_int(scr_height,9);
    screen_write_str(5,'  --  ',6);
    screen_write_int(initial_scr_height,9);
    screen_writeln_clel;
    screen_write_str(3,'Screen width   (characters)        W =',38);
    screen_write_int(scr_width,9);
    screen_write_str(5,'  --  ',6);
    screen_write_int(initial_scr_width,9);
    screen_writeln_clel;
    screen_write_str(3,'Editing options                    O =',38);
    print_options(options);
    screen_write_str(0,'  --  ',6);
    print_options(initial_options);
    screen_writeln_clel;
    screen_write_str(3,'Horizontal margins                 M =',38);
    print_margins(margin_left,margin_right);
    screen_write_str(0,'  --  ',6);
    print_margins(initial_margin_left,initial_margin_right);
    screen_writeln_clel;
    screen_write_str(3,'Vertical margins                   V =',38);
    print_margins(margin_top,margin_bottom);
    screen_write_str(0,'  --  ',6);
    print_margins(initial_margin_top,initial_margin_bottom);
    screen_writeln_clel;
    screen_write_str(3,'Tab settings                       T =',38);
    screen_writeln_clel;
    for i := 1 to scr_width do                   {### Scr_width is wrong }
      if i = margin_left       then screen_write_ch(0,'L')
      else if i = margin_right then screen_write_ch(0,'R')
      else if tab_stops[i]     then screen_write_ch(0,'T')
      else                          screen_write_ch(0,' ');
    screen_writeln;
    screen_writeln_clel;
{#if turbop}
    fillchar(buffer[1], sizeof(buffer), ' ');
    tmp_str := '  New Values: ';
    move(tmp_str[1], buffer[1], length(tmp_str));
{#else}
{##    buffer := '  New Values: ';}
{#endif}
    screen_getlinep(buffer,14,request.str,request.len,1,1);
    if request.len > 0 then
      begin
      ch_upcase_str(request.str,request.len);
      if not setparam(request) then
        screen_beep;
      end;
  until tt_controlc or (request.len = 0);
  frame_parameter := true;
  99:
  tpar_clean_object(request);
  end; {frame_parameter}

{#if vms or turbop}
end.
{#endif}
