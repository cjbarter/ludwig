/* -*- mode: C; tab-width: 8; c-basic-offset: 4; -*- */
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
 *      Jeff Blows (1987, 2018);                                       *
 *      Kelvin B. Nicolle (1987-90);                                   *
 *      Mark R. Prior (1987-88);                                       *
 *      Steve Nairn (1990); and                                        *
 *      Martin Sandiford (2018).                                       *
 *                                                                     *
 * Copyright  1987-90, 2018 University of Adelaide                     *
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
! Name:        FILESYS
!
! Description: The File interface to Unix
!
! $Header: /home/medusa/projects/ludwig/current/RCS/filesys.c.unix,v 4.21 90/10/31 13:02:35 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: filesys.c.unix,v $
! Revision 4.21  90/10/31  13:02:35  ludwig
! Change type of the second parameter of filesys_close, to conform
! with the changes made in the IBM PC version.   KBN
!
! Revision 4.20  90/08/31  11:46:14  ludwig
! Modified ISO1 symbol usage.  KBN
!
! Revision 4.19  90/02/28  11:39:42  ludwig
! Implement the File Save command:
! . Add a new routine  filesys_save
! . Modify filesys_create_open to open output files for read and write access
! . Modify filesys_close to allow close processing on a file without
!   actually closing it
! Fix bug in filesys_close. The directory stream opened during file backup
! processing was not being closed.
!
! Revision 4.18  90/02/08  16:47:42  ludwig
! make call to vdu_process_window_args conditional on the parse being of a
! command line.
!
! Revision 4.17  90/01/26  09:43:04  ludwig
! Steven Nairn.
! Call vdu_process_window_args before using getopt to process command line
! arguments.
!
! Revision 4.16  90/01/18  18:54:59  ludwig
! Entered into RCS at revision level 4.16
!
!
!---
! Revision History:
! 4-001 Ludwig V4.0 release.                                  7-Apr-1987
! 4-002 Jeff Blows                                           15-May-1987
!       Remove #include <sys/types.h>. It is included by <sys/param.h>
!       and the is68k C compiler objects to having the definitions
!       twice.
! 4-003 Kelvin B. Nicolle                                     5-Jun-1987
!       See const.h and type.h.
! 4-004 Mark R. Prior                                         7-Nov-1987
!       Rearrange code to do all test before setting the mode and
!         previous_id fields of the file data structure.
!       Add code to check for write access to a file.
!       Rename the file data structure field from buffer to buf.
!       Add a nul to the end of the read buffer.
!       Add "check_input = 1" to the parse of command line and FE using
!         the memory file.
! 4-005 Mark R. Prior                                        10-Nov-1987
!       Correct the use of umask when creating new files.
!       Change the mode of temporary files from 644 to 600.
! 4-006 Mark R. Prior                                        11-Nov-1987
!       Make the declaration of errno global.
! 4-007 Mark R. Prior                                        24-Nov-1987
!       Set the memory file name to NUL when the -M option is used.
! 4-008 Mark R. Prior                                        12-Dec-1987
!       If the last line of a file has no terminator, the line was being
!       lost.
! 4-009 Mark R. Prior                                        20-Feb-1988
!       Use conformant arrays to pass string parameters to ch routines.
!               string[offset],length -> string,offset,length
!       In all calls of ch_length, ch_upcase_str, ch_locase_str, and
!         ch_reverse_str, the offset was 1 and is now omitted.
! 4-010 Kelvin B. Nicolle                                     2-Sep-1988
!       Add flags to the C routine headers so that the include files
!       generated for the Multimax Pascal compiler will contain the
!       "nonpascal" directive. Also ensure that all routine headers are
!       terminated with a blank line.
! 4-011 Kelvin B. Nicolle                                     2-Sep-1988
!       Only the Ultrix Pascal compiler does not support underscores in
!       identifiers:  Put the underscores back in the Pascal sources and
!       make the macro definitions of the external names conditional in
!       the C sources.
! 4-012 Kelvin B. Nicolle                                    28-Oct-1988
!       Different operating systems have different implementations of
!       getopt.  Rationalize the construction of argv to be compatible.
! 4-013 Kelvin B. Nicolle                                     4-Nov-1988
!       Change the "multimax" flags in the routine headers to "umax" and
!       "mach".
! 4-014 Kelvin B. Nicolle                                    16-Dec-1988
!       In fileys_parse copy the usage strings before passing them to
!       screen_unix_message which blank pads the message.
! 4-015 Kelvin B. Nicolle                                    22-Mar-1989
!       Add dummy parameters to the ch_routines that expect conformant
!       arrays.
! 4-016 Kelvin N. Nicolle                                    13-Sep-1989
!       Modify Pascal headers for Tower version.
!--*/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/file.h>           /* get codes for access */
#include <sys/wait.h>
#include <errno.h>
#include <string.h>
#include <strings.h>
#include <sys/param.h>
#include <sys/stat.h>
#include <sys/dir.h>
#include <pwd.h>

#include "lwgetopt.h"
#include "const.h"
#include "type.h"

