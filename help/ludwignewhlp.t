!**********************************************************************}
!                                                                      }
!            L      U   U   DDDD   W      W  IIIII   GGGG              }
!            L      U   U   D   D   W    W     I    G                  }
!            L      U   U   D   D   W ww W     I    G   GG             }
!            L      U   U   D   D    W  W      I    G    G             }
!            LLLLL   UUU    DDDD     W  W    IIIII   GGGG              }
!                                                                      }
!**********************************************************************}
!   This source file by:                                               }
!                                                                      }
!       Chris J. Barter (1983, 1987);                                  }
!       Kelvin B. Nicolle (1987, 1990).                                }
!       Mark R. Prior (1987).                                          }
!                                                                      }
!  Copyright  1983, 1987, 1990 University of Adelaide                  }
!                                                                      }
!  Permission is hereby granted, free of charge, to any person         }
!  obtaining a copy of this software and associated documentation      }
!  files (the "Software"), to deal in the Software without             }
!  restriction, including without limitation the rights to use, copy,  }
!  modify, merge, publish, distribute, sublicense, and/or sell copies  }
!  of the Software, and to permit persons to whom the Software is      }
!  furnished to do so, subject to the following conditions:            }
!                                                                      }
!  The above copyright notice and this permission notice shall be      }
!  included in all copies or substantial portions of the Software.     }
!                                                                      }
!  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,     }
!  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF  }
!  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND               }
!  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS }
!  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN  }
!  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN   }
!  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE    }
!  SOFTWARE.                                                           }
!**********************************************************************}

