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
{  Copyright  1981, 1987, 1989-90, 2002 University of Adelaide         }
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
! Name:         TPAR
!
! Description:  Tpar maintenance.
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/tpar.pas,v 4.9 2002/07/21 02:24:41 martin Exp $
! $Author: martin $
! $Locker:  $
! $Log: tpar.pas,v $
! Revision 4.9  2002/07/21 02:24:41  martin
! Added some comments and operating system environment variable
! retrieval under fpc port. MPS
!
! Revision 4.8  2002/07/20 16:16:43  martin
! Fixed up index variable naming bug in TERMINAL-(HEIGHT,WIDTH,SPEED)
! environment variables.  Added fpc/Linux opsys name, and fallthrough
! case for Unknown operating systems.  Removed unused variable.
!
! Revision 4.7  1990/09/21 12:42:50  ludwig
! Change name of IBM-PC module system to msdos (system is reserved name).
!
Revision 4.6  90/01/18  17:22:32  ludwig
Entered into RCS at reviosion level 4.6.

!
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                     5-May-1987
!       tpar_duplicate was passing back the pointer to the last nxt of
!       the tpar chain.  Added a local variable which is now used to
!       follow the nxt pointer.
! 4-003 Jeff Blows                                              Jul-1989
!       IBM PC developments incorporated into main source code.
! 4-004 Kelvin B. Nicolle                                    12-Jul-1989
!       VMS include files renamed from ".ext" to ".h", and from ".inc"
!       to ".i".  Remove the "/nolist" qualifiers.
! 4-005 Kelvin B. Nicolle                                    13-Sep-1989
!       Add includes etc. for Tower version.
! 4-006 Kelvin B. Nicolle                                    25-Oct-1989
!       Correct the includes for the Tower version.
!--}

