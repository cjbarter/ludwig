{**********************************************************************}
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
! $Header: /home/medusa/user1/projects/ludwig/current/RCS/ludwighlp.t,v 4.4 90/02/28 14:11:15 ludwig Exp $
! $Log:         ludwighlp.t,v $
! Revision 4.4  90/02/28  14:11:15  ludwig
! Add the FS command and correct the FO command.
!
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                     6-May-1987
!       One line in section 4 contained a "\" in column 1. There was an
!       index entry in the .IDX file for "Gcat".
!       The text has been moved to columns 2..78 and column 1 now
!       contains only flag characters. HELPFILE.PAS and .C have been
!       modified accordingly.
! 4-003 Kelvin B. Nicolle                                    26-May-1987
!       Remove one line from the US section.
!
! To set up the required margins, tabs and file format, execute the
! Ludwig command "ex/ludwig/"
!
{ <jj ep/m=(2,78), t=(1,10,18,26,34,42,50,58,66,74), o=(-i),v=(0,0)/
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
     Symbol  Name           Action
     ------------------------------------------------------------------------
      A      Advance        Moves forward or backward n lines
      C      Insert Char    Inserts n spaces before Dot
      D      Delete         Deletes n characters
      G      Get            Gets nth occurrence of a string
      H      Help           Help on a command or topic
      I      Insert         Insert option--typed text is inserted
      J      Jump           Moves Dot left or right
      K      Kill           Deletes n lines
      L      Insert Line    Inserts n blank lines above Dot
      M      Mark           Defines a mark.  nM defines mark 1..9
      N      Next Char      Gets next occurrence of a character
      O      Overtype       Overtype option--typed text overwrites existing
      Q      Quit           Exits from editor
      R      Replace        Replaces one string with another
      SD     Define Span    Defines and names a span
      SC     Span Copy      Copies a previously defined span
      SW     Swap Lines     Swaps current line with one below (or above)
      "      Ditto          Copies characters from the line above
!
\2
+  2. Control Code Commands
   ========================

 Control codes are mapped to Ludwig commands as follows:

 CTRL/@                  Not used
 CTRL/A                  Not used
 CTRL/B                  Window Backward              { Same as WB }
 CTRL/C                  Not used
 CTRL/D                  Delete Char                  { Same as D }
 CTRL/E                  Window End                   { Same as WE }
 CTRL/F                  Window Forward               { Same as WF }
 CTRL/G                  Execute frame COMMAND        { Same as EX/COMMAND/ }
 CTRL/H or <BACKSPACE>   Cursor Left                  { Same as ZL }
 CTRL/I or <TAB>         Tab                          { Same as ZT }
 CTRL/J or <LINEFEED>    Cursor Down                  { Same as ZD }
 CTRL/K                  Kill Line                    { Same as K }
 CTRL/L                  Insert Line                  { Same as L }
 CTRL/M or <RETURN>      Carriage Return              { Same as ZC }
 CTRL/N                  New Window                   { Same as WN }
 CTRL/O                  Not used
 CTRL/P                  Type the command introducer  { Same as UC }
!
\%
 CTRL/Q                  Not used
 CTRL/R                  Cursor Right                 { Same as ZR }
 CTRL/S                  Not used
 CTRL/T                  Window Top                   { Same as WT }
 CTRL/U                  Cursor Up                    { Same as ZU }
 CTRL/V                  Not used
 CTRL/W                  Word Advance                 { Same as YA }
 CTRL/X                  Not used
 CTRL/Y                  Not used
 CTRL/Z                  Not used
 CTRL/[                  Not used        { Escape sequence introducer }
 CTRL/\                  Not used
 CTRL/]                  Not used
 CTRL/^                  Insert Character             { Same as C }
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
  A      Advance             Moves forward or backward n lines
  BR     Bridge              Bridges any of a set of characters
  C      Character insert    Inserts n spaces before Dot
  D      Delete              Deletes n characters
  ED     Edit frame          Changes frames, possibly creating a new one
  EK     Kill Edit frame     Destroys a frame and its attributes
  EN     Execute Norecompile Executes commands in a span; no recompilation
  EOL    End Of Line         Tests for end of line
  EOP    End Of Page         Tests for end of page
  EOF    End Of File         Tests for end of file
  EP     Edit Parameters     Shows editor parameters, e.g. margins, options
  EQC    Equal Column        Tests for column position of Dot
  EQM    Equal Mark          Tests for position of mark n
  EQS    Equal String        String match at Dot
  ER     Edit Return         Returns to frame which called current frame
  EX     Execute             Compiles and executes commands in a span
  FB     File Back           Rewinds the input file of the current frame
  FE     File Edit           Opens input and output files for current frame
!
\%
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
  I      Insert              Insert option--typed text is inserted
  J      Jump                Moves Dot left or right n characters
  K      Kill                Deletes n lines
  L      Insert Line         Inserts n blank lines above Dot
  M      Mark                Defines a mark; nM defines mark 1..9
  N      Next Character      Get nth occurrence of any of a set of characters
  O      Overtype            Overtype mode--typed text overwrites existing
!
\%
  Q      Quit                Exits from editor
  R      Replace             Replaces one string with another
  SA     Span Assign         Assigns text to a span
  SC     Span Copy           Copies a previously defined span
  SD     Span Define         Defines and names a span
  SI     Span Index          Lists all spans and frames
  SJ     Span Jump           Jumps to the beginning or end of a span
  SL     Split Line          Splits a line in two
  SR     Span Recompile      Recompiles a span
  ST     Span Transfer       Moves a previously defined span (not a copy)
  SW     Swap Line           Swaps a pair of lines
  UC     Command Introducer  Types the command introducer into the text
  UK     Key Mapping         Maps a command string onto a keyboard key
  UP     Parent Process      Attaches the terminal to the parent process
  US     Subprocess          Attaches the terminal to a subprocess
  V      Verify              Command Procedure interactive verify
  WB     Window Back         Moves the window back over the frame
  WE     Window End          Moves the window to the end of the frame
  WF     Window Forward      Moves the  window forward over the frame
  WH     Window Height       Sets the height of the window
  WL     Window Left         Shifts the window left
  WM     Window Middle       Centres the window on Dot
!
\%
  WN     New Window          Redisplays the current window
  WR     Window Right        Shifts the window right
  WS     Window Scroll       Enables scrolling with arrow keys
  WT     Window Top          Moves the window to the top of the frame
  WU     Window Update       Updates the window without a full re-draw
  YA     Word Advance        Advances n words
  YC     Centre Line         Centres line between margins
  YD     Word Delete         Deletes n words
  YF     Word Fill           Places as many words as possible on a line
  YJ     Line Justify        Expands line to fit exactly between margins
  YL     Align Left          Places start of line at left margin
  YR     Align Right         Places end of line at right margin
  YS     Word Squeeze        Removes extra spaces from line
  XA     Exit Abort          Aborts Command Procedure
  XS     Exit success        Command Procedure exit with success
  XF     Exit Failure        Command Procedure exit with failure
  ZB     Backtab             Same as <BACKTAB> key
  ZC     Carriage Return     Same as <RETURN> key
  ZD     Cursor Down         Same as down arrow key
  ZH     Cursor Home         Same as <HOME> key
  ZL     Cursor Left         Same as left arrow key
  ZR     Cursor Right        Same as right arrow key
!
\%
  ZT     Tab                 Same as <TAB> key
  ZU     Cursor Up           Same as up arrow key
  ZZ     Delete              Same as <DELETE> key
  \      Command             Switch between command and text entry modes
  ^      Execute String      Prompts for and executes a Command Procedure
  (      Direct Entry        An unprompted version of Execute String
  "      Ditto               Copies characters from line above
  '      Ditto from below    Copies characters from line below
  *      Case Change         Changes case to upper, lower or editcase
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
  <LINEFEED>    Cursor Down       Moves Dot to next line
  <TAB>         Tab               Moves Dot to the next tab stop
  <BACKSPACE>   Backspace         Moves Dot to left
  <DELETE>      Delete            Delete the previous character, move Dot left
  <BACKTAB>     Backtab           Moves Dot to the previous tab stop
  Left  Arrow   Cursor Left       Moves Dot to left (same as Backspace)
  Right Arrow   Cursor Right      Moves Dot to right
  Up    Arrow   Cursor Up         Moves Dot to next line
  Down  Arrow   Cursor Down       Moves Dot to previous line
  Home          Cursor Home       Moves Dot to the home position






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
 commands: I, R (second parameter), SA (second parameter), UK
 (second parameter), and ^.
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
   The commands R (Replace), SA (Span Assign), and UK (Key Mapping) take 2
 trailing parameters.  These are specified so that the outermost delimiter is
 also used to separate the 2 parameters.

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
        [<left context> ,] <middle context> [, <right context>]
   each context being a context free pattern (COMPOUND in syntax).
    - defaulting to left and middle if a third  pattern is not specified.
   When a pattern has been successfully matched, the marks Dot and Equals
   are left wrapped around the middle context.
   A context free pattern is defined with a regular expression.
   '|' is used to denote OR (alternative).  Concatenation is implicit.
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

   The Key Mapping command UK defines keys by name. There is a standard set
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
+  7. Release Notes for Ludwig V4.0
      =============================

 Changes in Command Names and Control Character Mappings
 =======================================================

 Removed Commands
 ----------------
 FA  \
 FC   > The slot number parameters have been removed. These command are no
 FF  /  longer required.
 UD  Replaced by the new UK command.


 The following control characters are no longer initially mapped to Ludwig
 commands or special functions.
 -------------------------------------------------------------------------
 CTRL/A  string invoke
 CTRL/C  ZH
 CTRL/Z  ZB
 CTRL/]  create sub-process
 CTRL/\  string define
!
\%
 Renamed Commands
 ----------------

 Old  New  Descriptive Name
 ---  ---  --------------------
 FR   FGR  Global File Read
 FW   FGW  Global File Write
 P    FP   File Page
 |    {    Left Margin


 Added Commands
 --------------
 UC     Command Introducer
 UK     Key Mapping
 UP     Parent Process
 US     Subprocess
 }      Right Margin

 See the appropriate help entry for more information.


!
\%
 Modified Behaviour of Existing Commands and Features
 ====================================================

 A:   +nA fails without moving Dot when the n'th line is the end-of-file
      line. This command no longer moves Dot when it fails.

 BR:  +nBR and -nBR are no longer allowed. -BR has been redefined to move Dot
      backwards over occurrences of any of the set of characters given in the
      trailing parameter. The characters spanned between Dot and Equals are
      now only from the parameter set. Coupled with the redefinition of -N
      this makes command strings such as "-N/0..9/-BR/0..9/" work correctly.
      In interactive mode, BR now prompts for a character set instead of just
      taking the next character from the keyboard.

 EP:  The following initial settings have been changed: "K=I,
      M=(1,terminal_width), O=(-I,-N,-W)". The sense of O=N has been
      reversed: it means treat carriage return as new line in insert mode.
      The default setting has been changed to O=-N so that the default action
      is unchanged.

 EQM: The test for Equals is EQM/=/ instead of EQM/0/.

!
\%
 F*:  The slot number parameters have been removed.

 FGR: Dot is now positioned at the end of the inserted text, not at the
      beginning.

 FP:  See "File loading" below.

 FX:  The frame used by the FX command has been renamed from C to COMMAND.

 N:   -N now leaves Dot to the right of the located character and does not
      fail when all the characters between Dot and beginning of file are in
      the command's character set. See BR. In interactive mode, N now prompts
      for a character set instead of just taking the next character from the
      keyboard.

 Q:   Attempting to quit when a frame has been modified, has an input file,
      and has no output now prompts with
         "This frame has no output file--are you sure you want to QUIT?"
      The sense of the question is different and the the positive and
      negative answers are therefore reversed in meaning.


!
\%
 SC:  Dot is now positioned at the end of the inserted text, not at the
      beginning.

 SD:  0SD is now illegal; =SD should be used.

 ST:  Dot is now positioned at the end of the inserted text, not at the
      beginning.

 UK:  All existing uses of the UD command can be rewritten using the revised
      SA command and the new UK command.
           old usage                       new usage
           ---------                       ---------
           /span-name//text                SA/span-name/text/
           //key-number/commands           UK/key-name/commands/
           /span-name/key-number/commands  SA/span-name/commands/
                                             UK/key-name/EN'span-name'/

 YA:  <YA moves to the beginning of the current paragraph in all cases. -nYA
      moves to the start of the n'th previous word. Use 0YA to move to start
      of current word.


!
\%
 " and ': The ditto commands now insert when the keyboard is in insert mode.
      Negative leading parameters are illegal in insert mode.

 ^:   The frame used by the ^ command has been renamed from C to COMMAND.

 command line: The command line "ludwig file" will now create a new file if
      the named file does not exist. If the file name was mistyped the user
      can quit immediately and no new file will be created. See file options.

 control-]: This key no longer creates a sub-process. The key can be mapped
      onto the new US command to emulate the previous functionality - this
      mapping is not present by default.

 default frame: The name of the default frame is now "LUDWIG". ED// is
      equivalent to ED/LUDWIG/, but the empty name is not accepted by span
      commands such as SC and ST.

 Dot, position after text insertion: Dot is now positioned at the end of the
      inserted text, not at the beginning. This affects the FGR, SC and ST
      commands.

 Equals: The Equals Mark is no longer accessible as mark number 0.
