      SUBROUTINE C_reset_event(ABORT,err)
*--------------------------------------------------------
*-       Prototype C analysis routine
*-
*-
*-   Purpose and Methods : resets all COIN quantities before an event 
*-                         is processed.
*-
*- 
*-   Output: ABORT    - success or failure
*-         : err      - reason for failure, if any
*- 
*-   Created  29-Oct-1993   Kevin B. Beard
*-   Modified  6-Dec-1993   K.B.Beard: adopt new errors
*-    $Log$
*-    Revision 1.1  1994/02/04 21:18:37  cdaq
*-    Initial revision
*-
*-
*- All standards are from "Proposal for Hall C Analysis Software
*- Vade Mecum, Draft 1.0" by D.F.Geesamn and S.Wood, 7 May 1993
*-
*-
*--------------------------------------------------------
      IMPLICIT NONE
      SAVE
*
      character*50 here
      parameter (here= 'C_reset_event')
*
      logical ABORT
      character*(*) err
*
      INCLUDE 'gen_data_structures.cmn'
*--------------------------------------------------------
*
      ABORT= .FALSE.
      err= ' '
*
      RETURN
      END
