/*
!   This source file by:
!
!       Kelvin B. Nicolle (1987, 1989-90);
!       Jeff Blows (1989);
!       Steve Nairn (1990-91);
!       Allan Kennington (1999);
!       Martin Sandiford (2002).
!
!  Copyright  1979-81, 1987-89 University of Adelaide
!
!  Permission is hereby granted, free of charge, to any person
!  obtaining a copy of this software and associated documentation
!  files (the "Software"), to deal in the Software without
!  restriction, including without limitation the rights to use, copy,
!  modify, merge, publish, distribute, sublicense, and/or sell copies
!  of the Software, and to permit persons to whom the Software is
!  furnished to do so, subject to the following conditions:
!
!  The above copyright notice and this permission notice shall be
!  included in all copies or substantial portions of the Software.
!
!  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
!  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
!  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
!  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
!  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
!  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
!  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
!  SOFTWARE.
*/
/*++
!
! Name:         type.h
!
! $Header: /home/medusa/projects/ludwig/current/RCS/type.h.unix,v 4.6 90/07/11 11:24:19 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log:	type.h.unix,v $
! Revision 4.6  90/07/11  11:24:19  ludwig
! Change test for ultrix to test for vax.  KBN
! 
! Revision 4.5  90/02/18  16:54:08  ludwig
! get the padding right in the key_name_record for a sparc running X
!
! Revision 4.4  90/02/17  16:29:49  ludwig
! changed keyboard interface types to be large enough to send all the new special
! keys.
!
! Revision 4.3  90/01/30  17:12:31  ludwig
! changed #ifdef ultrix||mc68020 to #if ultrix||mc68020 to keep compiler
! quiet (and make it work).
!
! Revision 4.2  90/01/18  17:21:31  ludwig
! entered into RCS at reviosion level 4.2
!---
!
!
! Revision History:
! 1-001 Kelvin B. Nicolle                                     5-Jun-1987
!       Created by collecting definitions from vdu.c, filesys.c, and
!       termdesc.h.
!       Some names have been changed to make them consistent with the
!       names in the pascal include files, and all have been put into
!       upper case.
! 1-002 Kelvin B. Nicolle                                     3-May-1989
!       The pyramid compiler now implements packed records.
!       Change definition of KEY_CODE_RANGE_f to char.
!--*/

/*++
! The following definitions define types for accessing variables and
! fields of unpacked records declared in Pascal.
! The definitions correspond to the Pascal types as follows:
!   ENUM1      enumerated types with up to 255 elements
!   ENUM2      enumerated types with more than 255 elements
!   INT1       -127..127
!   UINT1      0..255
!   INT2       -32767..32767
!   UINT2      0..65535
!   INT4       -MAXINT..MAXINT
!   UINT4      0..2*MAXINT+1
!   PTR        ^ anything
! The types with the suffix "_f" are used to access fields.
! Types ending with "_STR" and "_OBJECT" do not need a "_f" suffix.
!--*/

#if linux || MACOS
#  define ENUM1  unsigned char
#  define ENUM2  unsigned short
#  define INT1   char
#  define UINT1  unsigned char
#  define INT2   short
#  define UINT2  unsigned short
#  define INT4   int
#  define UINT4  unsigned int
#  define PTR    char *
#endif

#if vax || sun
#  define ENUM1  unsigned char
#  define ENUM2  unsigned short
#  define INT1   char
#  define UINT1  unsigned char
#  define INT2   short
#  define UINT2  unsigned short
#  define INT4   int
#  define UINT4  unsigned int
#  define PTR    char *
#endif

#if ns32000
#  define ENUM1  unsigned char
#  define ENUM2  unsigned short
#  define INT1   short
#  define UINT1  unsigned short
#  define INT2   short
#  define UINT2  unsigned short
#  define INT4   int
#  define UINT4  unsigned int
#  define PTR    char *
#endif

#if pyr
/* Pyramid pascal allocates 4 bytes for all subranges and Boolean. */
#  define ENUM1  unsigned int
#  define ENUM2  unsigned int
#  define INT1   int
#  define UINT1  unsigned int
#  define INT2   int
#  define UINT2  unsigned int
#  define INT4   int
#  define UINT4  unsigned int
#  define PTR    char *
#endif

#if unix && (vax || sun)
/* Vax and Sun pc force alignment of fields of records. */
#  define ENUM1_f  ENUM1
#  define ENUM2_f  ENUM2
#  define INT1_f   INT1
#  define UINT1_f  UINT1
#  define INT2_f   short :0; short
#  define UINT2_f  short:0; unsigned short
#  define INT4_f   int :0; int
#  define UINT4_f  int :0; unsigned int
#  define PTR_f    int :0; char *
#else
#  define ENUM1_f  ENUM1
#  define ENUM2_f  ENUM2
#  define INT1_f   INT1
#  define UINT1_f  UINT1
#  define INT2_f   INT2
#  define UINT2_f  UINT2
#  define INT4_f   INT4
#  define UINT4_f  UINT4
#  define PTR_f    PTR
#endif

