/**********************************************************************/
/*                                                                    */
/*           L      U   U   DDDD   W      W  IIIII   GGGG             */
/*           L      U   U   D   D   W    W     I    G                 */
/*           L      U   U   D   D   W ww W     I    G   GG            */
/*           L      U   U   D   D    W  W      I    G    G            */
/*           LLLLL   UUU    DDDD     W  W    IIIII   GGGG             */
/*                                                                    */
/**********************************************************************/
/*  This source file by:                                               *
 *                                                                     *
 *      Kelvin B. Nicolle (1989).                                      *
 *                                                                     *
 * Copyright  1987, 1989 University of Adelaide                        *
 *                                                                     *
 * Permission is hereby granted, free of charge, to any person         *
 * obtaining a copy of this software and associated documentation      *
 * files (the "Software"), to deal in the Software without             *
 * restriction, including without limitation the rights to use, copy,  *
 * modify, merge, publish, distribute, sublicense, and/or sell copies  *
 * of the Software, and to permit persons to whom the Software is      *
 * furnished to do so, subject to the following conditions:            *
 *                                                                     *
 * The above copyright notice and this permission notice shall be      *
 * included in all copies or substantial portions of the Software.     *
 *                                                                     *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,     *
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF  *
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND               *
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS *
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN  *
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN   *
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE    *
 * SOFTWARE.                                                           *
 **********************************************************************/

/*++
! Name:         HELPFILE
!
! Description: Load and support indexed help file under unix.
!
! $Header: /Users/martin/kk/src/ludwig/current/RCS/helpfile.c.unix,v 4.2 1990/01/18 18:06:11 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: helpfile.c.unix,v $
! Revision 4.2  1990/01/18 18:06:11  ludwig
! Entered into RCS at revision level 4.2
!
!
!
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Kelvin B. Nicolle                                    13-Sep-1989
!       Modify Pascal headers for Tower version.
!--*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/file.h>

#include "const.h"
#include "type.h"
#if defined(ultrix) || defined(linux) || defined(MACOS)
#include <search.h>
#else
typedef struct entry { char *key, *data; } ENTRY;
typedef enum { FIND, ENTER } ACTION;
#endif

/*
 * A help record is really a structure with two fields,
 *      key : a packed array [1..KEY_SIZE] of char
 *  and txt : a packed array [1..WRITE_SIZE] of char
 *
 * However, in C, it is more convienient to think of this as one string.
 * This is a result of having to use a temporary array because of the trailing
 * \0 in C strings and as a result it is better it iteratively insert characters
 * in an array rather than use a structure and worry about the \0's.
 */

#define  ENTRY_SIZE             KEY_SIZE+WRITE_SIZE
#define  KEY_SIZE               4
#define  NEW_HELPFILE_ENV       "LUD_NEWHELPFILE"
#define  NEW_DEFAULT_HLPFILE    "/usr/local/help/ludwignewhlp.idx"
#define  OLD_HELPFILE_ENV       "LUD_HELPFILE"
#define  OLD_DEFAULT_HLPFILE    "/usr/local/help/ludwighlp.idx"
#define  WRITE_SIZE             80

#define  STSRNF                 98994

#if vax && unix
#define helpfile_open helpfileopen
#define helpfile_read helpfileread
#define helpfile_next helpfilenext
#endif

typedef struct {
        long    position[2];
        char    key[KEY_SIZE+1];
        } key_type;

static key_type *keys;
static FILE     *helpfile = NULL;
static long     index_size,*current;
static ENTRY    entry;
static char     current_key[KEY_SIZE+1];

/*
function helpfile_open {(
                oldversion : boolean)
        :boolean};
  {umax:nonpascal}
  {mach:nonpascal}
  {tower:c_external}

*/
long helpfile_open(BOOLEAN old_version)
{
    long i,j,contents_size;
    char *help,buffer[ENTRY_SIZE+1];

    if (helpfile != NULL) /* we have done this before, dont do it again! */
        return 1;
    if (old_version) {
        fprintf(stderr, "%s\n", getenv(OLD_HELPFILE_ENV));
        if ((help = getenv(OLD_HELPFILE_ENV)) == NULL || (helpfile = fopen(help,"r")) == NULL)
            if ((helpfile = fopen(OLD_DEFAULT_HLPFILE,"r")) == NULL)
                return 0;
    } else {
        fprintf(stderr, "%s\n", getenv(NEW_HELPFILE_ENV));
        if ((help = getenv(NEW_HELPFILE_ENV)) == NULL || (helpfile = fopen(help,"r")) == NULL)
            if ((helpfile = fopen(NEW_DEFAULT_HLPFILE,"r")) == NULL)
                return 0;
    }
    fgets(buffer,ENTRY_SIZE+1,helpfile);
    /* get in the size of the index, and the contents (in lines) */
    sscanf(buffer,"%ld %ld\n",&index_size,&contents_size);
    keys = (key_type *)malloc(sizeof(key_type)*(index_size+1));
    for (i = 0;i < index_size;i++) {
        fgets(buffer,ENTRY_SIZE+1,helpfile);
        sscanf(buffer,"%4s %ld %ld\n",keys[i].key,&keys[i].position[0],&keys[i].position[1]);
    }
    /*
     * The key "0" is special, it's the contents page, it does NOT appear in the
     * index as it must be created on the fly while creating the index file.
     * Hence it's entry appears after the index but before the bulk of the
     * entries.
     */
    keys[index_size].position[0] = ftell(helpfile);
    strcpy(keys[index_size].key,"0");
    for (i = 0;i < contents_size;i++)
        fgets(buffer,ENTRY_SIZE+1,helpfile);
    keys[index_size].position[1] = ftell(helpfile);
    /*
     * Correct the positions in the index to point at the real offset in the
     * file.
     */
    for (i = 0;i < index_size;i++)
        for (j = 0;j < 2;j++)
            keys[i].position[j] += keys[index_size].position[1];
    /* now count the contents page in the index */
    index_size++;
    /* Create a hash table to store the indices. */
    if (hcreate(index_size) == 0)
        return 0;
    for (i = 0;i < index_size;i++) {
        entry.key = keys[i].key;
        entry.data = (char *)keys[i].position;
        if (hsearch(entry,ENTER) == 0)
            return 0;
    }
    return 1;
}