!
\%
 file loading: The FI and FE commands now load the input file into the frame
      without an explicit P command. The -FO and -FE commands write the
      contents of the frame (and the remainder of the input file, if any) to
      the output file without an explicit P command. The "Paging" message has
      been changed to "Loading File".

 file options: The options on the command line and those on the F* commands
      are now consistent. The options on the F* commands are no longer just a
      single character. Thus option "t" is now ambiguous. The old internal
      form of the number option ("#") is no longer accepted. For more
      information on file options use
         help ludwig             (VMS)
         man ludwig              (Unix)

 frame C: The frame used by the ^ and FX commands has been renamed from C to
      COMMAND.

 memory: The memory is set when the output file is closed rather than when it
      is opened.

      VMS: The ";" has been removed from the logical name definition to make
      it more useful in DCL commands.
!
\%
 output files:
      VMS: Output files are opened with a temporary name and with
      (rwed,rwed,,) protection. The temporary name is the final name with
      "-LW" appended to the file type. The file is renamed and given the same
      protection and ACLs as any earlier version of the file (or the default
      protection and ACLs if there is no earlier version) after the file has
      been written and closed.

      Unix: Output files are opened with a temporary name and with mode 0644.
      The temporary name is the final name with "-lw" appended to the file
      name. If necessary, a number is also appended to ensure that the name
      does not conflict with any existing file. The file is renamed after the
      file has been written and closed. If this replaces an earlier file,
      the mode of the earlier file is retained.

 pattern matcher:
      a. The tests for left and right margin are { and }; to be consistent
         with the new margin setting commands.
      b. Ranges are specified with [ and ] instead of { and }.