#ifdef TEST
#define FILE_NAME_LEN   60
#endif

#define FILESYS_SHORT_STRING_LENGTH (100)

static STR_OBJECT msg_string;
extern int errno;

#ifdef TEST
# define screen_message(string) fprintf(stderr,"%s\n",string)
#else
# ifdef linux
#  define screen_message _screen_unix_message
# else
#  define screen_message screen_unix_message
# endif
extern void screen_message(const char *msg);
#endif

static int filesys_expand_file_name(char *fnm, int *fns);

/*----------------------------------------------------------------------------*/

void
temporary_file_too_long(const char *fnm) {
    snprintf(msg_string, sizeof(msg_string),
             "Temporary filename too long for (%s)", fnm);
    screen_message(msg_string);
}

/*----------------------------------------------------------------------------*/

/*
 * @brief take a long string and shrink to requested length
 *
 * @param dest
 * @param src
 * @param buff_len size of destination and requested length
 *
 * simple test in ../tests directory - fs.c
 */
void filesys_compress_string(char * dest, char * src, int buff_len) {
  char * l_dest = dest;

  if (strlen(src) > FILESYS_SHORT_STRING_LENGTH) {
      // truncate the string
      int short_offset = FILESYS_SHORT_STRING_LENGTH/3;
      l_dest = stpncpy(l_dest, src, short_offset);
      l_dest = stpcpy(l_dest, "...");
      char * src_tail = src + (strlen(src) - short_offset);
      strncpy(l_dest, src_tail, short_offset);
  } else {
     // just copy to dest
     strcpy(l_dest, src);
  }
}

/*
function filesys_create_open {(
                fyle  : file_ptr;
                related_file : file_ptr;
                ordinary_open : boolean)
        : boolean};
  {umax:nonpascal}
  {mach:nonpascal}
  {tower:c_external}

*/
BOOLEAN
filesys_create_open(FILE_PTR fyle, FILE_PTR rfyle, BOOLEAN ordinary_open)
{
    char   related[FILE_NAME_LEN+1];
    char   *p;
    struct stat stat_buffer;
    int    pid,fd[2],uniq,exists,chlength();

# ifdef DEBUG
    /* Check the file has a 'Z' in the right place */
    if (fyle->zed != 'Z') {
        screen_message("FILE and FILESYS definition of file_object disagree.");
        return 0;
    }
# endif
    fyle->l_counter = 0;
    if (!fyle->output_flag) { /* open file for reading */
        if (fyle->fns == 0)
            return 0;
        if (!ordinary_open) { /* really executing a command */
            if (pipe(fd) == -1) {
                screen_message("Cannot create pipe");
                return 0;
            }
            if ((pid = fork()) == -1) {
                screen_message("Failed to fork");
                return 0;
            } else if (pid == 0) {
                close(fd[0]);
                if (dup2(fd[1],1) == -1 || dup2(fd[1],2) == -1)
                    exit(1);
                close(0);
                open("/dev/null", O_RDONLY);
                fyle->fnm[fyle->fns] = '\0';
                system(fyle->fnm);
                close(fd[1]);
                exit(0);
            } else {
                close(fd[1]);
                fyle->fd = fd[0];
            }
        } else {
            if (!filesys_expand_file_name(fyle->fnm,&fyle->fns)) {
                snprintf(msg_string, sizeof(msg_string),
                         "Error in filename (%s)", fyle->fnm);
                screen_message(msg_string);
                return 0;
            }
            if (stat(fyle->fnm,&stat_buffer) != 0) {
                return 0;
            }
            if ((stat_buffer.st_mode & S_IFMT) == S_IFDIR) {
                errno = EISDIR;
                return 0;
            }
            if ((fyle->fd = open(fyle->fnm,O_RDONLY,0)) < 0) {
                return 0;          /* fail,    return false */
            }
            fyle->mode = stat_buffer.st_mode & 07777;
            fyle->previous_file_id = stat_buffer.st_mtime;
        }
        fyle->idx = 0;
        fyle->len = 0;
        fyle->eof = 0;
    } else { /* otherwise open new file for output */
        if (rfyle != NULL)
            strcpy(related,rfyle->fnm);
        else
            *related = '\0';
        if (fyle->fns == 0) { /* default to related filename */
            strcpy(fyle->fnm,related);
            fyle->fns = strlen(fyle->fnm);
        }
        if (fyle->fns == 0)
            return 0;
        else if (!filesys_expand_file_name(fyle->fnm,&fyle->fns)) {
            snprintf(msg_string, sizeof(msg_string),
                     "Error in filename (%s)", fyle->fnm);
            screen_message(msg_string);
            return 0;
        }
        /*
         * if the file given is a directory create a filename using the input
         * filename in the given directory.
         */
        if (   (exists = (stat(fyle->fnm,&stat_buffer) == 0))
            && (stat_buffer.st_mode & S_IFMT) == S_IFDIR
            && *related != '\0') {
            /*
             * get the actual file name part of the related file spec
             * a '/' MUST exist in the name since the path has been fully
             * expanded, only problem is if the original filename is '/'
             */
            p = rindex(related,'/');
            if (strcmp(fyle->fnm,"/") == 0)
                strcpy(fyle->fnm,p);
            else
                strcat(fyle->fnm,p);
            exists = (stat(fyle->fnm,&stat_buffer) == 0);
        }
        if (exists) {
            /* if we wanted to create a new file then complain */
            if (fyle->create) {
                snprintf(msg_string, sizeof(msg_string),
                         "File (%s) already exists", fyle->fnm);
                screen_message(msg_string);
                return 0;
            }
            /* check that the file we may overwrite is not a directory */
            if ((stat_buffer.st_mode & S_IFMT) == S_IFDIR) {
                snprintf(msg_string, sizeof(msg_string),
                         "File (%s) is a directory", fyle->fnm);
                screen_message(msg_string);
                return 0;
            }
            /* check that we can write over the current version */
            if (access(fyle->fnm,W_OK) == -1) {
                snprintf(msg_string, sizeof(msg_string),
                         "Write access to file (%s) is denied", fyle->fnm);
                screen_message(msg_string);
                return 0;
            }
            fyle->mode = stat_buffer.st_mode & 07777;
            fyle->previous_file_id = stat_buffer.st_mtime;
        } else {
            fyle->mode = 0666 & ~umask(0);
            fyle->previous_file_id = 0;
        }
        /* now create the temporary name */
        uniq = 0;
        if (snprintf(fyle->tnm, sizeof(fyle->tnm), "%s-lw",
                     fyle->fnm) >= sizeof(fyle->tnm)) {
            temporary_file_too_long(fyle->fnm);
            return 0; /* fail */
        }
        while (access(fyle->tnm,F_OK) == 0) {
            if (snprintf(fyle->tnm, sizeof(fyle->tnm),
                         "%s-lw%d", fyle->fnm,++uniq) >= sizeof(fyle->tnm)) {
                temporary_file_too_long(fyle->fnm);
                return 0; /* fail */
            }
        }
        if ((fyle->fd = open(fyle->tnm, O_RDWR | O_CREAT, 0600)) < 0) {
            snprintf(msg_string, sizeof(msg_string),
                     "Error opening (%s) as output", fyle->tnm);
            screen_message(msg_string);
            return 0;          /* fail,    return false */
        }
    }
    return 1;              /* succeed, return true  */
}