!++
! Name:         LUDWIGHLP.TXT
!
! Description:  This file is the source for the Ludwig help file.
!               Run the program LUDWIGHLP to convert it to an indexed
!               sequential file suitable for Ludwig to interpret.
!
! $Header: /home/medusa/user1/projects/ludwig/current/RCS/ludwignewhlp.t,v 4.6 90/02/28 14:12:22 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log:	ludwignewhlp.t,v $
! Revision 4.6  90/02/28  14:12:22  ludwig
! Add the FS command and correct the FO command.
! 
! Revision 4.5  90/01/18  17:47:50  ludwig
! Entered into RCS at revision level 4.5
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                     5-May-1987
!       One line in section 4 contained a "\" in column 1. There was an
!       index entry in the .IDX file for "Gcat".
!       The text has been moved to columns 2..78 and column 1 now
!       contains only flag characters. HELPFILE.PAS and .C have been
!       modified accordingly.
! 4-003 Kelvin B. Nicolle                                    26-May-1987
!       Remove one line from the US section.
! 4-004 Mark R. Prior                                        ??     1987
!       Convert to Ludwig V4.1 command syntax.
! 4-005 Kelvin B. Nicolle                                    20-Nov-1987
!       Update the setup commands to V4.1.
!       Arrange the entries of section 7 into columns instead of rows.
!       Change "I" to "TI in the TI section.
!       Add an entry for the T prefix.
!
! To set up the required margins, tabs and file format, execute the
! Ludwig command "sx/ludwig/"
!
{ 2pc ep/m=(2,78), t=(1,10,18,26,34,42,50,58,66,74), o=(-i),v=(0,0)/
{ fk[] fo"-T"
{
!L       T       T       T       T       T       T       T       T       T   R
{<>
!
! The conventions for column one are:
!
!   { or !    means the line is a comment.  Also used to suppress unreleased
!             Ludwig commands and features.
!
!        +    means the line is to be displayed in a help INDEX.
!
!        \n   means the start of a topic numbered n, or a command n.
!
!        \%   means pause output at screen; wait for <RETURN>
!
!        \#   means end of file.  {Make sure it is!}
!
!      space  means the line is part of the help text.
!
!
! NOTE: The Help procedure displays 22 lines of text, reserving 2 lines for
! messages; the convention used here is to put a comment line in line 23,
! and the command marker for the next entry or the
! screen pause marker in line 24.
!
! All lines to go at the top of the index display must precede any
! lines starting with '+', any material to go at the end must follow them.
!
!--
\0
        Help for Ludwig users
        =====================

 You may ask for the display of any of the sections listed below by typing
   the section number, then pressing <RETURN>.
 For help on an individual command, type the command name (e.g. SC),
   then press <RETURN>.
 If you get lost, type 0 <RETURN> to get back here, also pressing <SPACE>
   will eventually get you back here.
 <RETURN> by itself, returns you back to Ludwig.
 On long help items, <SPACE> will get more help on that item.

   0. Main Help Menu
!
\1
+  1. Ludwig Basic Command Summary
   ===============================
     Symbol  Name            Action
     ------------------------------------------------------------------------
      AC     Advance Char    Moves Dot left or right
      AL     Advance Line    Moves forward or backward n lines
      AO     Advance Over    Gets next occurrence of a character
      CC     Create Char     Inserts n spaces before Dot
      CL     Create Line     Inserts n blank lines above Dot
      DC     Delete Char     Deletes n characters
      DL     Delete Line     Deletes n lines
      G      Get             Gets nth occurrence of a string
      H      Help            Help on a command or topic
      KI     Insert mode     Insert option--typed text is inserted
      KO     Overtype Mode   Overtype option--typed text overwrites existing
      M      Mark            Defines a mark.  nM defines mark 1..9
      Q      Quit            Exits from editor
      R      Replace         Replaces one string with another
      SD     Define Span     Defines and names a span
      SC     Span Copy       Copies a previously defined span
      TS     Text Swap       Swaps current line with one below (or above)
      "      Ditto           Copies characters from the line above
!
\2
+  2. Control Code Commands
   ========================

 Control codes are mapped to Ludwig commands as follows:

 CTRL/@                  Not used
 CTRL/A                  Not used
 CTRL/B                  Window Backward              { Same as WB }
 CTRL/C                  Not used
 CTRL/D                  Delete Char                  { Same as DC }
 CTRL/E                  Window End                   { Same as WE }
 CTRL/F                  Window Forward               { Same as WF }
 CTRL/G                  Execute frame COMMAND        { Same as SX/COMMAND/ }
 CTRL/H or <BACKSPACE>   Cursor Left                  { Same as KL }
 CTRL/I or <TAB>         Tab                          { Same as KT }
 CTRL/J or <LINEFEED>    Cursor Down                  { Same as KD }
 CTRL/K                  Delete Line                  { Same as DL }
 CTRL/L                  Create Line                  { Same as CL }
 CTRL/M or <RETURN>      Carriage Return              { Same as KC }
 CTRL/N                  New Window                   { Same as WN }
 CTRL/O                  Not used
 CTRL/P                  Type the command introducer  { Same as UC }
!
\%
 CTRL/Q                  Not used
 CTRL/R                  Cursor Right                 { Same as KR }
 CTRL/S                  Not used
 CTRL/T                  Window Top                   { Same as WT }
 CTRL/U                  Cursor Up                    { Same as KU }
 CTRL/V                  Not used
 CTRL/W                  Advance Word                 { Same as AW }
 CTRL/X                  Not used
 CTRL/Y                  Not used
 CTRL/Z                  Not used
 CTRL/[                  Not used        { Escape sequence introducer }
 CTRL/\                  Not used
 CTRL/]                  Not used
 CTRL/^                  Create Character             { Same as CC }
 CTRL/_                  Not used

   Some control codes have a meaning attached to them by the operating
 system.  For example, CTRL/S and CTRL/Q are often used to control the output
 from the system to the terminal, and CTRL/C is often used to abort a
 program. Under VMS CTRL/T may be enabled to produce process statistics.
 Under Unix CTRL/Z may be used to suspend a process.  These control codes can
 be mapped by Ludwig but will be ineffective.
!
\3
+  3. Complete Command Summary
   ===========================
 Symbol  Name                Action
 ----------------------------------------------------------------------------
  AC     Advance Character   Moves Dot left or right n characters
  AL     Advance Line        Moves forward or backward n lines
  AO     Advance Over        Bridges any of a set of characters
  AT     Advance To          Get nth occurrence of any of a set of characters
  AW     Advance Word        Advances n words
  CC     Create Character    Inserts n spaces before Dot
  CL     Create Line         Inserts n blank lines above Dot
  DC     Delete Character    Deletes n characters
  DL     Delete Line         Deletes n lines
  DW     Delete Word         Deletes n words
  ED     Edit frame          Changes frames, possibly creating a new one
  EK     Kill Edit frame     Destroys a frame and its attributes
  EOL    End Of Line         Tests for end of line
  EOP    End Of Page         Tests for end of page
  EOF    End Of File         Tests for end of file
  EP     Edit Parameters     Shows editor parameters, e.g. margins, options
  EQC    Equal Column        Tests for column position of Dot
  EQM    Equal Mark          Tests for position of mark n
!
\%
  EQS    Equal String        String match at Dot
  ER     Edit Return         Returns to frame which called current frame
  FB     File Back           Rewinds the input file of the current frame
  FE     File Edit           Opens input and output files for current frame
  FGB    Global File Back    Rewinds the global input file
  FGI    Global Input File   Opens the global input file (- to close)
  FGK    Global File Kill    Closes and deletes the global output file
  FGO    Global Output File  Opens the global output file (- to close)
  FGR    Global File Read    Reads n lines from the global input file
  FGW    Global File Write   Writes n lines to the global output file
  FI     File Input          Opens input file for current frame (- to close)
  FK     File Kill           Closes and deletes an output file
  FO     File Output         Opens output file for current frame (- to close)
  FP     File Page           Writes to the output file, reads from input file
  FS     File Save           Saves contents of current frame
  FT     File Table          Displays a table of currently open files
  FX     File Execute        Read file into frame COMMAND, compile & execute
  G      Get                 Gets the nth occurrence of a string
  H      Help                Displays help on a command or topic
  KB     Backtab             Same as <BACKTAB> key
  KC     Carriage Return     Same as <RETURN> key
  KD     Keyboard Down       Same as down arrow key
!
\%
  KH     Keyboard Home       Same as <HOME> key
  KI     Keyboard Insert     Insert option--typed text is inserted
  KL     Keyboard Left       Same as left arrow key
  KM     Keyboard Mapping    Maps a command string onto a keyboard key
  KO     Keyboard Overtype   Overtype mode--typed text overwrites existing
  KR     Keyboard Right      Same as right arrow key
  KT     Tab                 Same as <TAB> key
  KU     Keyboard Up         Same as up arrow key
  KX     Delete              Same as <DELETE> key
  M      Mark                Defines a mark; nM defines mark 1..9
  OP     Op. Sys. Parent     Attaches the terminal to the parent process
  OS     Op. Sys. Subprocess Attaches the terminal to a subprocess
  OX     Op. Sys. Execute    Executes an operating system command.
  PC     Position Column     Position dot relative to column 1
  PL     Position Line       Position dot relative to line 1
  Q      Quit                Exits from editor
  R      Replace             Replaces one string with another
  SA     Span Assign         Assigns text to a span
  SC     Span Copy           Copies a previously defined span
  SD     Span Define         Defines and names a span
  SE     Span Re-execute     Executes commands in a span; no recompilation
  SJ     Span Jump           Jumps to the beginning or end of a span
!
\%
  SM     Span Move           Moves a previously defined span (not a copy)
  SR     Span Recompile      Recompiles a span
  ST     Span Table          Lists all spans and frames
  SX     Span Execute        Compiles and executes commands in a span
  TB     Text Break          Splits a line in two
  TCE    Text Case Edit      Changes case to editcase
  TCL    Text Case Lower     Changes case to lowercase
  TCU    Text Case Upper     Changes case to uppercase
  TFC    Text Format Centre  Centres line between margins
  TFF    Text Format Fill    Places as many words as possible on a line
  TFJ    Text Format Justify Expands line to fit exactly between margins
  TFL    Text Format Left    Places start of line at left margin
  TFR    Text Format Right   Places end of line at right margin
  TFS    Text Format Squeeze Removes extra spaces from line
  TI     Text Insert         Insert text into line
  TO     Text Overtype       Overtype text into line
  TS     Text Swap           Swaps a pair of lines
  TX     Text Execute        Prompts for and executes a Command Procedure
  UC     Command Introducer  Types the command introducer into the text
  V      Verify              Command Procedure interactive verify
  WB     Window Back         Moves the window back over the frame
  WC     Window Centre       Centres the window on Dot
!
\%
  WE     Window End          Moves the window to the end of the frame
  WF     Window Forward      Moves the  window forward over the frame
  WH     Window Height       Sets the height of the window
  WL     Window Left         Shifts the window left
  WM     Window Move         Enables scrolling with arrow keys
  WN     New Window          Redisplays the current window
  WR     Window Right        Shifts the window right
  WT     Window Top          Moves the window to the top of the frame
  WU     Window Update       Updates the window without a full re-draw
  XA     Exit Abort          Aborts Command Procedure
  XS     Exit success        Command Procedure exit with success
  XF     Exit Failure        Command Procedure exit with failure
  \      Command             Switch between command and text entry modes
  (      Direct Entry        An unprompted version of Execute String
  "      Ditto               Copies characters from line above
  '      Ditto from below    Copies characters from line below
  {      Left Margin         Resets the left margin
  }      Right Margin        Resets the right margin
  ?      Invisible Insert    Insert characters invisibly



!
\%
  Special Keys
  ============
  By default these keys do the following.  See UK and Topic 6 to redefine the
  action of keys.

  <RETURN>      Carriage Return   Places Dot on next line on margin or indent
  <LINEFEED>    Keyboard Down     Moves Dot to next line
  <TAB>         Tab               Moves Dot to the next tab stop
  <BACKSPACE>   Backspace         Moves Dot to left
  <DELETE>      Delete            Delete the previous character, move Dot left
  <BACKTAB>     Backtab           Moves Dot to the previous tab stop
  Left  Arrow   Keyboard Left     Moves Dot to left (same as Backspace)
  Right Arrow   Keyboard Right    Moves Dot to right
  Up    Arrow   Keyboard Up       Moves Dot to next line
  Down  Arrow   Keyboard Down     Moves Dot to previous line
  Home          Keyboard Home     Moves Dot to the home position






!
\4
+  4. Trailing Parameters
   ======================

   For commands which require a string parameter in Command Procedures the
 parameter is delimited by any balanced pair of non-alphanumeric non-space
 characters, e.g. G/cat/ searches for the string "cat", using inexact case
 matching for alphabetic characters.

   In a Command Procedure trailing parameters may include end-of-line's.
 Multiple line trailing parameters are restricted to the following
 commands: TI, R (second parameter), SA (second parameter), KM
 (second parameter), and TX.
   Multiple line trailing parameters cannot be entered in response to a
 prompt in screen mode.








!
\%
  Some characters used as delimiters have a special meaning:

  " Indicates exact case matching to the Get, Replace and Equal String
    commands.  No further dereferencing is done.

  ' Indicates inexact case matching to the Get, Replace and Equal String
    commands.  No further dereferencing is done.

  ` Indicates a pattern matching template to the Get, Replace and Equal
    String commands (see section 5).  The pattern matcher does its own span
    dereferencing inside pattern specifications.  The rules are consistent
    with Ludwig commands but more extensive.

  ? The string is taken to be a Ludwig variable, and is replaced by the
    value of the variable.
      eg.  ti?terminal-name?
    inserts the name of the terminal in use in the text.





!
\%
  & The string is to be used as a prompt for interactive parameter entry.
      So G&What Do You Want ? &  will prompt "What Do You Want ? "
        instead of "Get    :".
      V&Do it ?&[ i"Done it" ] will insert "Done it" if
        Y is answered in response to the prompt "Do it ?".

    If the string is empty ("&&") the default prompt for the command is used.
      R&&With   :& will use the default prompt for the first parameter
      ("Replace:") and use "With   :" as the prompt for the second parameter.

  $ The string is taken to be a span name, and is replaced by the span
    itself, i.e. the span is dereferenced.
      eg.   g/$name$/
    searches for the string which is the contents of the span called NAME,
            g/$$name$$/
    dereferences the span name twice.
      i.e. The contents of span called NAME is used as the name of the span
      in which the target string is located.

    Dereferenced spans must contain one line only, unless the command allows
    multiple line trailing parameters.

!
\%
  ? The string is taken to be an environment variable, and is replaced by the
    value of that variable.
      eg.   v?ludwig-insert_mode?
    will succeed if Ludwig is in insert mode or was previously in insert mode
    when in command mode.

    Currently the following enquiries are recognized -
         terminal-name
         terminal-height
         terminal-width
         terminal-speed
         frame-name
         frame-inputfile
         frame-outputfile
         frame-modified
         ludwig-version
         ludwig-command_introducer
         ludwig-insert_mode
         ludwig-overtype_mode
         ludwig-opsys
{#if vms}
{##         lnm-<logical-name>}
{#elseif unix}
{##         env-<environment-variable>}
{#endif}

!
\%
 Rules for the processing of trailing parameters.

   Ludwig processes delimiters as follows.  The innermost set of delimiters
 are found, the search terminating when ", ' or ` are encountered.
 (Ludwig considers that " or ' or ` are always the innermost.)
 Ludwig then works its way outward, processing the delimited string according
 to the function of the delimiter.  If the processing yields a delimited
 string, Ludwig processes it according to the same rules, and then resumes
 applying the delimiters from the original string.

  eg.    G/$name$/ uses the contents of the span called NAME.
         G'$name$' looks for the string $name$ with inexact case match.
           as does G/'$name$'/.
         G$name$ is functionally the same as G/$name$/ and G$'name'$.
         G$&Span name ? &$  prompts "Span name ? " treating the reply as a
         span name, and uses the contents of the named span as the Get
         target.





!
\%
 The commands R (Get & Replace), SA (Span Assign), and KM (Key Mapping) take
 2 trailing parameters.  These are specified so that the outermost delimiter
 is also used to separate the 2 parameters.

   i.e. R/1st param/2nd param/

 Inside the outermost delimiters the rules are the same as those for single
 parameters.  If the outermost delimiters have a special function then it
 will apply to BOTH parameters.
 For default prompting use R&&&.

 Notes on use of Delimiters:
         R$name$something$ is not the same as R/$name$/something/,
           it IS the same as R/$name$/$something$/.
         Since " and ' stop further dereferencing, G/$'$span$'$/ will
           use the contents of the span called $SPAN$.

 In interactive use the outermost delimiters are implicitly supplied.
 \Gcat<return> gets the string "cat".  \G/cat/<return> looks for the string
 "/cat/".  (Here <return> is the <RETURN> key, and \ the command introducer).
 However \G'cat' looks for the string "cat" rather than the string "'cat'",
 because ' is a special delimiter.
!
\5
+  5. Use of the Pattern Matcher
   =============================
   A pattern definition consists of
        [<left context> ,] <middle context> [,<right context>]
   each context being a context free pattern (COMPOUND in syntax).
   - defaulting to left and middle if a third pattern is not specified.
   When a pattern has been successfully matched, the marks Dot and Equals
   are left wrapped around the middle context.
   A context free pattern is defined with a regular expression.
   '|' is used to denote OR (alternative). Concatenation is implicit.
   Parentheses are used to structure the expression.
   Most elements will take a repeat count parameter.

       Parameters are
         Numeric : (positive integers only)
         Kleene star : *.  0 or more repetitions.
         Kleene plus : +.  1 or more repetitions.
         Range :   [ nn , mm ]
           Specifies a range of repetitions nn to mm inclusive.
           The low bound defaults to 0, the high bound to indefinitely many.
           The comma is therefore mandatory.
         Negation : -.  Applies only to sets.
!
\%
       Elements of Patterns.
       ---------------------
         The sets  ::
           A : Alphabetic characters.
           U : Uppercase alphabetic.
           L : Lowercase alphabetic.
           P : Punctuation characters.  (),.;:"'!?-`  only
           N : Numeric characters.
           S : The space.  (non-space is therefore -S)
           C : All printable characters.
           D : Define.  To define a set.

             D<delimiter> { {char} | {char .. char} } <delimiter>
                  (the syntax is identical to NEXT and BRIDGE)
             EG.  D/a..z/ is the same as L
                  D/a..zA..Z$_0..9/ are all the valid characters in a
                                    VAX Pascal identifier.
             If the delimiters are $ or &, then the standard Ludwig span
               dereferencing and prompting mechanisms are used.  The returned
               span is used as the contents of a set definition
               specification.

!
\%
         Strings.
           Character strings are delimited with either single or double
             quotes.
           Double quotes are used to indicate exact case matching, whilst
           single quotes indicate inexact case matching.
           Dereferencing is allowed within strings if the string contains
             only a dereference.
           ie.
           '$fred$' will use the contents of span fred as a quoted string.
           '&String : &' will prompt  "String : ",
             and the input treated as a quoted string with inexact case match
           (both work with " as well, in which case exact case matching is
             used).
           To get the string $fred$ use '$''fred$', so $ is not both the
             first and last char of the string.

         Marks.
           @n, where n is a mark number, is used in a pattern to test for a
           mark at the present position.  Note that the presence of a mark
           where not needed will not affect the normal execution of the
           pattern matcher.

!
\%
         Positionals.
           < > are respectively the beginning and end of lines.
           { } the left and right margins.
            ^  the column that the Dot was in when the match started.

         Note : The marks and positionals are conceptually in the gaps to the
           left of the character in a column.  Also note that it is possible
           for more than one positional or mark to appear in exactly the same
           place.  If the behaviour of the pattern is dependent upon which of
           the positionals is found then the path taken will be
           indeterminate.

         Dereferenced Patterns.
           A pattern definition may be obtained using
           standard Ludwig dereferencing mechanisms.

           Note : 1. Dereferenced spans are pattern definitions NOT strings,
             therefore if a string is desired use string dereferencing as
             described above.
                  2. Dereferenced spans are Context free patterns and
             therefore may not contain context changes (commas).

!
\%
       SYNTAX.     Numbers are positive integers,
       -------     letters are case independent except in literal strings,
                   delimiters are matching non-alphanumeric characters.

         PATTERN DEFINITION ::=
           [COMPOUND ','] COMPOUND [',' COMPOUND]
         COMPOUND ::=
           PATTERN [ '|' COMPOUND ]
         PATTERN ::=
           { ( [ PARAMETER ]( SET | '(' COMPOUND ')' | STRING ))  |
             DEREFERENCE | ( '@' number )  } { ' ' }
         PARAMETER ::=
           '*' | '+' | number | ( '[' [ number ] ',' [ number ] ']' )
         SET ::=
           [ '-' ] ( 'A'|'P'|'N'|'U'|'L'|'S'|
           ('D' ( DEREFERENCE |
            (delimiter {{character} | {character ".." character}} delimiter)))
         STRING ::=
           (''' {character} ''') | ('"' {character} '"') |
           (''' DEREFERENCE ''') | ('"' DEREFERENCE  '"')
         DEREFERENCE ::=
           ( '$' span name '$' ) | ( '&' prompt '&' )
!
\6
+  6. Keyboard Interface
   =====================

   The Key Mapping command KM defines keys by name. There is a standard set
 of names which are used to define commonly provided keys:

     control keys: control-@ .. control-_
     standard keys generating control characters: return, line-feed, tab,
         back-space, delete
     cursor movement keys: up-arrow, down-arrow, left-arrow, right-arrow,
         home, back-tab
     the PFn keys: pf1 .. pf4
     numeric keypad keys: keypad-0 .. keypad-9, keypad-minus, keypad-comma,
         keypad-period, ..., enter
     other common keys: insert-char, delete-char, insert-line, delete-line,
         insert-mode, replace-mode, set-tab, clear-tab, erase-page,
         erase-line, erase-field, find, insert-here, remove, select,
         prev-screen, next-screen, help, do
     general function keys: function-1, ..., shift-function-1, ...,
         control-function-1, ..., control-shift-function-1, ...,
         meta-function-1, ..., meta-shift-function-1, ...,
         meta-control-function-1, ..., meta-control-shift-function-1, ...
!
{#if vms}
{##\%}
{##   The key names are defined in a terminal description file.  This is}
{## accessed by the logical name TERMDESC which normally translates to a}
{## directory.  The name of the terminal description file is obtained from the}
{## logical name TRMHND which defines the terminal handler for the terminal.}
{##   If the logical name TERMDESC translates to a file, that file is used.}
{##   The default file type for terminal description files is ".BIN".}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##!}
{#elseif unix}
{##\%}
{##   The key names are defined in a terminal description file.  This is}
{## accessed by the environment variable TERMDESC which normally contains a}
{## directory path.  If the environment variable TERMDESC is not defined, the}
{## directory path "/usr/local/lib/termdesc" is used.  The name of the terminal}
{## description file is obtained from the environment variable TERM which}
{## defines the termcap entry for the terminal.}
{##   If the environment variable TERMDESC contains a file path, that file is}
{## used.}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##!}
{#endif}
\7
+  7. Changes between V4.0 and V4.1
      =============================

 A new command language is available. Commands in the old language are mapped
 to the new language as follows -

         Old     New             Old     New             Old     New
         A       AL              SW      TS              ZC      KC
         BR      AO              UK      KM              ZD      KD
         C       CC              UP      OP              ZH      KH
         D       DC              US      OS              ZL      KL
         EN      SE              WM      WC              ZR      KR
         EX      SX              WS      WM              ZT      KT
         I       KI and TI       YA      AW              ZU      KU
         J       AC              YC      TFC             ZZ      KX
         K       DL              YD      DW              *E      TCE
         L       CL              YF      TFF             *L      TCL
         N       AT              YJ      TFJ             *U      TCU
         O       KO and TO       YL      TFL             ^       TX
         SI      ST              YR      TFR             ?       TN
         SL      TB              YS      TFS
         ST      SM              ZB      KB
!
\%
 New Commands

         PC      Position in Column
         PL      Position in Line
         OX      Operating system Command

 New Trailing parameter Delimiter

         ?       The string delimited by `?'s is interpreted as an
                 environment variable and the value of the variable is
                 substituted for the string.











!
\A
 PREFIX A COMMANDS
 =================
   Commands beginning with A pertain to moving dot.

  AC     Advance Character   Advances one character to the right.
  AL     Advance Line        Advances to the start of the next line.
  AO     Advance Over        Advances to the next character not in the set.
  AT     Advance To          Advances to the next character in the set.
  AW     Advance Word        Advances to the start of the next word.













!
\AC
 AC      ADVANCE CHARACTER
 ==      =================

   Moves the Dot n characters to the right or left in a line.  If the
 command cannot move the Dot as far as the leading parameter specifies
 (within the implementation line limit of 400 characters), the
 command fails, and the Dot is not moved.

 EXAMPLES:

   9AC  advance the Dot 9 characters to the right, moving the window to the
        right if necessary.
  -9AC  advance the Dot 9 characters to the left, moving the window to the
        left if necessary
   >AC  advance to the position after the last non-space character in a
        line, i.e. jump to the end-of-line.  If Dot is past the end-of-line,
        the command >J fails
   <AC  move the Dot to column 1
   =AC  jump to the previous Dot position (not necessarily in the same line)
  @9AC  jump to mark 9 (not necessarily in the same line)

 LEADING PARAMETER: [none, + , - , +n , -n , > , < , @ ] AC
!
\AL
 AL      ADVANCE LINE
 ==      ============

   Moves Dot forwards or backwards through the text by lines, each time
 re-setting Dot to column one.  The command will fail if there are
 insufficient lines below or above the line containing Dot; however >AL and
 <AL will never fail.  If the command fails, Dot does not move.

 EXAMPLES:

   9AL   move forward 9 lines
  -9AL   move backward 9 lines
   0AL   move to the beginning of the current line
   >AL   move to the end of file marker <End of File>
   @AL   move to the line containing mark 1
   =AL   move to where Dot was previously





 LEADING PARAMETER: [none, + , - , +n , -n , > , < , @ ] AL
!
\AO
 AO      ADVANCE OVER
 ==      ============

   Skips over occurrences of any of a set of specified characters.  If the
 character at Dot is not in the set specified, Dot does not move, and the
 command does not fail.  Exact case matching is used.

 EXAMPLES:

    AO'a'    skip occurrences of the character "a" to the right
   -AO'a'    skip occurrences of the character "a" to the left
    AO'abc'  skip occurrences of any of "a", "b" or "c"
    AO'aBc'  skip occurrences of any of "a", "B" or "c"
    AO'a..z' skip occurrences of any lower case alphabetic character
    AO'0..9' skip occurrences of any numeric string






 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] AO
!
\AT
 AT      ADVANCE TO
 ==      ==========

   Searches for the nth occurrence of any of a set of specified characters.
 The command fails if there are less than n occurrences remaining in the
 frame.  Exact case matching is used.

 EXAMPLES:

    AT'a'    search for the first occurrence of the character "a" forwards
   -AT'a'    search for the first occurrence of the character "a" backwards
   9AT'a'    search for the ninth occurrence of the character "a" forwards
    AT'abc'  search for the first occurrence of any of "a", "b" or "c"
    AT'a..z' search for the first occurrence of any lower case alphabetic







 LEADING PARAMETER: [none, + , - , +n , -n ,   ,   ,   ] AT
!
\AW
 AW      ADVANCE WORD
 ==      ============

   Advance Word moves to the beginning of the nth word, where a word is a
 contiguous block of non-blank characters.  0AW moves to the beginning of the
 current word.  >AW moves to the beginning of the next paragraph, and <AW to
 the beginning of the current paragraph, where a paragraph is a contiguous
 block of non-blank lines.

 EXAMPLES:
   before:           Dot
                     v
            hello there freddy
            ^     ^     ^
   after:   -AW   0AW   1AW






 LEADING PARAMETER: [none, + , - , +n , -n , > , < ,   ] AW
!
\C
 PREFIX C COMMANDS
 ================
   Commands beginning with C pertain to creating space to type some text.

  CC     Create Character    Create a character space.
  CL     Create Line         Create a blank line.
















!
\CC
 CC      CREATE CHARACTER
 =       ================

   Inserts n spaces to the left of Dot.  With a positive leading parameter,
 Dot does not move relative to the beginning of the line, while with a
 negative leading parameter, Dot stays on the character it was originally on.
 The command will fail to insert any spaces if the requested insertion would
 cause the line length to exceed the implementation line length limit (400
 characters).












 LEADING PARAMETER: [none, + , - , +n , -n ,   ,   ,   ] CC
!
\CL
 CL      CREATE LINE
 ==      ===========

   Inserts n empty lines above the current line, and positions Dot on the
 topmost inserted line, in the same column.  The command -CL inserts above
 the current line, but does not move the Dot.















 LEADING PARAMETER: [none, + , - , +n , -n ,   ,   ,   ] CL
!
\D
 PREFIX D COMMANDS
 ================
   Commands beginning with D pertain to deleting text.

  DC     Delete Character    Delete the character under dot.
  DL     Delete Line         Delete the current line.
  DW     Delete Word         Delete the current word.















!
\DC
 DC      DELETE CHARACTER
 =       ================

   Deletes characters at and to the right of Dot for positive parameters, and
 to the left for negative parameters.  The @ parameter specifies the deletion
 of all characters between the current position and the specified mark. Note
 that the mark can be to the left or the right of Dot.  @DC also places all
 the deleted text into frame OOPS.

 EXAMPLES:

   9DC   delete 9 characters at and to the right of Dot
   >DC   delete all characters from the current position to the end of line
   -DC   delete a character to the left of Dot
  @5DC   delete all characters from Dot to mark 5
   =DC   delete all characters from Dot to the previous Dot position





 LEADING PARAMETER: [none, + , - , +n , -n , > , < , @ ] DC
!
\DL
 DL      DELETE LINE
 ==      ===========

   Deletes n lines and then positions Dot on the next line in the same
 column. The command -DL deletes the line above , but does not move the Dot.
 All deleted text is placed in frame OOPS.

 EXAMPLES:

   9DL  delete 9 lines at and below the current line
  -9DL  delete 9 lines above the current line
   >DL  delete from the current line to the end-of-page
   <DL  delete above the current line to the beginning of the page
   @DL  delete lines from the current line to the line containing mark 1
   =DL  delete lines from the current line to the previous Dot position






 LEADING PARAMETER: [none, + , - , +n , -n , > , < , @ ] DL
!
\DW
 DW      DELETE WORD
 ==      ===========

   Delete Word deletes n words, where a word is a contiguous block of
 non-blank characters.  >DW deletes to the beginning of the next paragraph,
 and <DW to the beginning of the current paragraph, where a paragraph is a
 contiguous block of non-blank lines.














 LEADING PARAMETER: [none, + , - , +n , -n , > , < ,   ] DW
!
\E
 PREFIX E COMMANDS  Commands beginning with "E" fall into 3 categories.
 =================
 1. Most E* commands pertain to Frames.  A Frame is a local editing
    environment, containing its own: marks, input and output files, default
    strings for EQuals-String, Get and Replace, and text.  All Frames are
    named, the default frame has the name LUDWIG.
    Other frames always created by Ludwig are :
      COMMAND the command frame.  FX and TX place commands here and
              compile and execute them.
      OOPS    all text deleted from any other frame is placed here.
      HEAP    a special scratch frame.  Used especially by SA and KM.
    ED     Edit frame          Changes frames, possibly creating a new one
    EK     Kill Edit frame     Destroys a frame and its attributes
    EP     Edit Parameters     Show and/or change editor parameters.
    ER     Edit Return         Returns to frame which called current frame
               ------------------------------------
 2. EQ*    The EQUALS commands           (see EQ)
 3. EO*    The END OF commands           (see EO)




!
\ED
 ED      EDIT FRAME
 ==      ==========

   Change editing frames to the frame with the specified name.  If a frame
 with that name does not exist, a new (empty) one is created with that name.
 Note that the default frame has the name LUDWIG, and that the frame which
 holds the current Command Procedure has the name COMMAND.  Frame OOPS
 contains all text deleted by the DL, @DC, SA, FX, and TX commands.  Frame
 HEAP is used by the SA command to hold any spans it creates, and by the KM
 command.











 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] ED
!
\EK
 EK      EDIT KILL
 ==      =========

   Deletes a frame and its text.  The command will fail if there are files
 attached to the frame, the frame is currently being edited, or the
 frame is a special frame (COMMAND, OOPS, HEAP).  The default frame can be
 deleted.














 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] EK
!
\SE
 SE      SPAN EXECUTE
 ==      ============

   Executes the compiled code for a span; if there is no compiled code for
 the span, the span is compiled first.  Thus a span may be modified, or even
 deleted, yet its old code retained and executed.  Compilation can be forced
 by the Span Recompile command SR.  The Execute command SX is equivalent to
 SR followed by SE.













 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] SE
!
\EO
 PREFIX EO COMMANDS
 ==================

   Commands beginning with EO are used in Command Procedures to test whether
 Dot is at the END OF a construct.

  EOL    End Of Line         Tests for end of line
  EOP    End Of Page         Tests for end of page
  EOF    End Of File         Tests for end of file













!
\EOL
 EOL     END OF LINE
 ===     ===========

   Tests that Dot is at the end of line, which is defined to be the position
 immediately to the right of the last non-space character in the line.  >EOL
 tests that Dot is at or beyond the end of line.  <EOL tests that Dot is at
 or to the left of the end of line.














 LEADING PARAMETER: [none, + , - ,    ,    , > , < ,   ] EOL
!
\EOP
 EOP     END OF PAGE
 ===     ===========

   Tests if Dot is on the null line at the end of page, which is displayed as
 <Page Boundary>.  Note that EOP succeeds at end of file as well.
















 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] EOP
!
\EOF
 EOF     END OF FILE
 ===     ===========

   Test if Dot is on the null line at the end of file, which is displayed as
 <End of File>.
















 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] EOF
!
\EP
 EP      EDITOR PARAMETERS
 ==      =================

   Each editing frame has a set of parameters, initialized to default values
 at frame creation; the parameter values for the current frame may be changed
 at any time by the Editor Parameters command.  A "$" prefixed to a parameter
 assignment refers to the global default value, and the new value will be
 used in new frames.  An empty trailing parameter (<RETURN> after the prompt)
 produces a display of the current parameters in the following order:

     K    keyboard :
          =I     insert from keyboard (default)
          =O     overtype from keyboard
          =C     commands executed from keyboard without command introducer

     C    interactive command introducer  (default is "\")
          The introducer can be a single ASCII characater not in the set
          [' ','A'..'Z','a'..'z'], or any key name supported by the keyboard
          interface.  This parameter can only be defined in screen mode.

     S    memory space limit (default 500000 characters)

!
\%
     H    screen height

     W    screen width

     O    editor options:    (all off by default)
          =S     Show current options
          =W     Wrap at right margin
          =I     Indentation tracker, <RETURN> to current indentation, not
                 margin
          =N     Newline when <RETURN> is pressed in insert mode

     M    left and right margin settings (default is M=(1,terminal_width))
                 The character "." represents the column containing Dot.

     V    top and bottom margin settings (default depends on terminal height)







!
\%
     T    set and clear tabs:
          =(c1,c2,...cn) for tabs at columns c1,c2,...cn
          =D     return to default tab setting
          =S     set a tab at Dot
          =C     clear a tab at Dot
          =T     set tabs using the current line as a template
          =I     insert a line in the text showing tab stops and margins
          =R     set tabs and margins using the current line as a ruler--
                   as inserted by T=I

 EXAMPLES:
    EP'H=15'       set the screen height to 15 lines
    EP'O=I'        turn on the indentation tracker
    EP'O=-I'       turn off the indentation tracker
    EP'M=(12,70)'  set left margin to column 12, right margin to column 70
    EP'M=(20)'     set left margin to column 20
    EP'M=(,50)'    set right margin to column 50
    EP'M=(,.)'     set right margin to current Dot position
    EP'$S=300000'  set space for any new frame to 300000 characters
    EP'$O=(w,i,n)' set W,I,N options as global defaults

 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] EP
!
\EQ
 PREFIX EQ COMMANDS
 ==================

   Commands beginning with EQ are used in Command Procedures to test whether
 Dot is at a particular place, or at a particular piece of text.

  EQC    Equal Column        Tests for column position of Dot
  EQM    Equal Mark          Tests for position of mark n
  EQS    Equal String        String match at Dot













!
\EQC
 EQC     EQUAL COLUMN
 ===     ============

   Tests the relationship between Dot and the specified column.
 Column numbers range from 1 to 400 (an implementation limit).

 EXAMPLES:

    EQC'9'       succeeds if Dot is in column 9
   -EQC'9'       fails if Dot is in column 9
   >EQC'9'       succeeds if Dot is at, or to the right of column 9
   <EQC'9'       succeeds if Dot is at, or to the left of column 9









 LEADING PARAMETER: [none, + , - ,    ,    , > , < ,   ] EQC
!
\EQM
 EQM     EQUAL MARK
 ===     ==========

   Tests the relationship between Dot and the specified mark.
   The Equals and Modified marks are tested for using trailing parameters of
   "=" and "%".

 EXAMPLES:

    EQM'9'       succeeds if Dot is at mark 9
   -EQM'9'       fails if Dot is at mark 9
   >EQM'9'       succeeds if Dot is at, or to the right of mark 9
   <EQM'9'       succeeds if Dot is at, or to the left of mark 9








 LEADING PARAMETER: [none, + , - ,    ,    , > , < ,   ] EQM
!
\EQS
 EQS     EQUAL STRING
 ===     ============

   Matches a string with the text at and to the right of Dot using inexact
 case matching for alphabetic characters.  Exact case matching, pattern
 matching etc. are available and use the same pattern matching conventions
 as the commands GT and R.  Dot moves during the matching process, but
 returns to its original position after the match.

 EXAMPLES:

    EQS'cat'     succeeds if Dot is at the start of string cat
   -EQS'cat'     fails if Dot is at the start of string cat
   >EQS'cat'     succeeds if the text string is equal to or lexically greater
                 than cat
   <EQS'cat'     succeeds if the text string is equal to or lexically less
                 than cat




 LEADING PARAMETER: [none, + , - ,    ,    , > , < ,   ] EQS
!
\ER
 ER      EDIT RETURN
 ==      ===========

   The Edit Frame command ED changes the editing frame, and in doing so
 leaves a back reference to itself in the new frame.  The Edit Return command
 ER uses the back reference to return to that frame.  For example, if ED/B/
 were executed in frame A, then the editor would change frames from A to B.
 If ER were then executed in frame B, the editor would return to frame A, as
 if ED/A/ were executed.  A chain of returns is possible (as are cycles!).
 Note that ER itself does not leave a back reference.











 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] ER
!
\SX
 SX      SPAN EXECUTE
 ==      ============

   Executes the contents of a span as a Command Procedure.  If the procedure
 has syntax errors, it will not be executed, and the procedure will be
 displayed in its frame, with error messages.  Error messages take the form
 of comments, the comment marker (!) pointing to the error.  The erroneous
 procedure may be edited; the error messages need not be deleted.  After
 returning to the appropriate editing frame (usually by the Edit Return
 command ER), the procedure can be re-compiled and executed.











 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] SX
!
\F
 PREFIX F COMMANDS
 =================
   Commands beginning with F pertain to files.  A frame may have one input
 file, and one output file.

 Commands beginning with FG pertain to Global Files.
 Global files are not attached to frames.  (See help entry FG)

  FB     File Back           Rewinds the input file of the current frame
  FE     File Edit           Opens input and output files for current frame
  FI     File Input          Opens input file for current frame (- to close)
  FK     File Kill           Closes and deletes an output file
  FO     File Output         Opens output file for current frame (- to close)
  FP     File Page           Writes to the output file, reads from input file
  FS     File Save           Saves contents of current frame
  FT     File Table          Displays a table of currently open files
  FX     File Execute        Read file into frame COMMAND, compile & execute





!
\FB
 FB      FILE BACK
 ==      =========

   Rewinds the input file attached to the current frame, and loads the file
 into the frame.
















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] FB
!
\FE
 FE      FILE EDIT
 ==      =========

   Opens both an input and output file for the current frame.  The file
 specification argument is used for the input file.  The output file uses the
 same file specification with the version number field removed.  If not
 given, the default device and directory are used.  This is the normal
 command for opening a file in a new frame for editing.
   The command -FE writes the contents of the frame to the output file,
 copies any lines left in the input file to the output file, and closes
 both the input and output files.  No output file is created if the
 frame has not been modified.









 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] FE
!
\FG
 PREFIX FG COMMANDS
 ==================

   Commands beginning with FG pertain to Global Files.  Ludwig may have one
 Global Input file, and one Global Output file.  Input may be read into any
 frame, and output written from any frame.

  FGB    Global File Back    Rewinds the global input file
  FGI    Global Input File   Opens the global input file  (- to close)
  FGK    Global File Kill    Closes and deletes the global output file
  FGO    Global Output File  Opens the global output file (- to close)
  FGR    File Read           Reads n lines from the global input file
  FGW    File Write          Writes n lines to the global output file









!
\FGB
 FGB     FILE BACK (global)
 ===     ==================

   Rewinds the global input file.

















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] FGB
!
\FGI
 FGI     FILE INPUT (global)
 ===     ===================

   Opens an input file which is not attached to any particular frame, but
 which is globally accessible via the Global File Read command FGR, which
 reads from the global input file into the current frame.  The command -FGI
 closes the global input file.  There may only be one global input file.














 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] FGI
!
\FGK
 FGK     FILE KILL (global)
 ===     =================

   Closes and deletes the global output file.

















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] FK
!
\FGO
 FGO     FILE OUTPUT (global)
 ===     ====================

   Opens an output file which is not attached to any particular frame, but
 which is globally accessible via the Global File Write command FGW, which
 writes to the global output file from the current frame.  The command -FGO
 closes the global output file.  There may only be one global output file.














 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] FGO
!
\FGR
 FGR     FILE READ (global)
 ===     ==================

   Reads n lines from the global input file into the current frame, above the
 current line.
















 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] FGR
!
\FGW
 FGW     FILE WRITE (global)
 ===     ===================

   Writes lines from the current frame to the global output file, beginning
 with the current line.
















 LEADING PARAMETER: [none, + , - , +n , -n , > , < , @ ] FGW
!
\FI
 FI      FILE INPUT
 ==      ==========

   Opens an input file for the current frame, and loads the file into
 the frame.  The command -FI closes the input file attached to the
 current frame.















 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] FI
!
\FK
 FK      FILE KILL
 ==      =========

   Closes and deletes the output file attached to the current frame.

















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] FK
!
\FO
 FO      FILE OUTPUT
 ==      ===========

   Opens an output file for the current frame.  If no trailing parameter is
 given, and an input file is attached to the current frame, the output file
 specification defaults to that of the input file, with the version number
 field removed.
   The command -FO writes the contents of the frame to the output file,
 copies any lines left in the input file (if any) to the output file, and
 closes the output file.  No output file is created if the frame has not been
 modified.










 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] FO
!
\FP
 FP      FILE PAGE
 ==      =========

   Moves all text above the line containing Dot to the output file attached
 to the current frame, if any, and reads more text from the input file, if
 any.  The current line is not written out.  Once text is paged to an output
 file, it may only be edited again by closing the output file re-opening it
 as an input file.













 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] FP
!
\FS
 FS      FILE SAVE
 ==      =========

   The current frame is saved: the contents of the current frame are written
 to the output file; the remainder of the input file (if any) is copied to the
 output file; the output file is renamed from its temporary name to its
 final name; backup copies are created; and a new output file is opened.
   The editing environment is not altered.













 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] FS
!
\FT
 FT      FILE TABLE
 ==      ==========

   Displays the current files in a table, giving their status (viz. FI, FO,
 FGI, or FGO), read status (EOF if an input file has no further input), an
 indication whether the frame to which they are attached has been modified,
 the name of the frame to which they are attached, and the file
 specification.













 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] FT
!
{#if vms}
{##\FX}
{## FX      FILE EXECUTE}
{## ==      ============}
{##}
{##   Opens and reads a file into frame COMMAND, closes the file, and then}
{## executes frame COMMAND as a Command Procedure.  The previous contents of}
{## frame COMMAND (if any) are placed in frame OOPS.}
{##   The default file type is ".LUD".}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{## LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] FX}
{##!}
{#else}
\FX
 FX      FILE EXECUTE
 ==      ============

   Opens and reads a file into frame COMMAND, closes the file, and then
 executes frame COMMAND as a Command Procedure.  The previous contents of
 frame COMMAND (if any) are placed in frame OOPS.















 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] FX
!
{#endif}
\G
 G       GET
 =       ===

 Interactive Use:
 ---------------
   Performs a pattern directed string search.  The pattern may be a simple
 string, or an expression in a general pattern matching language.  For
 patterns which are simple character strings, inexact case matching is the
 default.  Exact case matching is performed if the search string is given in
 double quotes, e.g. "Cat".  If a null pattern is specified, the Get command
 will use the pattern last used in the current frame, if any.  The result of a
 search is displayed, and the user is asked to verify the result.  After a
 successful search, Dot is at the character after the matched string, and the
 Equals mark (=) is the first character of the string.  The position of
 Dot and Equals are reversed after a backward search.

 Command Procedure Use:
 ---------------------
   The Get command does not seek verification in Command Procedures, so an
 explicit Verify command can be useful, e.g. G/.../ V&&  Note that this
 Verify command is not part of the Get command.

!
\%
 EXAMPLES:

    G'cat'     search for the string cat, Cat, CAT etc.
   3G'cat'     search for the third occurrence of cat, Cat, CAT etc.
   -G'cat'     search backwards through the text for the pattern
    G"Cat"     search uses exact case match
    G'cat'=AC  move to the start of the found string (i.e. the previous
                position of Dot)
    G'cat'=CD  delete the found string












 LEADING PARAMETER: [none, + , - , +n , -n ,   ,   ,   ] G
!
\H
 H       HELP
 =       ====

 To get help on a particular command, enter the command name, and
   press <RETURN>.
 You may ask for the display of any of the sections listed below by typing
   the section number, then pressing <RETURN>.
 <RETURN> by itself, returns you back to Ludwig.
 On long help items, <SPACE> will get more help on that item.
 Pressing space will eventually get you to Topic 0.

         0.   Help for Ludwig users
         1.   Ludwig Basic Command Summary
         2.   Control Code Commands
         3.   Complete Command Summary
         4.   Trailing Parameters
         5.   Use of the Pattern Matcher
         6.   Key Map Numbering
         7.   Ludwig Notices (for latest information on Ludwig)
 This command is not allowed in non-interactive mode.

 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] H
!
\KI
 KI      INSERT MODE
 ==      ===========

   Sets the mode of keyboard entry so that typed characters are inserted into
 the text rather than overtyping existing text.  Note that insertion may
 cause a line to become longer than the screen width.  Insertion will fail
 when the line has reached its maximum length (400 characters), and at the
 right margin when the EP wrap option is turned off.  If the EP newline
 option has been turned on, <RETURN> will split the line.  (See help on EP.)
 The KO Overtype Mode command places the editor into the overtyping mode of
 keyboard entry.










 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] KI
!
\T
 PREFIX T COMMANDS
 =================
   Commands beginning with a T pertain to text manipulation.

  TB     Text Break          Splits a line in two
  TC*    Text Case ...       See help entry TC
  TF*    Text Format ...     See help entry TF
  TI     Text Insert         Insert text into line
  TO     Text Overtype       Overtype text into line
  TS     Text Swap           Swaps a pair of lines
  TX     Text Execute        Prompts for and executes a Command Procedure











!
\TI
 TI      TEXT INSERT
 ==      ===========

   The command takes a trailing parameter and inserts n copies in the text.

 EXAMPLES:

    TI/cat and dog/       insert the string "cat and dog" at Dot
   9TI/cat and dog/       insert the string "cat and dog" at Dot 9 times
    TI&&                  prompts for the text to be inserted
    TI&Enter name:&       user defined prompt for the text to be inserted










 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] TI
!
\M
 M       MARK
 =       ====

   Defines a mark in the text at the Dot.  If text containing a mark is
 deleted, the mark becomes attached to the first character to the right of
 the deleted text.  The commands which use marks are { AL DC FGW AC DL
 SD TS }; for example, @9AC moves the Dot to the position of mark number 9.

 EXAMPLES:

    M    define mark number 1
   9M    define mark number 9.  Mark numbers range 1..9
  -9M    undefine mark number 9








 LEADING PARAMETER: [none, + , - , +n , -n ,   ,   ,   ] M
!
\KO
 KO      OVERTYPE MODE
 ==      =============

   Sets the mode of keyboard entry so that typed characters are typed over
 existing text rather than inserted into the text.  Overtyping will fail at
 the right margin when the EP wrap option is turned off.  (See help on EP.)















 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] KO
!
\TO
 TO      TEXT OVERTYPE
 ==      =============

   The command takes a trailing parameter and overtypes n copies in the text.

 EXAMPLES:

    TO/cat and dog/       overtype the string "cat and dog" at Dot
   9TO/cat and dog/       overtype the string "cat and dog" at Dot 9 times
    TO&&                  prompts for the text to be overtyped
    TO&Enter name:&       user defined prompt for the text to be overtyped










 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] TO
!
\PC
 PC      POSITION COLUMN
 ==      ===============

   Positions dot relative to column 1 on the current line.

















 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] PC
!
\PL
 PL      POSITION LINE
 ==      =============

   Positions dot at the specified line relative to the first line in the
 frame, in column 1.
















 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] PL
!
\Q
 Q       QUIT
 =       ====

   Quits the editor altogether.  All lines from frames with attached output
 files are written to their corresponding output files.  For each frame with
 both an input and an output file attached, any remaining lines in the input
 file are copied to the output file.  All files are then closed.
   If a frame has an input file, no output file, and has been modified, then
 Ludwig will display the frame at the point of its last modification, and ask
 if the user wishes to continue the quit operation.  The following responses
 are possible:
      A       will cause Ludwig to disregard all frames in this condition
      Y       will disregard this frame but continue checking for others
      N or Q  will return to editing in the displayed frame







 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] Q
!
\R
 R       REPLACE
 =       =======

 Interactive Use:
 ---------------
   Performs n replacements of one string by another.  Each occurrence is
 verified before replacement.  Replying "N" will ignore an occurrence of the
 target pattern and search for the next, "Q" will abort the entire command,
 "Y" will replace this occurrence and search for the next if more than one
 replacement is to be performed, while "A" will perform all remaining
 replacements without further verification.  Replying "M" will display more
 lines of context aroung this occurrence, in order for the user to verify
 replacement.  The command prompts for both the target pattern and the
 replacement string unless a <RETURN> is given for the first parameter, in
 which case they will be the same as used by the previous Replace command in
 that frame.  Pattern matching is the same as for the Get command G.

 Command Procedure Use:
 ---------------------
   Replacement is not verified (see the Get command).


!
\%
 EXAMPLES:

    R/cat/mouse/    replace the next occurrence of cat, Cat or CAT etc.
                     by mouse
    R/"cat"/mouse/  replace the next occurrence of cat by mouse (exact
                     case match)
    R"cat"mouse"    an abbreviation for  R/"cat"/mouse/
   >R/cat/mouse/    replace all occurrences of cat by mouse, from Dot to
                     the end-of-page
   9R/X/Y/          replace the next 9 occurrences of x or X by Y
    R&&&            prompt interactively from a Command Procedure
    R&this&that&    user defined prompt from a Command Procedure









 LEADING PARAMETER: [none, + , - , +n , -n , > , < ,   ] R
!
\S
 PREFIX S COMMANDS
 =================
   Commands beginning with S pertain to Spans. Spans are named pieces of text
 delimited by two marks.  Spans are the basic method of text transport inside
 Ludwig.  Spans may contain Ludwig command code, which is executed with SX or
 SE.  Spans may also be associated with compiled Ludwig commands (created by
 SR or SX, and used by SE and SX).

  SA     Span Assign         Assigns text to a span
  SC     Span Copy           Copies a previously defined span
  SD     Span Define         Defines and names a span
  SE     Soan Execute        Executes a span
  SJ     Span Jump           Jumps to the beginning or end of a span
  SM     Span Move           Moves a previously defined span (not a copy)
  SR     Span Recompile      Recompiles a span
  ST     Span Table          Lists all spans and frames
  SX     Span Execute        Compiles and executes a span.





!
\SA
 SA      SPAN ASSIGN
 ==      ===========

   The Span Assign command SA replaces the contents of a span with a new
 piece of text.  If the span does not exist it is created at the bottom of the
 frame HEAP.  The old contents of the span (if any) are placed in frame OOPS.

 EXAMPLES:

    SA/name/Hello/    places the text "Hello" in the span called NAME.
    SA/name/$name2$/  places a copy of the text in the span called NAME2 in
                      the span called NAME.
    V$Flag$[ SA/Flag/N/ : SA/Flag/Y/ ]
        replaces the contents of Flag by N if it is currently Y, and Y if N.







 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] SA
!
\SC
 SC      SPAN COPY
 ==      =========

   The Span Define command SD, defines and names spans of text; the Span
 Copy command SC inserts a named span into the text, immediately to the
 left of Dot.  The command does not delete the original span.















 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] SC
!
\SD
 SD      SPAN DEFINE
 ==      ===========

   Defines and names a span between the character at Dot and the character at
 a specified mark.  If the mark was before the Dot, then the mark is at the
 first character of the span and the Dot is at the character after the end of
 the span.  If the mark was after the Dot, the opposite holds.  Once a span
 has been defined, it is not dependent on the the mark, nor on its boundary
 characters; if either of these are deleted, the span simply contracts.  Span
 definition replaces any previous use of that span name, but names of
 existing frames cannot be used as span names.  Span names are global to all
 frames.  Any non-blank string up to 31 characters in length is a valid name,
 but leading and trailing spaces are removed, and alphabetic characters are
 converted to upper case.

 EXAMPLES:
    SD'cat'      defines a span named cat between the Dot and mark 1
   9SD'cat'      as above, but uses mark 9
   =SD'cat'      as above, but uses the previous position of Dot for the mark

 LEADING PARAMETER: [none, + , - , +n ,    ,   ,   , @ ] SD

!
\ST
 ST      SPAN TABLE
 ==      ==========

   Displays all span names and the first 31 characters of each span.  All
 frames and their attached files are also displayed.
















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] ST
!
\SJ
 SJ      SPAN JUMP
 ==      =========

   Moves Dot to the end of a span (the character to the right of the last
 character of the span).  The command -SJ moves Dot to the first
 character of the span.















 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] SJ
!
\TB
 TB      TEXT BREAK
 ==      ==========

   Splits a line in two at the current position.  The characters in the
 current line to the left of the current position remain in place, and the
 rest of the line is moved to a new line, with the current character
 positioned where a <RETURN> or KC command would have placed the cursor.
 This will be the left margin, unless the EP indentation tracker option is
 turned on.  (See help on EP.)  Dot stays attached to the first character of
 the right-hand segment of the line.











 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] TB
!
\SR
 SR      SPAN RECOMPILE
 ==      ==============

   Recompiles a span for execution.  The Span Execute command SX
 automatically recompiles its span before executing it; the Execute
 Norecompile command SE does not do so if compiled code for the span exists.















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] SR
!
\SM
 SM      SPAN MOVE
 ==      =========

   The Span Define command SD, defines and names spans of text; the Span Move
 command SM inserts a named span into the text, immediately to the left of
 Dot.  Note that the span is moved, not copied.















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] SM
!
\TS
 TS      TEXT SWAP
 ==      =========

   Transfers the current line to a position after the nth line below it.  With
 a negative leading parameter, the line is moved to a position before the nth
 line above it.  The Dot stays with the line as it moves.

 EXAMPLES:

    TS  swap the current line with the line below it
   3TS  move the current line 3 lines down
   -TS  swap the current line with the line above it
  -3TS  move the current line 3 lines up
   @TS  move the current line to a position before line with the mark







 LEADING PARAMETER: [none, + , - , +n , -n , > , < , @ ] TS
!
\UC
 UC      COMMAND INTRODUCER
 ==      ==================

   This command types the command introducer character into the text,
 inserting or overtyping it according to the current keyboard mode.  The
 command fails if the introducer is not an ASCII character.  This command is
 allowed only in screen mode.














 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] UC
!
\KM
 KM      KEY MAPPING
 ==      ===========

   This command maps a Command Procedure onto a keyboard key.  It takes two
 parameters:
         KM/key name/command procedure/
 The key names are defined by the keyboard interface (see Section 6).  The
 command procedure may contain multiple lines of text.

   The command will fail if the key name is not supported by the user's
 terminal.  If the compilation of the command procedure fails, the command
 aborts and errors are reported in the same way as by the Execute EX command.
 This command is allowed only in screen mode.








 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] KM
!
\%
   The following definitions are pre-loaded by Ludwig:
         km/control-b/wb/                km/up-arrow/ku/
         km/control-d/dc/                km/down-arrow/kd/
         km/control-e/we/                km/left-arrow/kl/
         km/control-f/wf/                km/right-arrow/kr/
         km/control-g/sx'command'/       km/home/kh/
         km/control-h/kl/                km/back-tab/kb/
         km/control-i/kt/                km/insert-char/cc/
         km/control-j/kd/                km/delete-char/dc/
         km/control-k/dl/                km/insert-line/cl/
         km/control-l/cl/                km/delete-line/dl/
         km/control-m/kc/                km/help/h&&/
         km/control-n/wn/                km/find/gt&&/
         km/control-p/uc/                km/next-screen/wf/
         km/control-r/kr/                km/prev-screen/wb/
         km/control-t/wt/
         km/control-u/ku/
         km/control-w/aw/
         km/control-^/cc/



!
{#if vms}
{##\OP}
{## OP      OPERATING SYSTEM PARENT}
{## ==      =======================}
{##}
{##   This command attaches the terminal to the parent process of the process}
{## running Ludwig (if there is one).  The Ludwig session will be resumed when}
{## the terminal is re-attached to the process running Ludwig.  This command is}
{## not allowed in non-interactive mode.}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{## LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] OP}
{##!}
{#elseif unix}
{##\OP}
{## OP      OPERATING SYSTEM PARENT}
{## ==      =======================}
{##}
{##   This command suspends the process running Ludwig and transfers control}
{## to the parent shell process.  The shell "fg" command can be used to}
{## resume the suspended process.  This command is not allowed in}
{## non-interactive mode.}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{## LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] OP}
{##!}
{#endif}
{#if vms}
{##\OS}
{## OS      OPERATING SYSTEM SUBPROCESS}
{## ==      ===========================}
{##}
{##   This command attaches the terminal to a subprocess of the process running}
{## Ludwig.  The Ludwig session will be resumed when the terminal is re-attached}
{## to the process running Ludwig.  The first time this command is executed, it}
{## will create a new process; on subsequent executions it will attach to the}
{## same process if it still exists, or create a new process.  This command is}
{## not allowed in non-interactive mode.}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{## LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] OS}
{##!}
{#elseif unix}
{##\OS}
{## OS      OPERATING SYSTEM SHELL}
{## ==      ======================}
{##}
{##   This command creates a subprocess running the shell specificed by the}
{## environment variable SHELL, or "/bin/sh" if the environment variable is}
{## not defined.  The Ludwig process will be resumed when the shell process}
{## terminates.  This command is not allowed in non-interactive mode.}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{##}
{## LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] OS}
{##!}
{#endif}
\OX
 OX      OPERATING SYSTEM EXECUTE
 ==      ========================

 Execute an Operating System command inserting the lines output above the
 current line.
















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] OX
!
\V
 V       VERIFY
 =       ======

   Verify looks at the first character of its trailing parameter, and if it is
 either a 'y', a 'Y' or a space then the V command succeeds.  If the first
 character is an 'a' or 'A' then the V command will not prompt again, and will
 always return success.  Entering 'q' or 'Q' causes an ABORT (see XA).  Any
 other response is taken as 'n' or 'N' and V fails.

 Example:
 -------
   V&Shall I Go On?&     prompts "Shall I Go On?"
   V/Shall I Go On?/     uses "S" as the answer (watch out for this!)
   V&&                   prompts "Verify?"







 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] V
!
\W
 PREFIX W COMMANDS
 =================

   Commands beginning with W pertain to the management of the visible window
 (the screen).  Normally the window tracks the Dot.  The Dot is restricted to
 be within the EP Vertical Margins, and never off the sides of the screen. In
 a Command Procedure the screen image is kept up to date, until the Dot moves
 off the screen, in which case no further updating is attempted unless a WU
 command forces a new screen image to be made, or the Command Procedure
 terminates.

  WB     Window Back         Moves the window back over the frame
  WC     Window Centre       Centres the window on Dot
  WE     Window End          Moves the window to the end of the frame
  WF     Window Forward      Moves the  window forward over the frame
  WH     Window Height       Sets the height of the window
  WL     Window Left         Shifts the window left
  WM     Window Move         Enables scrolling with arrow keys
  WN     New Window          Redisplays the current window
  WR     Window Right        Shifts the window right
  WT     Window Top          Moves the window to the top of the frame
  WU     Window Update       Updates the window without a full re-draw
!
\WB
 WB      WINDOW BACK
 ==      ===========

   Moves the window back over the frame by n window heights.

















 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] WB
!
\WE
 WE      WINDOW END
 ==      ==========

   Moves the window to the end of the current frame.

















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] WE
!
\WF
 WF      WINDOW FORWARD
 ==      ==============

   Moves the window forward over the frame by n window heights.

















 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] WF
!
\WH
 WH      WINDOW HEIGHT
 ==      =============

   Sets the height of the window to n lines.  When operating over slow
 communications lines it may be convenient to reduce the window height.
 When the leading parameter is omitted, the height of the window is set to
 the height of the terminal.














 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] WH
!
\WL
 WL      WINDOW LEFT
 ==      ===========

   Moves the window n characters to the left, if possible.  When no leading
 parameter is given, the window is moved 40 characters left, if possible.
















 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] WL
!
\WC
 WC      WINDOW CENTRE
 ==      =============

   Scrolls the window so that Dot is centred between the top and bottom
 margins.
















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] WC
!
\WN
 WN      NEW WINDOW
 ==      ==========

   Redisplays the current window.  This command is useful when the current
 display has become corrupted, e.g. by a transmission error, or by a system
 message.















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] WN
!
\WR
 WR      WINDOW RIGHT
 ==      ============

   Moves the window n characters to the right.  When no leading parameter is
 given, the window is moved 40 characters right.  Note that the maximum line
 length is 400 characters, and the right margin of the screen cannot move
 past column 400.














 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] WR
!
\WM
 WM      WINDOW MOVE
 ==      ===========

   Scrolls the screen n lines with Dot fixed to the text.  When no leading
 parameter is given, the arrow keys scroll until some other key is pressed.
















 LEADING PARAMETER: [none, + , - , +n , -n , > , < ,   ] WM
!
\WT
 WT      WINDOW TOP
 ==      ==========

   Moves the window to the top of the current frame.

















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] WT
!
\WU
 WU      WINDOW UPDATE
 ==      =============

   Ludwig attempts to maintain the display while a Command Procedure is being
 executed. If the Dot moves off the screen, no further updating is attempted
 until the procedure terminates.  The Window Update command WU can be used
 within a Command Procedure to force an update at any time.














 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] WU
!
\X
 PREFIX X COMMANDS
 =================

   Commands beginning with X are the EXIT commands.  These commands are used
 within Command Procedures for flow control and error handling.  Any command
 in Ludwig can exit with one of three statuses, Success, Failure, or Abort.
 Also in a Command Procedure a group of commands (commands within parentheses)
 may exit with any of the three statuses.  If a command or a group of commands
 is followed by an exit handler the success and failure statuses are used to
 select action within the handler.  An Abort exit status causes the Command
 Procedure to terminate.  The EXIT XA,XS,XF commands are used to explicitly
 cause a group of commands to exit.  The leading parameter indicates the
 number of levels of parentheses (textual) that should be exited.

 Exit handlers have the form
    <command> "[" code executed on success ":" code executed on failure "]"
 If the colon is omitted the code (if any) is assumed to be a success handler.

  XA     Exit Abort          Aborts Command Procedure
  XS     Exit success        Command Procedure exit with success
  XF     Exit Failure        Command Procedure exit with failure

!
\XA
 XA      EXIT ABORT
 ==      ==========

 Command Procedure Use:
 ---------------------
   Aborts all Command Procedure execution, no matter how deeply nested
 (textually or dynamically), and returns control to interactive keyboard
 entry; signals failure on return.













 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] XA
!
\XF
 XF      EXIT FAIL
 ==      =========

 Command Procedure Use:
 ---------------------
   Transfers control out of a Command Procedure by the specified number of
 nesting levels; "nesting level" is textual, based on a count of parentheses
 only, not dynamic.  Usually used in exit handlers (see Command Procedures).
 It signals failure on return.

 EXAMPLE:
 -------
    >( 5( AC[:2XF] ) AL[:XS] )  TO/*****/

    Failure of the command AC causes execution of its fail handler, which
    in this case is the command 2XF.  Control transfers out by two levels,
    i.e. out of both loops.  Because XF signals a failure on exit from the
    loop, the entire procedure fails at that point so TO/*****/ is not
    executed.


 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] XF
!
\XS
 XS      EXIT SUCCESS
 ==      ============

 Command Procedure Use:
 ---------------------
   Transfers control out of a Command Procedure by the specified number of
 nesting levels; "nesting level" is textual, based on a count of parentheses
 only, not dynamic.  Usually used in exit handlers (see Command Procedures).
 It signals success on return.

 EXAMPLE:
 -------
    >( 5( AC[:2XF] ) AL[:XS] )  TO/*****/

    Failure of the command AL causes execution of its fail handler, which
    in this case is the command XS.  Control transfers out by one level,
    i.e.  out of the outermost loop.  Because XS sets the execution status
    to "success", TO/*****/ is executed.



 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] XS
!
\TF
 PREFIX TF COMMANDS
 ==================

   Commands beginning with TF are the text formatting commands.  These
 commands are used to construct Command Procedures, or may be used in
 sequence, to format text according to normal text layout conventions.

  TFC    Centre Line         Centres line between margins
  TFF    Word Fill           Places as many words as possible on a line
  TFJ    Line Justify        Expands line to fit exactly between margins
  TFL    Align Left          Places start of line at left margin
  TFR    Align Right         Places end of line at right margin
  TFS    Word Squeeze        Removes extra spaces from line









!
\TFC
 TFC     CENTRE LINE
 ===     ===========

           |                                                      |
             Centre Line places the current line between the left
             and right margins, with an equal number of blanks at
             each end.  TFC fails if the line is too long to fit
            between the margins.  Dot is placed at the left margin
           of the next line.  >TFC centres a paragraph beginning at
             the current line, where a paragraph is a contiguous
                          block of non-blank lines.
           |                                                      |

 Suggested use is
      >TFF=AC>TFC






 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] TFC
!
\TFF
 TFF     LINE FILL
 ===     =========

   Line Fill places as many words on the current line (between the margins)
 as possible, placing words onto the next line, or removing them from the
 next line, if necessary.  A word is a contiguous block of non-blank
 characters.  If text protrudes to the left of the left margin it is not
 moved.  >TFF will format an entire paragraph, where a paragraph is a
 contiguous block of non-blank lines.

 Suggested use to format a paragraph is as follows :
   Place Dot on the first character of the first word (indented to its
   intended position).

   Ragged Right Format          >TFS=AC>TFF
   Ragged Left Format           >TFS=AC>TFF=AC>TFR
   Left and Right Justified     >TFS=AC>TFF=AC>TFJ




 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] TFF
!
\TFJ
 TFJ     LINE JUSTIFY
 ===     ============

   Line Justify expands the current line by inserting spaces between words so
 that the line fits between the margins. If text protrudes to the left of the
 left margin the protruding text is not modified. The line is not modified if
 the next  line is  blank. If the  line protrudes past  the right  margin the
 command fails. >TFJ justifies an entire  paragraph from Dot onward, but will
 not expand the last  line of the paragraph. 3TFJ justifies  the next 2 lines
 treating the third line as the last  line of the paragraph. Dot is placed on
 the left margin of the next line.

 Suggested use to justify a paragraph is as follows :
   Place Dot on the first letter of the first word of the
   paragraph (indented to its intended position).
   Then
                   >TFS=AC>TFF=AC>TFJ




 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] TFJ
!
\TFL
 TFL     ALIGN LEFT
 ===     ==========

 Align Left places the first character of the first word of the current line
 on the left margin.  If the line protrudes to the left of the left margin
 the command fails.  The Dot is placed on the left margin of the next line.
 >TFL aligns an entire paragraph from Dot onward, where a paragraph is a
 contiguous block of non-blank lines.













 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] TFL
!
\TFR
 TFR     ALIGN RIGHT
 ===     ===========

        Align Right places the last character of the last word of the current
    line on the right margin. If the line protrudes to the right of the right
 margin the text is not modified. The Dot is placed on the left margin of the
          next line. >TFR aligns an entire paragraph from Dot onward, where a
                          paragraph is a contiguous block of non-blank lines.













 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] TFR
!
\TFS
 TFS     WORD SQUEEZE
 ===     ============

   Word Squeeze removes all extra spaces from the current line.  Any series
 of multiple spaces is replaced by a single space.  If all the text is to the
 right of the left margin then the leading spaces are retained.  Dot is
 placed on the left margin of the next line.

 Suggested use to format a paragraph is as follows :
   Place Dot on the first character of the first word (indented to its
   intended position).

   Ragged Right Format          >TFS=AC>TFF
   Ragged Left Format           >TFS=AC>TFF=AC>TFR
   Left and Right Justified     >TFS=AC>TFF=AC>TFJ






 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] TFS
!
\K
 PREFIX K COMMANDS
 =================

   Commands beginning with K are the commands associated with the use of the
 keyboard within Ludwig.

 The keyboard keys only invoke the associated command by default.  It is
 possible to map a command string onto any of these keys.

  KB     Backtab             Same as <BACKTAB> key
  KC     Carriage Return     Same as <RETURN> key
  KD     Cursor Down         Same as down arrow key
  KH     Cursor Home         Same as <HOME> key
  KI     Insert Mode         Change to insert mode
  KL     Cursor Left         Same as left arrow key
  KM     Key Mapping         Define a command key mapping
  KO     Overtype mode       Change to overtype mode
  KR     Cursor Right        Same as right arrow key
  KT     Tab                 Same as <TAB> key
  KU     Cursor Up           Same as up arrow key
  KX     Delete              Same as <DELETE> key

!
\KB
 KB      BACKTAB
 ==      =======

   Moves to the previous tab position on the line, if any.  Tabs are set by
 default on columns 1, 9, 17,... etc.  See command EP for information on
 setting tabs.















 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] KB
!
\KC
 KC      CARRIAGE RETURN
 ==      ===============

   Advances Dot n lines; useful in Command Procedures.  If the EP indentation
 tracker option is turned off, Dot moves either to the left margin or to
 column one if it was to the left of the left margin already.  If the EP
 indentation tracker option is turned on, Dot moves to the position of the
 first non-blank character of the line which it was on when the KC command
 was executed.  (The behaviour of the indentation tracker is actually more
 complex than this, but is best understood by experimentation.)  When working
 in insert mode, if the EP newline option is turned on, KC or <RETURN>
 behaves as Text Break TB.









 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] KC
!
\KD
 KD      CURSOR DOWN
 ==      ===========

   Moves Dot vertically down; useful in Command Procedures.

















 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] KD
!
\KH
 KH      CURSOR HOME
 ==      ===========

   Moves Dot home; useful in Command Procedures.  Home is the position in
 column 1 of the top line of the current screen.  However, in order for Dot
 to stay within the upper vertical margin, the screen may scroll downwards
 while Dot remains on the character in the home position.  The number of
 lines which the screen must scroll depends on the upper margin setting.
 (See help on EP.)












 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] KH
!
\KL
 KL      CURSOR LEFT
 ==      ===========

   Moves Dot left; useful in Command Procedures.  The command >KL moves Dot to
 the current left margin, unless it is to the left of the left margin, in
 which case it fails.















 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] KL
!
\KR
 KR      CURSOR RIGHT
 ==      ============

   Moves Dot right; useful in Command Procedures.  The command >KR moves Dot
 to the current right margin, unless it is to the right of the right margin,
 in which case it fails.















 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] KR
!
\KT
 KT      TAB
 ==      ===

   Moves to the next tab position on the line, if any.  Tabs are set by
 default on columns 1, 9, 17,... etc.  See command EP for information on
 setting tabs.















 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] KT
!
\KU
 KU      CURSOR UP
 ==      =========

   Moves Dot up; useful in Command Procedures.

















 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] KU
!
\KX
 KX      DELETE
 ==      ======

   Equivalent to the keyboard DEL key; useful in Command Procedures.
 Equivalent to the command sequence -AC TO/ / -AC when in overtype mode
 and -AC DC when in insert mode.















 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] KZ
!
\\
 \      COMMAND
 =      =======

   Normally, typing at the keyboard causes characters to be entered into the
 text being edited, either by overtyping or insertion.  The character "\" is
 the default command introducer, and when it is typed, it is not entered into
 the text, but enables the keyboard to be used to enter the name of a single
 editing command.  The command will be executed if it is valid.

 Normally, the command introducer is needed for every command entry. The
 command -\ enables a sequence of editing commands to be entered
 interactively without the need for a command introducer. This facility is
 especially useful for hand simulating Command Procedures, but should be used
 with care. The command \ re-establishes normal text entry from the keyboard
 (as do the commands KO and KI). \ returns Ludwig to the editing mode stored
 by the most recent -\ command. KI or KO put it into Insert or Overtype modes
 respectively.




 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] \
!
\TX
 TX      TEXT EXECUTE
 ==      ============

   Provides a line for the interactive specification of a Command Procedure.
 Command Procedures entered this way may not be longer than one line on the
 screen.  On pressing <RETURN>, the command string is placed in frame
 COMMAND, the previous contents of which (if any) are placed in frame OOPS.
 Frame COMMAND is then compiled, and if there are no syntax errors, executed.
 If any syntax errors are detected, frame COMMAND is displayed with the
 Command Procedure and error messages.  Error messages take the form of
 comments, the comment marker (!) pointing to the error.  The erroneous
 procedure may be edited in frame COMMAND; the error messages need not be
 deleted.  After returning to the appropriate editing frame (usually by the
 Edit Return command ER), the procedure in COMMAND can be re-compiled and
 executed by the Execute command SX.  Unless remapped (see the UK command),
 CTRL/G is a convenient synonym for SX/COMMAND/.





 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] TX
!
\(
 (       DIRECT ENTRY EXECUTE STRING
 =       ===========================

   The Direct Entry Execute String command "(" is used in exactly the same
 way as the Execute String command "^", but it does not provide a line to
 type on, nor does it echo the command string to the terminal.  The command
 string is submitted for execution by a balancing ")", but the command string
 is not copied into frame COMMAND.  Syntax errors are reported by ringing the
 terminal bell at the time the error is typed.  Any valid Command Procedure
 may be entered this way.  This method of command entry is most useful for
 Command Procedures stored in terminal function keys.










 LEADING PARAMETER [ none, + ,   , +n ,    , > ,   ,   ] (
!
\"
 "       DITTO
 =       =====

   Copies characters from the line immediately above the Dot, inserting or
 overtyping them at the Dot, and moving the Dot to the right.  The command
 remains in effect until a key other than " or ' is depressed; thus copying
 can be controlled conveniently with repeated entry of the " character.  With
 a negative leading parameter, copying moves from right to left.  The command
 ' copies from the line below.  -" and -' are not allowed in insert mode.

 EXAMPLES:

    "    copy a character from above the Dot
    '    copy a character from below the Dot
   9"    copy nine characters from above and to the right of the Dot
  -9"    copy nine characters from above and to the left of the Dot
   >"    copy all characters from above the Dot to the end of line
   <"    copy all characters from above the Dot to column one
   >'    copy all characters from below the Dot to the end of line
   <'    copy all characters from below the Dot to column one

 LEADING PARAMETER: [none, + , - , +n , -n , > , < ,   ] "
!
\'
 '       DITTO FROM BELOW
 =       ================

   Copies characters from the line immediately below the Dot, inserting or
 overtyping them at the Dot, and moving the Dot to the right.  The command
 remains in effect until a key other than " or ' is depressed; thus copying
 can be controlled conveniently with repeated entry of the " character.  With
 a negative leading parameter, copying moves from right to left.  The command
 ' copies from the line below.  -' and -" are not allowed in insert mode.

 EXAMPLES:

    '    copy a character from below the Dot
    "    copy a character from above the Dot
   9'    copy nine characters from below and to the right of the Dot
  -9'    copy nine characters from below and to the left of the Dot
   >'    copy all characters from below the Dot to the end of line
   <'    copy all characters from below the Dot to column one
   >"    copy all characters from above the Dot to the end of line
   <"    copy all characters from above the Dot to column one

 LEADING PARAMETER: [none, + , - , +n , -n , > , < ,   ] '
!
\TC
 TC      TEXT CASE CHANGE
 ==      ================

   Changes the case of alphabetic characters.  The command takes a trailing
 parameter, either U, L or E (u, l or e) to specify upper, lower or edit case.
 The command moves the Dot to the right, or to the left with a negative
 leading parameter.  The command remains in effect until a character other
 than U, L or E is typed, or the end-of-line is reached.  No trailing
 parameter delimiters are required when the Case Change command is used in
 Command Procedures.

 EXAMPLES:

   9TCU  change nine characters to upper case, from the Dot to the right
  -9TCU  change nine characters to upper case, from the Dot to the left
   >TCL  change all characters to lower case, from the Dot to the end of line
   <TCL  change all characters to lower case, from the Dot to column one
   >TCE  Changes The Rest Of The Line To Edit Case (This Is Edit Case)



 LEADING PARAMETER: [none, + , - , +n , -n , > , < ,   ] TC
!
\{
 {      LEFT MARGIN
 =      ===========

   The command { sets the left margin at the current column and -{ sets it
 to the default left margin for the frame.  The left margin is significant
 for commands such as <RETURN> and Split Line.  The left and right margins
 can also be set by the Editor Parameters command EP.














 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] {
!
\}
 }       RIGHT MARGIN
 =       ============

   The command } sets the right margin at the current column and -{ sets it
 to the default right margin for the frame.  The right margin is significant
 for interactive text entry.  The left and right margins can also be set by
 the Editor Parameters
 command EP.













 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] }
!
\TN
 TN      TEXT NOECHO
 ==      ===========

   The command allows n characters to be entered interactively, and inserted
 at the Dot in the current frame.  However, no prompt is issued, character
 entry is not echoed, and the insertion does not occur until entry is
 complete. The leading parameter > allows text to be accepted invisibly until
 <RETURN> is entered.  Text Noecho is useful in Command Procedures which have
 to prompt for input from the terminal.












 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] TN
!
\#
