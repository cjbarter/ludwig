{**********************************************************************}
{*                                                                    *}
{*           L      U   U   DDDD   W      W  IIIII   GGGG             *}
{*           L      U   U   D   D   W    W     I    G                 *}
{*           L      U   U   D   D   W ww W     I    G   GG            *}
{*           L      U   U   D   D    W  W      I    G    G            *}
{*           LLLLL   UUU    DDDD     W  W    IIIII   GGGG             *}
{*                                                                    *}
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
{                                                                      }
{  Copyright  1987-89 University of Adelaide                           }
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
! Name:         CH
!
! Description:  These are basic character manipulation routines that are
!               not normally available in Pascal. Free Pascal provides
!               them in it's runtime libraries.
!
!               Based on ch.pas.ibm
!
! $Header: /home/martin/src/ludwig/current/fpc/../RCS/ch.pas.ibm,v 4.1 1990/01/18 18:25:15 ludwig Exp $
! $Author$
! $Locker$
! $Log$
!
!
! Revision History:
!--}

{#if fpc}
unit ch;

interface
uses value;
{$I ch.i}

implementation

{--------------------------------------------------------------------}

procedure ch_move (
        var     src ;
                st1 : strlen_range;
        var     dst ;
                st2 : strlen_range;
                len : strlen_range);

begin
  move(str_object(src)[st1], str_object(dst)[st2], len);
end;

{--------------------------------------------------------------------}

procedure ch_copy (
        var     src     ;
                st1     : strlen_range;
                src_len : strlen_range;
        var     dst     ;
                st2     : strlen_range;
                dst_len : strlen_range;
                fill    : char);

var
  d   : strlen_range;
  len : strlen_range;

begin
  len := min(src_len, dst_len);
  if len <> 0 then
    move(str_object(src)[st1], str_object(dst)[st2], len);
  d := st2 + len;
  len := dst_len - len;
  if len > 0 then
    fillchar(str_object(dst)[d],len,fill);
end;

{--------------------------------------------------------------------}

procedure ch_fill (
        var     dst  ;
                st1  : strlen_range;
                len  : strlen_range;
                fill : char);

begin
  if len > 0 then
    fillchar(str_object(dst)[st1],len,fill);
end;

{--------------------------------------------------------------------}

function ch_length (
        var     str ;
                len : strlen_range)
        : strlen_range;

begin
  { This works safely, because fpc has short-circuit evaluation }
  while (len > 0) and (write_str(str)[len] = ' ') do
    dec(len);
  ch_length := len
end;

{--------------------------------------------------------------------}

procedure ch_upcase_str (
        var     str ;
                len : strlen_range);

var
  i : strlen_range;

begin
  for i := 1 to len do
    str_object(str)[i] := upcase(str_object(str)[i]);
end;

{--------------------------------------------------------------------}

procedure ch_locase_str (
        var     str ;
                len : strlen_range);

var
  i : strlen_range;

begin
  for i := 1 to len do
    str_object(str)[i] := lowercase(str_object(str)[i]);
end;

{--------------------------------------------------------------------}

function ch_upcase_chr (
                ch      : char)
        : char;

begin
  ch_upcase_chr := upcase(ch)
end;

{--------------------------------------------------------------------}

function ch_locase_chr (
                ch      : char)
        : char;

begin
  ch_locase_chr := lowercase(ch)
end;

{--------------------------------------------------------------------}

procedure ch_reverse_str (
        var     src : str_object;
        var     dst : str_object;
                len : strlen_range);

{ Assumes that src and dest are not overlapping. }
var
  i : integer;

begin
  for i := 1 to len do
    dst[succ(len) - i] := src[i];
end;

{--------------------------------------------------------------------}

function ch_compare_str (
        var     target    : str_object;
                st1       : strlen_range;
                len1      : strlen_range;
        var     text      : str_object;
                st2       : strlen_range;
                len2      : strlen_range;
                exactcase : boolean;
        var     nch_ident : strlen_range)
        : integer;

var
  diff : integer;
  i    : integer;
  s    : str_object;

begin
  move(text[st2], s[1], len2);
  if not exactcase then
    ch_upcase_str(s[1], len2);    {not sure about length here was len2-st2}
  i := 1;
  while (i <= len1) and (i <= len2) and (target[st1 + i - 1] = s[i]) do
    inc(i);
  nch_ident := i;
  if (i <= len1) and (i <= len2) then
  begin
    diff := integer(ord(target[i+st1-1])) - integer(ord(s[i]));
    diff := diff div abs(diff)
  end
  else if (i <= len1) then
    diff := 1
  else if (i <= len2) then
    diff := -1
  else
    diff := 0;
  ch_compare_str := diff;
end;

{-------------------------------------------------------------------}

function ch_search_str (
        var     target    : str_object;
                st1       : strlen_range;
                len1      : strlen_range;
        var     text      : str_object;
                st2       : strlen_range;
                len2      : strlen_range;
                exactcase : boolean;
                backwards : boolean;
        var     found_loc : strlen_range)
        : boolean;

var
  i : integer;
  s : str_object;

begin
  ch_search_str := false;
  if backwards then
  begin
    for i := 1 to len2 do
      s[succ(len2) - i] := text[pred(st2) + i];
    found_loc := len2
  end
  else
  begin
    move(text[st2], s[1], len2);
    found_loc := 0
  end;
  if not exactcase then
    ch_upcase_str(s[1], len2);    {not sure about length here was len2-st2}
  for i := 1 to succ(len2 - len1) do
  begin
    if CompareByte(target[st1], s[i], len1) = 0 then
    begin
      ch_search_str := true;
      if backwards then
        found_loc := succ(len2 - (i + len1))
      else
        found_loc := pred(i);
      exit
    end;
  end;
end;

end.
{#endif}