/*----------------------------------------------------------------------------*/

static int
filesys_write_file_name(char *mem, char *fnm, int fns)
{
    int envfd;

    if (mem != NULL && mem[0] != '\0') {
        if ((envfd = open(mem, O_CREAT | O_WRONLY | O_TRUNC, 0666)) >= 0) {
            write(envfd, fnm, fns);
            write(envfd, "\n", strlen("\n"));
            close(envfd);
            return 1;
        }
    }
    return 0;
}

/*----------------------------------------------------------------------------*/

static int
filesys_read_file_name(char *mem, char *fnm, int *fns)
{
    int envfd;
    int read_len;
    int nl_idx;

    if (mem != NULL && (envfd = open(mem, O_RDONLY)) >= 0) {
        read_len = read(envfd, fnm, FILE_NAME_LEN);
        close(envfd);
        if (read_len > 0) {
            for (nl_idx = 0; nl_idx < read_len; ++nl_idx) {
                if (fnm[nl_idx] == '\n' || fnm[nl_idx] == '\r')
                    break;
            }
            memset(fnm + nl_idx, 0, FILE_NAME_LEN - nl_idx);
            *fns = nl_idx;
            return nl_idx != 0;
        }
    }
    return 0;
}

/*----------------------------------------------------------------------------*/

