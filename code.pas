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
{       Wayne N. Agutter (1979-80)                                     }
{       Chris J. Barter (1979-89)                                      }
{       Bevin R. Brett (1979-82)                                       }
{       Kevin J. Maciunas (1980-84 )                                   }
{       Kelvin B. Nicolle (1981-90)                                    }
{       Mark R. Prior (1987-88)                                        }
{       Jeff Blows (1988-90,2020)                                      }
{       Martin Sandiford (1991, 2002, 2008, 2018)                      }
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
! Name:         CODE
!
! Description:  Ludwig compiler and interpreter.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/code.pas,v 4.9 2002/07/20 17:25:12 martin Exp $
! $Author: martin $
! $Locker:  $
! $Log: code.pas,v $
! Revision 4.9  2002/07/20 17:25:12  martin
! Changed added turbop to unix only conditional.
!
! Revision 4.8  1990/01/18 18:22:43  ludwig
! Entered into RCS at revision level 4.8
!
!
!
! Revison History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                    15-Apr-1987
!       In scan_simple_command:
!       . moved check for number of V commands to top.
!       . always copy code pointer.
!       . duplicate tpar if non-nil, else compile new tpar.
!       . move increment of code reference count to just before call to
!         generate.
! 4-003 Mark R. Prior                                        20-Feb-1988
!       Strings passed to ch routines are now passed using conformant
!         arrays, or as type str_object.
!               string[offset],length -> string,offset,length
!       In all calls of ch_length, ch_upcase_str, ch_locase_str, and
!         ch_reverse_str, the offset was 1 and is now omitted.
! 4-004 Kelvin B. Nicolle                                     9-Sep-1988
!       In scan_trailing_param add a local variable to work around a bug
!       in the Multimax pascal compiler (reference 0016).
! 4-005 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-006 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
! 4-007 Kelvin B. Nicolle                                    13-Sep-1989
!       Add includes etc. for Tower version.
! 4-008 Kelvin B. Nicolle                                    25-Oct-1989
!       Correct the includes for the Tower version.
!       Remove the superfluous include of system.h.
!--}