!
\%
 trailing parameters: The trailing parameter "?" has been replaced by "&&",
      or "&&&" for commands with two trailing parameters. An empty prompt
      string in any context is replaced by the default prompt string for the
      command. Span names and prompt strings can no longer end with an
      end-of-line.

















!
\%
 New Features
 ============

 EP:  The C option takes a single ASCII character not in the set
      [' ','A'..'Z','a'..'z'] or any key name supported by the keyboard
      interface.

 FX:  nFX is now implemented. Under VMS the file parameter is now parsed with
      a default file type of ".LUD".

 I:   The I command can now have multiple line trailing parameters. This
      makes it easier to insert multiple lines of text in hardcopy and
      non-interactive modes.
           a                                  >ji/
           li/line 1/a                        line 1
           li/line 2/a        becomes         line 2
           li/line 3/a                        line 3/

 SI:  The Span Index display no longer displays text beyond the end of a
      span. Spans longer than 31 characters, and spans containing more than
      one line, have "..." printed to show that the display is not the whole
      span.
!
\%
 SW:  >SW and <SW are now implemented, moving the line to the bottom and top
      of the frame respectively.

 WB:  nWB is now implemented.

 WF:  nWF is now implemented.

 WH:  WH with no leading parameter now sets the window to the height of the
      terminal.

 ^:   Repeat counts are now allowed on the ^ command.

 character set: The DEC Multinational Character Set is now supported under
      VMS. This includes case conversions.

 command introducer: The command introducer can now be any ASCII character
      not in the set [' ','A'..'Z','a'..'z'], or any key name supported by
      the keyboard interface. This is set by the C option of the EP command.

 control-P: This key is now mapped to the new UC command. The key can now be
      remapped without losing the "type command introducer" function.

!
\%
 keyboard interface: The keyboard interface has been redesigned. See help
      section 6.

 leading parameters: The leading parameter "+" is allowed wherever the
      leading parameters "+n" or "-" are allowed.

 Modified mark: A new mark has been implemented to mark the point of last
      modification of a frame. The mark is undefined until the modified flag
      is set. It is referenced by the leading parameter "%". To test for the
      Modified mark use EQM/%/.

 multiple line trailing parameters: The syntax of trailing parameters has
      been generalized to allow parameters to contain end-of-line's. Multiple
      line trailing parameters are restricted to the following commands: I,
      R:second parameter, SA:second parameter, UK:second parameter, and ^.
         Multiple line trailing parameters cannot be entered in response to a
      prompt in screen mode.

 nested execution: The main executor routine has a recursion limit of 100.

 output file close: No new file is created if the frame has not been
      modified.
!
\%
 prompted reads: line editing is available during all prompted reads under
      VMS.

 window position: The window is redrawn in the same position after returning
      from commands such as ER and H.

















