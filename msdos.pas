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
{       Jeff Blows (1988).                                             }
{                                                                      }
{  Copyright  1988 University of Adelaide                              }
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
! Name:        MSDOS
!
! $Header: /home/medusa/user1/projects/ludwig/current/RCS/msdos.pas.ibm,v 4.1 90/01/18 17:28:43 ludwig Exp Locker: ludwig $
! $Author: ludwig $
! $Locker: ludwig $
! $Log:	msdos.pas.ibm,v $
Revision 4.1  90/01/18  17:28:43  ludwig
Entered into RCS at revision level 4.1.

!
!
! Description:  Provide low level interface outines to MS-DOS system.
!
! Revision History:
! 4-001 Jeff Blows                                              23-Apr-88
!       Implemented on MS-DOS.
!
!--}

unit msdos;

interface
uses value;
{$I msdos.i}

implementation
{#if fpc}
  uses baseunix, unix, screen, ch, sysutils;
{#endif}


const
  nul = 0;


{#if fpc}
function fpc_suspend  : boolean;

begin {fpc_suspend}
  fpc_suspend := (FpKill(0, SIGTSTP) = 0)
end; {fpc_suspend}



function fpc_shell : boolean;

begin {fpc_shell}
  fpc_shell := false;
  screen_message(msg_not_implemented)
end; {fpc_shell}
{#endif}


procedure msdos_exit (
		status : integer);

  begin
  halt(status)
  end;


function cvt_int_str (
		num   : integer;
	var     strng : str_object;
		width : scr_col_range)
	: boolean;

  var
    tmp_str : string;

  begin
  fillchar(strng[1], sizeof(strng), ' ');
  str(num:width, tmp_str);
  move(tmp_str[1], strng[1], length(tmp_str));
  strng[succ(length(tmp_str))] := chr(0); {now it looks like a unix string}
  cvt_int_str := true;
  end;


function cvt_str_int (
	var     num   : integer;
	var     strng : str_object)
	: boolean;

  var
    tmp_str : string;
    code    : word;

  begin
  move(strng[1] , tmp_str[1], 3);
  tmp_str[0] := chr(3);
  val(tmp_str, num, code);
  cvt_str_int := code = 0;
  end;


function get_environment (
	var     environ : name_str;
	var     reslen  : strlen_range;
	var     result  : str_object)
	: boolean;

{#if fpc}
var
  len : Integer;
  str : AnsiString;
{#endif}

begin
{#if fpc}
  len := ch_length(environ, name_len);
  environ[len + 1] := chr(nul);
  str := GetEnvironmentVariable(StrPas(@environ));
  len := Length(str);
  if len <> 0 then
  begin
    reslen := len;
    ch_move(Pointer(str)^, 1, result, 1, reslen);
    get_environment := true
  end
  else
    get_environment := false;
{#else}
{##  get_environment := false}
{#endif}
end;


procedure init_signals{};

  begin
  end;


procedure exit_handler (
		sig : integer);

  begin
  end;


function msdos_suspend 
	: boolean;

  begin
  msdos_suspend := false
  end;


function msdos_shell 
	: boolean;

begin
  msdos_shell := false
end;


function msdos_bcmp (
		var     str1, str2      ;
			len             : integer)
		: boolean;

  var
    i       : integer;
    found   : boolean;

  begin
  found := true;
  i := 1;
  while (i <= len) and found do
  begin
    found := str_object(str1)[i] = str_object(str2)[i];
    inc(i);
  end;
  msdos_bcmp := found;
  end;

end.