{#if vms}
{##[ident('4-008'),}
{## overlaid]}
{##module code (output);}
{#elseif turbop}
unit code;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'code.fwd'}
{##%include 'ch.h'}
{##%include 'exec.h'}
{##%include 'frame.h'}
{##%include 'line.h'}
{##%include 'mark.h'}
{##%include 'screen.h'}
{##%include 'tpar.h'}
{##%include 'vdu.h'}
{##%include 'vdu_vms.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "code.h"}
{####include "ch.h"}
{####include "exec.h"}
{####include "frame.h"}
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
{###<$F=code.h#>}
{###<$F=ch.h#>}
{###<$F=exec.h#>}
{###<$F=frame.h#>}
{###<$F=line.h#>}
{###<$F=mark.h#>}
{###<$F=screen.h#>}
{###<$F=tpar.h#>}
{###<$F=vdu.h#>}
{#elseif turbop}
interface
  uses value;
  {$I code.i}

implementation
  uses ch, exec, frame, line, mark, screen, tpar, vdu;
{#endif}


procedure code_discard (
        var     code_head : code_ptr);

  { This routine releases the specified code and compacts the code array.  }
  { The code_head is set to NIL. }

  var
    start,source : code_idx;
    size : code_idx;
    link : code_ptr;

  begin {code_discard}
  with code_head^ do
    begin
    ref := ref - 1;
    if ref = 0 then
      begin
      start := code;
      size  := len;

      for source := start to start+size-1 do
        with compiler_code[source] do
          begin
          if code <> nil then code_discard(code);
          if tpar <> nil then tpar_clean_object(tpar^);
          end;

      for source := start+size to code_top do
        compiler_code[source-size]:= compiler_code[source];
      code_top := code_top-size;

      link := blink;
      while link <> code_list do
        with link^ do
          begin
          code:= code-size;
          link:= blink;
          end;

      flink^.blink := blink;
      blink^.flink := flink;

      dispose(code_head);
      code_head := nil;
      end;
    end;
  end; {code_discard}


function code_compile (
        var     span      : span_object;
                from_span : boolean)
        : boolean;

  label 99;
  var
    status       : msg_str;
    key          : key_code_range;
    eoln         : boolean;     { Used to signal end of line }
    pc           : integer;     { This is always an offset from code_top }
    code_base    : code_idx;    { Base in code array for new code }
    startpoint,
    endpoint,
    currentpoint : mark_object;
    verify_count : integer;
{#if turbop}
    error_msg_str : string;
    msg_buffer    : msg_str;
{#endif}

{#if vms}
{##  procedure error (err_text : packed array [l1..err_len:strlen_range] of char);}
{#elseif unix or turbop}
  procedure error (err_text : msg_str);
{#endif}

    { Inserts an error message into the span where it was detected.}

    label 99;
    var
      e_line : line_ptr;
      str    : str_object;
      i, j   : integer;

    begin {error}
    status := msg_syntax_error;
    if from_span then
      begin
      { If possible, backup the current point one character. }
      with currentpoint do
        begin
        if line <> startpoint.line then
          if col > 1 then col := col-1
          else
            begin
            line := line^.blink;
            col  := line^.used+1;
            if col > 1 then col := col-1;
            if line = startpoint.line then
              if col < startpoint.col then col := startpoint.col;
            end
        else
        if col > startpoint.col then col := col-1;
        end;

      { Insert the error message into the span. }
      if ludwig_mode = ludwig_screen then
        begin
        if not frame_edit(currentpoint.line^.group^.frame^.span^.name)
        then goto 99;
        with current_frame^ do
          begin
          if marks[0] <> nil then
            if not mark_destroy(marks[0]) then goto 99;
          if not lines_create(1,e_line,e_line) then goto 99;
          with currentpoint do
            begin
            ch_fill(str,1,col-1,' ');
            i := col;
            str[i] := '!';
            if i < max_strlen then
              begin
              i := i+1;
              str[i] := ' ';
              end;
            j := 0;
{#if vms}
{##            while (i < max_strlen) and (j < err_len) do}
{#elseif unix or turbop}
            while (i < max_strlen) and (j < msg_str_len) do
{#endif}
              begin
              i := i+1;
              j := j+1;
              str[i] := err_text[j];
              end;
            end;
          if not line_change_length(e_line,i) then goto 99;
          ch_move(str,1,e_line^.str^,1,i);
          e_line^.used := ch_length(str,i);
          if not lines_inject(e_line,e_line,currentpoint.line) then goto 99;
          if not mark_create(e_line,currentpoint.col,dot) then goto 99;
          end;
        end;
      end;
  99:
    end; {error}

  function nextkey : boolean;

    label 99;

    begin {nextkey}
    nextkey := false;
    eoln := false;
    if not from_span then
      begin
      key := vdu_get_key;
      if tt_controlc then goto 99;
      end
    else
      with currentpoint do
        if (line=endpoint.line) and (col=endpoint.col) then
          key := 0    { finished span }
        else
          with line^ do
            begin
            if col <= used then
              begin
              key := ord(str^[col]);
              col := col+1;
              end
            else
            if line <> endpoint.line then
              begin
              key  := ord(' ');
              eoln := true;
              line := flink;
              col  := 1;
              end
            else
              key := 0;   { finished the span}
            end;
    nextkey := true;
  99:
    end; {nextkey}

  function nextnonbl : boolean;

    label 1,99;

    begin {nextnonbl}
    nextnonbl := false;
  1:
    repeat
      if not nextkey then goto 99;
      if from_span then
        with currentpoint,line^ do
          if (key = ord('<')) and (col <= used) then
            if str^[col] = '>' then
              key := 0;
    until key <> ord(' ');
    if key = ord('!') then          { Comment - throw away rest of line. }
      if from_span then
        begin
        with currentpoint do
          col := line^.used+1;
        goto 1;
        end
      else
        begin status := msg_comments_illegal; goto 99 end;
    nextnonbl := true;
  99:
    end; {nextnonbl}

  function generate (irep:leadparam; icnt:integer; iop:commands;
                     itpar:tpar_ptr; ilbl:integer; icode:code_ptr)
           : boolean;

    label 99;

    begin {generate}
    generate := false;
    pc := pc+1;
    if code_base + pc > max_code then
      begin status := msg_compiler_code_overflow; goto 99 end;
    with compiler_code[code_base+pc] do
      begin
      rep := irep;  cnt:= icnt;  op := iop;
      tpar := itpar;  lbl  := ilbl;  code := icode;
      end;
    generate := true;
  99:
    end; {generate}

  procedure poke (location,newlabel:code_idx);
    begin {poke}
    compiler_code[code_base+location].lbl:= newlabel;
    end; {poke}

{#if vms}
{##  [check(nooverflow)] #<bug224#>}
{#endif}
  function scan_command (full_scan:boolean) : boolean;

    label 99;
    var
      pc1,pc2,
      pc3,pc4     : integer;   { These are always offsets from code_base }
      repsym      : leadparam;
      repcount    : integer;
      command     : commands;
      tparam      : tpar_ptr;
      lookup_code : code_ptr;
      i,j         : 1..expand_lim;

    function scan_leading_param : boolean;

      label 99;

      function getcount : boolean;

        label 99;
        const
          max_repcount = 65535;
        var
          digit : 0..9;

        begin {getcount}
        getcount := false;
        if key in numeric_set then
          begin
          repcount := 0;
          repeat
            digit := key - ord('0');
            if repcount <= (max_repcount-digit) div 10 then
              repcount := repcount*10 + digit
            else
              begin
{#if turbop}
              fillchar(msg_buffer[1] , sizeof(msg_buffer), ' ');
              error_msg_str := 'Count too large';
              move(error_msg_str[1], msg_buffer[1], length(error_msg_str));
              error(msg_buffer);
{#else}
{##              error('Count too large');}
{#endif}
              goto 99;
              end;
            if not nextkey then goto 99;
          until not (key in numeric_set);
          end
        else repcount := 1;
        getcount := true;
      99:
        end; {getcount}

      begin {scan_leading_param}
      scan_leading_param := false;
      if key in [ord('0')..ord('9'), ord('+'), ord('-'), ord('>'), ord('.'),
                 ord('<'), ord(','), ord('@'), ord('='), ord('%')] then
        case chr(key) of
          '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
                    begin
                    repsym := pint;
                    if not getcount then goto 99;
                    end;
          '+'     : begin
                    if not nextkey then goto 99;
                    repsym := plus;
                    repcount := 1;
                    if key in numeric_set then
                      begin
                      repsym := pint;
                      if not getcount then goto 99;
                      end;
                    end;
          '-'     : begin
                    if not nextkey then goto 99;
                    repsym := minus;
                    repcount := -1;
                    if key in numeric_set then
                      begin
                      repsym := nint;
                      if not getcount then goto 99;
                      repcount := -repcount;
                      end;
                    end;
          '>', '.': begin
                    if not nextkey then goto 99;
                    repsym := pindef;
                    repcount := 0;
                    end;
          '<', ',': begin
                    if not nextkey then goto 99;
                    repsym := nindef;
                    repcount := 0;
                    end;
          '@'     : begin
                    if not nextkey then goto 99;
                    repsym := marker;
                    if not getcount then goto 99;
                    if (repcount = 0) or (repcount > max_mark_number) then
                      begin
{#if turbop}
                      fillchar(msg_buffer[1] , sizeof(msg_buffer), ' ');
                      error_msg_str := 'Illegal mark number';
                      move(error_msg_str[1], msg_buffer[1], length(error_msg_str));
                      error(msg_buffer);
{#else}
{##                      error('Illegal mark number');}
{#endif}
                      goto 99;
                      end;
                    end;
          '='     : begin
                    if not nextkey then goto 99;
                    repsym := marker;
                    repcount := mark_equals;
                    end;
          '%'     : begin
                    if not nextkey then goto 99;
                    repsym := marker;
                    repcount := mark_modified;
                    end;
        end{case}
      else begin repsym := none; repcount := 1; end;
      scan_leading_param := true;
    99:
      end; {scan_leading_param}

    function scan_trailing_param : boolean;

      label 99;
      var
        parstring : str_object;
        parlength : integer;
        pardelim  : key_code_range;
        tc,tci    : tpcount_type;
        tp,tpl    : tpar_ptr;
{ tci is introduced to work around a bug on the Multimax:              }
{       for tc := 1 to tc                                              }
{ produces incorrect code                                              }

      begin {scan_trailing_param}
      scan_trailing_param := false;
      tc     := cmd_attrib[command].tpcount;
      tparam := nil;
      { Some commands only take trailing parameters when repcount is +ve }
      if (tc < 0) then
        begin
        if repsym = minus then tc := 0
        else tc := -tc;
        end;
      if tc > 0 then
        begin
        if not nextkey then goto 99;
        pardelim := key;
        if not (pardelim in
                 (printable_set - alpha_set - numeric_set - space_set)) then
          begin
{#if turbop}
          fillchar(msg_buffer[1] , sizeof(msg_buffer), ' ');
          error_msg_str := 'Illegal parameter delimiter';
          move(error_msg_str[1], msg_buffer[1], length(error_msg_str));
          error(msg_buffer);
{#else}
{##          error('Illegal parameter delimiter');}
{#endif}
          goto 99;
          end;
        for tci := 1 to tc do
          begin
          repeat
            parlength := 0;
            repeat
              if not nextkey then goto 99;
              if key = 0 then
                begin
{#if turbop}
                fillchar(msg_buffer[1] , sizeof(msg_buffer), ' ');
                error_msg_str := 'Missing trailing delimiter';
                move(error_msg_str[1], msg_buffer[1], length(error_msg_str));
                error(msg_buffer);
{#else}
{##                error('Missing trailing delimiter');}
{#endif}
                goto 99;
                end;
              parlength := parlength + 1;
              parstring[parlength] := chr(key);
            until (key = pardelim) or eoln;
            parlength := parlength - 1;
            if eoln and not cmd_attrib[command].tpar_info[tci].ml_allowed then
              begin
{#if turbop}
                fillchar(msg_buffer[1] , sizeof(msg_buffer), ' ');
                error_msg_str := 'Missing trailing delimiter';
                move(error_msg_str[1], msg_buffer[1], length(error_msg_str));
                error(msg_buffer);
{#else}
{##              error('Missing trailing delimiter');}
{#endif}
              goto 99;
              end;
            new(tp);
            with tp^ do
              begin
              len := parlength; dlm := chr(pardelim);
              str := parstring; nxt := nil; con:= nil;
              end;
            if tparam = nil then    { 1st time through }
              begin tparam := tp; tpl := tp end
            else
              if tpl <> nil then
                begin tpl^.con := tp; tpl := tp end
              else
                begin tparam^.nxt := tp; tpl := tp end
          until key = pardelim;
          tpl := nil;
          end;
        end;
      scan_trailing_param := true;
    99:
      end; {scan_trailing_param}

    function scan_exit_handler : boolean;

      label 99;

      begin {scan_exit_handler}
      scan_exit_handler := false;
      if not nextnonbl then goto 99;
      if key = ord('[') then
        begin
        if not nextnonbl then goto 99;
        while (key <> ord(':')) and (key <> ord(']')) do
          {Construct exit part. }
          if not scan_command(full_scan) then goto 99;
        if key = ord(':') then
          begin
          {Jump over fail handler.}
          if not generate(none,0,cmd_pcjump,nil,0,nil) then goto 99;
          pc4 := pc;
          poke(pc1,pc+1);                   {Set fail label for command }
          if not nextnonbl then goto 99;
          while key <> ord(']') do
            {Construct fail part. }
            if not scan_command(full_scan) then goto 99;
          poke(pc4,pc+1);                   {End of fail handler. }
          end
        else
          poke(pc1,pc+1);                     {Set fail label}
        if not nextnonbl then goto 99;
        end;
      scan_exit_handler := true;
    99:
      end; {scan_exit_handler}

    function scan_simple_command : boolean;

      label 99;
      var
        i : integer;
        tmp_tp : tpar_ptr;

      begin {scan_simple_command}
      scan_simple_command := false;
      if not (repsym in cmd_attrib[command].lp_allowed) then
        begin
{#if turbop}
        fillchar(msg_buffer[1] , sizeof(msg_buffer), ' ');
        error_msg_str := 'Illegal leading parameter';
        move(error_msg_str[1], msg_buffer[1], length(error_msg_str));
        error(msg_buffer);
{#else}
{##        error('Illegal leading parameter');}
{#endif}
        goto 99;
        end;
      if command = cmd_verify then
        begin
        verify_count := verify_count + 1;
        if verify_count > max_verify then
          begin
{#if turbop}
        fillchar(msg_buffer[1] , sizeof(msg_buffer), ' ');
        error_msg_str := 'Too many verify commands in span';
        move(error_msg_str[1], msg_buffer[1], length(error_msg_str));
        error(msg_buffer);
{#else}
{##          error('Too many verify commands in span');}
{#endif}
          goto 99;
          end;
        repcount := verify_count;
        end;
      lookup_code := lookup[key].code;
      if lookup[key].tpar = nil then
        if cmd_attrib[command].tpcount <> 0 then
          if full_scan then
            begin if not scan_trailing_param then goto 99 end
          else
            begin
            new(tparam);
            with tparam^ do
              begin
              len:= 0;  dlm:= tpd_prompt;
              nxt:= nil;  con:= nil;
              end;
            tmp_tp := tparam;
            for i:= 2 to cmd_attrib[command].tpcount do
              begin
              new(tmp_tp^.nxt);
              tmp_tp := tmp_tp^.nxt;
              with tmp_tp^ do
                begin
                len := 0; dlm := tpd_prompt;
                nxt:= nil;  con := nil;
                end;
              end;
            end
        else
          tparam := nil
      else
        tpar_duplicate(lookup[key].tpar,tparam);
      if lookup_code <> nil then
        lookup_code^.ref := lookup_code^.ref + 1;
      if not generate(repsym,repcount,command,tparam,0,lookup_code) then goto 99;
      pc1 := pc;
      scan_simple_command := true;
    99:
      end; {scan_simple_command}

    function scan_compound_command : boolean;

      label 99;

      begin {scan_compound_command}
      scan_compound_command := false;
      if not (repsym in [none,plus,pint,pindef]) then
        begin
{#if turbop}
        fillchar(msg_buffer[1] , sizeof(msg_buffer), ' ');
        error_msg_str := 'Illegal leading parameter';
        move(error_msg_str[1], msg_buffer[1], length(error_msg_str));
        error(msg_buffer);
{#else}
{##        error('Illegal leading parameter');}
{#endif}
        goto 99;
        end;
      if not generate(none,0,cmd_exitto,nil,0,nil) then goto 99;
      pc2 := pc;
      if not generate(none,0,cmd_failto,nil,0,nil) then goto 99;
      pc1 := pc;
      pc3 := pc + 1;
      if repsym <> pindef then
        if not generate(none,repcount,cmd_iterate,nil,0,nil) then goto 99;
      if not nextnonbl then goto 99;
      repeat
        if not scan_command(true) then goto 99;
      until key = ord(')');
      if not generate(none,0,cmd_pcjump,nil,pc3,nil) then goto 99;
      poke(pc2,pc+1);                       {Fill in exit label.}
      scan_compound_command := true;
    99:
      end; {scan_compound_command}

    begin {scan_command}
    scan_command := false;
    if not scan_leading_param then goto 99;
    if key in lower_set then
      key := ord(ch_upcase_chr(chr(key)));
    command := lookup[key].command;
    while command in prefixes do
      begin
      if not nextkey then goto 99;
      if key < 0 then
        begin
{#if turbop}
        fillchar(msg_buffer[1] , sizeof(msg_buffer), ' ');
        error_msg_str := 'Command not valid';
        move(error_msg_str[1], msg_buffer[1], length(error_msg_str));
        error(msg_buffer);
{#else}
{##        error('Command not valid');}
{#endif}
        goto 99;
        end;
      i  := lookupexp_ptr[command];
      j  := lookupexp_ptr[succ(command)];
      while (i<j) and (ch_upcase_chr(chr(key))<>lookupexp[i].extn) do
        i := succ(i);
      if i < j then
                   {bug224--incorrect code for this array access}
        command := lookupexp[i].command
      else
        begin
{#if turbop}
        fillchar(msg_buffer[1] , sizeof(msg_buffer), ' ');
        error_msg_str := 'Command not valid';
        move(error_msg_str[1], msg_buffer[1], length(error_msg_str));
        error(msg_buffer);
{#else}
{##        error('Command not valid');}
{#endif}
        goto 99;
        end;
      end;
    if key = ord('(') then
      begin if not scan_compound_command then goto 99 end
    else
    if command <> cmd_noop then
      begin if not scan_simple_command then goto 99 end
    else
      begin
{#if turbop}
      fillchar(msg_buffer[1] , sizeof(msg_buffer), ' ');
      error_msg_str := 'Command not valid';
      move(error_msg_str[1], msg_buffer[1], length(error_msg_str));
      error(msg_buffer);
{#else}
{##      error('Command not valid');}
{#endif}
      goto 99;
      end;
    if full_scan then
      if not scan_exit_handler then goto 99;
    scan_command := true;
  99:
    end; {scan_command}

  begin {code_compile}
  code_compile := false;      { Set up failure conditions. }
{#if turbop}
  fillchar(status[1], sizeof(status), ' ');
{#else}
{##  status := msg_blank;        #< Assume will work. #>}
{#endif}
  eoln := false;

  with span do
    begin
    if from_span then
      begin
      startpoint   := mark_one^;  { Make Local Copies of the }
      endpoint     := mark_two^;  { PHYSICAL marks.          }
      currentpoint := startpoint;
      end;
    if code <> nil then code_discard(code);
    end;

  code_base := code_top;
  pc := 0;      { This will be incremented before code is written. }
  verify_count := 0;
  if not nextnonbl then goto 99;
  if key = 0 then
    begin
{#if turbop}
        fillchar(msg_buffer[1] , sizeof(msg_buffer), ' ');
        error_msg_str := 'Span contains no commands';
        move(error_msg_str[1], msg_buffer[1], length(error_msg_str));
        error(msg_buffer);
{#else}
{##    error('Span contains no commands');}
{#endif}
    goto 99;
    end;
  if from_span then
    repeat
      if not scan_command(true) then goto 99;
    until key = 0
  else
    if not scan_command(false) then goto 99;

  if not generate(pint,1,cmd_exit_success,nil,0,nil) then goto 99;

  { Fill in code header. }

  new(span.code);
  with span do
    begin
    with code^ do
      begin
      ref   := 1;
      code  := code_base + 1;
      len   := pc;
      flink := code_list^.flink;              { Link it into chain. }
      blink := code_list;
      end;
    code_list^.flink^.blink := code;
    code_list^.flink        := code;
    end;
  code_top := code_base + pc;
  code_compile := true;
99:
  if status <> msg_blank then
    begin
    exit_abort := true;
    screen_message(status);
    end;
  end; {code_compile}


{#if debug}
 procedure writecode;

   var
     j,k : integer;
     hp : code_ptr;
     tp : tpar_ptr;

   begin {writecode}
   hp:= code_list^.flink;
   while hp <> code_list do
     begin
     with hp^ do
       begin
       writeln(' New Segment, ref count ',ref:1);
       for j:= 1 to len do
         with compiler_code[code+j-1] do
           begin
{#if vms}
{##           write(j:2,' : ',lbl:6,op,rep:6,cnt:6);}
{#elseif unix or turbop}
           write(j:2,' : ',lbl:6,ord(op):6,ord(rep):6,cnt:6);
{#endif}
           if tpar <> nil then
             begin
             tp:= tpar;
             write('-');
             repeat
               write(tpar^.dlm);
               with tp^ do
                 for k := 1 to len do write(str[k]);
               tp:= tp^.nxt;
             until tp = nil;
             write(tpar^.dlm);
             end;
           writeln;
           end;
       end;
     hp:= hp^.flink;
     end;
   end; {writecode}
{#endif}


function code_interpret (
                rept      : leadparam;
                count     : integer;
                code_head : code_ptr;
                from_span : boolean)
        : boolean;

  label 99;
  var
    curr_rep      : leadparam;                { repeat count type }
    curr_cnt      : integer;                  { repeat count value }
    curr_op       : commands;                 { op-code }
    curr_tpar     : tpar_ptr;                 { trailing parameter record ptr}
    curr_lbl      : code_idx;                 { label field }
    curr_code     : code_ptr;
    labels        : array [1..100] of
                      record
                        exitlabel : code_idx;
                        faillabel : code_idx;
                        count : integer
                      end;
    level         : 0..100;
    pc            : code_idx;
    interp_status : (success,failure,failforever);
    request       : tpar_object;
    verify_always : verify_array;

  begin {code_interpret}
  code_interpret := false;
  with request do
    begin
    nxt:= nil;  con:= nil;
    end;

  with code_head^ do ref := ref+1;

  if rept = pindef then count := -1;
  interp_status := success;
  verify_always := initial_verify;

  while (count <> 0) and (interp_status = success) do
    begin
    count := count-1;
    level := 1;
    with labels[1] do begin exitlabel := 0; faillabel := 0; count := 0 end;
    pc := 1;
    repeat
{#if debug}
      if pc > code_head^.len then
        begin screen_message(dbg_pc_out_of_range); goto 99; end;
{#endif}
      interp_status := success;
      { Note! code_head^.code may be changed by a span compilation/creation. }
      with compiler_code[code_head^.code-1 + pc] do
        begin
        curr_lbl  := lbl;
        curr_op   := op;
        curr_rep  := rep;
        curr_cnt  := cnt;
        curr_tpar := tpar;
        curr_code := code;
        end;
      pc := pc+1;

      if curr_op in [cmd_pcjump, cmd_exitto, cmd_failto, cmd_iterate,
                     cmd_exit_success, cmd_exit_fail, cmd_exit_abort,
                     cmd_extended, cmd_verify, cmd_noop] then
        case curr_op of

          cmd_pcjump:
            pc := curr_lbl;

          cmd_exitto:
            begin
            from_span := true;          { This is done to fix \n(...) from }
                                        { being Not From_Span to From_Span }
            level := level+1;
            with labels[level] do
              begin
              exitlabel := curr_lbl;
              faillabel := 0;
              count     := 0;
              end;
            end;

          cmd_failto:
            labels[level].faillabel := curr_lbl;

          cmd_iterate:
            if labels[level].count = curr_cnt then
              begin
              pc := labels[level].exitlabel;
              level := level-1;
              end
            else
              labels[level].count := labels[level].count + 1;

          cmd_exit_success:
            begin
            if curr_rep = pindef then curr_cnt := level;
            if curr_cnt > 0 then
              begin
              if curr_cnt >= level then
                level := 0
              else
                level := level-curr_cnt;
              pc := labels[level+1].exitlabel;
              end;
            end;

          cmd_exit_fail:
            begin
            interp_status := failure;
            if curr_rep = pindef then curr_cnt := level;
            if curr_cnt > 0 then
              begin
              if curr_cnt >= level then
                level := 0
              else
                level := level-curr_cnt;
              pc := labels[level+1].faillabel;
              end;
            end;

          cmd_exit_abort:
            begin
            exit_abort := true;
            interp_status := failforever;
            pc := 0;
            end;

          cmd_extended:
            begin
{#if debug}
            if curr_code = nil then
              begin  screen_message(dbg_code_ptr_is_nil); goto 99; end;
{#endif}
            if not code_interpret(curr_rep, curr_cnt, curr_code, true) then
              ;
            end;

          cmd_verify :
            if not verify_always[curr_cnt] then
              if ludwig_mode = ludwig_batch then
                begin
                exit_abort  := true;
                interp_status := failforever;
                pc := 0;
                end
              else if tpar_get_1(curr_tpar,cmd_verify,request) then
                begin
                if request.len = 0 then     { If didn't specify, use default. }
                  begin
                  request := current_frame^.verify_tpar;
                  if request.len = 0 then
                    begin screen_message(msg_no_default_str); goto 99; end;
                  end
                else
                  { If did specify, save for next time. }
                  current_frame^.verify_tpar := request;
                if request.str[1] = 'Y' then
                  {do nothing}
                else if request.str[1] = 'A' then
                  verify_always[curr_cnt] := true
                else if request.str[1] = 'Q' then
                  begin
                  exit_abort  := true;
                  interp_status := failforever;
                  pc := 0;
                  end
                else
                  begin
                  interp_status := failure;
                  pc := curr_lbl;
                  end;
                end;

{#if debug}
          cmd_noop:
            begin screen_message(dbg_illegal_instruction); goto 99; end;
{#endif}

        end{case}
      else
        begin
        { call execute command }
        if not execute(curr_op,curr_rep,curr_cnt,curr_tpar,from_span) then
          begin
          interp_status := failure;
          pc := curr_lbl;
          end;
        if exit_abort then
          begin
          interp_status := failforever;
          pc := 0;
          end;
        end;

      if tt_controlc then
        begin
        interp_status := failforever;
        pc := 0;
        end;

      if interp_status = failure then
        begin
        while (pc = 0) and (level >= 1) do
          begin
          pc := labels[level].faillabel;
          level := level - 1;
          end;
        end;

    until pc = 0;

    end;        {count loop}

  code_interpret := (interp_status = success);
99:
  tpar_clean_object(request);
  code_discard(code_head);

  end; {code_interpret}

{#if vms or turbop}
end.
{#endif}
