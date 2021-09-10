{   This source file by:                                               }
{                                                                      }
{       Mark R. Prior (1988);                                          }
{       Jeff Blows (1989); and                                         }
{       Kelvin B. Nicolle (1989).                                      }
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
procedure ch_move (
        var     src ;
                st1 : strlen_range;
        var     dst ;
                st2 : strlen_range;
                len : strlen_range);
procedure ch_copy (
        var     src     ;
                st1     : strlen_range;
                src_len : strlen_range;
        var     dst     ;
                st2     : strlen_range;
                dst_len : strlen_range;
                fill    : char);
procedure ch_fill (
        var     dst  ;
                st1  : strlen_range;
                len  : strlen_range;
                fill : char);
function ch_length (
        var     str ;
                len : strlen_range)
        : strlen_range;
procedure ch_upcase_str (
        var     str ;
                len : strlen_range);
procedure ch_locase_str (
        var     str ;
                len : strlen_range);
function ch_upcase_chr (
                ch      : char)
        : char;
function ch_locase_chr (
                ch      : char)
        : char;
procedure ch_reverse_str (
        var     src : str_object;
        var     dst : str_object;
                len : strlen_range);
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