!
\%
 Bugs Fixed
 ==========
 D:   0D, and @D with Dot=mark no longer set the modified flag.

 EK:  The modified flag is no longer set in the current frame.

 FT:  The bug in displaying long file specifications has been fixed.

 H:   The delete key is now processed in the internal prompt.

 K:   0K, and @K with Dot on the same line as the mark no longer set the
      modified flag.

 R:   Dot and Equals are moved, and the modified flag set, only after a
      completed replacement.

 ST:  ST from one frame to another now sets the modified flag in the source
      frame.

 V:   In non-interactive mode V aborts as if receiving an answer of 'Q'.

 YA:  The modified flag is no longer set by the YA command.
!
\%
 WL:  >WL is now a syntax error.

 WR:  >WR is now a syntax error.

 YJ:  YJ no longer hangs when there is no text between the margins and text
      to the left of the left margin.

 ZC:  ZC executed on the end-of-file line sets the modified flag.

 Dot, initial position: The initial position of Dot in a new frame is
      (left-margin,1) instead of (1,1).

 output files: The temporary file is now created with delete access so that
      FK will not fail. The required access is put on the file when it is
      closed and renamed.

 initialization: Failure during execution of the initialization commands no
      longer aborts Ludwig.

 right margin: The default setting of the right margin is the terminal width,
      not always 80. Text entry at the right margin without the wrap option
      set now jams properly.
!
\%
 Changes to the Ludwig command line
 ==================================

 file options: The "tab" option is global in meaning, and is applied to all
      output files unless overridden on the FO or FE command.

      VMS: The "list", "fortran" and "number" options have been replaced by
      the "type" and "attribute" options. Stream_LF files are supported.
      Editing a numbered input file produces a numbered output file. The
      "quick" option is no longer accepted.

 initialize option: The initialization option is now of the form
         /initialize=file        default=LUD_INIT        VMS
         -i file                 default=~/.ludwigrc     Unix
      The file is executed with the Ludwig FX command.


 For more information on the command line use
         help ludwig             (VMS)
         man ludwig              (Unix)


!
\A
 A       ADVANCE
 =       =======

   Moves Dot forwards or backwards through the text by lines, each time
 re-setting Dot to column one.  The command will fail if there are
 insufficient lines below or above the line containing Dot; however >A and <A
 will never fail.  If the command fails, Dot does not move.

 EXAMPLES:

   9A   move forward 9 lines
  -9A   move backward 9 lines
   0A   move to the beginning of the current line
   >A   move to the end of file marker <End of File>
   @A   move to the line containing mark 1
   =A   move to where Dot was previously





 LEADING PARAMETER: [none, + , - , +n , -n , > , < , @ ] A
!
\BR
 BR      BRIDGE CHARACTER
 ==      ================

   Skips over occurrences of any of a set of specified characters.  If the
 character at Dot is not in the set specified, Dot does not move, and the
 command does not fail.  Exact case matching is used.

 EXAMPLES:

    BR'a'    skip occurrences of the character "a" to the right
   -BR'a'    skip occurrences of the character "a" to the left
    BR'abc'  skip occurrences of any of "a", "b" or "c"
    BR'aBc'  skip occurrences of any of "a", "B" or "c"
    BR'a..z' skip occurrences of any lower case alphabetic character
    BR'0..9' skip occurrences of any numeric string






 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] BR
!
\C
 C       INSERT CHARACTER
 =       ================

   Inserts n spaces to the left of Dot.  With a positive leading parameter,
 Dot does not move relative to the beginning of the line, while with a
 negative leading parameter, Dot stays on the character it was originally on.
 The command will fail to insert any spaces if the requested insertion would
 cause the line length to exceed the implementation line length limit (400
 characters).












 LEADING PARAMETER: [none, + , - , +n , -n ,   ,   ,   ] C
!
\D
 D       DELETE CHARACTER
 =       ================

   Deletes characters at and to the right of Dot for positive parameters, and
 to the left for negative parameters.  The @ parameter specifies the deletion
 of all characters between the current position and the specified mark. Note
 that the mark can be to the left or the right of Dot.  @D also places all
 the deleted text into frame OOPS.

 EXAMPLES:

   9D   delete 9 characters at and to the right of Dot
   >D   delete all characters from the current position to the end of line
   -D   delete a character to the left of Dot
  @5D   delete all characters from Dot to mark 5
   =D   delete all characters from Dot to the previous Dot position





 LEADING PARAMETER: [none, + , - , +n , -n , > , < , @ ] D
!
\E
 PREFIX E COMMANDS  Commands beginning with "E" fall into 4 categories.
 =================
 1. Most E* commands pertain to Frames.  A Frame is a local editing
    environment, containing its own: marks, input and output files, default
    strings for EQuals-String, Get and Replace, and text.  All Frames are
    named, the default frame has the name LUDWIG.
    Other frames always created by Ludwig are :
      COMMAND the command frame.  FX and ^ place commands here and compile
              and execute them.
      OOPS    all text deleted from any other frame is placed here.
      HEAP    a special scratch frame.  Used especially by SA and UK.
    ED     Edit frame          Changes frames, possibly creating a new one
    EK     Kill Edit frame     Destroys a frame and its attributes
    EP     Edit Parameters     Show and/or change editor parameters.
    ER     Edit Return         Returns to frame which called current frame
               ------------------------------------
 2. EX and EN execute the contents of spans as Ludwig command code.
    EX     Execute             Compiles and executes commands in a span
    EN     Execute Norecompile Executes commands in a span; no recompilation
              -------------------------------------
 3. EQ*    The EQUALS commands           (see EQ)
 4. EO*    The END OF commands           (see EO)
