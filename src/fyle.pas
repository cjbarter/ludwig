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
{       Jeff Blows (1989);                                             }
{       Kelvin B. Nicolle (1989-90); and                               }
{       Martin Sandiford (2002).                                       }
{                                                                      }
{  Copyright  1979-81, 1987, 1989-90, 2002 University of Adelaide      }
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
! Name:         FYLE
!
! Description:  Open/Create, Read/Write, Close/Delete Input/Output
!               files.
!
! $Header: /home/martin/src/ludwig/current/fpc2/../RCS/fyle.pas,v 4.11 2002/07/20 16:24:16 martin Exp $
! $Author: martin $
! $Locker:  $
! $Log: fyle.pas,v $
! Revision 4.11  2002/07/20 16:24:16  martin
! Changed some conditionals to msdos from turbop to allow use
! for fpc compilation.
!
! Revision 4.10  1990/11/21 16:41:58  ludwig
! In the IBM-PC version, disable the File Save command until the code in
!   the filesys module is fixed.    KBN
!
! Revision 4.9  90/10/24  15:08:17  ludwig
! Fix call to filesys_close.   KBN
!
! Revision 4.8  90/05/30  14:16:52  ludwig
! Fix a bug in the File Save command.
! Saving an empty frame produced a segmentation fault.
!
! Revision 4.7  90/02/28  12:07:45  ludwig
! Implement the File Save command.
!
! Revision 4.6  90/01/18  18:08:13  ludwig
! Entered into RCS at revision level 4.6
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
!       Change the module name from files to fyle.
!       Remove the superfluous include of system.h.
! 4-006 Kelvin B. Nicolle                                    17-Jan-1990
!       Add code to implement the File Save command.
!--}

