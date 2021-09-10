/*-
 * Adapted from FreeBSD getopt.h which is under the following license,
 * updated 2018 by Martin Sandiford.
 *
 * Copyright (c) 1987, 1993, 1994 The Regents of the University of California.
 * Copyright (c) 2018 University of Adelaide.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include "lwgetopt.h"

#include <stdio.h>
#include <string.h>

int   lwoptind = 1;     /* index into parent argv vector */
int   lwoptopt;         /* character checked for validity */
int   lwoptreset;       /* reset getopt */
char *lwoptarg;         /* argument associated with option */

#define  BADCH  (int)'?'
#define  BADARG  (int)':'
#define  EMSG  ""

/*
 * lwgetopt --
 *  Parse argc/argv argument vector.
 */
int
lwgetopt(int nargc, char * const nargv[], const char *ostr) {
    static char *place = EMSG;    /* option letter processing */
    char *oli;                    /* option letter list index */

    if (lwoptreset || *place == 0) {
        /* update scanning pointer */
        lwoptreset = 0;
        place = nargv[lwoptind];
        if (lwoptind >= nargc || *place++ != '-') {
            /* Argument is absent or is not an option */
            place = EMSG;
            return (-1);
        }
        lwoptopt = *place++;
        if (lwoptopt == '-' && *place == 0) {
            /* "--" => end of options */
            ++lwoptind;
            place = EMSG;
            return (-1);
        }
        if (lwoptopt == 0) {
            /* Solitary '-', treat as a '-' option
               if the program (eg su) is looking for it. */
            place = EMSG;
            if (strchr(ostr, '-') == NULL)
                return (-1);
            lwoptopt = '-';
        }
    } else {
        lwoptopt = *place++;
    }

    /* See if option letter is one the caller wanted... */
    if (lwoptopt == ':' || (oli = strchr(ostr, lwoptopt)) == NULL) {
        if (*place == 0)
            ++lwoptind;
        return (BADCH);
    }

    /* Does this option need an argument? */
    if (oli[1] != ':') {
        /* don't need argument */
        lwoptarg = NULL;
        if (*place == 0) {
            ++lwoptind;
        }
    } else {
        /* Option-argument is either the rest of this argument or the
           entire next argument. */
        if (*place) {
            lwoptarg = place;
        } else if (oli[2] == ':') {
            /*
             * GNU Extension, for optional arguments if the rest of
             * the argument is empty, we return NULL
             */
            lwoptarg = NULL;
        } else if (nargc > ++lwoptind) {
            lwoptarg = nargv[lwoptind];
        } else {
            /* option-argument absent */
            place = EMSG;
            if (*ostr == ':')
                return (BADARG);
            return (BADCH);
        }
        place = EMSG;
        ++lwoptind;
    }
    return (lwoptopt);      /* return option letter */
}