!
\ED
 ED      EDIT FRAME
 ==      ==========

   Change editing frames to the frame with the specified name.  If a frame
 with that name does not exist, a new (empty) one is created with that name.
 Note that the default frame has the name LUDWIG, and that the frame which
 holds the current Command Procedure has the name COMMAND.  Frame OOPS
 contains all text deleted by the K, @D, SA, FX, and ^ commands.  Frame HEAP
 is used by the SA command to hold any spans it creates, and by the UK
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
\EN
 EN      EXECUTE NORECOMPILE
 ==      ===================

   Executes the compiled code for a span; if there is no compiled code for
 the span, the span is compiled first.  Thus a span may be modified, or even
 deleted, yet its old code retained and executed.  Compilation can be forced
 by the Span Recompile command SR.  The Execute command EX is equivalent to
 SR followed by EN.













 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] EN
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
 as the commands G and R.  Dot moves during the matching process, but
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
\EX
 EX      EXECUTE
 ==      =======

   Executes the contents of a span as a Command Procedure.  If the procedure
 has syntax errors, it will not be executed, and the procedure will be
 displayed in its frame, with error messages.  Error messages take the form
 of comments, the comment marker (!) pointing to the error.  The erroneous
 procedure may be edited; the error messages need not be deleted.  After
 returning to the appropriate editing frame (usually by the Edit Return
 command ER), the procedure can be re-compiled and executed.











 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] EX
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
    G'cat'=J   move to the start of the found string (i.e. the previous
               position of Dot)
    G'cat'=D   delete the found string












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
\I
 I       INSERT
 =       ======

 Interactive Use:
 ---------------
   Sets the mode of keyboard entry so that typed characters are inserted into
 the text rather than overtyping existing text.  Note that insertion may
 cause a line to become longer than the screen width.  Insertion will fail
 when the line has reached its maximum length (400 characters), and at the
 right margin when the EP wrap option is turned off.  If the EP newline
 option has been turned on, <RETURN> will split the line.  (See help on EP.)
 The O Overtype command places the editor into the overtyping mode of
 keyboard entry.

 Command Procedure Use:
 ---------------------
   The command takes a trailing parameter in Command Procedures; see the
 examples below.
 n is the number of copies to be inserted (Command Procedures only)



!
\%
 EXAMPLES:

    I/cat and dog/       insert the string "cat and dog" at Dot
   9I/cat and dog/       insert the string "cat and dog" at Dot 9 times
    I&&                  prompts for the text to be inserted
    I&Enter name:&       user defined prompt for the text to be inserted















 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] I
!
\J
 J       JUMP
 =       ====

   Moves the Dot n characters to the right or left in a line.  If the
 command cannot move the Dot as far as the leading parameter specifies
 (within the implementation line limit of 400 characters), the
 command fails, and the Dot is not moved.

 EXAMPLES:

   9J   advance the Dot 9 characters to the right, moving the window to the
        right if necessary.
  -9J   advance the Dot 9 characters to the left, moving the window to the
        left if necessary
   >J   advance to the position after the last non-space character in a
        line, i.e. jump to the end-of-line.  If Dot is past the end-of-line,
        the command >J fails
   <J   move the Dot to column 1
   =J   jump to the previous Dot position (not necessarily in the same line)
  @9J   jump to mark 9 (not necessarily in the same line)

 LEADING PARAMETER: [none, + , - , +n , -n , > , < , @ ] J
!
\K
 K       KILL LINE
 =       =========

   Deletes n lines and then positions Dot on the next line in the same
 column. The command -K deletes the line above , but does not move the Dot.
 All deleted text is placed in frame OOPS.

 EXAMPLES:

   9K   delete 9 lines at and below the current line
  -9K   delete 9 lines above the current line
   >K   delete from the current line to the end-of-page
   <K   delete above the current line to the beginning of the page
   @K   delete lines from the current line to the line containing mark 1
   =K   delete lines from the current line to the previous Dot position






 LEADING PARAMETER: [none, + , - , +n , -n , > , < , @ ] K
!
\L
 L       INSERT LINE
 =       ===========

   Inserts n empty lines above the current line, and positions Dot on the
 topmost inserted line, in the same column.  The command -L inserts above the
 current line, but does not move the Dot.















 LEADING PARAMETER: [none, + , - , +n , -n ,   ,   ,   ] L
!
\M
 M       MARK
 =       ====

   Defines a mark in the text at the Dot.  If text containing a mark is
 deleted, the mark becomes attached to the first character to the right of
 the deleted text.  The commands which use marks are { A D FGW J K SD SW };
 for example, @9J moves the Dot to the position of mark number 9.

 EXAMPLES:

    M    define mark number 1
   9M    define mark number 9.  Mark numbers range 1..9
  -9M    undefine mark number 9








 LEADING PARAMETER: [none, + , - , +n , -n ,   ,   ,   ] M
!
\N
 N       NEXT CHARACTER
 =       ==============

   Searches for the nth occurrence of any of a set of specified characters.
 The command fails if there are less than n occurrences remaining in the
 frame.  Exact case matching is used.

 EXAMPLES:

    N'a'    search for the first occurrence of the character "a" forwards
   -N'a'    search for the first occurrence of the character "a" backwards
   9N'a'    search for the ninth occurrence of the character "a" forwards
    N'abc'  search for the first occurrence of any of "a", "b" or "c"
    N'a..z' search for the first occurrence of any lower case alphabetic







 LEADING PARAMETER: [none, + , - , +n , -n ,   ,   ,   ] N
!
\O
 O       OVERTYPE
 =       ========

 Interactive Use:
 ---------------
   Sets the mode of keyboard entry so that typed characters are typed over
 existing text rather than inserted into the text.  Overtyping will fail at
 the right margin when the EP wrap option is turned off.  (See help on EP.)

 Command Procedure Use:
 ---------------------
   The command takes a trailing parameter in Command Procedures; see the
 examples below.
 n is the number of copies to be overtyped (Command Procedures only)








