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
{       Chris J. Barter (1987);                                        }
{       Wayne N. Agutter (1987);                                       }
{       Bevin R. Brett (1987);                                         }
{       Kevin J. Maciunas (1980-84 )                                   }
{       Jeff Blows (1989-90);                                          }
{       Kelvin B. Nicolle (1989); and                                  }
{       Martin Sandiford (2002).                                       }
{                                                                      }
{  Copyright  1987, 1989-90, 2002 University of Adelaide               }
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
! Name:         LINE
!
! Description:  Line manipulation commands.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/line.pas,v 4.7 2002/07/15 13:56:45 martin Exp $
! $Author: martin $
! $Locker:  $
! $Log: line.pas,v $
! Revision 4.7  2002/07/15 13:56:45  martin
! Fixed some memory handling issues with turbo pascal
!
! Revision 4.6  1990/09/21 12:36:14  ludwig
! Change name of IBM-PC module system to msdos (system is reserved name).
!
! Revision 4.5  90/01/18  18:01:44  ludwig
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
{##module line;}
{#elseif turbop}
unit line;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'line.fwd'}
{##%include 'ch.h'}
{##%include 'screen.h'}
{##%include 'system.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "line.h"}
{####include "ch.h"}
{####include "screen.h"}
{####include "system.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=line.h#>}
{###<$F=ch.h#>}
{###<$F=screen.h#>}
{###<$F=system.h#>}
{#elseif turbop}
interface
  uses value;
  {$I line.i}

implementation
  uses ch, screen, msdos;
{#endif}

{----------------------------------------------------------------------}

{ The Two Following routines maintain a Pool of free Lines/Groups.}
{ This should enhance the Page Fault performance by keeping all   }
{ the Lines/Groups together in clusters.                          }


{}procedure line_line_pool_extend;
    var
      new_line : line_ptr;
      i        : integer;

    begin {line_line_pool_extend}
    for i := 1 to 20 do
      begin
      new(new_line);
      new_line^.flink := free_line_pool;
      free_line_pool  := new_line;
      end;
    end; {line_line_pool_extend}


{}procedure line_group_pool_extend;
    var
      new_group : group_ptr;
      i         : integer;

    begin {line_group_pool_extend}
    for i := 1 to 20 do
      begin
      new(new_group);
      new_group^.flink := free_group_pool;
      free_group_pool  := new_group;
      end;
    end; {line_group_pool_extend}


function line_eop_create (
                inframe : frame_ptr;
        var     group   : group_ptr)
        : boolean;

  { Purpose  : Create a group containing only the EOP line.
    Inputs   : inframe: pointer to the frame to contain the new group.
    Outputs  : group: pointer to the created group.
    Bugchecks: none.
  }
  var
    new_line : line_ptr;
    new_group : group_ptr;

  begin {line_eop_create}
  line_eop_create := false;
  if free_line_pool = nil then
    line_line_pool_extend;
  new_line       := free_line_pool;
  free_line_pool := new_line^.flink;
  if free_group_pool = nil then
    line_group_pool_extend;
  new_group       := free_group_pool;
  free_group_pool := new_group^.flink;
  with new_line^ do
    begin
    flink := nil;
    blink := nil;
    group := new_group;
    offset_nr := 0;
    mark := nil;
    str := nil;
    len := 0;
    used := 0;
    scr_row_nr := 0;
    end;
  with new_group^ do
    begin
    flink := nil;
    blink := nil;
    frame := inframe;
    first_line := new_line;
    last_line := new_line;
    first_line_nr := 1;
    nr_lines := 1;
    end;
  group := new_group;
  line_eop_create := true;
  end; {line_eop_create}


function line_eop_destroy (
        var     group : group_ptr)
        : boolean;

  { Purpose  : Destroy a group containing only the EOP line.
    Inputs   : group: pointer to the group to be destroyed.
    Outputs  : group: nil.
    Bugchecks: .group_ptr is nil
               .group has forward or backward link
               .group contains non-eop lines
               .line has forward or backward link
               .line has incorrect group pointer
               .line has incorrect line number
               .line has marks
               .line is on the screen
  }
{#if debug}
  label 99;
{#endif}
  var
    this_group : group_ptr;
    eop_line : line_ptr;
{#if vms}
{##    descr : string_descriptor;}
{##    status : vms_status_code;}
{#endif}

  begin {line_eop_destroy}
  line_eop_destroy := false;
{#if debug}
  if group = nil then
    begin
    screen_message(dbg_group_ptr_is_nil);
    goto 99;
    end;
{#endif}
  this_group := group;
{#if debug}
  with this_group^ do
    begin
    if (flink <> nil) or (blink <> nil) then
      begin
      screen_message(dbg_flink_or_blink_not_nil);
      goto 99;
      end;
    if (first_line <> last_line) or (nr_lines <> 1) then
      begin
      screen_message(dbg_group_has_lines);
      goto 99;
      end;
    end;
{#endif}
  eop_line := group^.first_line;
  with eop_line^ do
    begin
{#if debug}
    if (flink <> nil) or (blink <> nil) then
      begin
      screen_message(dbg_flink_or_blink_not_nil);
      goto 99;
      end;
    if group <> this_group then
      begin
      screen_message(dbg_invalid_group_ptr);
      goto 99;
      end;
    if offset_nr <> 0 then
      begin
      screen_message(dbg_invalid_offset_nr);
      goto 99;
      end;
    if mark <> nil then
      begin
      screen_message(dbg_line_has_marks);
      goto 99;
      end;
    if scr_row_nr <> 0 then
      begin
      screen_message(dbg_line_on_screen);
      goto 99;
      end;
{#endif}
    if str <> nil then
      begin
{#if vms}
{##      descr.len := len;}
{##      descr.typ := 512; #<VMS 3.0 requires this to be correct#>}
{##      descr.str := str;}
{##      status := lib$sfree1_dd(descr);}
{#if debug}
{##      if not odd(status) then}
{##        begin}
{##        screen_message(dbg_library_routine_failure);}
{##        goto 99;}
{##        end;}
{#endif}
{#elseif unix}
{##      free(str);}
{#elseif turbop}
      freemem(str,len);
{#endif}
{#if debug}
      str := nil;
{#endif}
      end;
    end;
  eop_line^.flink   := free_line_pool;
  free_line_pool    := eop_line;
  this_group^.flink := free_group_pool;
  free_group_pool   := this_group;
  group := nil;
  line_eop_destroy := true;
{#if debug}
  99:
{#endif}
  end; {line_eop_destroy}


function lines_create (
                line_count : line_range;
        var     first_line,
                last_line  : line_ptr)
        : boolean;

  { Purpose  : Create a linked list of lines.
    Inputs   : line_count: the number of lines to create.
    Outputs  : first_line, last_line: pointers to the created lines.
    Bugchecks: None.
  }
  var
    prev_line, this_line, top_line : line_ptr;
    line_nr : line_range;

  begin {lines_create}
  lines_create := false;
  top_line := nil;
  prev_line := nil;
  this_line := nil;
  for line_nr := 1 to line_count do
    begin
    if free_line_pool = nil then
      line_line_pool_extend;
    this_line      := free_line_pool;
    free_line_pool := this_line^.flink;
    if top_line = nil then top_line := this_line;
    with this_line^ do
      begin
      flink      := nil;
      blink      := prev_line;
      group      := nil;
      offset_nr  := 0;
      mark       := nil;
      str        := nil;
      len        := 0;
      used       := 0;
      scr_row_nr := 0;
      end;
    if prev_line <> nil then
      prev_line^.flink := this_line;
    prev_line := this_line;
    end;
  first_line := top_line;
  last_line := this_line;
  lines_create := true;
  end; {lines_create}


function lines_destroy (
        var     first_line,
                last_line : line_ptr)
        : boolean;

  { Purpose  : Destroy a linked list of lines.
               The lines must have been extracted from the data structure
               before this routine is called.
    Inputs   : first_line, last_line: pointers to the lines to be destroyed.
    Outputs  : first_line, last_line: nil.
    Bugchecks: .first_line or last_line is nil
               .first_line/last_line contains back/forward link
               .back links not correct
               .line has a group pointer
               .line has a line number
               .line has marks
               .line is on the screen
               .last_line is not the last line in the linked list
  }
{#if debug}
  label 99;
{#endif}
  var
    this_line, prev_line, next_line : line_ptr;
{#if vms}
{##    descr : string_descriptor;}
{##    status : vms_status_code;}
{#endif}

  begin {lines_destroy}
  lines_destroy := false;
{#if debug}
  if (first_line = nil) or (last_line = nil) then
    begin
    screen_message(dbg_line_ptr_is_nil);
    goto 99;
    end;
  if (first_line^.blink <> nil) or (last_line^.flink <> nil) then
    begin
    screen_message(dbg_flink_or_blink_not_nil);
    goto 99;
    end;
{#endif}
  prev_line := nil;
  this_line := first_line;
  while this_line <> nil do
    begin
    with this_line^ do
      begin
{#if debug}
      if blink <> prev_line then
        begin
        screen_message(dbg_invalid_blink);
        goto 99;
        end;
      if group <> nil then
        begin
        screen_message(dbg_invalid_group_ptr);
        goto 99;
        end;
      if offset_nr <> 0 then
        begin
        screen_message(dbg_invalid_offset_nr);
        goto 99;
        end;
      if mark <> nil then
        begin
        screen_message(dbg_line_has_marks);
        goto 99;
        end;
      if scr_row_nr <> 0 then
        begin
        screen_message(dbg_line_on_screen);
        goto 99;
        end;
{#endif}
      if str <> nil then
        begin
{#if vms}
{##        descr.len := len;}
{##        descr.typ := 512; #<VMS 3.0 requires this to be correct#>}
{##        descr.str := str;}
{##        status := lib$sfree1_dd(descr);}
{#if debug}
{##        if not odd(status) then}
{##          begin}
{##          screen_message(dbg_library_routine_failure);}
{##          goto 99;}
{##          end;}
{#endif}
{#elseif unix}
{##        free(str);}
{#elseif turbop}
        freemem(str,len);
{#endif}
{#if debug}
        str := nil;
{#endif}
        end;
{#if debug}
      len := 0;
{#endif}
      end;
    prev_line := this_line;
    next_line := this_line^.flink;
    this_line := next_line;
    end;
{#if debug}
  if prev_line <> last_line then
    begin
    screen_message(dbg_last_not_at_end);
    goto 99;
    end;
{#endif}
  last_line^.flink := free_line_pool;
  free_line_pool   := first_line;
  first_line := nil;
  last_line := nil;
  lines_destroy := true;
{#if debug}
  99:
{#endif}
  end; {lines_destroy}


{}function groups_destroy (var first_group,last_group:group_ptr) : boolean;

    { Purpose  : Destroy a linked list of groups.
      Inputs   : first_group, last_group: pointers to the groups to be destroyed
      Outputs  : first_group, last_group: nil.
      Bugchecks: .first_group or last_group is nil
                 .first_group/last_group contains back/forward link
                 .back links not correct
                 .group has a frame pointer
                 .group contains lines
                 .last_group is not the last group in the linked list
    }
{#if debug}
    label 99;
    var
      this_group, prev_group, next_group : group_ptr;
{#endif}

    begin {groups_destroy}
    groups_destroy := false;
{#if debug}
    if (first_group = nil) or (last_group = nil) then
      begin
      screen_message(dbg_group_ptr_is_nil);
      goto 99;
      end;
    if (first_group^.blink <> nil) or (last_group^.flink <> nil) then
      begin
      screen_message(dbg_flink_or_blink_not_nil);
      goto 99;
      end;
    prev_group := nil;
    this_group := first_group;
    while this_group <> nil do
      begin
      with this_group^ do
        begin
        if blink <> prev_group then
          begin
          screen_message(dbg_invalid_blink);
          goto 99;
          end;
        if frame <> nil then
          begin
          screen_message(dbg_invalid_frame_ptr);
          goto 99;
          end;
        if (first_line <> nil) or (last_line <> nil) or (nr_lines <> 0) then
          begin
          screen_message(dbg_group_has_lines);
          goto 99;
          end;
        end;
      prev_group := this_group;
      next_group := this_group^.flink;
      this_group := next_group;
      end;
    if prev_group <> last_group then
      begin
      screen_message(dbg_last_not_at_end);
      goto 99;
      end;
{#endif}
    last_group^.flink := free_group_pool;
    free_group_pool   := first_group;
    first_group := nil;
    last_group := nil;
    groups_destroy := true;
{#if debug}
    99:
{#endif}
    end; {groups_destroy}


function lines_inject (
                first_line,
                last_line,
                before_line : line_ptr)
        : boolean;

  { Purpose  : Inject a linked list of lines into the data structure.
    Inputs   : first_line, last_line: pointers to the lines to be injected.
             : before_line: pointer to the line before which the lines are to
               be injected.
    Outputs  : none.
    Bugchecks: .first_line, last_line or before_line is nil
               .first_line/last_line contains back/forward link
               .back links not correct
               .line has a group pointer
               .line has a line number
               .line has marks
               .line is on the screen
               .last_line is not the last line in the linked list
  }
{#if debug}
  label 99;
{#endif}
  var
    this_line, prev_line, top_line, adjust_line,
       end_group_last_line, next_group_first_line : line_ptr;
    nr_new_lines, nr_free_lines_top, nr_free_lines_end, nr_free_lines,
       line_nr, nr_lines_to_adjust, nr_lines_to_adjust_here : line_range;
    offset : group_line_range;
    nr_new_groups, group_nr : integer;
    top_group, end_group, first_group, last_group,
       adjust_group, this_group : group_ptr;
    this_frame : frame_ptr;
    space : space_range;

  begin {lines_inject}
  lines_inject := false;

  { Scan be lines to inserted, counting lines and checking space used. }
{#if debug}
  if (first_line = nil) or (last_line = nil) or (before_line = nil) then
    begin
    screen_message(dbg_line_ptr_is_nil);
    goto 99;
    end;
  if (first_line^.blink <> nil) or (last_line^.flink <> nil) then
    begin
    screen_message(dbg_flink_or_blink_not_nil);
    goto 99;
    end;
{#endif}
  nr_new_lines := 0;
  space := 0;
{#if debug}
  prev_line := nil;
{#endif}
  this_line := first_line;
  while this_line <> nil do
    begin
    with this_line^ do
      begin
{#if debug}
      if blink <> prev_line then
        begin
        screen_message(dbg_invalid_blink);
        goto 99;
        end;
      if group <> nil then
        begin
        screen_message(dbg_invalid_group_ptr);
        goto 99;
        end;
      if offset_nr <> 0 then
        begin
        screen_message(dbg_invalid_offset_nr);
        goto 99;
        end;
      if mark <> nil then
        begin
        screen_message(dbg_line_has_marks);
        goto 99;
        end;
      if scr_row_nr <> 0 then
        begin
        screen_message(dbg_line_on_screen);
        goto 99;
        end;
{#endif}
      space := space + len;
      end;
    nr_new_lines := nr_new_lines + 1;
{#if debug}
    prev_line := this_line;
{#endif}
    this_line := this_line^.flink;
    end;
{#if debug}
  if prev_line <> last_line then
    begin
    screen_message(dbg_last_not_at_end);
    goto 99;
    end;
{#endif}

  { Define some useful pointers }
  {                     +-------------+   +-------------+
                        | top_group   |   | top_line    |
                        +-------------+   +-------------+
                            |     ^           |     ^
  insert groups here ===>   |     |           |     |   <=== insert lines here
                            v     |           v     |
      +-------------+   +-------------+   +-------------+
      | this_frame  |<--| end_group   |<--| before_line |
      +-------------+   +-------------+   +-------------+
  }
  top_line := before_line^.blink;   { can be nil }
  end_group := before_line^.group;
  top_group := end_group^.blink;   {can be nil}
  this_frame := end_group^.frame;

  { Determine number of free lines available in end_group and top_group. }
  nr_free_lines_end := max_grouplines - end_group^.nr_lines;
  if top_group <> nil then
    nr_free_lines_top := max_grouplines - top_group^.nr_lines
  else
    nr_free_lines_top := 0;
  nr_free_lines := nr_free_lines_end + nr_free_lines_top;
  line_nr := end_group^.first_line_nr;

  { If insufficient free lines are available, insert some new groups. }
  if nr_new_lines > nr_free_lines then
    begin
    { Create a chain of new groups. }
    nr_new_groups := (nr_new_lines - nr_free_lines - 1) div
                                                   max_grouplines + 1;
    first_group := nil;
    last_group := nil;
    for group_nr := 1 to nr_new_groups do
      begin
      if free_group_pool = nil then
        line_group_pool_extend;
      this_group      := free_group_pool;
      free_group_pool := this_group^.flink;
      if first_group = nil then first_group := this_group;
      with this_group^ do
        begin
        flink := nil;
        blink := last_group;
        frame := this_frame;
        first_line := nil;
        last_line := nil;
        first_line_nr := line_nr;
        nr_lines := 0;
        end;
      if last_group <> nil then
        last_group^.flink := this_group;
      last_group := this_group;
      end;

{ *** No more failure points follow.                                         }
{ *** Can now start putting the new stuff into the data structure.           }

    { Link new groups into data structure between top_group and end_group. }
    last_group^.flink := end_group;
    end_group^.blink := last_group;
    if top_group <> nil then
      begin
      top_group^.flink := first_group;
      adjust_group := top_group;
      end
    else
      begin
      this_frame^.first_group := first_group;
      adjust_group := first_group;
      end;
    first_group^.blink := top_group;
    end
  else
  if nr_new_lines > nr_free_lines_end then
    adjust_group := top_group
  else
    adjust_group := end_group;

  { Insert lines into data structure between top_line and before_line. }
  last_line^.flink := before_line;
  before_line^.blink := last_line;
  if before_line^.offset_nr = 0 then
    end_group^.first_line := first_line;
  if top_line <> nil then
    top_line^.flink := first_line;
  first_line^.blink := top_line;

  { Now put the data structure back together. }
  nr_lines_to_adjust := nr_new_lines;
  if nr_new_lines > nr_free_lines_end then
    begin
    adjust_line := end_group^.first_line;
    nr_lines_to_adjust := nr_lines_to_adjust + before_line^.offset_nr;
    end_group^.nr_lines := 0;
    end
  else
    begin
    adjust_line := first_line;
    end_group^.nr_lines := before_line^.offset_nr;
    end;
  end_group_last_line := end_group^.last_line;

  while nr_lines_to_adjust > 0 do
    with adjust_group^ do
      begin
      nr_lines_to_adjust_here := max_grouplines - nr_lines;
      if nr_lines_to_adjust_here > nr_lines_to_adjust then
        nr_lines_to_adjust_here := nr_lines_to_adjust;
      if nr_lines = 0 then
        begin
        first_line := adjust_line;
        first_line_nr := line_nr;
        end;
      for offset := nr_lines to nr_lines + nr_lines_to_adjust_here - 1 do
        begin
        with adjust_line^ do
          begin
          group := adjust_group;
          offset_nr := offset;
          adjust_line := flink;
          end;
        end;
      last_line := adjust_line^.blink;
      nr_lines := nr_lines + nr_lines_to_adjust_here;
      line_nr := first_line_nr + nr_lines;
      nr_lines_to_adjust := nr_lines_to_adjust - nr_lines_to_adjust_here;
      adjust_group := flink;
      end;
{#if debug}
  if adjust_line <> before_line then
    begin
    screen_message(dbg_internal_logic_error);
    goto 99;
    end;
{#endif}
  next_group_first_line := end_group_last_line^.flink;
  offset := end_group^.nr_lines;
  repeat
    with adjust_line^ do
      begin
      offset_nr := offset;
      offset := offset + 1;
      adjust_line := flink;
      end;
  until adjust_line = next_group_first_line;
  with end_group^ do
    begin
    last_line := end_group_last_line;
    if adjust_group = end_group then
      begin
      first_line_nr := line_nr;
      first_line := before_line;
      end;
    nr_lines := offset;
    end;
  adjust_group := end_group^.flink;
  while adjust_group <> nil do
    with adjust_group^ do
      begin
      first_line_nr := first_line_nr + nr_new_lines;
      adjust_group := flink;
      end;

  this_frame^.space_left := this_frame^.space_left - space;

  { Update the screen. }
  if  (before_line^.scr_row_nr <> 0)
  and (before_line <> scr_top_line )
  then
    screen_lines_inject(first_line,nr_new_lines,before_line);

  lines_inject := true;
{#if debug}
  99:
{#endif}
  end; {lines_inject}


function lines_extract (
                first_line,
                last_line : line_ptr)
        : boolean;

  { Purpose  : Extract lines from the data structure.
    Inputs   : first_line, last_line: pointers to the lines to be extracted.
    Outputs  : none.
    Bugchecks: .first_line or last_line is nil
               .last_line is eop line
               .first and last lines in different frames
               .first_line > last_line
               .line has marks
  }
  label 1, 99;
  var
    top_line, end_line, this_line, first_scr_line, last_scr_line : line_ptr;
    first_line_nr, line_nr : line_range;
    nr_lines_to_remove : integer;
    first_group, last_group, top_group, end_group, this_group : group_ptr;
    this_frame : frame_ptr;
    first_line_offset_nr, offset : line_offset_range;
    space : space_range;

  begin {lines_extract}
  lines_extract := false;
{#if debug}
  if (first_line = nil) or (last_line = nil) then
    begin
    screen_message(dbg_line_ptr_is_nil);
    goto 99;
    end;
  if last_line^.flink = nil then
    begin
    screen_message(dbg_line_is_eop);
    goto 99;
    end;
  if first_line^.group^.frame <> last_line^.group^.frame then
    begin
    screen_message(dbg_lines_from_diff_frames);
    goto 99;
    end;
  if first_line^.group^.first_line_nr + first_line^.offset_nr >
       last_line^.group^.first_line_nr + last_line^.offset_nr then
    begin
    screen_message(dbg_first_follows_last);
    goto 99;
    end;
{#endif}

  { Define some useful pointers }
  {                     +-------------+   +-------------+
                        | top_group   |<--| top_line    |
                        +-------------+   +-------------+
                                              |     ^
                                              v     |
    n.b. the group      +-------------+   +-------------+    )
    pointers may not    | first_group |<--| first_line  |    )
    be distinct         +-------------+   +-------------+    )
                                                ...          ) To be removed
                        +-------------+   +-------------+    )
                        | last_group  |<--| last_line   |    )
                        +-------------+   +-------------+    )
                                              |     ^
                                              v     |
      +-------------+   +-------------+   +-------------+
      | this_frame  |<--| end_group   |<--| end_line    |
      +-------------+   +-------------+   +-------------+
  }
  top_line := first_line^.blink;   { can be nil }
  end_line := last_line^.flink;
  { The following group pointers may not be distinct. }
  first_group := first_line^.group;
  last_group := last_line^.group;
  if top_line <> nil then
    top_group := top_line^.group
  else
    top_group := nil;
  end_group := end_line^.group;
  this_frame := end_group^.frame;

  first_line_offset_nr := first_line^.offset_nr;
  first_line_nr := first_group^.first_line_nr + first_line_offset_nr;
  nr_lines_to_remove :=
        last_group^.first_line_nr + last_line^.offset_nr - first_line_nr + 1;
{#if debug}

  { Check that there are no marks on the lines to be removed. }
  this_line := first_line;
  for line_nr := 1 to nr_lines_to_remove do
    with this_line^ do
      begin
      if mark <> nil then
        begin
        screen_message(dbg_line_has_marks);
        goto 99;
        end;
      this_line := flink;
      end;
  if this_line <> last_line^.flink then
    begin
    screen_message(dbg_internal_logic_error);
    goto 99;
    end;
{#endif}

  if this_frame = scr_frame then
    begin
    if first_line^.scr_row_nr <> 0 then
      first_scr_line := first_line
    else
      with scr_top_line^ do
        if first_line_nr < group^.first_line_nr + offset_nr then
          first_scr_line := scr_top_line
        else goto 1;
    if last_line^.scr_row_nr <> 0 then
      last_scr_line := last_line
    else
      with scr_bot_line^ do
        if last_line^.group^.first_line_nr + last_line^.offset_nr >
                      group^.first_line_nr + offset_nr then
          last_scr_line := scr_bot_line
        else goto 1;
    screen_lines_extract(first_scr_line,last_scr_line);
 1: end;

  { Unlink the lines. }
  if top_line <> nil then
    top_line^.flink := end_line;
  first_line^.blink := nil;
  last_line^.flink := nil;
  end_line^.blink := top_line;

  { Determine the space being released by removing these lines }
{#if debug}
  {   and clear their group pointers. }
{#endif}
  space := 0;
  this_line := first_line;
  for line_nr := 1 to nr_lines_to_remove do
    begin
    with this_line^ do
      begin
      space := space + len;
{#if debug}
      group := nil;
      offset_nr := 0;
{#endif}
      this_line := flink;
      end;
    end;
  this_frame^.space_left := this_frame^.space_left + space;

  { Adjust top_group and end_group. }
  if top_group <> end_group then
    begin
    if top_group <> nil then
      top_group^.last_line := top_line;
    end_group^.first_line := end_line;
    end_group^.first_line_nr := first_line_nr;
    end;

  { Adjust groups below end_group. }
  this_group := end_group^.flink;
  while this_group <> nil do
    with this_group^ do
      begin
      first_line_nr := first_line_nr - nr_lines_to_remove;
      this_group := flink;
      end;

  { Adjust first_group..last_group for removed lines. }
  if first_group = top_group then
    begin
    nr_lines_to_remove := nr_lines_to_remove -
        (first_group^.nr_lines - first_line_offset_nr);
    first_group^.nr_lines := first_line_offset_nr;
    if first_group <> last_group then
      first_group := first_group^.flink;
    end;
  this_group := first_group;
  while nr_lines_to_remove > 0 do
    with this_group^ do
      begin
      nr_lines_to_remove := nr_lines_to_remove - nr_lines;
      nr_lines := 0;
{#if debug}
      if nr_lines_to_remove >= 0 then
        begin
        frame := nil;
        first_line := nil;
        last_line := nil;
        first_line_nr := 0;
        end;
{#endif}
      this_group := flink;
      end;

  { Adjust end_group for remaining lines. }
  if nr_lines_to_remove < 0 then
    begin
    if top_group = end_group then
      begin
      offset := first_line_offset_nr;
      end_group^.nr_lines := offset - nr_lines_to_remove;
      end
    else
      begin
      offset := 0;
      end_group^.nr_lines := -nr_lines_to_remove;
      end;
    this_line := end_line;
    for offset := offset to end_group^.nr_lines - 1 do
      with this_line^ do
        begin
        offset_nr := offset;
        this_line := flink;
        end;
    end;

  { Dispose of empty groups. }
  if first_group^.nr_lines = 0 then
    begin
    last_group := first_group;
    end_group := last_group^.flink;
    while end_group^.nr_lines = 0 do
      begin
      last_group := end_group;
      end_group := end_group^.flink;
      end;
    top_group := first_group^.blink;   { can be nil }
    if top_group <> nil then
      top_group^.flink := end_group
    else
      this_frame^.first_group := end_group;
    first_group^.blink := nil;
    last_group^.flink := nil;
    end_group^.blink := top_group;
    if not groups_destroy(first_group,last_group) then
      goto 99;
    end;
  lines_extract := true;
  99:
  end; {lines_extract}


function line_change_length (
                line       : line_ptr;
                new_length : strlen_range)
        : boolean;

  { Purpose  : Change the length of the allocated text of a line.
    Inputs   : line: pointer to the line to be adjusted.
               new_length: the new length of the text.
    Outputs  : none.
    Bugchecks: .line is nil
  }
  label 99;
  var
    new_str : str_ptr;
{#if vms}
{##    descr : string_descriptor;}
{##    status  : vms_status_code;}
{#endif}

  begin {line_change_length}
  line_change_length := false;
{#if debug}
  if line = nil then
    begin
    screen_message(dbg_line_ptr_is_nil);
    goto 99;
    end;
{#endif}
{#if vms}
{##  descr.typ := 512;}
{#endif}
  with line^ do
    begin
    if new_length > 0 then
      begin
      { Quantize the length to get some slack..}
      if new_length < max_strlen - 10 then
        new_length := (new_length div 10 + 1) * 10
      else
        new_length := max_strlen;
      { Create a new str_object and copy the text from the old one. }
{#if vms}
{##      descr.len := 0;}
{##      descr.str := nil;}
{##      status := lib$sget1_dd(new_length,descr);}
{##      if not odd(status) then}
{##        begin}
{##        screen_message(msg_exceeded_dynamic_memory);}
{##        goto 99;}
{##        end;}
{##      new_str := descr.str;}
{#elseif unix}
{##      new_str := malloc(new_length);}
{##      if new_str = nil then}
{##        begin}
{##        screen_message(msg_exceeded_dynamic_memory);}
{##        goto 99;}
{##        end;}
{#elseif turbop}
      getmem(new_str, new_length);
      if new_str = nil then
        begin
        screen_message(msg_exceeded_dynamic_memory);
        goto 99;
        end;
{#endif}
      ch_copy(str^,1,len,new_str^,1,new_length,' ');
      end
    else
      new_str := nil;
    { Dispose the old str_object. }
    if str <> nil then
      begin
{#if vms}
{##      descr.len := len;}
{##      descr.str := str;}
{##      status := lib$sfree1_dd(descr);}
{#if debug}
{##      if not odd(status) then}
{##        begin}
{##        screen_message(dbg_library_routine_failure);}
{##        goto 99;}
{##        end;}
{#endif}
{#elseif unix}
{##      free(str);}
{#elseif turbop}
      freemem(str,len);
{#endif}
      end;
    { Update the amount of free space available in the frame. }
    if group <> nil then
      with group^.frame^ do
        space_left := space_left + len - new_length;

    { Change line to refer to the new str_object. }
    str   := new_str;
    len   := new_length;
    used  := ch_length(str^,len);
    end;
  line_change_length := true;
  99:
  end; {line_change_length}


function line_to_number (
                line   : line_ptr;
        var     number : line_range)
        : boolean;

  { Purpose  : Determine the line number of a given line.
    Inputs   : line: the line whose number is to be determined.
    Outputs  : number: the line number.
    Bugchecks: .line is nil
  }
{#if debug}
  label 99;
{#endif}

  begin {line_to_number}
  line_to_number := false;
{#if debug}
  if line = nil then
    begin
    screen_message(dbg_line_ptr_is_nil);
    goto 99;
    end;
{#endif}
  number := line^.group^.first_line_nr + line^.offset_nr;
  line_to_number := true;
{#if debug}
  99:
{#endif}
  end; {line_to_number}


function line_from_number (
                frame  : frame_ptr;
                number : line_range;
        var     line   : line_ptr)
        : boolean;

  { Purpose  : Find the line with a given line number in a given frame.
    Inputs   : frame: the frame to search.
               number: the line number to search for.
    Outputs  : line: a pointer to the found line, or nil.
    Bugchecks: .frame pointer is nil
               .line pointer is nil
  }
{#if debug}
  label 99;
{#endif}
  var
    this_group : group_ptr;
    this_line : line_ptr;
    line_nr : line_range;

  begin {line_from_number}
  line_from_number := false;
{#if debug}
  if frame = nil then
    begin
    screen_message(dbg_frame_ptr_is_nil);
    goto 99;
    end;
  if number <= 0 then
    begin
    screen_message(dbg_invalid_line_nr);
    goto 99;
    end;
{#endif}
  this_group := frame^.last_group;
  if number >= this_group^.first_line_nr + this_group^.nr_lines then
    line := nil
  else
    begin
    while this_group^.first_line_nr > number do
      this_group := this_group^.blink;
    this_line := this_group^.first_line;
    for line_nr := 1 to number - this_group^.first_line_nr do
      this_line := this_line^.flink;
    line := this_line;
    end;
  line_from_number := true;
{#if debug}
  99:
{#endif}
  end; {line_from_number}

{#if vms or turbop}
end.
{#endif}