/*
function filesys_close {(
                fyle   : file_ptr;
                action : integer;
                msgs   : boolean)
        : boolean};
  {umax:nonpascal}
  {mach:nonpascal}
  {tower:c_external}

*/
BOOLEAN
filesys_close(FILE_PTR fyle, int action, BOOLEAN msgs)
/* Closes a file, described by fileptr fyle.
 * Action is an integer interpreted as follows:
 *   0 : close
 *   1 : close and delete
 *   2 : process the file as if closing it, but do not close it
 * The msgs parameter indicates whether we want to be told about what
 * is going on.
 * Returns true (1) on success, false (0) on failure.
 */
{
    char   *s,dir[FILE_NAME_LEN],bname[FILE_NAME_LEN];
    /* spec is used to hold the full path - comprised of dir and temp or bname */
    char   spec[FILE_NAME_LEN + FILE_NAME_LEN + 3];
    char   temp[FILE_NAME_LEN];
    struct stat stat_buffer;
    int    pstat;
    DIR    *dirp;
    struct direct *dp;
    long   i,j,*versions;
    long   entries = 0,vnum,max_vnum = 0,min_vnum = -1;

    if (fyle->output_flag == 0) {
        /* reap any children */
        while (waitpid(0, &pstat, WNOHANG) == 0) {
            /* Do nothing */
        }
        /* an ordinary input file, just close */
        if (close(fyle->fd) < 0)
            return 0;          /* fail,    return false */
        if (msgs) {
            snprintf(msg_string, sizeof(msg_string),
                     "File %s closed (%d line%s read).",
                     fyle->fnm, fyle->l_counter,
                     (fyle->l_counter == 1) ? "" : "s");
            screen_message(msg_string);
        }
        return 1;              /* succeed, return true */
    }
    /* an output file to close */
    if ((action != 2) && (close(fyle->fd) < 0))
        return 0;              /* fail,    return false */
    if (action == 1) {
        /* remove the file */
        if (!unlink(fyle->tnm)) {
            if (msgs) {
                snprintf(msg_string, sizeof(msg_string),
                         "Output file %s deleted.", fyle->tnm);
                screen_message(msg_string);
            }
            return 1;          /* succeed, return true  */
        } else
            return 0;
    }
    /*
     * check that another file hasn't been created while we were editting
     * with the name we are going to use as the output name.
     */
    if (stat(fyle->fnm,&stat_buffer) == 0)
        if (stat_buffer.st_mtime != fyle->previous_file_id) {
            snprintf(msg_string, sizeof(msg_string),
                     "%s was modified by another process", fyle->fnm);
            screen_message(msg_string);
        }
    strcpy(dir,fyle->fnm);
    /* find out what directory we are putting this file in */
    s = rindex(dir,'/');
    /* if directory is "/" it is OK to make it "" since we add a '/' later */
    *s = '\0';
    strcpy(bname,++s);
    strcat(bname,"~%d"); /* create format for backup filenames */
    if (fyle->purge) {
        /*
         * make sure we allocate some space, even if fyle->versions = 0
         */
        versions = (long *)malloc(sizeof(long)*(fyle->versions+1));
        versions[0] = 0;
        dirp = opendir((*dir == 0)?"/":dir);
        for (dp = readdir(dirp); dp != NULL;dp = readdir(dirp)) {
            if (sscanf(dp->d_name,bname,&vnum) == 1) {
                for (i = 0;i < entries && versions[i] > vnum;i++);
                if (i < fyle->versions-1) {
                    if (entries == fyle->versions-1) {
                        /*
                         * Temp and spec are the same size, so we are
                         * guaranteed to overflow spec if we overflow temp
                         */
                        snprintf(temp, sizeof(temp), bname,versions[entries-1]);
                        if (snprintf(spec, sizeof(spec), "%s/%s",
                                     dir, temp) < sizeof(spec)) {
                            unlink(spec);
                        }
                    } else {
                        entries++;
                    }
                    for (j = entries-1;j > i;j--) {
                        versions[j] = versions[j-1];
                    }
                    versions[i] = vnum;
                } else {
                    snprintf(spec, sizeof(spec), "%s/%s", dir, dp->d_name);
                    unlink(spec);
                }
            }
        }
        closedir(dirp);
        max_vnum = versions[0];
        free(versions);
    } else {
        dirp = opendir((*dir == 0)?"/":dir);
        for (dp = readdir(dirp); dp != NULL;dp = readdir(dirp))
            if (sscanf(dp->d_name,bname,&vnum) == 1) {
                if (vnum > max_vnum)
                    max_vnum = vnum;
                if (min_vnum == -1 || vnum < min_vnum)
                    min_vnum = vnum;
                entries++;
            }
        closedir(dirp);
        if (entries >= fyle->versions) {
            snprintf(temp, sizeof(temp), bname, min_vnum);
            snprintf(spec, sizeof(spec), "%s/%s", dir, temp);
            unlink(spec);
        }
    }
    /*
     * Perform Backup on original file if -
     *    a. fyle->versions != 0
     * or b. doing single backup and backup already done at least once
     */
    if (fyle->versions != 0 || (!fyle->purge && max_vnum != 0)) {
        /* does the real file already exist? */
        if (stat(fyle->fnm,&stat_buffer) == 0) {
            /* try to rename current file to backup */
            snprintf(temp, sizeof(temp), bname, max_vnum + 1);
            if (snprintf(spec, sizeof(spec), "%s/%s",
                         dir, temp) < sizeof(spec)) {
                rename(fyle->fnm, spec);
            }
        }
    }
    /* now rename the temp file to the real thing */
    chmod(fyle->tnm, fyle->mode & 07777);
    if (rename(fyle->tnm, fyle->fnm)) {
        char tnm[FILESYS_SHORT_STRING_LENGTH] = {0};
        char fnm[FILESYS_SHORT_STRING_LENGTH] = {0};
        filesys_compress_string(&tnm[0], fyle->tnm, FILESYS_SHORT_STRING_LENGTH);
        filesys_compress_string(&fnm[0], fyle->fnm, FILESYS_SHORT_STRING_LENGTH);
        snprintf(msg_string, sizeof(msg_string), "Cannot rename %s to %s\n",
                 tnm, fnm);
        screen_message(msg_string);
        return 0;          /* fail,    return false */
    } else {
        if (msgs) {
            snprintf(msg_string, sizeof(msg_string),
                     "File %s created (%d line%s written).",
                     fyle->fnm, fyle->l_counter,
                     (fyle->l_counter == 1) ? "" : "s");
            screen_message(msg_string);
        }
        /*
         * Time to set the memory, if it's required and we aren't writing in
         * one of the global tmp directories
         */
        if (strcmp(dir,"/tmp") != 0 && strcmp(dir,"/usr/tmp") != 0) {
            filesys_write_file_name(fyle->memory, fyle->fnm, fyle->fns);
        }
        return 1;                  /* succeed, return true  */
    }
}

