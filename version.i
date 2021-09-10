{++
! $Header: /home/martin/src/ludwig/current/fpc2/../RCS/version.i,v 5.6 1990/10/24 17:51:29 ludwig Exp $
! $Author: ludwig $
! $Locker:  $
! $Log: version.i,v $
! Revision 5.6  1990/10/24 17:51:29  ludwig
! For all versions:
!  . Make the dbg message strings conditional on the debug symbol.
!  . Make the validate routine body conditional on the debug symbol.
!  . Change second parameter of filesys_close and fix calls in fyle and opsys.
! For the Turbo Pascal version on the IMB PC:
!  . Modify the screen_str_message routine.
!  . Add the File Save command.
!  . Include call to value_initializations.
!  . Clean up the method of setting the Ludwig version string.
!  . Initialize some global variables that were not initialized.
! Modules revised: const.i 4.14, validate.pas 4.6, filesys.pas.ibm 4.2,
!                  fyle.pas 4.9, opsys.pas 4.7, screen.pas 4.12,
!                  ludwig.pas 4.12, value.pas 4.15
!
! Revision 5.5  90/08/17  11:10:25  ludwig
! Fixed bug with typeahead being processed out of order.
! Modules revised: vdu.c.unix 4.29
!
! Revision 5.4  90/08/10  17:21:28  ludwig
! Fixed a bug with ludwig looping when output was redirected.
! Modules revised: vdu.c.unix 4.28
!
! Revision 5.3  90/05/30  14:20:50  ludwig
! Fixed a bug in the FS command.
! Modules revised: fyle.pas 4.8
!
! Revision 5.2  90/05/23  14:52:54  ludwig
! Fix a bug in the YD command of the old command set.
! Modules revised: word.pas 4.7,8
!
! Revision 5.1  90/05/16  15:46:29  ludwig
! Release of Ludwig V5.0.
!
! Revision 4.2  90/03/21  11:02:34  ludwig
! Version checkpoint...FS command completed
!
! Revision 4.1  90/01/18  16:57:51  ludwig
! Entered into RCS at revision level 4.1
!--}

  begin
{#if debug}
  ludwig_version := 'X5.0-006                       ';
{#else}
{##  ludwig_version := 'V5.0-006                       ';}
{#endif}
  end;