{#if vms}
{##[ident('4-008'),}
{## overlaid]}
{##module fyle;}
{###< This should have been file, to be consistant, but file is a reserved word #>}
{#elseif turbop}
unit fyle;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'fyle.fwd'}
{##%include 'ch.h'}
{##%include 'exec.h'}
{##%include 'filesys.h'}
{##%include 'line.h'}
{##%include 'mark.h'}
{##%include 'screen.h'}
{##%include 'tpar.h'}
{##%include 'vdu.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "fyle.h"}
{####include "ch.h"}
{####include "exec.h"}
{####include "filesys.h"}
{####include "line.h"}
{####include "mark.h"}
{####include "screen.h"}
{####include "tpar.h"}
{####include "vdu.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=fyle.h#>}
{###<$F=ch.h#>}
{###<$F=exec.h#>}
{###<$F=filesys.h#>}
{###<$F=line.h#>}
{###<$F=mark.h#>}
{###<$F=screen.h#>}
{###<$F=tpar.h#>}
{###<$F=vdu.h#>}
{#elseif turbop}
interface
  uses value;
  {$I fyle.i}

implementation
  uses ch, exec, filesys, line, mark, screen, tpar, vdu;
{#endif}


procedure file_name (
                fp      : file_ptr;
                max_len : integer;
        var     act_fnm : file_name_str;
        var     act_len : integer);

  { Return a file's name, in the specified width. }
  var
    head_len       ,
    tail_len       : 0..file_name_len;
    i              : 1..file_name_len;

  begin {file_name}
  with fp^ do
    begin
    if fns <= max_len then
      begin
      head_len := fns;
      tail_len := 0;
      end
    else
      begin { Cut chars out the middle of the file name, insert '---' };
      tail_len := (max_len-3) div 2;
      head_len := max_len-3-tail_len;
      end;
    for i := 1 to head_len do act_fnm[i] := fnm[i];
    if tail_len > 0 then
      begin
      for i := 1 to 3 do
        begin
        head_len := head_len+1;
        act_fnm[head_len] := '-';
        end;
      for i := fns-tail_len+1 to fns do
        begin
        head_len := head_len+1;
        act_fnm[head_len] := fnm[i];
        end;
      end;
    act_len := head_len;
    end; {with}
  end; {file_name}


procedure file_table{};

  { List the current files. }
  var
    file_slot      : file_range;
    frame_name     : name_str;
    len            : integer;
    compressed_fnm : file_name_str;
    room           : integer;
    file_len       : integer;

  begin {file_table}
  screen_unload;
  screen_home(false);
  screen_write_str(0,'Usage   Mod Frame  Filename',27);
  screen_writeln;
  screen_write_str(0,'------- --- ------ --------',27);
  screen_writeln;
  screen_writeln;
  for file_slot := 1 to max_files do
  if files[file_slot] <> nil then
    begin
    if files_frames[file_slot] <> nil then
      begin
      frame_name := files_frames[file_slot]^.span^.name;
      len := name_len;
      while (len > 6) and (frame_name[len] = ' ') do
        len := len-1;
      end
    else
      begin
      frame_name := '                               ';
      len := 6;
      end;

    if files_frames[file_slot] <> nil then
      begin
      if files[file_slot]^.output_flag then screen_write_str(0,'FO ',3)
      else                                  screen_write_str(0,'FI ',3);
      end
    else
      if file_slot = fgi_file            then screen_write_str(0,'FGI',3) else
      if file_slot = fgo_file            then screen_write_str(0,'FGO',3) else
      if files[file_slot]^.output_flag   then screen_write_str(0,'FFO',3)
      else                                    screen_write_str(0,'FFI',3);

    if files[file_slot]^.eof           then screen_write_str(1,'EOF',3)
    else                                    screen_write_str(1,'   ',3);

    if files_frames[file_slot] <> nil then
      if files_frames[file_slot]^.text_modified then
        screen_write_str(1,' * ',3)
      else
        screen_write_str(1,'   ',3)
    else
      screen_write_str(1,'   ',3);

    screen_write_name_str(1,frame_name,len);
    if len > 6 then
      begin
      screen_writeln;
      screen_write_str(0,'                  ',18);
      end;

    if ludwig_mode = ludwig_screen then
      room := terminal_info.width-18-1
    else
      room := file_name_len;
    file_name(files[file_slot],room,compressed_fnm,file_len);
    screen_write_file_name_str(1,compressed_fnm,file_len);
    screen_writeln;
    end;
  screen_pause;
  end; {file_table}


procedure file_fix_eop (
                eof      : boolean;
                eop_line : line_ptr);

  begin {file_fix_eop}
  with eop_line^ do
    begin
    if eof then
      begin
      str^[ 1] := '<';
      str^[ 2] := 'E'; str^[ 3] := 'n'; str^[ 4] := 'd';
      str^[ 5] := ' ';
      str^[ 6] := 'o'; str^[ 7] := 'f';
      str^[ 8] := ' ';
      str^[ 9] := 'F'; str^[10] := 'i'; str^[11] := 'l'; str^[12] := 'e';
      str^[13] := '>'; str^[14] := ' '; str^[15] := ' ';
      end
    else
      begin
      str^[ 1] := '<';
      str^[ 2] := 'P'; str^[ 3] := 'a'; str^[ 4] := 'g'; str^[ 5] := 'e';
      str^[ 6] := ' ';
      str^[ 7] := 'B'; str^[ 8] := 'o'; str^[ 9] := 'u'; str^[10] := 'n';
      str^[11] := 'd'; str^[12] := 'a'; str^[13] := 'r'; str^[14] := 'y';
      str^[15] := '>';
      end;
    if scr_row_nr <> 0 then screen_draw_line(eop_line);
    end;
  end; {file_fix_eop}


function file_create_open (
                fn       : file_name_str;
                parse    : parse_type;
        var     inputfp  : file_ptr;
        var     outputfp : file_ptr)
        : boolean;

  { Parse fn and create I/O streams to files. }

  label
    99;

  begin {file_create_open}
  file_create_open := false;
  if parse in [parse_command,parse_input,parse_edit,parse_stdin,parse_execute] then
    begin
    if inputfp <> nil then
      begin
      screen_message(msg_file_already_in_use);
      goto 99;
      end;
    new(inputfp);
    with inputfp^ do
      begin
      valid       := false;
      first_line  := nil;
      last_line   := nil;
      line_count  := 0;
      output_flag := false;
{#if vms}
{##      with buf_dsc do}
{##        begin}
{##        typ := 512;}
{##        len := 0;}
{##        str := nil;}
{##        end;}
{##      dns := 0;}
{#elseif turbop}
      eof := false;
      idx := max_strlen;        {make sure we read something}
      len := 0;
{#endif}
      zed         := 'Z';
      end;
    end;
  if parse in [parse_command,parse_output,parse_edit] then
    begin
    if outputfp <> nil then
      begin
      screen_message(msg_file_already_in_use);
      goto 99;
      end;
    new(outputfp);
    with outputfp^ do
      begin
      valid       := false;
      first_line  := nil;
      last_line   := nil;
      line_count  := 0;
      output_flag := true;
{#if vms}
{##      with buf_dsc do}
{##        begin}
{##        typ := 512;}
{##        len := 0;}
{##        str := nil;}
{##        end;}
{##      dns := 0;}
{#elseif msdos}
{##      memory_size := 0;}
{##      tns := 0;}
{#endif}
      zed         := 'Z';
      end;
    end;
  if filesys_parse(fn,parse,file_data,inputfp,outputfp) then
    file_create_open := true;
  if inputfp <> nil then
    if not inputfp^.valid then
      begin
      dispose(inputfp);
      inputfp := nil;
      end;
  if outputfp <> nil then
    if not outputfp^.valid then
      begin
      dispose(outputfp);
      outputfp := nil;
      end;
99:
  end; {file_create_open}


function file_close_delete (
        var     fp     : file_ptr;
                delete : boolean;
                msgs   : boolean)
        : boolean;

  { Close a file, if it is an output file it can optionally be deleted. }

  begin {file_close_delete}
  file_close_delete := false;
  if fp<>nil then
    begin
    if filesys_close(fp, ord(delete), msgs) then
      begin
      with fp^ do
        begin
        if first_line<>nil then       {Dispose of any unused input lines.}
          if lines_destroy(first_line,last_line) then;    {Ignore errors.}
        end;
      dispose(fp);
      fp := nil;
      file_close_delete := true;
      end;
    end;
  end; {file_close_delete}


function file_read (
                fp         : file_ptr;
                count      : line_range;
                best_try   : boolean;
        var     first,last : line_ptr;
        var     actual_cnt : integer)
        : boolean;

  { Read a series of lines from input file. }
  label
    99;
  var
    line,
    line_2 : line_ptr;
    outlen : strlen_range;
    buffer : str_object;
    i      : line_range;

  begin {file_read}
  file_read := false;
  with fp^ do
    begin

    { Try to read the lines. }

    if output_flag then
      begin screen_message(msg_not_input_file); goto 99; end;
    while (count>line_count) and (not eof) do
      begin

      {Try to read another line.}

      if filesys_read(fp,buffer,outlen) then
        begin
        outlen := ch_length(buffer,outlen);
        if not lines_create(1,line,line_2) then goto 99;
        if not line_change_length(line,outlen) then
          begin
          if lines_destroy(line,line_2) then;
          goto 99;
          end;
        ch_copy(buffer,1,outlen,line^.str^,1,line^.len,' ');
        line^.used  := outlen;
        line^.blink := last_line;
        if last_line <> nil then
          last_line^.flink := line
        else
          first_line := line;
        last_line  := line;
        line_count := line_count+1;
        end
      else
      if not eof then
        begin {Something drastically wrong with the input!}
              {As a TEMPORARY measure, ignore.}
        end;
      end;

    {Check there is enough lines.}

    if line_count<count then
      begin
      if not best_try then
        begin screen_message(msg_not_enough_input_left); goto 99; end;
      count := line_count;
      end;

    {Break off the required lines.}

    actual_cnt := count;
    if count = 0 then
      begin
      first := nil;
      last  := nil;
      end
    else
    if line_count=count then
      begin

      {Give caller the whole list.}

      first      := first_line;
      last       := last_line;
      first_line := nil;
      last_line  := nil;
      line_count := 0;
      end
    else
      begin

      {Give caller the first 'count' lines in the list.}
      {Find last line to be removed.}

      if count<line_count/2 then
        begin
        line  := first_line;
        for i := 2 to count do line := line^.flink;
        end
      else
        begin
        line  := last_line;
        for i := line_count downto count+1 do line := line^.blink;
        end;

      {Remove lines from list.}

      first := first_line;
      last  := line;
      first_line        := line^.flink;
      line^.flink       := nil;
      first_line^.blink := nil;
      line_count := line_count-count;
      end;

    {Note we succeeded.}

    file_read := true;
    end;
99:
  end; {file_read}


function file_write (
                first_line,
                last_line : line_ptr;
                fp        : file_ptr)
        : boolean;

  { Write a series of lines to an output file.                   }
  { Stop when the last line output or when the next line is NIL. }
  label 99;

  begin {file_write}
  file_write := false;

  { Allow first_line=nil as a termination condition so that    }
  { this routine can be used in an emergency to save an edit   }
  { session after drastic internal corruption has happened.    }

  while first_line<>nil do
    begin
    with first_line^ do
      begin
      if not filesys_write(fp,str^,used) then goto 99;
      if first_line = last_line then
        begin
        file_write := true;
        goto 99;
        end;
      first_line := flink;
      end;
    end;
  file_write := true;
99:
  end; {file_write}


function file_windthru (
                current   : frame_ptr;
                from_span : boolean)
        : boolean;

  { Write all the remaining input file to the output file. }

  label
    98,99;

  var
    outlen    : strlen_range;
    buffer    : str_object;
    first_line,
    last_line : line_ptr;

  begin {file_windthru}
  with current^ do
    begin
    file_windthru := false;
    { Check that there is something to windthru to! }
    if output_file = 0 then
      goto 99;
    if files[output_file] = nil then
      goto 99;
    if text_modified and not from_span then
      begin
      screen_message(msg_writing_file);
      if ludwig_mode = ludwig_screen then
        vdu_flush(false);
      end;
    { Do any lines that have already been read in.}
    first_line := first_group^.first_line;
    last_line := last_group^.last_line^.blink;
    if (first_line <> nil) and (last_line <> nil) then
      begin
      if text_modified then
        if not file_write(first_line,last_line,files[output_file]) then goto 98;
      if not marks_squeeze(first_line,1,last_line^.flink,1) then goto 98;
      if not lines_extract(first_line,last_line) then goto 98;
      if not lines_destroy(first_line,last_line) then goto 98;
      if input_file <> 0 then
        if files[input_file] <> nil then
          files[input_file]^.line_count := 0;
      end;
    { So far so good, assume the rest is going to work }
    file_windthru := true;
    if text_modified then { Only bother if we are going to keep the output }
      begin
      if input_file <> 0 then
        if files[input_file] <> nil then
          if not files[input_file]^.eof then
            begin
            { Copy the file through until eof found.}
            while filesys_read(files[input_file],buffer,outlen) do
              if not filesys_write(files[output_file],
                                   buffer,
                                   ch_length(buffer,outlen)) then
                begin
                { Whoops, something went wrong }
                file_windthru := false;
                goto 98;
                end;
            { Status depends on if we successfully read it all }
            file_windthru := files[input_file]^.eof;
            end;
      end;
98:
    if text_modified and not from_span then
      screen_clear_msgs(false);
    end;
99:
  end; {file_windthru}


function file_rewind (
        var     fp : file_ptr)
        : boolean;

  { Rewind a file. }

  begin {file_rewind}
  file_rewind := false;
  if fp<>nil then
    begin
    with fp^ do
      begin
      if first_line<>nil then         {Dispose of any unused input lines.}
        begin
        if lines_destroy(first_line,last_line) then;    {Ignore errors.}
        first_line := nil;
        last_line  := nil;
        line_count := 0;
        end;
      end;
    if filesys_rewind(fp) then ;      {Ignore failures due to unable to }
    file_rewind := true;              {rewind SYS$INPUT, TT:, NL:, etc. }
    end;
  end; {file_rewind}


function file_page (
                current_frame : frame_ptr;
        var     exit_abort    : boolean)
        : boolean;

  label
    98,99;

  var
    i              : integer;
    first_line,
    last_line      : line_ptr;

  begin {file_page}
  file_page := false;
  with current_frame^,dot^ do
    begin
    if not exec_compute_line_range(current_frame,nindef,0,first_line,last_line) then
      begin
      screen_message(dbg_internal_logic_error);
      goto 99;
      end;
    {  PAGE OUT THE STUFF ABOVE THE DOT LINE. }
    if (first_line <> nil) then
      begin
      if output_file <> 0 then
        if not file_write(first_line,last_line,files[output_file]) then
          begin
          { SHOULD EXIT_ABORT, NOT JUST FAIL. }
          exit_abort := true;
          goto 99;
          end;
      if last_line^.flink = nil then goto 99;
      if not marks_squeeze(first_line,1,last_line^.flink,1) then goto 99;
      if not lines_extract(first_line,last_line) then goto 99;
      if not lines_destroy(first_line,last_line) then goto 99;
      end;
    {  PAGE IN THE NEW LINES  }
    if input_file = 0 then goto 98;
    while (space_left*10 > space_limit) and (not tt_controlc) do
      begin
      if not file_read(files[input_file],
                       50,        { READ # LINES AT A TIME.              }
                       true,      { DOESN'T MATTER IF CAN'T GET THEM ALL.}
                       first_line,{ FIRST LINE READ IN }
                       last_line, { LAST  LINE READ IN }
                       i)         { ACTUAL_COUNT       }
      then goto 99;

      input_count := input_count+i;

      { Inject the inputted lines. }
      if first_line = nil then goto 98;
      if not lines_inject(first_line,last_line,last_group^.last_line)
      then goto 99;

      { IF DOT WAS ON THE NULL LINE,  SHIFT IT ONTO THE FIRST LINE }
      if line^.flink = nil then
        begin
        if not mark_create(first_line,col,dot) then goto 99;
        end;
      end;
98:
    if input_file <> 0 then
      file_fix_eop(files[input_file]^.eof,last_group^.last_line);
    file_page := true;
    end;
99:
  end; {file_page}


function file_command (
                command   : commands;
                rept      : leadparam;
                count     : integer;
                tparam    : tpar_ptr;
                from_span : boolean)
        : boolean;

  label 99;
  var
    first,last    : line_ptr;
    lines_to_read : integer;
    lines_written : integer;
    status        : msg_str;
    saved_cmd     : commands;
    file_slot     : slot_range;
    file_slot_2   : slot_range;
    fnm           : file_name_str;
    i             : integer;
    dummy_fptr    : file_ptr;
    nr_lines      : line_range;

  function check_slot_allocation (
                  slot              : slot_range;
                  must_be_allocated : boolean)
          : boolean;

    begin {check_slot_allocation}
    if (slot = 0) = (must_be_allocated) then
      begin
      if must_be_allocated then
        status := msg_no_file_open
      else
        status := msg_file_already_open;
      check_slot_allocation := false;
      end
    else
      check_slot_allocation := true;
    end; {check_slot_allocation}

  function check_slot_usage (
                  slot           : slot_range;
                  must_be_in_use : boolean)
          : boolean;

    begin {check_slot_usage}
    check_slot_usage := false;
    if check_slot_allocation(slot,true) then
      if (files[slot] = nil) = (must_be_in_use) then
        if must_be_in_use then
          status := msg_no_file_open
        else
          status := msg_file_already_open
      else
        check_slot_usage := true;
    end; {check_slot_usage}

  function check_slot_direction (
                  slot           : slot_range;
                  must_be_output : boolean)
          : boolean;

    begin {check_slot_direction}
    check_slot_direction := false;
    if check_slot_usage(slot,true) then { was c_s_allocation ! PJC }
      if files[slot]^.output_flag <> must_be_output then
        if must_be_output then
          status := msg_not_output_file
        else
          status := msg_not_input_file
      else
        check_slot_direction := true;
    end; {check_slot_direction}

  function free_file (slot:slot_range):boolean;
    label 99;
    begin {free_file}
    free_file := true;
    if not check_slot_allocation(slot,true) then
      begin
      free_file := false;
      goto 99;
      end;
    if files_frames[slot] <> nil then
      begin
      with files_frames[slot]^ do
        begin
        if slot = output_file then
          output_file := 0
        else
          begin
          file_fix_eop(true,files_frames[slot]^.last_group^.last_line);
          input_file := 0;
          end;
        files_frames[slot] := nil;
        end;
      end
    else
    if slot = fgi_file then fgi_file := 0
    else
    if slot = fgo_file then fgo_file := 0;
   99:
    end; {free_file}

  function get_free_slot (var new_slot:slot_range):boolean;
    label 99;
    var slot : slot_range;

    begin {get_free_slot}
    get_free_slot := true;
    slot := 1;
    while (slot<max_files) and ((files[slot]<>nil) or (slot=file_slot)) do
      slot := slot+1;
    if files[slot] <> nil then
      begin
      status := msg_no_more_files_allowed;
      get_free_slot := false;
      goto 99;
      end;
    new_slot := slot;
   99:
    end; {get_free_slot}

  function get_file_name(
                tparam    : tpar_ptr;
        var     fnm       : file_name_str):boolean;

    label 99;
    var
      file_name : tpar_object;

    begin {get_file_name}
    get_file_name := true;
    with file_name do
      begin
      con:= nil;  nxt:= nil;
      end;
    if not tpar_get_1(tparam,command,file_name) then
      begin
      get_file_name := false;
      goto 99;
      end;
    with file_name do
{#if ISO1}
      ch_copy(str,1,len,fnm,1,file_name_len,' ');
{#else}
{##      ch_copy_str_fnm(str,1,len,fnm,1,file_name_len,' ');}
{#endif}
    tpar_clean_object(file_name);
   99:
    end; {get_file_name}

  begin {file_command}
  file_command := false;
{#if turbop}
  fillchar(status[1], sizeof(status), ' ');
{#else}
{##  status := msg_blank;}
{#endif}
  file_slot := 0;

  with current_frame^ do
    begin
    { Fudge some of the commands that accept rept = minus. }
    if (rept = minus) and (command <> cmd_file_write) then
      begin
      saved_cmd := command;
      command := cmd_file_close;
      end;
    { Perform the operation. }
    case command of

      cmd_file_input:
        begin
        if not check_slot_allocation(input_file,false) then
          goto 99;
        if not get_free_slot(file_slot) then
          goto 99;
        if not get_file_name(tparam,fnm) then
          goto 99;
        dummy_fptr := nil;
        if not file_create_open(fnm,parse_input,files[file_slot],dummy_fptr) then goto 99;
        input_file := file_slot;
        files_frames[file_slot] := current_frame;
        if not from_span then
          begin
          screen_message(msg_loading_file);
          if ludwig_mode = ludwig_screen then
            vdu_flush(false);
          end;
        if not file_page(current_frame,exit_abort) then
          ;
        { Clean up the LOADING message. }
        if not from_span then
          screen_clear_msgs(false);
        end;

      cmd_file_global_input:
        begin
        if not check_slot_allocation(fgi_file,false) then
          goto 99;
        if not get_free_slot(file_slot) then
          goto 99;
        if files[file_slot] = nil then
          begin
          if not get_file_name(tparam,fnm) then
            goto 99;
          dummy_fptr := nil;
          if not file_create_open(fnm,parse_input,files[file_slot],dummy_fptr) then goto 99;
          end;
        fgi_file := file_slot;
        end;

      cmd_file_edit:
        begin
        if not check_slot_allocation(input_file ,false) then
          goto 99;
        if not check_slot_allocation(output_file,false) then
          goto 99;
        if not get_free_slot(file_slot) then
          goto 99;
        if not get_free_slot(file_slot_2) then
          goto 99;

        if not get_file_name(tparam,fnm) then
          goto 99;
        if not file_create_open(fnm,parse_edit,files[file_slot],files[file_slot_2]) then goto 99;
        input_file := file_slot;
        files_frames[file_slot] := current_frame;
        output_file := file_slot_2;
        files_frames[file_slot_2] := current_frame;
        if not from_span then
          begin
          screen_message(msg_loading_file);
          if ludwig_mode = ludwig_screen then
            vdu_flush(false);
          end;
        if not file_page(current_frame,exit_abort) then
          ;
        { Clean up the LOADING message. }
        if not from_span then
          screen_clear_msgs(false);
        end;

      cmd_file_execute:
        begin
        if not check_slot_allocation(input_file,false) then
          goto 99;
        if not get_free_slot(file_slot) then
          goto 99;
        if not get_file_name(tparam,fnm) then
          goto 99;
        dummy_fptr := nil;
        if not file_create_open(fnm,parse_execute,files[file_slot],dummy_fptr) then
          goto 99;
        input_file := file_slot;
        files_frames[file_slot] := current_frame;
        if not file_page(current_frame,exit_abort) then
          ;
        { Clean up the LOADING message. }
        if not free_file(file_slot) then
          goto 99;
        if not file_close_delete(files[file_slot],true,false) then
          goto 99;
        end;

      cmd_file_close:
        begin
        case saved_cmd of
  {-FI}   cmd_file_input         : file_slot := input_file;
  {-FO}   cmd_file_output        : file_slot := output_file;
  {-FGI}  cmd_file_global_input  : file_slot := fgi_file;
  {-FGO}  cmd_file_global_output : file_slot := fgo_file;
  {-FE}   cmd_file_edit          : file_slot := input_file;
        end{case};
        if saved_cmd in [cmd_file_output,cmd_file_edit] then
          begin
          if not file_windthru(current_frame,from_span) then
            goto 99;
          {
          ! Update the screen now so that the file closed messages
          ! remain visible.
          }
          screen_fixup;
          end;
        if not free_file(file_slot) then
          goto 99;
        if saved_cmd in [cmd_file_global_input,cmd_file_global_output] then
          begin
          if not file_close_delete(files[file_slot],false,true) then
            goto 99;
          end
        else
          begin
          if not file_close_delete(files[file_slot],
                                   not text_modified,
                                   text_modified
                                   or not files[file_slot]^.output_flag) then
            goto 99;
          end;
        if saved_cmd = cmd_file_edit then
          begin
          file_slot := output_file;
          if not free_file(file_slot) then
            goto 99;
          if not file_close_delete(files[file_slot],not text_modified,text_modified) then
            goto 99;
          end;
        if saved_cmd in [cmd_file_output,cmd_file_edit] then
          text_modified := false;
        end;

      cmd_file_kill:
        begin
        file_slot := output_file;
        if not free_file(file_slot) then
          goto 99;
        if not file_close_delete(files[file_slot],true,true) then goto 99;
        end;

      cmd_file_global_kill:
        begin
        file_slot := fgo_file;
        if not free_file(file_slot) then
          goto 99;
        if not file_close_delete(files[file_slot],true,true) then goto 99;
        end;

      cmd_file_output:
        begin
        if not check_slot_allocation(output_file,false) then
          goto 99;
        if not get_free_slot(file_slot) then
          goto 99;
        if not get_file_name(tparam,fnm) then
          goto 99;
        if input_file <> 0 then
          begin
          if not file_create_open(fnm,parse_output,files[input_file],files[file_slot])
          then goto 99;
          end
        else
          begin
          dummy_fptr := nil;
          if not file_create_open(fnm,parse_output,dummy_fptr,files[file_slot]) then goto 99;
          end;
        output_file := file_slot;
        files_frames[file_slot] := current_frame;
        end;

      cmd_file_global_output:
        begin
        if not check_slot_allocation(fgo_file,false) then
          goto 99;
        if not get_free_slot(file_slot) then
          goto 99;
        if files[file_slot] = nil then
          begin
          if not get_file_name(tparam,fnm) then
            goto 99;
          dummy_fptr := nil;
          if not file_create_open(fnm,parse_output,dummy_fptr,files[file_slot]) then goto 99;
          end;
        fgo_file := file_slot;
        end;

      cmd_file_read:
        begin
        if not check_slot_allocation(fgi_file,true) then
          goto 99;
        lines_to_read := count;
        if rept = pindef then lines_to_read := maxint;
        if not file_read(files[fgi_file],
                         lines_to_read,
                         rept = pindef,
                         first,
                         last,
                         i)
        then goto 99;
        if first <> nil then
          begin
          if not lines_inject(first, last, dot^.line) then
            goto 99;
          if not mark_create (first, 1, marks[mark_equals]) then
            goto 99;
          text_modified := true;
          if not mark_create(last^.flink, 1, marks[mark_modified]) then
            goto 99;
          if not mark_create (last^.flink, 1, dot) then
            goto 99;
          end;
        end;

      cmd_file_write:
        begin
        if not check_slot_allocation(fgo_file,true) then
          goto 99;
        { Establish which lines to write. }
        if not from_span then
          begin
          screen_message(msg_writing_file);
          if ludwig_mode = ludwig_screen then
            vdu_flush(false);
          end;
        if not exec_compute_line_range(current_frame,
                                       rept,
                                       count,
                                       first,
                                       last)
        then goto 99;
        if first <> nil then
          if not file_write(first,last,files[fgo_file]) then
            goto 99;
        if not from_span then
          screen_clear_msgs(false);
        end;

      cmd_file_rewind:
        begin
        if not check_slot_direction(input_file,false) then goto 99;
        if not file_rewind(files[input_file]) then goto 99;
        if not from_span then
          begin
          screen_message(msg_loading_file);
          if ludwig_mode = ludwig_screen then
            vdu_flush(false);
          end;
        if not file_page(current_frame,exit_abort) then
          ;
        { Clean up the LOADING message. }
        if not from_span then
          screen_clear_msgs(false);
        end;

      cmd_file_global_rewind:
        begin
        if not check_slot_direction(fgi_file,false) then goto 99;
        if not file_rewind(files[fgi_file]) then goto 99;
        end;

      cmd_file_save:
        begin
{#if msdos}
{##        status := msg_not_implemented; goto 99;}
{##        #< This is not true, but the filesys code doesn't work yet. #>}
{##        #< It is better to fail than to destroy the user's file!    #>}
{##        #<                                      KBN 21 Nov 1990     #>}
{#else}
        if output_file = 0 then
          begin status := msg_no_output; goto 99; end;
        if not text_modified then
          begin
          if not from_span then
            begin
            screen_message(msg_not_modified);
            if ludwig_mode = ludwig_screen then
              vdu_flush(false);
            end;
          file_command := true;
          goto 99;
          end;
        if not from_span then
          begin
          screen_message(msg_saving_file);
          if ludwig_mode = ludwig_screen then
            vdu_flush(false);
          end;
        lines_written := files[output_file]^.l_counter;
        first := first_group^.first_line;
        last := last_group^.last_line^.blink;
        { If the frame is empty, last = nil }
        if last <> nil then
          if not file_write(first,last,files[output_file]) then goto 99;
        if input_file <> 0 then
          dummy_fptr := files[input_file]
        else
          dummy_fptr := nil;
        if not filesys_save(dummy_fptr,files[output_file],lines_written) then
          goto 99;
        if last = nil then
          nr_lines := 0
        else
          if not line_to_number(last,nr_lines) then nr_lines := 0;
        input_count := files[output_file]^.l_counter + nr_lines;
        if input_file <> 0 then
          files[input_file]^.l_counter := input_count;
        text_modified := false;
{#endif}
        end;

    end{case};
    end{with};
  file_command := true;
99:
  if status <> msg_blank then
    screen_message(status);
  end; {file_command}

{#if vms or turbop}
end.
{#endif}