/*----------------------------------------------------------------------------*/

/*
function filesys_read {(
                fyle   : file_ptr;
        var     buffer : str_object;
        var     outlen : strlen_range)
        : boolean};
  {umax:nonpascal}
  {mach:nonpascal}
  {tower:c_external}

*/
BOOLEAN
filesys_read(FILE_PTR fyle, char *output_buffer, STRLEN_RANGE *outlen)
/* Attempts to read MAX_STRLEN characters into buffer.
 * Number of characters read is returned in outlen.
 * Returns true (1) on success, false (0) on failure.
 */
{
    register int ch;

    *outlen = 0;
    do {
        if (fyle->idx == fyle->len) {
            fyle->len = read(fyle->fd, fyle->buf, MAX_STRLEN);
            fyle->idx = 0;
        }
        if (fyle->len <= 0) {
            fyle->eof = 1;
            /*
             * If the last line is not terminated properly,
             * the buffer is not empty and we must return the buffer.
             */
            if (*outlen) break;
            return 0;          /* fail,    return false */
        }
        ch = toascii(fyle->buf[fyle->idx++]);
        if (isprint(ch))
            output_buffer[(*outlen)++] = ch;
        else if (ch == '\t') { /* expand the tab */
            register int exp = (8 - (*outlen)%8);

            if ((*outlen+exp) > MAX_STRLEN)
                exp = MAX_STRLEN - *outlen;
            for (; exp > 0; exp--)
                output_buffer[(*outlen)++] = ' ';
        }
        else if (ch == '\n' || ch == '\r' || ch == '\v' || ch == '\f')
            break;              /* finished if newline or carriage return */
        else
            ; /* forget funny control characters */
    } while (*outlen < MAX_STRLEN);
    fyle->l_counter++;
    if (*outlen > 300)
        ch = 2;
    return 1;              /* succeed, return true  */
}

/*----------------------------------------------------------------------------*/

/*
function filesys_rewind {(
                fyle : file_ptr)
        : boolean};
  {umax:nonpascal}
  {mach:nonpascal}
  {tower:c_external}

*/
BOOLEAN
filesys_rewind(FILE_PTR fyle)
/*
 * Rewinds file described by the FILE_PTR `fyle'.
 */
{
    fflush(stdout);
    if (lseek(fyle->fd, 0, L_SET) < 0)
        return 0;
    fyle->idx = 0;
    fyle->len = 0;
    fyle->eof = 0;
    fyle->l_counter = 0;
    return 1;
}

/*----------------------------------------------------------------------------*/

/*
function filesys_write {(
                fyle   : file_ptr;
        var     buffer : str_object;
                bufsiz : strlen_range)
        : boolean};
  {umax:nonpascal}
  {mach:nonpascal}
  {tower:c_external}

*/
BOOLEAN
filesys_write(FILE_PTR fyle, char *buffer, STRLEN_RANGE bufsiz)
/* Attempts to write bufsiz characters from buffer to the file described by
 * fyle. Returns true (1) on success, false (0) on failure.
 */
{
    static char nl = '\n';
    int  i,tabs,offset,count;

    offset = tabs = 0;
    if (fyle->entab) {
        for (i = 0;i < bufsiz;i++)
            if (buffer[i] != ' ') break;
        tabs = i/8;
        offset = tabs*7;
        for (i = 0;i < tabs;i++)
            buffer[offset+i] = '\t';
    }
    count = write(fyle->fd, &buffer[offset], bufsiz-offset);
    if (tabs)
        for (i = 0;i < tabs;i++)
            buffer[offset+i] = ' ';
    if (count != bufsiz-offset)
        return 0;
    write(fyle->fd, &nl, 1);
    fyle->l_counter++;
    return 1;              /* succeed, return true  */
}

/*----------------------------------------------------------------------------*/

