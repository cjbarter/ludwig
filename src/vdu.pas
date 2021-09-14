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
{       Martin Sandiford (2002); and                                   }
{       Jeff Blows (2020).                                             }
{                                                                      }
{  Copyright  2002, 2020 University of Adelaide                        }
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
! Name:         VDU
!
! Description:  This module does all the complex control of the VDU type
!               screens that Ludwig demands.
!               This is the Free Pascal version.
!
! $Header$
!--}

{#if fpc}

unit vdu;



interface
  uses value;
  {$I vdu.i}



implementation


uses
  ncurses, termio, strings;


const
  bs  =   8;
  cr  =  13;
  spc =  32;
  del = 127;

  out_m_cleareol = 1;
  (* These min/max values define the range of "normal" keycodes *)
  min_normal_code   = 0;
  max_normal_code   = ord_maxchar;
  (* This is how many curses keys we know about *)
  num_ncurses_keys  = (KEY_RESIZE - KEY_MIN) + 1;
  ncurses_subtract  = KEY_MIN - 1;
  massaged_min      = ncurses_subtract - KEY_RESIZE;
  num_control_chars = 33; { 0..31 and 127 }



var
  control_chars  : set of 0..ord_maxchar;
  terminators    : set of 0..ord_maxchar;
  vdu_setup      : boolean;
  in_insert_mode : boolean;



{}function massage_key(key_code : longint) : key_code_range;
begin {massage_key}
  if (key_code >= min_normal_code) and (key_code <= max_normal_code) then
    massage_key := key_code_range(key_code)
  else if (key_code >= KEY_MIN) and (key_code <= KEY_RESIZE) then
  begin
    if key_code = KEY_BACKSPACE then
      massage_key := del
    else
      massage_key := key_code_range(ncurses_subtract - key_code)
  end
  else
    massage_key := 0
end; {massage_key}


{}function unmassage_key(key : key_code_range) : longint;
begin {unmassage_key}
  if (key >= min_normal_code) and (key <= max_normal_code) then
    unmassage_key := longint(key)
  else if (key < min_normal_code) and (key >= massaged_min) then
    unmassage_key := ncurses_subtract - longint(key)
  else
    unmassage_key := 0
end; {unmassage_key}


procedure vdu_movecurs (
                x,
                y : scr_col_range);

begin {vdu_movecurs}
  move(y - 1, x - 1);
end; {vdu_movecurs}


procedure vdu_flush (
                wait : boolean);
begin {vdu_flush}
  refresh;
end; {vdu_flush}


procedure vdu_beep {};

begin {vdu_beep}
  if ERR = flash then
    beep;
end; {vdu_beep}


procedure vdu_cleareol {};

begin {vdu_cleareol}
  clrtoeol;
  vdu_flush(false)
end; {vdu_cleareol}


procedure vdu_displaystr (
                strlen : scr_col_range;
         var    str    : char;
                opts   : integer);

var
  maxlen    : integer;
  hitmargin : boolean;

begin {vdu_displaystr}
  maxlen := COLS - getcurx(stdscr);
  if strlen >= maxlen then
  begin
    strlen := maxlen;
    hitmargin := true
  end
  else
    hitmargin := false;
  addnstr(@str, strlen);
  if (not hitmargin) and ((opts and out_m_cleareol) <> 0) then
    vdu_cleareol;
  vdu_flush(false)
end; {vdu_displaystr}


procedure vdu_displaych (
                ch : char);

begin {vdu_displaych}
  addch(longint(ch))
end; {vdu_displaych}


procedure vdu_clearscr {};

begin {vdu_clearscr}
  clear
end; {vdu_clearscr}


procedure vdu_cleareos {};

begin {vdu_cleareos}
  clrtobot
end; {vdu_cleareos}


procedure vdu_redrawscr {};

begin {vdu_redrawscr}
  touchwin(stdscr);
{ FIXME  clearok(stdscr, byte(true))}
end; {vdu_redrawscr}


procedure vdu_scrollup (
                n : integer);

begin {vdu_scrollup}
  scrollok(stdscr, true);
  scrl(n);
  scrollok(stdscr, false)
end; {vdu_scrollup}


procedure vdu_deletelines (
                n         : integer;
                clear_eos : boolean);

begin {vdu_deletelines}
  insdelln(-n);
  (* From what I can tell, clear_eos appears to be false if it is not
   * required that the lines that have been cleared are blanked.
   * With (n)?curses, the lines are always blanked, so we ignore this
   * flag.
  if clear_eos and we_didnt_clear then
    vdu_cleareos;
   *)
  vdu_flush(false)
end; {vdu_deletelines}


procedure vdu_insertlines (
                n     : integer);

begin {vdu_deletelines}
  insdelln(n);
  vdu_flush(false)
end; {vdu_deletelines}


procedure vdu_insertchars (
                n : scr_col_range);

var
  i :  integer;

begin {vdu_insertchars}
  for i := 1 to n do
    insch(longint(' '));
  vdu_flush(false)
end; {vdu_insertchars}


procedure vdu_deletechars (
                n : scr_col_range);

var
  i :  integer;

begin {vdu_deletechars}
  for i := 1 to n do
    delch;
  vdu_flush(false)
end; {vdu_deletechars}


procedure vdu_displaycrlf {};

var
  y : integer;

begin {vdu_displaycrlf}
  y := getcury(stdscr);
  if y = LINES - 1 then
    vdu_scrollup(1)
  else
    y := y + 1;
  move(y, 0);
  vdu_flush(false)
end; {vdu_displaycrlf}


procedure vdu_take_back_key (
                key : key_code_range);

begin {vdu_take_back_key}
  ungetch(unmassage_key(key))
end; {vdu_take_back_key}


procedure vdu_new_introducer (
                key : key_code_range);

begin {vdu_new_introducer}
  terminators := control_chars;
  if key > 0 then
    terminators := terminators + [key]
end; {vdu_new_introducer}


function vdu_get_key 
        : key_code_range;

var
  raw_key : LongInt;

begin {vdu_get_key}
  vdu_flush(true);
  repeat
    raw_key := getch();
  until raw_key <> ERR;
  vdu_get_key := massage_key(raw_key)
end; {vdu_get_key}



procedure vdu_get_input (
        var     prompt     : str_object;
                prompt_len : strlen_range;
        var     get        : str_object;
                get_len    : strlen_range;
        var     outlen     : strlen_range);

var
  key    : key_code_range;
  maxlen : integer;

begin {vdu_get_input}
  vdu_displaystr(prompt_len, prompt[1], out_m_cleareol);
  fillchar(get[1], sizeof(get), ' ');

  outlen := 0;
  maxlen := COLS - getcurx(stdscr);
  if get_len > maxlen then
    get_len := maxlen;

  key := vdu_get_key;
  while (get_len > 0) and (key <> cr) do
  begin
    if (outlen > 0) and ((key = bs) or (key = del)) then
    begin
      inc(get_len);
      dec(outlen);
      addch(bs);
      addch(spc);
      addch(bs);
    end
    else
    begin
      if (key < 0) or (key in control_chars) then
      begin
        vdu_beep;
      end
      else
      begin
        dec(get_len);
        inc(outlen);
        get[outlen] := chr(key);
        addch(longint(key));
      end;
    end;
    key := vdu_get_key;
  end;
end; {vdu_get_input}


procedure vdu_insert_mode (
                turn_on : boolean);

begin {vdu_insert_mode}
  in_insert_mode := turn_on
end; {vdu_insert_mode}


procedure vdu_get_text (
                str_len : integer;
        var     str     : str_object;
        var     outlen  : strlen_range);

var
  key    : key_code_range;
  maxlen : integer;

begin {vdu_get_text}
  fillchar(str[1], sizeof(str), ' ');
  vdu_flush(false);

  outlen := 0;
  maxlen := COLS - getcurx(stdscr);
  if str_len > maxlen then
    str_len := maxlen;

  while (str_len > 0) do
  begin
    key := vdu_get_key;
    if (key < 0) or (key in terminators) then
    begin
      vdu_take_back_key(key);
      str_len := 0
    end
    else
    begin
      if in_insert_mode then
        vdu_insertchars(1);
      addch(longint(key));
      refresh;
      outlen := outlen + 1;
      str[outlen] := chr(key);
      str_len := str_len - 1
    end;
  end;
end; {vdu_get_text}


procedure vdu_keyboard_init (
        var     nr_key_names      : key_names_range;
        var     key_name_list_ptr : key_name_array_ptr;
        var     key_introducers   : accept_set_type;
        var     terminal_info     : terminal_info_type);

var
  i : integer;

begin {vdu_keyboard_init}
  nr_key_names := num_control_chars + num_ncurses_keys;
  getmem(key_name_list_ptr, (nr_key_names + 1) * sizeof(key_name_record));

  for i := 1 to num_control_chars - 1 do
    key_name_list_ptr^[i].key_code := key_code_range(i - 1);
  key_name_list_ptr^[ 1].key_name := 'CONTROL-@                               ';
  key_name_list_ptr^[ 2].key_name := 'CONTROL-A                               ';
  key_name_list_ptr^[ 3].key_name := 'CONTROL-B                               ';
  key_name_list_ptr^[ 4].key_name := 'CONTROL-C                               ';
  key_name_list_ptr^[ 5].key_name := 'CONTROL-D                               ';
  key_name_list_ptr^[ 6].key_name := 'CONTROL-E                               ';
  key_name_list_ptr^[ 7].key_name := 'CONTROL-F                               ';
  key_name_list_ptr^[ 8].key_name := 'CONTROL-G                               ';
  key_name_list_ptr^[ 9].key_name := 'BACKSPACE                               ';
  key_name_list_ptr^[10].key_name := 'TAB                                     ';
  key_name_list_ptr^[11].key_name := 'LINE-FEED                               ';
  key_name_list_ptr^[12].key_name := 'CONTROL-K                               ';
  key_name_list_ptr^[13].key_name := 'CONTROL-L                               ';
  key_name_list_ptr^[14].key_name := 'RETURN                                  ';
  key_name_list_ptr^[15].key_name := 'CONTROL-N                               ';
  key_name_list_ptr^[16].key_name := 'CONTROL-O                               ';
  key_name_list_ptr^[17].key_name := 'CONTROL-P                               ';
  key_name_list_ptr^[18].key_name := 'CONTROL-Q                               ';
  key_name_list_ptr^[19].key_name := 'CONTROL-R                               ';
  key_name_list_ptr^[20].key_name := 'CONTROL-S                               ';
  key_name_list_ptr^[21].key_name := 'CONTROL-T                               ';
  key_name_list_ptr^[22].key_name := 'CONTROL-U                               ';
  key_name_list_ptr^[23].key_name := 'CONTROL-V                               ';
  key_name_list_ptr^[24].key_name := 'CONTROL-W                               ';
  key_name_list_ptr^[25].key_name := 'CONTROL-X                               ';
  key_name_list_ptr^[26].key_name := 'CONTROL-Y                               ';
  key_name_list_ptr^[27].key_name := 'CONTROL-Z                               ';
  key_name_list_ptr^[28].key_name := 'CONTROL-[                               ';
  key_name_list_ptr^[29].key_name := 'CONTROL-\                               ';
  key_name_list_ptr^[30].key_name := 'CONTROL-]                               ';
  key_name_list_ptr^[31].key_name := 'CONTROL-^                               ';
  key_name_list_ptr^[32].key_name := 'CONTROL-_                               ';
  with key_name_list_ptr^[33] do
  begin
    key_name_list_ptr^[33].key_code := key_code_range(del);
    key_name_list_ptr^[33].key_name := 'DELETE                                  ';
  end;

  for i := KEY_MIN to KEY_RESIZE do
    key_name_list_ptr^[num_control_chars + 1 + i - KEY_MIN].key_code := massage_key(i);
  key_name_list_ptr^[num_control_chars+  1].key_name := 'BREAK                                   ';
  key_name_list_ptr^[num_control_chars+  2].key_name := 'DOWN-ARROW                              ';
  key_name_list_ptr^[num_control_chars+  3].key_name := 'UP-ARROW                                ';
  key_name_list_ptr^[num_control_chars+  4].key_name := 'LEFT-ARROW                              ';
  key_name_list_ptr^[num_control_chars+  5].key_name := 'RIGHT-ARROW                             ';
  key_name_list_ptr^[num_control_chars+  6].key_name := 'HOME                                    ';
  key_name_list_ptr^[num_control_chars+  7].key_name := 'BACKSPACE                               ';
  key_name_list_ptr^[num_control_chars+  8].key_name := 'FUNCTION-0                              ';
  key_name_list_ptr^[num_control_chars+  9].key_name := 'FUNCTION-1                              ';
  key_name_list_ptr^[num_control_chars+ 10].key_name := 'FUNCTION-2                              ';
  key_name_list_ptr^[num_control_chars+ 11].key_name := 'FUNCTION-3                              ';
  key_name_list_ptr^[num_control_chars+ 12].key_name := 'FUNCTION-4                              ';
  key_name_list_ptr^[num_control_chars+ 13].key_name := 'FUNCTION-5                              ';
  key_name_list_ptr^[num_control_chars+ 14].key_name := 'FUNCTION-6                              ';
  key_name_list_ptr^[num_control_chars+ 15].key_name := 'FUNCTION-7                              ';
  key_name_list_ptr^[num_control_chars+ 16].key_name := 'FUNCTION-8                              ';
  key_name_list_ptr^[num_control_chars+ 17].key_name := 'FUNCTION-9                              ';
  key_name_list_ptr^[num_control_chars+ 18].key_name := 'FUNCTION-10                             ';
  key_name_list_ptr^[num_control_chars+ 19].key_name := 'FUNCTION-11                             ';
  key_name_list_ptr^[num_control_chars+ 20].key_name := 'FUNCTION-12                             ';
  key_name_list_ptr^[num_control_chars+ 21].key_name := 'SHIFT-FUNCTION-1                        ';
  key_name_list_ptr^[num_control_chars+ 22].key_name := 'SHIFT-FUNCTION-2                        ';
  key_name_list_ptr^[num_control_chars+ 23].key_name := 'SHIFT-FUNCTION-3                        ';
  key_name_list_ptr^[num_control_chars+ 24].key_name := 'SHIFT-FUNCTION-4                        ';
  key_name_list_ptr^[num_control_chars+ 25].key_name := 'SHIFT-FUNCTION-5                        ';
  key_name_list_ptr^[num_control_chars+ 26].key_name := 'SHIFT-FUNCTION-6                        ';
  key_name_list_ptr^[num_control_chars+ 27].key_name := 'SHIFT-FUNCTION-7                        ';
  key_name_list_ptr^[num_control_chars+ 28].key_name := 'SHIFT-FUNCTION-8                        ';
  key_name_list_ptr^[num_control_chars+ 29].key_name := 'SHIFT-FUNCTION-9                        ';
  key_name_list_ptr^[num_control_chars+ 30].key_name := 'SHIFT-FUNCTION-10                       ';
  key_name_list_ptr^[num_control_chars+ 31].key_name := 'SHIFT-FUNCTION-11                       ';
  key_name_list_ptr^[num_control_chars+ 32].key_name := 'SHIFT-FUNCTION-12                       ';
  key_name_list_ptr^[num_control_chars+ 33].key_name := 'FUNCTION-25                             ';
  key_name_list_ptr^[num_control_chars+ 34].key_name := 'FUNCTION-26                             ';
  key_name_list_ptr^[num_control_chars+ 35].key_name := 'FUNCTION-27                             ';
  key_name_list_ptr^[num_control_chars+ 36].key_name := 'FUNCTION-28                             ';
  key_name_list_ptr^[num_control_chars+ 37].key_name := 'FUNCTION-29                             ';
  key_name_list_ptr^[num_control_chars+ 38].key_name := 'FUNCTION-30                             ';
  key_name_list_ptr^[num_control_chars+ 39].key_name := 'FUNCTION-31                             ';
  key_name_list_ptr^[num_control_chars+ 40].key_name := 'FUNCTION-32                             ';
  key_name_list_ptr^[num_control_chars+ 41].key_name := 'FUNCTION-33                             ';
  key_name_list_ptr^[num_control_chars+ 42].key_name := 'FUNCTION-34                             ';
  key_name_list_ptr^[num_control_chars+ 43].key_name := 'FUNCTION-35                             ';
  key_name_list_ptr^[num_control_chars+ 44].key_name := 'FUNCTION-36                             ';
  key_name_list_ptr^[num_control_chars+ 45].key_name := 'FUNCTION-37                             ';
  key_name_list_ptr^[num_control_chars+ 46].key_name := 'FUNCTION-38                             ';
  key_name_list_ptr^[num_control_chars+ 47].key_name := 'FUNCTION-39                             ';
  key_name_list_ptr^[num_control_chars+ 48].key_name := 'FUNCTION-40                             ';
  key_name_list_ptr^[num_control_chars+ 49].key_name := 'FUNCTION-41                             ';
  key_name_list_ptr^[num_control_chars+ 50].key_name := 'FUNCTION-42                             ';
  key_name_list_ptr^[num_control_chars+ 51].key_name := 'FUNCTION-43                             ';
  key_name_list_ptr^[num_control_chars+ 52].key_name := 'FUNCTION-44                             ';
  key_name_list_ptr^[num_control_chars+ 53].key_name := 'FUNCTION-45                             ';
  key_name_list_ptr^[num_control_chars+ 54].key_name := 'FUNCTION-46                             ';
  key_name_list_ptr^[num_control_chars+ 55].key_name := 'FUNCTION-47                             ';
  key_name_list_ptr^[num_control_chars+ 56].key_name := 'FUNCTION-48                             ';
  key_name_list_ptr^[num_control_chars+ 57].key_name := 'FUNCTION-49                             ';
  key_name_list_ptr^[num_control_chars+ 58].key_name := 'FUNCTION-50                             ';
  key_name_list_ptr^[num_control_chars+ 59].key_name := 'FUNCTION-51                             ';
  key_name_list_ptr^[num_control_chars+ 60].key_name := 'FUNCTION-52                             ';
  key_name_list_ptr^[num_control_chars+ 61].key_name := 'FUNCTION-53                             ';
  key_name_list_ptr^[num_control_chars+ 62].key_name := 'FUNCTION-54                             ';
  key_name_list_ptr^[num_control_chars+ 63].key_name := 'FUNCTION-55                             ';
  key_name_list_ptr^[num_control_chars+ 64].key_name := 'FUNCTION-56                             ';
  key_name_list_ptr^[num_control_chars+ 65].key_name := 'FUNCTION-57                             ';
  key_name_list_ptr^[num_control_chars+ 66].key_name := 'FUNCTION-58                             ';
  key_name_list_ptr^[num_control_chars+ 67].key_name := 'FUNCTION-59                             ';
  key_name_list_ptr^[num_control_chars+ 68].key_name := 'FUNCTION-60                             ';
  key_name_list_ptr^[num_control_chars+ 69].key_name := 'FUNCTION-61                             ';
  key_name_list_ptr^[num_control_chars+ 70].key_name := 'FUNCTION-62                             ';
  key_name_list_ptr^[num_control_chars+ 71].key_name := 'FUNCTION-63                             ';
  key_name_list_ptr^[num_control_chars+ 72].key_name := 'DELETE-LINE                             ';
  key_name_list_ptr^[num_control_chars+ 73].key_name := 'INSERT-LINE                             ';
  key_name_list_ptr^[num_control_chars+ 74].key_name := 'DELETE-CHAR                             ';
  key_name_list_ptr^[num_control_chars+ 75].key_name := 'INSERT-CHAR                             ';
  key_name_list_ptr^[num_control_chars+ 76].key_name := 'EIC                                     ';
  key_name_list_ptr^[num_control_chars+ 77].key_name := 'CLEAR                                   ';
  key_name_list_ptr^[num_control_chars+ 78].key_name := 'CLEAR-EOS                               ';
  key_name_list_ptr^[num_control_chars+ 79].key_name := 'CLEAR-EOL                               ';
  key_name_list_ptr^[num_control_chars+ 80].key_name := 'SCROLL-FORWARD                          ';
  key_name_list_ptr^[num_control_chars+ 81].key_name := 'SCROLL-REVERSE                          ';
  key_name_list_ptr^[num_control_chars+ 82].key_name := 'PAGE-DOWN                               ';
  key_name_list_ptr^[num_control_chars+ 83].key_name := 'PAGE-UP                                 ';
  key_name_list_ptr^[num_control_chars+ 84].key_name := 'SET-TAB                                 ';
  key_name_list_ptr^[num_control_chars+ 85].key_name := 'CLEAR-TAB                               ';
  key_name_list_ptr^[num_control_chars+ 86].key_name := 'CLEAR-ALL-TABS                          ';
  key_name_list_ptr^[num_control_chars+ 87].key_name := 'SEND                                    ';
  key_name_list_ptr^[num_control_chars+ 88].key_name := 'SOFT-RESET                              ';
  key_name_list_ptr^[num_control_chars+ 89].key_name := 'RESET                                   ';
  key_name_list_ptr^[num_control_chars+ 90].key_name := 'PRINT                                   ';
  key_name_list_ptr^[num_control_chars+ 91].key_name := 'LOWER-LEFT                              ';
  key_name_list_ptr^[num_control_chars+ 92].key_name := 'KEY-A1                                  ';
  key_name_list_ptr^[num_control_chars+ 93].key_name := 'KEY-A3                                  ';
  key_name_list_ptr^[num_control_chars+ 94].key_name := 'KEY-B2                                  ';
  key_name_list_ptr^[num_control_chars+ 95].key_name := 'KEY-C1                                  ';
  key_name_list_ptr^[num_control_chars+ 96].key_name := 'KEY-C3                                  ';
  key_name_list_ptr^[num_control_chars+ 97].key_name := 'BACK-TAB                                ';
  key_name_list_ptr^[num_control_chars+ 98].key_name := 'BEGIN                                   ';
  key_name_list_ptr^[num_control_chars+ 99].key_name := 'CANCEL                                  ';
  key_name_list_ptr^[num_control_chars+100].key_name := 'CLOSE                                   ';
  key_name_list_ptr^[num_control_chars+101].key_name := 'COMMAND                                 ';
  key_name_list_ptr^[num_control_chars+102].key_name := 'COPY                                    ';
  key_name_list_ptr^[num_control_chars+103].key_name := 'CREATE                                  ';
  key_name_list_ptr^[num_control_chars+104].key_name := 'END                                     ';
  key_name_list_ptr^[num_control_chars+105].key_name := 'EXIT                                    ';
  key_name_list_ptr^[num_control_chars+106].key_name := 'FIND                                    ';
  key_name_list_ptr^[num_control_chars+107].key_name := 'HELP                                    ';
  key_name_list_ptr^[num_control_chars+108].key_name := 'MARK                                    ';
  key_name_list_ptr^[num_control_chars+109].key_name := 'MESSAGE                                 ';
  key_name_list_ptr^[num_control_chars+110].key_name := 'MOVE                                    ';
  key_name_list_ptr^[num_control_chars+111].key_name := 'NEXT                                    ';
  key_name_list_ptr^[num_control_chars+112].key_name := 'OPEN                                    ';
  key_name_list_ptr^[num_control_chars+113].key_name := 'OPTIONS                                 ';
  key_name_list_ptr^[num_control_chars+114].key_name := 'PREVIOUS                                ';
  key_name_list_ptr^[num_control_chars+115].key_name := 'REDO                                    ';
  key_name_list_ptr^[num_control_chars+116].key_name := 'REFERENCE                               ';
  key_name_list_ptr^[num_control_chars+117].key_name := 'REFRESH                                 ';
  key_name_list_ptr^[num_control_chars+118].key_name := 'REPLACE                                 ';
  key_name_list_ptr^[num_control_chars+119].key_name := 'RESTART                                 ';
  key_name_list_ptr^[num_control_chars+120].key_name := 'RESUME                                  ';
  key_name_list_ptr^[num_control_chars+121].key_name := 'SAVE                                    ';
  key_name_list_ptr^[num_control_chars+122].key_name := 'SHIFT-BEGIN                             ';
  key_name_list_ptr^[num_control_chars+123].key_name := 'SHIFT-CANCEL                            ';
  key_name_list_ptr^[num_control_chars+124].key_name := 'SHIFT-COMMAND                           ';
  key_name_list_ptr^[num_control_chars+125].key_name := 'SHIFT-COPY                              ';
  key_name_list_ptr^[num_control_chars+126].key_name := 'SHIFT-CREATE                            ';
  key_name_list_ptr^[num_control_chars+127].key_name := 'SHIFT-DELETE-CHAR                       ';
  key_name_list_ptr^[num_control_chars+128].key_name := 'SHIFT-DELETE-LINE                       ';
  key_name_list_ptr^[num_control_chars+129].key_name := 'SELECT                                  ';
  key_name_list_ptr^[num_control_chars+130].key_name := 'SEND                                    ';
  key_name_list_ptr^[num_control_chars+131].key_name := 'SHIFT-CLEAR-EOL                         ';
  key_name_list_ptr^[num_control_chars+132].key_name := 'SHIFT-EXIT                              ';
  key_name_list_ptr^[num_control_chars+133].key_name := 'SHIFT-FIND                              ';
  key_name_list_ptr^[num_control_chars+134].key_name := 'SHIFT-HELP                              ';
  key_name_list_ptr^[num_control_chars+135].key_name := 'SHIFT-HOME                              ';
  key_name_list_ptr^[num_control_chars+136].key_name := 'SHIFT-INSERT-CHAR                       ';
  key_name_list_ptr^[num_control_chars+137].key_name := 'SHIFT-LEFT                              ';
  key_name_list_ptr^[num_control_chars+138].key_name := 'SHIFT-MESSAGE                           ';
  key_name_list_ptr^[num_control_chars+139].key_name := 'SHIFT-MOVE                              ';
  key_name_list_ptr^[num_control_chars+140].key_name := 'SHIFT-NEXT                              ';
  key_name_list_ptr^[num_control_chars+141].key_name := 'SHIFT-OPTIONS                           ';
  key_name_list_ptr^[num_control_chars+142].key_name := 'SHIFT-PREVIOUS                          ';
  key_name_list_ptr^[num_control_chars+143].key_name := 'SHIFT-PRINT                             ';
  key_name_list_ptr^[num_control_chars+144].key_name := 'SHIFT-REDO                              ';
  key_name_list_ptr^[num_control_chars+145].key_name := 'SHIFT-REPLACE                           ';
  key_name_list_ptr^[num_control_chars+146].key_name := 'SHIFT-RIGHT                             ';
  key_name_list_ptr^[num_control_chars+147].key_name := 'SHIFT-RESUME                            ';
  key_name_list_ptr^[num_control_chars+148].key_name := 'SHIFT-SAVE                              ';
  key_name_list_ptr^[num_control_chars+149].key_name := 'SHIFT-SUSPEND                           ';
  key_name_list_ptr^[num_control_chars+150].key_name := 'SHIFT-UNDO                              ';
  key_name_list_ptr^[num_control_chars+151].key_name := 'SUSPEND                                 ';
  key_name_list_ptr^[num_control_chars+152].key_name := 'UNDO                                    ';
  key_name_list_ptr^[num_control_chars+153].key_name := 'MOUSE                                   ';
  key_name_list_ptr^[num_control_chars+154].key_name := 'WINDOW-RESIZE-EVENT                     ';

  key_introducers := [];

  with terminal_info do
  begin
    name := str_ptr(termname);
    namelen := strlen(termname);
    width := COLS;
    height := LINES
  end
end; {vdu_keyboard_init}


function vdu_init (
                outbuflen     : integer;
        var     capabilities  : terminal_capabilities;
        var     terminal_info : terminal_info_type;
        var     ctrl_c_flag   : boolean;
        var     winchange_flag: boolean)
        : boolean;

begin {vdu_init}
  capabilities := [trmflags_v_hard];
  terminal_info.width := 80;
  terminal_info.height := 4;
  if (isatty(0) = 0) or (isatty(1) = 0) then
    vdu_init := false
  else
  begin
    vdu_setup := initscr <> nil;
    if vdu_setup then
    begin
      raw;
      noecho;
      nonl;
      intrflush(stdscr, false);
{#if NCURSESMOUSE}
      mousemask (ALL_MOUSE_EVENTS, nil);
{#endif}
      keypad(stdscr, true);
      idlok(stdscr, true);
      idcok(stdscr, true);
      scrollok(stdscr, false);
      terminal_info.width := COLS;
      terminal_info.height := LINES;
      capabilities := [
                       trmflags_v_clel, (* Clear to end of line *)
                       trmflags_v_cles, (* Clear to end of screen *)
                       trmflags_v_clsc, (* Clear screen *)
                       trmflags_v_dlch, (* Delete char *)
                       trmflags_v_dlln, (* Delete line *)
                       trmflags_v_inln, (* Insert line *)
                       trmflags_v_inch, (* Insert char *)
                       trmflags_v_scdn, (* Scroll down *)
                       trmflags_v_wrap  (* Wrap at margins *)
                      ];
      vdu_clearscr;
      vdu_flush(true);
      flushinp
    end;
    vdu_init := true
  end
end; {vdu_init}


procedure vdu_free {};

begin {vdu_free}
  if vdu_setup then
  begin
    vdu_scrollup(1);
    vdu_movecurs(1, LINES);
    vdu_flush(true);
    endwin
  end
end; {vdu_free}


procedure vdu_get_new_dimensions (
        var     new_x : scr_col_range;
        var     new_y : scr_row_range);

begin {vdu_get_new_dimensions}
  new_x := scr_col_range(COLS);
  new_y := scr_row_range(LINES)
end; {vdu_get_new_dimensions}



begin
  control_chars := [$00, $01, $02, $03, $04, $05, $06, $07,
                    $08, $09, $0A, $0B, $0C, $0D, $0E, $0F,
                    $10, $11, $12, $13, $14, $15, $16, $17,
                    $18, $19, $1A, $1B, $1C, $1D, $1E, $1F,
                    $7F];
  in_insert_mode := false;
  vdu_setup := false
end.
{#endif}