!
\%
 EXAMPLES:

    O/cat and dog/       overtype the string "cat and dog" at Dot
   9O/cat and dog/       overtype the string "cat and dog" at Dot 9 times
    O&&                  prompts for the text to be overtyped
    O&Enter name:&       user defined prompt for the text to be overtyped














 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] O

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
    R/"cat"/mouse/  replace the next occurrence of cat by mouse (exact case
                    match)
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
   Except for SW and SL commands beginning with S pertain to Spans.
 Spans are named pieces of text delimited by two marks.  Spans are the basic
 method of text transport inside Ludwig.  Spans may contain Ludwig command
 code, which is executed with EX or EN.  Spans may also be associated with
 compiled Ludwig commands (created by SR or EX, and used by EN and EX).

  SA     Span Assign         Assigns text to a span
  SC     Span Copy           Copies a previously defined span
  SD     Span Define         Defines and names a span
  SI     Span Index          Lists all spans and frames
  SJ     Span Jump           Jumps to the beginning or end of a span
  SR     Span Recompile      Recompiles a span
  ST     Span Transfer       Moves a previously defined span (not a copy)
          --------------------------------

 The SW and SL commands are useful for fast manipulation of text lines.
  SL     Split Line          Splits a line in two
  SW     Swap Line           Swaps a pair of lines


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
\SI
 SI      SPAN INDEX
 ==      ==========

   Displays all span names and the first 31 characters of each span.  All
 frames and their attached files are also displayed.
















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] SI
!
\SJ
 SJ      SPAN JUMP
 ==      =========

   Moves Dot to the end of a span (the character to the right of the last
 character of the span).  The command -SJ moves Dot to the first
 character of the span.















 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] SJ
!
\SL
 SL      SPLIT LINE
 ==      ==========

   Splits a line in two at the current position.  The characters in the
 current line to the left of the current position remain in place, and the
 rest of the line is moved to a new line, with the current character
 positioned where a <RETURN> or ZC command would have placed the cursor.
 This will be the left margin, unless the EP indentation tracker option is
 turned on.  (See help on EP.)  Dot stays attached to the first character of
 the right-hand segment of the line.











 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] SL
!
\SR
 SR      SPAN RECOMPILE
 ==      ==============

   Recompiles a span for execution.  The Span Execute command EX
 automatically recompiles its span before executing it; the Execute
 Norecompile command EN does not do so if compiled code for the span exists.















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] SR
!
\ST
 ST      SPAN TRANSFER
 ==      =============

   The Span Define command SD, defines and names spans of text; the Span
 Transfer command ST inserts a named span into the text, immediately to the
 left of Dot.  Note that the span is moved, not copied.















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] ST
!
\SW
 SW      SWAP LINE
 ==      =========

   Transfers the current line to a position after the nth line below it.  With
 a negative leading parameter, the line is moved to a position before the nth
 line above it.  The Dot stays with the line as it moves.

 EXAMPLES:

    SW  swap the current line with the line below it
   3SW  move the current line 3 lines down
   -SW  swap the current line with the line above it
  -3SW  move the current line 3 lines up
   @SW  move the current line to a position before line with the mark







 LEADING PARAMETER: [none, + , - , +n , -n , > , < , @ ] SW
!
\U
 PREFIX U COMMANDS
 =================

   Commands beginning with U are a miscellaneous group with various
 functions.

  UC     Command Introducer  Types the command introducer into the text
  UK     Key Mapping         Maps a command string onto a keyboard key
  UP     Parent Process      Attaches the terminal to the parent process
  US     Subprocess          Attaches the terminal to a subprocess












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
\UK
 UK      KEY MAPPING
 ==      ===========

   This command maps a Command Procedure onto a keyboard key.  It takes two
 parameters:
         UK/key name/command procedure/
 The key names are defined by the keyboard interface (see Section 6).  The
 command procedure may contain multiple lines of text.

   The command will fail if the key name is not supported by the user's
 terminal.  If the compilation of the command procedure fails, the command
 aborts and errors are reported in the same way as by the Execute EX command.
 This command is allowed only in screen mode.

   If the command procedure consists of a single I or O command, it is
 necessary to put the command in ( ).  For example
         uk/keypad-2/(i"2")/




 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] UK
!
\%
   The following definitions are pre-loaded by Ludwig:
         uk/control-b/wb/                uk/up-arrow/zu/
         uk/control-d/d/                 uk/down-arrow/zd/
         uk/control-e/we/                uk/left-arrow/zl/
         uk/control-f/wf/                uk/right-arrow/zr/
         uk/control-g/ex'command'/       uk/home/zh/
         uk/control-h/zl/                uk/back-tab/zb/
         uk/control-i/zt/                uk/insert-char/c/
         uk/control-j/zd/                uk/delete-char/d/
         uk/control-k/k/                 uk/insert-line/l/
         uk/control-l/l/                 uk/delete-line/k/
         uk/control-m/zc/                uk/help/h&&/
         uk/control-n/wn/                uk/find/g&&/
         uk/control-p/uc/                uk/next-screen/wf/
         uk/control-r/zr/                uk/prev-screen/wb/
         uk/control-t/wt/
         uk/control-u/zu/
         uk/control-w/ya/
         uk/control-^/c/