/*
function filesys_save {(
              i_fyle : file_ptr;
              o_fyle : file_ptr;
              copy_lines : integer)
      : boolean};
  {umax:nonpascal}
  {mach:nonpascal}
  {tower:c_external}

*/
BOOLEAN
filesys_save(FILE_PTR i_fyle, FILE_PTR o_fyle, int copy_lines)
/*  Implements part of the File Save command. */
{
        BOOLEAN input_eof;
        int input_position;
        STR_OBJECT line;
        STRLEN_RANGE line_len;
        FILE_OBJECT fyle;
        int i;

        if (i_fyle != 0) {

            /*  remember things to be restored */
            input_eof = i_fyle->eof;
            input_position = lseek(o_fyle->fd, 0, L_INCR);

            /*  copy unread portion of input file to output file */
            do {
                 if (filesys_read(i_fyle, line, &line_len))
                     filesys_write(o_fyle, line, line_len);
            } while (i_fyle->eof == 0);

            /* close input file */
            filesys_close(i_fyle, 0, TRUE);
        }

        /* rename temporary file to output file */
        /* process backup options, but do not close the file */
        filesys_close(o_fyle, 2, TRUE);

        /* make the old output file the new input file */
        if (i_fyle == NULL) {
          i_fyle = &fyle;
          i_fyle->output_flag = FALSE;
          i_fyle->first_line = NULL;
          i_fyle->last_line = NULL;
          i_fyle->line_count = 0;
        }
        i_fyle->fns = o_fyle->fns;
        strcpy(i_fyle->fnm,o_fyle->fnm);
        i_fyle->fd = o_fyle->fd;

        /* rewind the input file */
        filesys_rewind(i_fyle);

        /* open a new output file */
        o_fyle->create = FALSE;
        if (filesys_create_open(o_fyle, NULL, TRUE) == 0)
            return 0;

        /* copy lines from the input file to the output file */
        for (i = 0; i < copy_lines; i++) {
             if (filesys_read(i_fyle, line, &line_len)==0) return 0;
             if (filesys_write(o_fyle, line, line_len)==0) return 0;
         }

        /* reposition or close the input file */
        if (i_fyle == &fyle) {
            close(i_fyle->fd);
        } else {
            i_fyle->eof = input_eof;
            lseek(i_fyle->fd, input_position, L_SET);
            i_fyle->idx = 0;
            i_fyle->len = 0;
        }
        return 1;
}

/*----------------------------------------------------------------------------*/

static size_t ch_length(char *str, size_t len)
{
    while ((len > 0) && (str[len] == ' ')) {
        len -= 1;
    }
    return len;
}

/*----------------------------------------------------------------------------*/

/*
function  filesys_parse {(
        var     command_line : file_name_str;
                parse        : parse_type;
        var     file_data    : file_data_type;
        var     input_file   : file_ptr;
        var     output_file  : file_ptr)
        : boolean};
  {umax:nonpascal}
  {mach:nonpascal}
  {tower:c_external}

*/

#ifdef XWINDOWS
int vdu_process_window_args();
#endif

