       SUBROUTINE  s_print_decoded_dc(ABORT,err)
*--------------------------------------------------------
*-
*-   Purpose and Methods : Dump SOS_DECODED_DC BANKS
*-
*-      Required Input BANKS     SOSS_DECODED_DC
*-
*-   Output: ABORT           - success or failure
*-         : err             - reason for failure, if any
*- 
*-   Created 29-FEB-1994   D. F. Geesaman
* $Log$
* Revision 1.2  1995/04/06 19:38:33  cdaq
* (JRA) Remove SDC_WIRE_COORD
*
* Revision 1.1  1994/03/24  20:29:16  cdaq
* Initial revision
*
*--------------------------------------------------------
       IMPLICIT NONE
       SAVE
*
       character*50 here
       parameter (here= 's_print_decoded_dc')
*
       logical ABORT
       character*(*) err
*
       integer*4 j
       include 'gen_data_structures.cmn'
       include 'gen_constants.par'
       include 'gen_units.par'
       include 'sos_tracking.cmn'
       include 'sos_geometry.cmn'          
*
*--------------------------------------------------------
       ABORT = .FALSE.
       err = ' '
       write(sluno,'(''        SOS_DECODED_DC BANKS'')')
       write(sluno,'(''     SDC_TOT_HITS='',I4)') SDC_TOT_HITS
       if(SDC_TOT_HITS.GT.0) then
         if(  sdebug_mc_start_time .ne. 0 ) then
           write(sluno,'(''  sdebug_mc_start_time is set.'',
     &     ''  SSTART_TIME is set to zero in DC decoding'')')
         endif
         write(sluno,'(''     SDC_HITS_PER_PLANE'')')
         write(sluno,'('' Plane='',18i4)') (j,j=1,sdc_num_planes)
         write(sluno,'(7x,18i4)')
     &      (SDC_HITS_PER_PLANE(j),j=1,sdc_num_planes)
         write(sluno,'('' Num  Plane     Wire    Wire Center '',
     &      ''TDC Value DRIFT TIME DRIFT DIST'')')
         write(sluno,'(1x,i2,2x,i3,7x,i4,5x,F10.5,i8,2x,2F10.5)')       
     &     (j,SDC_PLANE_NUM(j),SDC_WIRE_NUM(j),
     &        SDC_WIRE_CENTER(j),SDC_TDC(j),SDC_DRIFT_TIME(j),
     &        SDC_DRIFT_DIS(j),
     &        j=1,SDC_TOT_HITS)    
       endif
       RETURN
       END