/*
function helpfile_read {(
        var     key    : key_str;
                keylen : integer;
        var     buf    : help_record;
                buflen : integer;
        var     reclen : integer)
                : integer};
  {umax:nonpascal}
  {mach:nonpascal}
  {tower:c_external}

*/
long helpfile_read(char *keystr, long keylen, char *buffer, long buflen, long *reclen)
{
    char  buf[ENTRY_SIZE+1];
    ENTRY *result,entry;
    long  i;

    for (i = 0;i < keylen && keystr[i] != ' ';i++)
        current_key[i] = keystr[i];
    current_key[i] = '\0';
    entry.key = current_key;
    /*
     * lookup the key in the hash table, if it fails return the mysterious
     * status STSRNF
     */
    if ((result = hsearch(entry,FIND)) == NULL)
        return STSRNF;
    /* Find the offset in the helpfile for the entry and go there */
    current = (long *)result->data;
    fseek(helpfile,current[0],0);
    /* Get the first line in the entry and package it up in a help_record */
    fgets(buf,ENTRY_SIZE+1,helpfile);
    *reclen = KEY_SIZE+strlen(buf)-1; /* remove that \n!! */
    for (i = 0;i < buflen;i++)
        buffer[i] = ' ';
    for (i = 0;i < strlen(current_key);i++)
        buffer[i] = current_key[i];
    for (i = 0;i < strlen(buf)-1;i++)
        buffer[i+KEY_SIZE] = buf[i];
    return 1;
}

/*
function helpfile_next {(
        var     buf    : help_record;
                buflen : integer;
        var     reclen : integer)
        : integer};
  {umax:nonpascal}
  {mach:nonpascal}
  {tower:c_external}

*/
long helpfile_next(char *buffer, long buflen, long *reclen)
{
    char buf[ENTRY_SIZE+1];
    long i;

    /*
     * if the current position = the end of the entry return 0, else give back
     * the next line nicely packaged.
     */
    if (ftell(helpfile) == current[1])
        return 0;
    else {
        fgets(buf,ENTRY_SIZE+1,helpfile);
        *reclen = KEY_SIZE+strlen(buf)-1; /* remove that \n!!! */
        for (i = 0;i < buflen;i++)
            buffer[i] = ' ';
        for (i = 0;i < strlen(current_key);i++)
            buffer[i] = current_key[i];
        for (i = 0;i < strlen(buf)-1;i++)
            buffer[i+KEY_SIZE] = buf[i];
        return 1;
    }
}

int
keycmp(key_type *k1, key_type *k2)
{
    return strcmp(k1->key,k2->key);
}

#ifdef TEST

int
main(int argc, char **argv)
{
    char string[80],buffer[ENTRY_SIZE+1];
    long buflen;

    if (helpfile_open(1) == 0) {
        fprintf(stderr,"Cannot open helpfile!\n");
        exit(1);
    }
    while (1) {
        fputs("Topic: ",stdout);
        gets(string);
        if (strcmp(string,"exit") == 0)
            exit(0);
        if (helpfile_read(string,strlen(string),buffer,ENTRY_SIZE,&buflen)) {
            buffer[KEY_SIZE+buflen] = '\0';
            fputs(&buffer[KEY_SIZE],stderr);
            fputc('\n',stderr);
            while (helpfile_next(buffer,ENTRY_SIZE,&buflen)) {
                buffer[KEY_SIZE+buflen] = '\0';
                fputs(&buffer[KEY_SIZE],stderr);
                fputc('\n',stderr);
            }
        }else
            fprintf(stderr,"Nothing found on %s\n",string);
    }
}
#endif