int filesys_parse(
    char *command_line,
    PARSE_TYPE parse,
    FILE_DATA_TYPE *file_data,
    FILE_PTR *input,
    FILE_PTR *output
) {
    static char usage[]="usage : ludwig [-c] [-r] [-i value] [-I] [-s value]\
 [-m file] [-M] [-t] [-T] [-b value] [-B value] [-o] [-O] [-u] [file [file]]";
    static char file_usage[]="usage : [-m file] [-t] [-T] [-b value] [-B value]\
 [file [file]]";

    long    c,errors,versions,space;
    int     argc, len;
    short   purge,entab,files;
    BOOLEAN usage_flag,create_flag,read_only_flag,space_flag,version_flag;
    short   check_input;
    char    *temp,*argv[255],*initialize,*memory,*file[2];
    char    def_memory[MAX_STRLEN],def_init[MAX_STRLEN];

    if (parse == PARSE_STDIN) {
        (*input)->valid = 1;
        (*input)->fd = 0;
        (*input)->eof = 0;
        (*input)->l_counter = 0;
        return 1;
    }
    /* create an argc and argv from the "command_line" */
    command_line[ch_length(command_line, FILE_NAME_LEN)] = '\0';
    argv[0] = "Ludwig";
    argc = 1;
    for (temp = strtok(command_line," ");temp != NULL;temp = strtok(NULL," "))
        argv[argc++] = temp;
    argv[argc] = NULL;
    entab = file_data->entab;
    space = file_data->space;
    purge = file_data->purge;
    versions = file_data->versions;
    create_flag = read_only_flag = space_flag = usage_flag = version_flag = 0;
    errors = check_input = 0;
    if (parse == PARSE_COMMAND) {
        snprintf(def_init, sizeof(def_init), "%s/.ludwigrc", getenv("HOME"));
        initialize = def_init;
        snprintf(def_memory, sizeof(def_memory),
                 "%s/.lud_memory", getenv("HOME"));
        memory = def_memory;
    } else {
        initialize = NULL;
        memory = NULL;
    }
#ifdef XWINDOWS
#ifdef DEBUG
    {
      int i;
      fprintf (stderr, "argc = %d argv = \\\n", argc);
      for (i = 0; i < argc; i++) fprintf(stderr,"%s,\n", argv[i]);
    }
#endif
    /* run through argc and argv and remove window specific options */
    /* only if we are processing a command line */
    if (parse == PARSE_COMMAND)
      errors = vdu_process_window_args( &argc, argv );
#ifdef DEBUG
    {
      int i;
      fprintf (stderr, "argc = %d argv = \\\n", argc);
      for (i = 0; i < argc; i++) fprintf(stderr,"%s,\n", argv[i]);
    }
#endif
#endif /* XWINDOWS */
    lwoptreset = 1;
    lwoptind = 1;
    while ((c = lwgetopt(argc,argv,"cri:Is:m:MtTb:B:oOu")) != -1) {
        switch (c) {
        case 'c' :
            if (read_only_flag)
                errors++;
            else
                create_flag = 1;
            break;
        case 'r' :
            if (create_flag)
                errors++;
            else
                read_only_flag = 1;
            break;
        case 'i' :
            initialize = lwoptarg;
            break;
        case 'I' :
            initialize = NULL;
            break;
        case 's' :
            space_flag = 1;
            sscanf(lwoptarg, "%ld", &space);
            break;
        case 'm' :
            memory = lwoptarg;
            break;
        case 'M' :
            memory = NULL;
            break;
        case 't' :
            entab = 1;
            break;
        case 'T' :
            entab = 0;
            break;
        case 'b' :
            purge = 0;
            sscanf(lwoptarg, "%ld", &versions);
            break;
        case 'B' :
            purge = 1;
            sscanf(lwoptarg, "%ld", &versions);
            break;
        case 'o' :
            version_flag = 1;
            file_data->old_cmds = 1;
            break;
        case 'O' :
            version_flag = 1;
            file_data->old_cmds = 0;
            break;
        case 'u' :
            usage_flag = 1;
            break;
        }
    }
    if (usage_flag || errors) {
        if (parse == PARSE_COMMAND)
            strcpy(msg_string,usage);
        else
            strcpy(msg_string,file_usage);
        screen_message(msg_string);
        return 0;
    }
    if (parse == PARSE_COMMAND) {
        if (initialize) {
            len = strlen(initialize);
            memcpy(file_data->initial, initialize, len);
            if (len < MAX_STRLEN) {
                memset(file_data->initial + len, ' ', MAX_STRLEN - len);
            }
        }
        else
            memset(file_data->initial, ' ', MAX_STRLEN);
        file_data->space = space;
        file_data->entab = entab;
        file_data->purge = purge;
        file_data->versions = versions;
    } else if (   create_flag || read_only_flag || initialize
               || space_flag || version_flag)
        return 0;
    for (files = 0; lwoptind < argc; lwoptind++) {
        if (files >= 2) {
            screen_message("More than two files specified");
            return 0;
        }
        file[files++] = argv[lwoptind];
    }
    if (files == 2) {
        check_input = 1;
        if (   parse == PARSE_INPUT || parse == PARSE_OUTPUT
            || parse == PARSE_EXECUTE || create_flag || read_only_flag) {
            screen_message("Only one file name can be specified");
            return 0;
        }
    }
    switch (parse) {
        case PARSE_COMMAND :
        case PARSE_EDIT :
            if (files > 0) {
                (*input)->fns = strlen(file[0]);
                strcpy((*input)->fnm,file[0]);
            } else if (memory != NULL) {
                if (filesys_read_file_name(memory, (*input)->fnm, &((*input)->fns))) {
                    check_input = 1;
                } else {
                    if (parse == PARSE_COMMAND) {
                      (*input)->fns = 0;
                      return 1;
                    }
                    snprintf(msg_string, sizeof(msg_string),
                             "Error opening memory file (%s)", memory);
                    screen_message(msg_string);
                    return 0;
                }
            } else if (parse == PARSE_COMMAND) {
                (*input)->fns = 0;
                return 1;
            } else {
                (*input)->fns = 0;
                return 0;
            }
            if (files > 1) {
                (*output)->fns = strlen(file[1]);
                strcpy((*output)->fnm,file[1]);
            } else {
                (*output)->fns = (*input)->fns;
                strcpy((*output)->fnm,(*input)->fnm);
            }
            if (memory != NULL)
                strcpy((*output)->memory,memory);
            else
                (*output)->memory[0] = '\0';
            (*output)->entab = entab;
            (*output)->purge = purge;
            (*output)->versions = versions;
            if (read_only_flag) {
                (*input)->create = 0;
                if (filesys_create_open(*input,NULL,TRUE) == 0) {
                    snprintf(msg_string, sizeof(msg_string),
                             "Error opening (%s) as input", (*input)->fnm);
                    screen_message(msg_string);
                    return 0;
                }
                (*input)->valid = 1;
            } else if (create_flag) {
                (*output)->create = 1;
                if (filesys_create_open(*output,NULL,TRUE) == 0)
                    return 0;
                (*output)->valid = 1;
            } else {
                (*input)->create = 0;
                (*output)->create = 0;
                if (filesys_create_open(*input,NULL,TRUE) != 0)
                    (*input)->valid = 1;
                else if (check_input || parse == PARSE_EDIT ||
                         errno == EWOULDBLOCK || errno == EISDIR) {
                    snprintf(msg_string, sizeof(msg_string),
                             "Error opening (%s) as input", (*input)->fnm);
                    screen_message(msg_string);
                    return 0;
                }
                if (filesys_create_open(*output,*input,TRUE) != 0)
                    (*output)->valid = 1;
                else
                    return 0;
            }
            break;
        case PARSE_INPUT :
            if (files == 1) {
                (*input)->fns = strlen(file[0]);
                strcpy((*input)->fnm,file[0]);
            } else if (memory == NULL ||
                       !filesys_read_file_name(memory, (*input)->fnm, &((*input)->fns))) {
                (*input)->fns = 0;
                return 0;
            }
            (*input)->create = 0;
            if (   (*input)->fns == 0
                || filesys_create_open(*input,NULL,TRUE) == 0) {
                snprintf(msg_string, sizeof(msg_string),
                         "Error opening (%s) as input", (*input)->fnm);
                screen_message(msg_string);
                return 0;
            }
            (*input)->valid = 1;
            break;
        case PARSE_EXECUTE :
            if (files == 1) {
                (*input)->fns = strlen(file[0]);
                strcpy((*input)->fnm,file[0]);
            } else {
                (*input)->fns = 0;
            }
            (*input)->create = 0;
            if (   (*input)->fns == 0
                || filesys_create_open(*input,NULL,TRUE) == 0)
                return 0;
            (*input)->valid = 1;
            break;
        case PARSE_OUTPUT :
            if (files == 1) {
                (*output)->fns = strlen(file[0]);
                strcpy((*output)->fnm,file[0]);
            } else if ((*input) != NULL) {
                (*output)->fns = (*input)->fns;
                strcpy((*output)->fnm,(*input)->fnm);
            } else
                (*output)->fns = 0;
            if (memory != NULL)
                strcpy((*output)->memory,memory);
            else
                (*output)->memory[0] = '\0';
            (*output)->entab = entab;
            (*output)->purge = purge;
            (*output)->versions = versions;
            (*output)->create = 0;
            if (   (*output)->fns == 0
                || filesys_create_open(*output,*input,TRUE) == 0)
                return 0;
            (*output)->valid = 1;
            break;
        case PARSE_STDIN :
            break;
    }
    return 1;
}

