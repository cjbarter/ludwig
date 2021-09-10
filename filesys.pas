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
{       Martin Sandiford (2002).                                       }
{                                                                      }
{  Copyright  2002 University of Adelaide                              }
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
! Name:         FILESYS
!
! Description:  This routine parses the command line, and filenames.
!               This is the Free Pascal version.
!
! $Header$
!--}

unit filesys;



interface
  uses value;
  {$I filesys.i}



implementation

{$L filesys_c}
{$L lwgetopt}

function filesys_create_open (
		fyle  : file_ptr;
		related_file : file_ptr;
		ordinary_open : boolean)
	: boolean;
cdecl; external;



function filesys_close (
		fyle   : file_ptr;
		action : integer;
		msgs   : boolean)
	: boolean;
cdecl; external;



function filesys_read (
	       fyle   : file_ptr;
           var buffer : str_object;
           var outlen : strlen_range)
	: boolean;
cdecl; external;



function filesys_rewind (
		fyle : file_ptr)
	: boolean;
cdecl; external;



function filesys_write (
		fyle   : file_ptr;
	var     buffer : str_object;
		bufsiz : strlen_range)
	: boolean;
cdecl; external;



function filesys_save (
	      i_fyle : file_ptr;
	      o_fyle : file_ptr;
	      copy_lines : integer)
      : boolean;
cdecl; external;



function  filesys_parse (
	var     command_line : file_name_str;
		parse        : parse_type;
	var     file_data    : file_data_type;
	var     input_file   : file_ptr;
	var     output_file  : file_ptr)
	: boolean;
cdecl; external;



end.