!
{#if vms}
{##\UP}
{## UP      PARENT PROCESS}
{## ==      ==============}
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
{## LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] UP}
{##!}
{#elseif unix}
{##\UP}
{## UP      PARENT PROCESS}
{## ==      ==============}
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
{## LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] UP}
{##!}
{#endif}
{#if vms}
{##\US}
{## US      SUBPROCESS}
{## ==      ==========}
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
{## LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] US}
{##!}
{#elseif unix}
{##\US}
{## US      SUBPROCESS}
{## ==      ==========}
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
{## LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] US}
{##!}
{#endif}
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
  WE     Window End          Moves the window to the end of the frame
  WF     Window Forward      Moves the  window forward over the frame
  WH     Window Height       Sets the height of the window
  WL     Window Left         Shifts the window left
  WM     Window Middle       Centres the window on Dot
  WN     New Window          Redisplays the current window
  WR     Window Right        Shifts the window right
  WS     Window Scroll       Enables scrolling with arrow keys
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
\WM
 WM      WINDOW MIDDLE
 ==      =============

   Scrolls the window so that Dot is centred between the top and bottom
 margins.
















 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] WM
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
\WS
 WS      WINDOW SCROLL
 ==      =============

   Scrolls the screen n lines with Dot fixed to the text.  When no leading
 parameter is given, the arrow keys scroll until some other key is pressed.
















 LEADING PARAMETER: [none, + , - , +n , -n , > , < ,   ] WS
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
    >( 5( J[:2XF] ) A[:XS] )  O/*****/

    Failure of the command J causes execution of its fail handler, which
    in this case is the command 2XF.  Control transfers out by two levels,
    i.e. out of both loops.  Because XF signals a failure on exit from the
    loop, the entire procedure fails at that point so O/*****/ is not
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
    >( 5( J[:2XF] ) A[:XS] )  O/*****/

    Failure of the command A causes execution of its fail handler, which
    in this case is the command XS.  Control transfers out by one level,
    i.e.  out of the outermost loop.  Because XS sets the execution status
    to "success", O/*****/ is executed.



 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] XS
!
\Y
 PREFIX Y COMMANDS
 =================

   Commands beginning with Y are the word processor commands.  These commands
 are used to construct Command Procedures, or may be used in sequence, to
 format text according to normal text layout conventions.

  YA     Word Advance        Advances n words
  YC     Centre Line         Centres line between margins
  YD     Word Delete         Deletes n words
  YF     Word Fill           Places as many words as possible on a line
  YJ     Line Justify        Expands line to fit exactly between margins
  YL     Align Left          Places start of line at left margin
  YR     Align Right         Places end of line at right margin
  YS     Word Squeeze        Removes extra spaces from line







!
\YA
 YA      WORD ADVANCE
 ==      ============

   Word Advance moves to the beginning of the nth word, where a word is a
 contiguous block of non-blank characters.  0YA moves to the beginning of the
 current word.  >YA moves to the beginning of the next paragraph, and <YA to
 the beginning of the current paragraph, where a paragraph is a contiguous
 block of non-blank lines.

 EXAMPLES:
   before:           Dot
                     v
            hello there freddy
            ^     ^     ^
   after:   -YA   0YA   1YA






 LEADING PARAMETER: [none, + , - , +n , -n , > , < ,   ] YA
!
\YC
 YC      CENTRE LINE
 ==      ===========

           |                                                      |
             Centre Line places the current line between the left
             and right margins, with an equal number of blanks at
              each end.  YC fails if the line is too long to fit
            between the margins.  Dot is placed at the left margin
           of the next line.  >YA centres a paragraph beginning at
             the current line, where a paragraph is a contiguous
                          block of non-blank lines.
           |                                                      |

 Suggested use is
      >YF=J>YC






 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] YC
!
\YD
 YD      WORD DELETE
 ==      ===========

   Word Delete deletes n words, where a word is a contiguous block of
 non-blank characters.  >YD deletes to the beginning of the next paragraph,
 and <YD to the beginning of the current paragraph, where a paragraph is a
 contiguous block of non-blank lines.














 LEADING PARAMETER: [none, + , - , +n , -n , > , < ,   ] YD
!
\YF
 YF      LINE FILL
 ==      =========

   Line Fill places as many words on the current line (between the margins)
 as possible, placing words onto the next line, or removing them from the
 next line, if necessary.  A word is a contiguous block of non-blank
 characters.  If text protrudes to the left of the left margin it is not
 moved.  >YF will format an entire paragraph, where a paragraph is a
 contiguous block of non-blank lines.

 Suggested use to format a paragraph is as follows :
   Place Dot on the first character of the first word (indented to its
   intended position).

   Ragged Right Format          >YS=J>YF
   Ragged Left Format           >YS=J>YF=J>YR
   Left and Right Justified     >YS=J>YF=J>YJ




 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] YF
!
\YJ
 YJ      LINE JUSTIFY
 ==      ============

   Line Justify expands the current line by inserting spaces between words so
 that the line  fits between the margins.   If text protrudes to  the left of
 the  left margin  the protruding  text is  not  modified.  The  line is  not
 modified if the  next line is blank.   If the line protrudes  past the right
 margin  the command  fails.   >YJ  justifies an  entire  paragraph from  Dot
 onward, but will  not expand the last line of  the paragraph.  3YJ justifies
 the next 2 lines treating the third  line as the last line of the paragraph.
 Dot is placed on the left margin of the next line.

 Suggested use to justify a paragraph is as follows :
   Place Dot on the first letter of the first word of the
   paragraph (indented to its intended position).
   Then
                   >YS=J>YF=J>YJ




 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] YJ
!
\YL
 YL      ALIGN LEFT
 ==      ==========

 Align Left places the first character of the first word of the current line
 on the left margin.  If the line protrudes to the left of the left margin
 the command fails.  The Dot is placed on the left margin of the next line.
 >YL aligns an entire paragraph from Dot onward, where a paragraph is a
 contiguous block of non-blank lines.













 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] YL
!
\YR
 YR      ALIGN RIGHT
 ==      ===========

        Align Right places the last character of the last word of the current
   line on the right margin.  If the line protrudes to the right of the right
    margin the text is not modified.  The Dot is placed on the left margin of
      the next line.  >YR aligns an entire paragraph from Dot onward, where a
                          paragraph is a contiguous block of non-blank lines.













 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] YR
!
\YS
 YS      WORD SQUEEZE
 ==      ============

   Word Squeeze removes all extra spaces from the current line.  Any series
 of multiple spaces is replaced by a single space.  If all the text is to the
 right of the left margin then the leading spaces are retained.  Dot is
 placed on the left margin of the next line.

 Suggested use to format a paragraph is as follows :
   Place Dot on the first character of the first word (indented to its
   intended position).

   Ragged Right Format          >YS=J>YF
   Ragged Left Format           >YS=J>YF=J>YR
   Left and Right Justified     >YS=J>YF=J>YJ






 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] YS
!
\Z
 PREFIX Z COMMANDS
 =================

   Commands beginning with Z are the commands that implement the basic
 movement functions in Ludwig.  They are useful within Command Procedures,
 since the appropriate key cannot be pressed, and they provide some functions
 not available elsewhere in Ludwig.

 The keyboard keys only invoke the associated command by default.  It is
 possible to map a command string onto any of these keys.

  ZB     Backtab             Same as <BACKTAB> key
  ZC     Carriage Return     Same as <RETURN> key
  ZD     Cursor Down         Same as down arrow key
  ZH     Cursor Home         Same as <HOME> key
  ZL     Cursor Left         Same as left arrow key
  ZR     Cursor Right        Same as right arrow key
  ZT     Tab                 Same as <TAB> key
  ZU     Cursor Up           Same as up arrow key
  ZZ     Delete              Same as <DELETE> key


!
\ZB
 ZB      BACKTAB
 ==      =======

   Moves to the previous tab position on the line, if any.  Tabs are set by
 default on columns 1, 9, 17,... etc.  See command EP for information on
 setting tabs.















 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] ZB
!
\ZC
 ZC      CARRIAGE RETURN
 ==      ===============

   Advances Dot n lines; useful in Command Procedures.  If the EP indentation
 tracker option is turned off, Dot moves either to the left margin or to
 column one if it was to the left of the left margin already.  If the EP
 indentation tracker option is turned on, Dot moves to the position of the
 first non-blank character of the line which it was on when the ZC command
 was executed.  (The behaviour of the indentation tracker is actually more
 complex than this, but is best understood by experimentation.)  When working
 in insert mode, if the EP newline option is turned on, ZC or <RETURN>
 behaves as Split Line SL.









 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] ZC
!
\ZD
 ZD      CURSOR DOWN
 ==      ===========

   Moves Dot vertically down; useful in Command Procedures.

















 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] ZD
!
\ZH
 ZH      CURSOR HOME
 ==      ===========

   Moves Dot home; useful in Command Procedures.  Home is the position in
 column 1 of the top line of the current screen.  However, in order for Dot
 to stay within the upper vertical margin, the screen may scroll downwards
 while Dot remains on the character in the home position.  The number of
 lines which the screen must scroll depends on the upper margin setting.
 (See help on EP.)












 LEADING PARAMETER: [none,   ,   ,    ,    ,   ,   ,   ] ZH
!
\ZL
 ZL      CURSOR LEFT
 ==      ===========

   Moves Dot left; useful in Command Procedures.  The command >ZL moves Dot to
 the current left margin, unless it is to the left of the left margin, in
 which case it fails.















 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] ZL
!
\ZR
 ZR      CURSOR RIGHT
 ==      ============

   Moves Dot right; useful in Command Procedures.  The command >ZR moves Dot
 to the current right margin, unless it is to the right of the right margin,
 in which case it fails.















 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] ZR
!
\ZT
 ZT      TAB
 ==      ===

   Moves to the next tab position on the line, if any.  Tabs are set by
 default on columns 1, 9, 17,... etc.  See command EP for information on
 setting tabs.















 LEADING PARAMETER: [none, + ,   , +n ,    ,   ,   ,   ] ZT
!
\ZU
 ZU      CURSOR UP
 ==      =========

   Moves Dot up; useful in Command Procedures.

















 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] ZU
!
\ZZ
 ZZ      DELETE
 ==      ======

   Equivalent to the keyboard DEL key; useful in Command Procedures.
 Equivalent to the command sequence -J O/ / -J when in overtype mode
 and -J D when in insert mode.















 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] ZZ
!
\\
 \       COMMAND
 =       =======

   Normally, typing at the keyboard causes characters to be entered into the
 text being edited, either by overtyping or insertion.  The character "\" is
 the default command introducer, and when it is typed, it is not entered into
 the text, but enables the keyboard to be used to enter the name of a single
 editing command.  The command will be executed if it is valid.

 Normally, the command introducer is needed for every command entry.  The
 command -\ enables a sequence of editing commands to be entered
 interactively without the need for a command introducer.  This facility is
 especially useful for hand simulating Command Procedures, but should be used
 with care.  The command \ re-establishes normal text entry from the keyboard
 (as do the commands O and I).  \ returns Ludwig to the editing mode stored
 by the most recent -\ command.  I or O put it into Insert or Overtype modes
 respectively.




 LEADING PARAMETER: [none, + , - ,    ,    ,   ,   ,   ] \
!
\^
 ^       EXECUTE STRING
 =       ==============

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
 executed by the Execute command EX.  Unless remapped (see the UK command),
 CTRL/G is a convenient synonym for EX/COMMAND/.





 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] ^
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
\*
 *       CASE CHANGE
 =       ===========

   Changes the case of alphabetic characters.  The command takes a trailing
 parameter, either U, L or E (u, l or e) to specify upper, lower or edit case.
 The command moves the Dot to the right, or to the left with a negative
 leading parameter.  The command remains in effect until a character other
 than U, L or E is typed, or the end-of-line is reached.  No trailing
 parameter delimiters are required when the Case Change command is used in
 Command Procedures.

 EXAMPLES:

   9*U  change nine characters to upper case, from the Dot to the right
  -9*U  change nine characters to upper case, from the Dot to the left
   >*L  change all characters to lower case, from the Dot to the end of line
   <*L  change all characters to lower case, from the Dot to column one
   >*E  Changes The Rest Of The Line To Edit Case (This Is Edit Case)



 LEADING PARAMETER: [none, + , - , +n , -n , > , < ,   ] *
!
\{
 {       LEFT MARGIN
 =       ===========

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
\?
 ?       INVISIBLE INSERT
 =       ================

   The command allows n characters to be entered interactively, and inserted
 at the Dot in the current frame.  However, no prompt is issued, character
 entry is not echoed, and the insertion does not occur until entry is
 complete. The leading parameter > allows text to be accepted invisibly until
 <RETURN> is entered.  Invisible insert is useful in Command Procedures which
 have to prompt for input from the terminal.












 LEADING PARAMETER: [none, + ,   , +n ,    , > ,   ,   ] ?
!
\#