/*----------------------------------------------------------------------------*/

static int
filesys_expand_file_name(char *fnm, int *fns)
{
    struct passwd *passwd;
    char *s,*p,*q,*tmp,*cwd;

    if (fnm[0] == '\0' || fnm[0] == '/')
        return 1;
    else if (fnm[0] == '~') {
        if ((tmp = (char *)malloc(*fns+1)) == NULL) {
            perror("malloc");
            return 0;
        }
        strcpy(tmp,&fnm[1]);
        if ((p = index(tmp,'/')) != NULL) *p = '\0';
        if (*tmp == '\0') {
            if ((s = getenv("HOME")) == NULL)
                *fnm = '\0';
            else
                strcpy(fnm,s);
        } else {
            if ((passwd = getpwnam(tmp)) == NULL) {
                free(tmp);
                return 0;
            }
            strcpy(fnm,passwd->pw_dir);
        }
        *p = '/';
        strcat(fnm,p);
        *fns = strlen(fnm);
        free(tmp);
        return 1;
    } else if (fnm[0] != '.') {
        if ((cwd = (char *)malloc(MAXPATHLEN)) == NULL) {
            perror("malloc");
            return 0;
        }
        if ((cwd = getcwd(cwd, MAXPATHLEN)) == NULL) {
            perror(cwd);
            return 0;
        }
        if ((s = (char *)malloc(*fns+1)) == NULL) {
            free(cwd);
            perror("malloc");
            return 0;
        }
        strcpy(s,fnm);
        if (strcmp(cwd,"/") == 0)
            sprintf(fnm,"/%s",s);
        else if (*s != '\0')
            sprintf(fnm,"%s/%s",cwd,s);
        else
            strcpy(fnm,cwd);
        *fns = strlen(fnm);
        free(s);
        free(cwd);
        return 1;
    } else {
        if ((cwd = (char *)malloc(MAXPATHLEN)) == NULL) {
            perror("malloc");
            return 0;
        }
        if ((cwd = getcwd(cwd, MAXPATHLEN)) == NULL) {
            perror(cwd);
            return 0;
        }
        if ((q = s = tmp = (char *)malloc(*fns+1)) == NULL) {
            free(cwd);
            perror("malloc");
            return 0;
        }
        strcpy(tmp,fnm);
        while (*s == '.' && *++q == '.' && *++q == '/') {
            /*
             * filename references parent so modify cwd
             */
            if ((p = rindex(cwd,'/')) == NULL) {
                free(tmp);
                free(cwd);
                return 0;
            }
            if (p != cwd) /* if cwd == "/" dont touch the '/'!! */
                *p = '\0';
            else
                *++p = '\0'; /* make cwd "/" NOT ""! */
            q++;
            s = q;
        }
        if (strcmp(cwd,"/") == 0) {
            strcpy(fnm,cwd);
            strcat(fnm,(*q == '/')?++q:s);
        } else
            sprintf(fnm,"%s/%s",cwd,(*q == '/')?++q:s);
        *fns = strlen(fnm);
        free(tmp);
        free(cwd);
        return 1;
    }
}
