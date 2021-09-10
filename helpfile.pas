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
{       Martin Sandiford (2008).                                       }
{                                                                      }
{  Copyright  2008 University of Adelaide                              }
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
! Name:         HELPFILE
!
! Description:   Load and support indexed help file under FreePascal.
!
!--}

unit helpfile;

interface
  uses value;
  {$I helpfile.i}

implementation

{$L helpfile_c}

function helpfile_open (
		old_version : boolean)
	:boolean;
cdecl; external;


function helpfile_read (
	var     key    : key_str;
		keylen : integer;
	var     buf    : help_record;
		buflen : integer;
	var     reclen : integer)
		: integer;
cdecl; external;


function helpfile_next (
	var     buf    : help_record;
		buflen : integer;
	var     reclen : integer)
	: integer;
cdecl; external;


end.