#define BOOLEAN         ENUM1
#define CHAR            unsigned char
#define INTEGER         INT4

#define BOOLEAN_f       ENUM1_f
#define CHAR_f          unsigned char
#define INTEGER_f       INT4_f

/*
 * Definitions from here on correspond to definitions in type.inc.
 */

typedef enum { PARSE_COMMAND, PARSE_INPUT, PARSE_OUTPUT,
	       PARSE_EDIT, PARSE_STDIN, PARSE_EXECUTE
	} PARSE_TYPE;

#define LINE_RANGE      UINT4   /* 0..max_lines    */
#define LINE_RANGE_f    UINT4_f /* 0..max_lines    */
#define SCR_COL_RANGE   UINT2   /* 0..max_scr_cols */
#define SCR_COL_RANGE_f UINT2_f /* 0..max_scr_cols */
#define SCR_ROW_RANGE   UINT1   /* 0..max_scr_rows */
#define SCR_ROW_RANGE_f UINT1_f /* 0..max_scr_rows */
#define STRLEN_RANGE    UINT2   /* 0..max_strlen   */
#define STRLEN_RANGE_f  UINT2_f /* 0..max_strlen   */

/* Strings */
typedef char FILE_NAME_STR[FILE_NAME_LEN];

/* Keyboard interface. */
#if XWINDOWS
#define KEY_CODE_RANGE   INT2
#define KEY_CODE_RANGE_f INT2_f
#define KEY_NAMES_RANGE  UINT2
#else
#if vms
#define KEY_CODE_RANGE   INT2   /* -max_special_keys..ord_maxchar */
#define KEY_CODE_RANGE_f INT2_f /* -max_special_keys..ord_maxchar */
#define KEY_NAMES_RANGE  UINT1  /* 0..max_nr_key_names */
#else
#if ns32000 || pyr || sun
#define KEY_CODE_RANGE   INT2   /* -max_special_keys..ord_maxchar */
#define KEY_CODE_RANGE_f char  /* -max_special_keys..ord_maxchar */
#define KEY_NAMES_RANGE  UINT2 /* 0..max_nr_key_names */
#else
#define KEY_CODE_RANGE   INT1  /* -max_special_keys..ord_maxchar */
#define KEY_CODE_RANGE_f INT1_f/* -max_special_keys..ord_maxchar */
#define KEY_NAMES_RANGE  UINT2 /* 0..max_nr_key_names */
#endif
#endif
#endif

typedef char KEY_NAME_STR[KEY_NAME_LEN];
typedef struct {
	KEY_NAME_STR     key_name;
	KEY_CODE_RANGE_f key_code;
#if vax || mc68000
	char             dummy;
#endif
#ifdef sparc
#ifdef XWINDOWS
	char             d1, d2;
#else
	char             d1,d2,d3;
#endif
#endif
	} KEY_NAME_RECORD;

#ifndef XWINDOWS
  /* don't need parse table for xwindows */

#define PARSE_TABLE_INDEX       UINT2   /* 0..max_parse_table */
#define PARSE_TABLE_INDEX_f     UINT2_f /* 0..max_parse_table */
typedef struct {
	CHAR_f              ch;
	KEY_CODE_RANGE_f    key_code;
	PARSE_TABLE_INDEX_f index;
	} PARSE_TABLE_RECORD;
#endif /* not XWINDOWS */

/* Objects */
typedef char STR_OBJECT[MAX_STRLEN];

#pragma pack(push, 4)

typedef struct {
  BOOLEAN_f       valid;
  PTR_f           first_line;
  PTR_f           last_line;
  LINE_RANGE_f    line_count;
  BOOLEAN_f       output_flag;
  BOOLEAN_f       eof;
  INTEGER_f       fns;
  FILE_NAME_STR   fnm;
  INTEGER_f       l_counter;
  FILE_NAME_STR   memory;
  FILE_NAME_STR   tnm;
  BOOLEAN_f       entab;
  BOOLEAN_f       create;
  INTEGER_f       fd;
  INTEGER_f       mode;
  INTEGER_f       idx;
  INTEGER_f       len;
  STR_OBJECT      buf;
  time_t          previous_file_id;
  UINT1           time_t_pad[8-TIME_T_SIZE];
  BOOLEAN_f       purge;
  INTEGER_f       versions;
  CHAR_f          zed;
} FILE_OBJECT;

typedef FILE_OBJECT *FILE_PTR;

typedef struct {
  BOOLEAN_f  old_cmds;
  BOOLEAN_f  entab;
  INTEGER_f  space;
  STR_OBJECT initial;
  BOOLEAN_f  purge;
  INTEGER_f  versions;
} FILE_DATA_TYPE;

#pragma pack(pop)

