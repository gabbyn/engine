      SUBROUTINE G_proper_shutdown(ABORT,err)
*--------------------------------------------------------
*-       Prototype C analysis routine
*-
*-
*-   Purpose and Methods : Closes files properly, flushes, etc.
*- 
*-   Output: ABORT		- success or failure
*-         : err	- reason for failure, if any
*- 
*-   Created  20-Nov-1993   Kevin B. Beard for new error standards
*-    $Log$
*-    Revision 1.2  1994/04/15 20:36:49  cdaq
*-    (KBB) Add ntuple handling
*-
* Revision 1.1  1994/02/04  22:12:15  cdaq
* Initial revision
*
*-
*- All standards are from "Proposal for Hall C Analysis Software
*- Vade Mecum, Draft 1.0" by D.F.Geesamn and S.Wood, 7 May 1993
*-
*-
*--------------------------------------------------------
      IMPLICIT NONE
      SAVE
*
      character*17 here
      parameter (here= 'G_proper_shutdown')
*
      logical ABORT
      character*(*) err
*
      INCLUDE 'gen_filenames.cmn'
*
      logical bad_HMS,bad_SOS,bad_COIN,bad_HBK
      character*132 err_HMS,err_SOS,err_COIN,err_HBK
      integer cycle,IO
      character*132 file
      character*8 nametag
      parameter (nametag= here)
      character*80 default_histfile
      parameter (default_histfile= 'engine_output.hbk')
*
*--------------------------------------------------------
*-chance to flush any statistics, etc.
      call H_proper_shutdown(bad_HMS,err_HMS)
*     
      call S_proper_shutdown(bad_SOS,err_SOS)
*     
      call C_proper_shutdown(bad_COIN,err_COIN)
*
      IO= G_LUN_TEMP                    ! temporary IO channel
      file= g_histout_filename		! File to write histograms into
      if(file.EQ.' ') file= default_histfile
*
      call G_open_HBOOK_file(IO,file,'NEW',bad_HBK,err_HBK) !FORTRAN file open
      IF(.NOT.bad_HBK) THEN
        call HRFILE(IO,nametag,'N')   !tell HBOOK to use channel IO (New)
        cycle= 0                      !dummy for internal counting
        call HROUT(0,cycle,' ')	      !CERNLIB flush buffers, all histograms
        call HREND(nametag)           !done with this channel
        CLOSE(IO)                     !FORTRAN file close
      ENDIF
*
      ABORT= bad_HMS .or. bad_SOS .or. bad_COIN .or. bad_HBK
      err= ' '
      IF(ABORT) THEN              !assemble error message
        If(bad_HBK) Then
          err= err_HBK
        EndIf
        If(bad_COIN .and. err.NE.' ') Then
          call G_prepend(err_COIN//' &',err)
        ElseIf(bad_COIN) Then
          err= err_COIN
        EndIf
        If(bad_SOS .and. err.NE.' ') Then
          call G_prepend(err_SOS//' &',err)
        ElseIf(bad_SOS) Then
          err= err_SOS
        EndIf
        If(bad_HMS .and. err.NE.' ') Then
          call G_prepend(err_HMS//' &',err)
        ElseIf(bad_HMS) Then
          err= err_HMS
        EndIf
        call G_add_path(here,err)
      ENDIF
      RETURN
      END
