/*  This source file by:
 * 
 *	Kelvin B. Nicolle (1987-90);
 *	Mark R. Prior (1987-88);
 *      Jeff Blows (1989); and
 *      Martin Sandiford (2002).
 *
 * Copyright  1987-90, 2002 University of Adelaide
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
/*
 *
 * Name:        const.h
 *
 * Description: A parser for termdesc files.
 *
 * $Header: /home/medusa/projects/ludwig/current/RCS/const.h.unix,v 4.2 90/02/17 16:12:07 ludwig Exp $
 * $Author: ludwig $
 * $Locker:  $
 * $Log:	const.h.unix,v $
Revision 4.2  90/02/17  16:12:07  ludwig
increased the maximum number of special keys and key names up to 1000 for
the XWINDOWS version

Revision 4.1  90/01/18  18:21:45  ludwig
 Entered into RCS at revision level 4.1

 *
 *
 * Revision History:
 * 1-001 Kelvin B. Nicolle                                    5-Jun-1987
 *       Created by collecting definitions from vdu.c, filesys.c, and
 *       termdesc.h.
 *       Some names have been changed to make them consistent with the
 *       names in the pascal include files, and all have been put into
 *       upper case.
 */

#define FALSE                   0
#define TRUE                    1
#define MAXINT                  2147483647

#if defined(vms) || defined(fpc)
#define ORD_MAXCHAR             255
#else
#define ORD_MAXCHAR             127
#endif

#define MAX_LINES               MAXINT  /* Max lines per frame          */
#define MAX_STRLEN              400     /* Max length of a string       */
#define MAX_SCR_ROWS            100     /* Max nr of rows on screen     */
#define MAX_SCR_COLS            255     /* Max nr of cols on screen     */

/* String lengths */
#if defined(vms) || defined(fpc)
#define FILE_NAME_LEN           255
#else
#define FILE_NAME_LEN           252
#endif

/* Keyboard interface. */
#ifdef XWINDOWS
#define MAX_SPECIAL_KEYS	1000
#define MAX_NR_KEY_NAMES	1000
#else
#define MAX_SPECIAL_KEYS        100
#define MAX_NR_KEY_NAMES        200
#define MAX_PARSE_TABLE         300
#endif

#define KEY_NAME_LEN            40  /* WARNING - this value is assumed in USER.PAS */