{#if vms}
{##[ident('4-006'),}
{## overlaid]}
{##module tpar (output);}
{#elseif turbop}
unit tpar;
{#endif}

{#if vms}
{##%include 'const.i'}
{##%include 'type.i'}
{##%include 'var.i'}
{##}
{##%include 'tpar.fwd'}
{##%include 'ch.h'}
{##%include 'span.h'}
{##%include 'screen.h'}
{##%include 'system.h'}
{#elseif unix and not tower}
{####include "const.i"}
{####include "type.i"}
{####include "var.i"}
{##}
{####include "tpar.h"}
{####include "ch.h"}
{####include "screen.h"}
{####include "span.h"}
{####include "system.h"}
{#elseif tower}
{###<$F=const.i#>}
{###<$F=type.i#>}
{###<$F=var.i#>}
{##}
{###<$F=tpar.h#>}
{###<$F=ch.h#>}
{###<$F=screen.h#>}
{###<$F=span.h#>}
{###<$F=system.h#>}
{#elseif turbop}
interface
  uses value;
  {$I tpar.i}

implementation
  uses ch, screen, span, msdos;
{#endif}


procedure tpar_clean_object (
        var     tp_o : tpar_object);

  procedure discard_tp (tp : tpar_ptr);
    begin {discard_tp}
    with tp^ do
      if nxt <> nil then
        discard_tp(nxt)
      else
        if con <> nil then
          discard_tp(con);

    dispose(tp);
    end; {discard_tp}

  begin {tpar_clean_object}
  with tp_o do
    begin
    if con <> nil then
      discard_tp(con);
    if nxt <> nil then
      discard_tp(nxt);
    con:= nil;
    nxt:= nil;
    end;
  end; {tpar_clean_object}


{}procedure tpar_duplicate_con(tpar:tpar_ptr; var tp_o:tpar_object);

  var
    tp, tp2 : tpar_ptr;

  begin
  tp_o := tpar^;
  tp_o.nxt := nil;
  tp2:= nil;
  while tpar^.con <> nil do
    begin
    tpar := tpar^.con;
    new(tp);
    tp^ := tpar^;
{#if debug}
    if tp^.nxt <> nil then
      screen_message(dbg_nxt_not_nil);
{#endif}
    if tp2 = nil then
      tp_o.con := tp
    else
      tp2^.con := tp;
    tp2 := tp;
    end;
  end; {tpar_duplicate_con}


procedure tpar_duplicate (
                from_tp : tpar_ptr;
        var     to_tp   : tpar_ptr);

  var
    tmp_tp : tpar_ptr;

  begin {tpar_duplicate}
  if from_tp <> nil then
    begin
    new(to_tp);
    tpar_duplicate_con(from_tp,to_tp^);
    from_tp := from_tp^.nxt;
    tmp_tp := to_tp;
    while from_tp <> nil do
      begin
      new(tmp_tp^.nxt);
      tmp_tp := tmp_tp^.nxt;
      tpar_duplicate_con(from_tp,tmp_tp^);
      from_tp := from_tp^.nxt;
      end;
    end
  else
    to_tp := nil;
  end; {tpar_duplicate}


function tpar_to_mark (
        var     strng : tpar_object;
        var     mark  : integer)
        : boolean;

  label 99;
  var
    i : integer;

  begin {tpar_to_mark}
  tpar_to_mark := false;
  with strng do
    begin
    if len = 0 then
      begin screen_message(msg_illegal_mark_number); goto 99; end;
    if str[1] in ['0'..'9'] then
      begin
      i := 1;
      if not tpar_to_int(strng,i,mark) then goto 99;
      if (i <= len) or (mark < 1) or (mark > max_mark_number) then
        begin screen_message(msg_illegal_mark_number); goto 99; end;
      end
    else
      begin
      if (len > 1) or not (str[1] in ['=','%']) then
        begin screen_message(msg_illegal_mark_number); goto 99; end;
      if str[1] = '=' then
        mark := mark_equals
      else
        mark := mark_modified;
      end;
    end;
  tpar_to_mark := true;
99:
  end; {tpar_to_mark}


function tpar_to_int (
        var     strng : tpar_object;
        var     chpos,
                int   : integer)
        : boolean;

  label 99;
  var
    number,digit : integer;
    ch : char;

  begin {tpar_to_int}
  tpar_to_int := false;
  with strng do
    begin
    if chpos > len then
      ch := chr(0)
    else
      ch := str[chpos];
    if not (ch in ['0'..'9']) then
      begin screen_message(msg_invalid_integer); goto 99; end;
    number := 0;
    repeat
      digit := ord(ch) - ord('0');
      if number <= (maxint-digit) div 10 then
        number := number*10 + digit
      else
        begin screen_message(msg_invalid_integer); goto 99; end;
      chpos := succ(chpos);
      if chpos > len then
        ch := chr(0)
      else
        ch := str[chpos];
    until not (ch in ['0'..'9']);
    end;
  int := number;
  tpar_to_int := true;
 99:
  end; {tpar_to_int}


function tpar_analyse (
                cmd   : user_commands;
        var     tran  : tpar_object;
                depth : integer;
                this_tp : tpcount_type)
        : boolean;

  label 99;
  var
    ended : boolean;
    verify_reply : verify_response;
    delim : char;
    tmp_tp : tpar_ptr;
    buffer : str_object;

  function tpar_substitute (var tpar : tpar_object) : boolean;

    label 99;
    var
      dummy,
      span        : span_ptr;
      start_mark,
      end_mark    : mark_object;
      srclen      : 0..max_strlen;
      name        : name_str;
      tmp_tp_2,
      tmp_tp      : tpar_ptr;

    begin {tpar_substitute}
    tpar_substitute := false;
    with tpar do
      begin
      if con <> nil then
        begin
        screen_message(msg_span_names_are_one_line);
        goto 99;
        end;
{#if ISO1}
      ch_copy(str,1,len,name,1,name_len,' ');     { Get the Span name }
      ch_upcase_str(name,name_len);             { and Up Case it    }
{#else}
{##      ch_copy_str_name(str,1,len,name,1,name_len,' ');}
{##      ch_upcase_name(name,name_len);}
{#endif}
      if span_find(name,span,dummy) then
        begin
        dlm := chr(0);
        start_mark := span^.mark_one^;
        end_mark   := span^.mark_two^;
        if start_mark.line = end_mark.line then
          begin
          len := end_mark.col - start_mark.col;
          if start_mark.col > start_mark.line^.used then  { Span in thin air }
            srclen := 0
          else
          if end_mark.col > end_mark.line^.used then
            srclen := end_mark.line^.used - start_mark.col + 1
          else
            srclen := len;
          with start_mark do
            ch_copy(line^.str^,col,srclen,str,1,len,' ');
          end
        else
          if not cmd_attrib[cmd].tpar_info[this_tp].ml_allowed then
            begin
            screen_message(msg_span_must_be_one_line);
            goto 99;
           end
          else
            begin
            {copy entire span into a tpar}
            with start_mark do
              begin
              if col > line^.used then  {Thin air span}
                len := 0
              else
                len := line^.used - col + 1;
              ch_move(line^.str^,col,str,1,len);
              end;
            {Anything between the start and end marks?}
            tmp_tp := nil;
            start_mark.line := start_mark.line^.flink;
            while start_mark.line <> end_mark.line do
              begin
              new(tmp_tp_2);
              if tmp_tp = nil then
                tpar.con := tmp_tp_2
              else
                tmp_tp^.con := tmp_tp_2;
              tmp_tp := tmp_tp_2;
              with tmp_tp^ do
                begin
                dlm := chr(0);
                nxt := nil; con:= nil;
                len := start_mark.line^.used;
                ch_move(start_mark.line^.str^,1,str,1,len);
                end;
              start_mark.line := start_mark.line^.flink;
              end;
            with end_mark do
              begin
              {create new tpar}
              new(tmp_tp_2);
              if tmp_tp = nil then
                tpar.con := tmp_tp_2
              else
                tmp_tp^.con := tmp_tp_2;
              tmp_tp := tmp_tp_2;
              with tmp_tp^ do
                begin
                dlm := chr(0);
                nxt := nil; con := nil;
                len := col-1;
                ch_copy(line^.str^,1,line^.used,str,1,len,' ');
                end;
              end;
            end;
        tpar_substitute := true;
        end
      else
        begin screen_message(msg_no_such_span); goto 99; end;
      end;
   99:
    end; {tpar_substitute}

  function tpar_enquire (var tpar : tpar_object) : boolean;

    var
      name : name_str;

    function find_enquiry(
                    name   : name_str;
            var     result : str_object;
            var     reslen : strlen_range)
            : boolean;

      var
        variable_type : (unknown,terminal,frame,opsys,ludwig);
        item          : name_str;
        i,j           : integer;
        len           : strlen_range;
{#if vms}
{##        numstr        : number_str;}
{#endif}
{#if msdos}
{##        tmp_str       : string;}
{#endif}

      begin {find_enquiry}
      find_enquiry := false;
      variable_type := unknown;
      item := '                               ';
      i := 1;
{#if ISO1}
      len := ch_length(name,name_len);
{#else}
{##      len := ch_length_name(name,name_len);}
{#endif}
      while (i < len) and (name[i] <> '-') do
        begin
        item[i] := ch_upcase_chr(name[i]);
        i := i+1;
        end;
      if name[i] = '-' then
        begin
        i := i + 1;
        if item = 'TERMINAL                       ' then
          variable_type := terminal
        else if item = 'FRAME                          ' then
          variable_type := frame
{#if vms}
{##        else if item = 'LNM                            ' then}
{##          variable_type := opsys}
{#elseif unix or fpc}
        else if item = 'ENV                            ' then
          variable_type := opsys
{#endif}
        else if item = 'LUDWIG                         ' then
          variable_type := ludwig;
        item := '                               ';
        j := 1;
        while i <= len do
          begin
          if variable_type = opsys then
            item[j] := name[i]
          else
            item[j] := ch_upcase_chr(name[i]);
          i := i+1;
          j := j+1;
          end;
        case variable_type of
          terminal :
            begin
            find_enquiry := true;
            if item = 'NAME                           ' then
              begin
              reslen := terminal_info.namelen;
              ch_copy(terminal_info.name^,1,reslen,result,1,max_strlen,' ');
              end
            else if item = 'HEIGHT                         ' then
              begin
{#if vms}
{##              vms_check_status(ots$cvt_l_ti(terminal_info.height,numstr));}
{##              reslen := 20;}
{##              while numstr[21-reslen] = ' ' do reslen := reslen-1;}
{##              ch_copy(numstr,21-reslen,reslen,result,1,max_strlen,' ');}
{#else}
              if not cvt_int_str(terminal_info.height,result,20) then
{#if msdos}
{##                screen_msdos_message('Integer conversion failed.');}
{#else}
                screen_message('Integer conversion failed.');
{#endif}
              reslen := 1;
              while (ord(result[reslen])<>0) do
                reslen := reslen+1;
              {back up over the chr(nul)}
              reslen := reslen - 1;
{#endif}
              end
            else if item = 'WIDTH                          ' then
              begin
{#if vms}
{##              vms_check_status(ots$cvt_l_ti(terminal_info.width,numstr));}
{##              reslen := 20;}
{##              while numstr[21-reslen] = ' ' do reslen := reslen-1;}
{##              ch_copy(numstr,21-reslen,reslen,result,1,max_strlen,' ');}
{#else}
              if not cvt_int_str(terminal_info.width,result,20) then
{#if msdos}
{##                screen_msdos_message('Integer conversion failed.');}
{#else}
                screen_message('Integer conversion failed.');
{#endif}
              reslen := 1;
              while (ord(result[reslen])<>0) do
                reslen := reslen+1;
              {back up over the chr(nul)}
              reslen := reslen - 1;
{#endif}
              end
            else if item = 'SPEED                          ' then
              begin
{#if vms}
{##              vms_check_status(ots$cvt_l_ti(terminal_info.speed,numstr));}
{##              reslen := 20;}
{##              while numstr[21-reslen] = ' ' do reslen := reslen-1;}
{##              ch_copy(numstr,21-reslen,reslen,result,1,max_strlen,' ');}
{#else}
              if not cvt_int_str(terminal_info.speed,result,20) then
{#if msdos}
{##                screen_msdos_message('Integer conversion failed.');}
{#else}
                screen_message('Integer conversion failed.');
{#endif}
              reslen := 1;
              while (ord(result[reslen])<>0) do
                reslen := reslen+1;
              {back up over the chr(nul)}
              reslen := reslen - 1;
{#endif}
              end
            else
              find_enquiry := false;
            end;
          frame :
            begin
            find_enquiry := true;
            if item = 'NAME                           ' then
              begin
{#if ISO1}
              reslen := ch_length(current_frame^.span^.name,name_len);
              ch_copy(current_frame^.span^.name,1,reslen,result,1,max_strlen,' ');
{#else}
{##              reslen := ch_length_name(current_frame^.span^.name,name_len);}
{##              ch_copy_name_str(current_frame^.span^.name,1,reslen,result,1,max_strlen,' ');}
{#endif}
              end
            else if item = 'INPUTFILE                      ' then
              begin
              if current_frame^.input_file = 0 then
                reslen := 0
              else
                begin
                reslen := files[current_frame^.input_file]^.fns;
{#if ISO1}
                ch_copy(files[current_frame^.input_file]^.fnm,1,reslen,result,1,max_strlen,' ');
{#else}
{##                ch_copy_fnm_str(files[current_frame^.input_file]^.fnm,1,reslen,result,1,max_strlen,' ');}
{#endif}
                end
              end
            else if item = 'OUTPUTFILE                     ' then
              begin
              if current_frame^.output_file = 0 then
                reslen := 0
              else
                begin
                reslen := files[current_frame^.output_file]^.fns;
{#if ISO1}
                ch_copy(files[current_frame^.output_file]^.fnm,1,reslen,result,1,max_strlen,' ');
{#else}
{##                ch_copy_fnm_str(files[current_frame^.output_file]^.fnm,1,reslen,result,1,max_strlen,' ');}
{#endif}
                end
              end
            else if item = 'MODIFIED                       ' then
              begin
              reslen := 1;
              if current_frame^.text_modified then
                result[1] := 'Y'
              else
                result[1] := 'N';
              end
            else
              find_enquiry := false;
            end;
          opsys :
            begin
{#if vms}
{##            find_enquiry := lib$sys_trnlog(}
{##                                 substr(item,1,ch_length(item,name_len)),}
{##                                 reslen,result) = 1;}
{#elseif unix or fpc}
            find_enquiry := get_environment(item,reslen,result);
{#endif}
            end;
          ludwig :
            begin
            find_enquiry := true;
            if item = 'VERSION                        ' then
              begin
              reslen := 8;
{#if ISO1}
              ch_copy(ludwig_version,1,reslen,result,1,max_strlen,' ');
{#else}
{##              ch_copy_name_str(ludwig_version,1,reslen,result,1,max_strlen,' ');}
{#endif}
              end
            else if item = 'OPSYS                          ' then
              begin
{#if vms}
{##              reslen := 3;}
{##              result := 'VMS';}
{#elseif unix}
{##              reslen := 4;}
{##              result := 'Unix';}
{#elseif msdos}
{##              reslen := 6;}
{##              fillchar(result[1], sizeof(result), ' ');}
{##              tmp_str := 'MS-DOS';}
{##              move(tmp_str[1], result[1], length(tmp_str));}
{#elseif fpc}
              reslen := 9;
              result := 'fpc/Linux';
{#else}
{##              reslen := 7;}
{##              result := 'Unknown';}
{#endif}
              end
            else if item = 'COMMAND_INTRODUCER             ' then
              begin
              if not (command_introducer in printable_set) then
                begin
                reslen := 0;
                screen_message(msg_nonprintable_introducer);
                end
              else
                begin
                reslen := 1;
                result[1] := chr(command_introducer);
                end
              end
            else if item = 'INSERT_MODE                    ' then
              begin
              reslen := 1;
              if    (edit_mode = mode_insert)
                 or (    (edit_mode = mode_command)
                     and (previous_mode = mode_insert)) then
                result[1] := 'Y'
              else
                result[1] := 'N';
              end
            else if item = 'OVERTYPE_MODE                  ' then
              begin
              reslen := 1;
              if    (edit_mode = mode_overtype)
                 or (    (edit_mode = mode_command)
                     and (previous_mode = mode_overtype)) then
                result[1] := 'Y'
              else
                result[1] := 'N';
              end
            else
              find_enquiry := false;
            end;
          unknown :
        end;
        end;
      end;  {find_enquiry}

    begin {tpar_enquire}
    tpar_enquire := false;
    with tpar do
      begin
      dlm := chr(0);
{#if ISO1}
      ch_copy(str,1,len,name,1,name_len,' ');     { Get the Enquiry name }
{#else}
{##      ch_copy_str_name(str,1,len,name,1,name_len,' ');     #< Get the Enquiry name #>}
{#endif}
      if find_enquiry(name,str,len) then
        tpar_enquire := true
      else
        begin
        screen_message(msg_unknown_item);
        exit_abort := true;
        end;
      end;
    end; {tpar_enquire}

  begin {tpar_analyse}
  tpar_analyse := false;
  ended := false;
  if depth > max_tpar_recursion then
    begin screen_message(msg_tpar_too_deep); goto 99; end;
  with tran do
    begin
    if not (dlm in [tpd_smart,tpd_exact,tpd_lit]) then
      repeat
        delim := dlm;    { Save copy of delimiter in case of recursive call. }
        if con = nil then
          begin
          if len > 1 then
            begin
            if (str[1] = str[len]) and
               (str[1] in [tpd_span,tpd_prompt,tpd_environment,
                           tpd_smart,tpd_exact,tpd_lit]) then
              {nested delimiters}
              begin
              dlm := str[1];
              len := len - 2;
              ch_move(str,2,str,1,len);
              if not tpar_analyse(cmd,tran,depth+1,this_tp) then goto 99;
              end;
            end;
          end
        else
          begin
          tmp_tp:= tran.con;
          while tmp_tp^.con <> nil do
            tmp_tp:= tmp_tp^.con;
          if (len <> 0) and (tmp_tp^.len <> 0) then
            if (str[1] = tmp_tp^.str[tmp_tp^.len]) and
               (str[1] in [tpd_span,tpd_prompt,tpd_environment,
                           tpd_smart,tpd_exact,tpd_lit]) then
              {nested delimiters}
              begin
              dlm := str[1];
              len := len - 1;
              ch_move(str,2,str,1,len);
              tmp_tp^.len := tmp_tp^.len - 1;
              if not tpar_analyse(cmd,tran,depth+1,this_tp) then goto 99;
              end;
          end;
        if delim = tpd_span then
          begin
          if not tpar_substitute(tran) then goto 99;
          end
        else
        if delim = tpd_environment then
          if file_data.old_cmds then
            begin
            screen_message(msg_reserved_tpd);
            goto 99;
            end
          else
            begin
            if not tpar_enquire(tran) then goto 99;
            end
        else
        if delim = tpd_prompt then
          if ludwig_mode <> ludwig_batch then
            begin
            if cmd = cmd_verify then
              begin
              if len = 0 then
                with cmd_attrib[cmd].tpar_info[this_tp] do
                  begin
{#if ISO1}
                  ch_move(dflt_prompts[prompt_name],1,buffer,1,tpar_prom_len);
{#else}
{##                  ch_move_prompt_str(dflt_prompts[prompt_name],1,buffer,1,}
{##                                     tpar_prom_len);}
{#endif}
                  verify_reply := screen_verify(buffer,tpar_prom_len);
                  end
              else
                verify_reply := screen_verify(str,len);
              case verify_reply of
                verify_reply_yes    : str[1] := 'Y';
                verify_reply_no     : str[1] := 'N';
                verify_reply_always : str[1] := 'A';
                verify_reply_quit   : str[1] := 'Q';
              end{case};
              len := 1;
              end
            else
              if len = 0 then
                {change first str and len with cmd values}
                with cmd_attrib[cmd].tpar_info[this_tp] do
                  begin
{#if ISO1}
                  ch_move(dflt_prompts[prompt_name],1,buffer,1,tpar_prom_len);
{#else}
{##                  ch_move_prompt_str(dflt_prompts[prompt_name],1,buffer,1,}
{##                                     tpar_prom_len);}
{#endif}
                  screen_getlinep(buffer,tpar_prom_len,
                                  str,len,cmd_attrib[cmd].tpcount,this_tp);
                  end
              else
                begin
                if con <> nil then
                  begin
                  screen_message(msg_prompts_are_one_line);
                  goto 99;
                  end
                else
                  screen_getlinep(str,len,str,len,cmd_attrib[cmd].tpcount,
                                  this_tp);
                end;
            dlm := chr(0);
            end
          else
            begin
            screen_message(msg_interactive_mode_only);
            goto 99;
            end
        else
          ended := true;
      until ended or tt_controlc;
    end;
  tpar_analyse := not tt_controlc;
 99:
  end; {tpar_analyse}


{}procedure trim (var request:tpar_object);

    var
      i : integer;

    begin {trim}
    if request.len > 0 then
      begin
      { Find first non-blank character }
      i := 0;
      repeat
        i := i + 1;
      until (request.str[i] <> ' ') or (i = request.len);
      with request do
        begin
        len := len-i+1;
        ch_copy(str,i,len,str,1,max_strlen,' ');
        ch_upcase_str(str,max_strlen);
        end;
      end;
    end; {trim}


function tpar_get_1 (
                tpar : tpar_ptr;
                cmd  : user_commands;
        var     tran : tpar_object)
        : boolean;

  label 99;

  begin {tpar_get_1}
  tpar_get_1 := false;
{#if debug}
  if tpar = nil then
    begin screen_message(dbg_tpar_nil);  goto 99;  end;
{#endif}
  tpar_duplicate_con(tpar, tran);

  if tpar_analyse(cmd,tran,1,1) then
    begin
    if cmd_attrib[cmd].tpar_info[1].trim_reply then
      trim(tran);
    tpar_get_1 := true;
    end;
99:
  end; {tpar_get_1}


function tpar_get_2 (
                tpar : tpar_ptr;
                cmd  : user_commands;
        var     trn1,
                trn2 : tpar_object)
        : boolean;

  label 99;

  begin {tpar_get_2}
  tpar_get_2 := false;

{#if debug}
  if tpar = nil then
    begin screen_message(dbg_tpar_nil);  goto 99; end;
  if tpar^.nxt = nil then
    begin screen_message(dbg_tpar_nil);  goto 99; end;
{#endif}

  tpar_duplicate_con(tpar, trn1);
  tpar_duplicate_con(tpar^.nxt, trn2);

  if not tpar_analyse(cmd,trn1,1,1) then goto 99;
  if trn1.len <> 0 then
    if not tpar_analyse(cmd,trn2,1,2) then goto 99;
  if cmd_attrib[cmd].tpar_info[1].trim_reply then
    trim(trn1);
  if cmd_attrib[cmd].tpar_info[2].trim_reply then
    trim(trn2);
  tpar_get_2 := true;
99:
  end; {tpar_get_2}

{#if vms or turbop}
end.
{#endif}
