*=======================================================================
      subroutine h_prt_cal_raw
*=======================================================================
*-
*-      Dumps the raw calorimeter data
*-
*-      Created: 19 Mar 1994      Tsolak A. Amatuni
*-      Modified 25 Mar 1994      DFG
*-                                Change name
*-                                Change lun
*-                7 Apr 1884      DFG   Change print order
* $Log$
* Revision 1.4  1995/07/19 18:54:55  cdaq
* *** empty log message ***
*
* Revision 1.3  1995/05/22  19:39:20  cdaq
* (SAW) Split gen_data_data_structures into gen, hms, sos, and coin parts"
*
* Revision 1.2  1995/01/27  20:26:00  cdaq
* (JRA) Subtract pedestal from ADC value
*
* Revision 1.1  1994/04/13  15:41:33  cdaq
* Initial revision
*
*-----------------------------------------------------------------------
*
      implicit none
      save
*
      integer*4 hit      !Hit number
      integer*4 row,col,nb
      real*4 adc
*
      include 'hms_data_structures.cmn'
      include 'hms_calorimeter.cmn'
      include 'hms_tracking.cmn'
*
      write(hlun_dbg_cal,10) hcal_tot_hits
   10 format(///'      HMS Calorimeter Raw Data      ',/,
     &          '      Total Number of Hits:',i3,     //,
     &          ' Hit #   Column #   Row #   ADC Value')
*
*
      if(hcal_tot_hits.le.0) return
*
      do hit=1,hcal_tot_hits
        row=hcal_row(hit)
        col=hcal_column(hit)
        nb =row+hmax_cal_rows*(col-1)
        adc=float(hcal_adc(hit))-hcal_ped_mean(nb)
        write(hlun_dbg_cal,20)
     &       hit,hcal_column(hit),hcal_row(hit),adc
 20     format(i5,3x,i5,4x,i5,7x,f8.1)
      enddo
*
      return
      end
