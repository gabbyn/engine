      function s_tdc_time_per_channel(plane,wire)
*
*     routinne to return tdc slope (in ns/channel ) for a given sos plane and
*     wire
*
*     d.f. geesaman      17 feb 1994        first dummy routine
* $Log$
* Revision 1.2  1994/03/24 19:56:24  cdaq
* (DFG) Add includes, return value now a registered variable
*
* Revision 1.1  1994/02/21  16:41:23  cdaq
* Initial revision
*
*
      implicit none
      include 'gen_data_structures.cmn'
      include 'sos_geometry.cmn'
*     inputs
*     
      integer*4      plane     ! sos plane number of hit
      integer*4      wire      ! sos wire number of hit
*
*     output
*    
      real*4         s_tdc_time_per_channel 
*
*      s_drift_time_calc = SSTART_TIME 
*     &      - FLOAT(tdc)*s_tdc_time_per_channel(plane,wire)
*     &      + s_tdc_zero(plane,wire)                     
*
      s_tdc_time_per_channel = sdc_tdc_time_per_channel
      return
      end
