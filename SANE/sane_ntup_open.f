      Subroutine sane_ntup_open(file,ABORT,err)
      implicit none
      save

      character*13 here
      parameter(here='sane_ntuple_open')

      logical ABORT
      character*(*) err

      include 'b_ntuple.cmn'
      include 'sane_ntuple.cmn'
      include 'bigcal_bypass_switches.cmn'
      include 'gen_run_info.cmn'


      integer default_bank,default_recl
      parameter(default_bank=8000)     !4 bytes/word
      parameter(default_recl=1024)     !record length
      character*80 title,file
      character*80 directory,name
      character*1000 pat,msg,chform
      integer status,size,io,id,bank,recL,iv(10),m
      real rv(10)

      logical HEXIST        !CERNLIB function

      err=' '
      ABORT=.false.
      if(sane_ntuple_exists) then
         call sane_ntup_shutdown(ABORT,err)
         if(abort) then
            call G_add_path(here,err)
            return
         endif
      endif

c     get any free IO channel

      call g_IO_control(io,'ANY',ABORT,err)
      sane_ntuple_exists = .not.ABORT
      if(ABORT) then
         call G_add_path(here,err)
         return
      endif

      sane_ntuple_iochannel = io

      id = sane_ntuple_id
      name = sane_ntuple_name
      title = sane_ntuple_title
      ABORT = HEXIST(id)
      if(ABORT) then
         call g_IO_control(sane_ntuple_iochannel,'FREE',ABORT,err)
         call g_build_note(':HBOOK id#$ already in use',
     $        '$',id,' ',rv,' ',err)
         call G_add_path(here,err)
         return
      endif

      call HCDIR(directory,'R') !CERNLIB read current directory

      recL = 8191
      iquest(10) = 65000
      call HROPEN(io,name,file,'NQ',recL,status)
      
      write(*,*)'ifile=',file
      ABORT= status.ne.0
      if(ABORT) then
         call g_IO_control(sane_ntuple_iochannel,'FREE',ABORT,err)
         iv(1) = status
         iv(2) = io
         pat= ':HROPEN error#$ opening IO#$ "'//file//'"'
         call G_build_note(pat,'$',iv,' ',rv,' ',err)
         call G_add_path(here,err)
         return
      endif

      size = sane_ntuple_size
      bank = default_bank
      title = sane_ntuple_title


      if(sane_ntuple_type.eq.2) then ! col-wise ntuple for cluster analysis
                                     ! for calibration purposses
         call hbset('BSIZE',8176,status)
         call HBNT(id,title,' ')
         
c
c
c

        call HBNAME(id,'bevinfo',bgid,'bgid:I*4,bgtype:I*4,'//
     $        'btrigtype:I*4')
        call HBNAME(id,'bhits',ngooda,'ngooda:I*4,ngoodt:I*4,'//
     $       'ngoodta:I*4,ngoodtt:I*4,irowmax:I*4,icolmax:I*4,'//
     $       'max_adc:R*4')
        call HBNAME(id,'SANEY1',y1t_hit,
     $       'y1t_hit[0,300]:I*4,y1t_row(y1t_hit):I*4,'//
     $       'y1t_tdc(y1t_hit):I*4,'//
     $       'y1t_y(y1t_hit):R*4')
        call HBNAME(id,'SANEY2',y2t_hit,
     $       'y2t_hit[0,300]:I*4,y2t_row(y2t_hit):I*4,'//
     $       'y2t_tdc(y2t_hit)[0,20000]:I*4,'//
     $       'y2t_y(y2t_hit):R*4')
        call HBNAME(id,'SANEY3',y3t_hit,
     $       'y3t_hit[0,300]:I*4,y3t_row(y3t_hit):I*4,'//
     $       'y3t_tdc(y3t_hit)[0,20000]:I*4,'//
     $       'y3t_y(y3t_hit):R*4')
        call HBNAME(id,'SANEX1',x1t_hit,
     $       'x1t_hit[0,300]:I*4,x1t_row(x1t_hit):I*4,'//
     $       'x1t_tdc(x1t_hit)[0,20000]:I*4,'//
     $       'x1t_x(x1t_hit):R*4')
        call HBNAME(id,'SANECER',cer_hit,
     $       'cer_hit[0,50]:I*4,cer_num(cer_hit):I*4,'//
     $       'cer_tdc(cer_hit):I*4,'//
     $       'cer_adc(cer_hit):I*4')
        call HBNAME(id,'SANELUC',luc_hit,
     $       'luc_hit[0,50]:I*4,luc_row(luc_hit):I*4,'//
     $       'ladc_pos(luc_hit):I*4,ladc_neg(luc_hit):I*4,'//
     $       'ltdc_pos(luc_hit):I*4,ltdc_neg(luc_hit):I*4,'//
     $       'luc_y(luc_hit):R*4')

        

        if(bbypass_find_clusters.eq.0) then
           call HBNAME(id,'clustblock',nclust,
     $          'nclust[0,25]:I*4,ncellclust(nclust)[0,25]:I*4,'//
     $          'ncellbad(nclust)[0,25]:I*4,'//
     $          'ncellx(nclust),ncelly(nclust),iycell(25,nclust),'//
     $          'ixcell(25,nclust),cellbad(25,nclust):L,'//
     $          'xcell(25,nclust),ycell(25,nclust),'//
     $          'eblock(25,nclust),ablock(25,nclust),'//
     $          'xmoment(nclust),ymoment(nclust),'//
     $          'eclust(nclust),aclust(nclust),'//
     $          'xclust(nclust),yclust(nclust)')
           if(bbypass_calc_cluster_time.eq.0) then
              if(bbypass_sum8.eq.0) then
                 call HBNAME(id,'clusttdc',nclust8,
     $                'nclust8[0,25]:I*4,'//
     $                'ncell8clust(nclust8)[0,10]:I*4,'//
     $                'irow8hit(10,nclust8)[0,56]:I*4,'//
     $                'icol8hit(10,nclust8)[0,4]:I*4,'//
     $                'nhit8clust(10,nclust8)[0,8]:I*4,'//
     $                's8(10,nclust8),'//
     $                'tcell8(10,8,nclust8),tclust8(nclust8),'//
     $                'tcut8(nclust8),tcut8cor(nclust8),'//
     $                'trms8(nclust8)')
              endif
              
              if(bbypass_sum64.eq.0) then
                 call HBNAME(id,'clusttrig',nclust64,
     $                'nclust64[0,25]:I*4,'//
     $                'ncell64clust(nclust64)[0,6]:I*4,'//
     $                'irow64hit(6,nclust64)[0,19]:I*4,'//
     $                'icol64hit(6,nclust64)[0,2]:I*4,'//
     $                'nhit64clust(6,nclust64)[0,8]:I*4,'//
     $                'tcell64(6,8,nclust64),a64(6,nclust64),'//
     $                's64(6,nclust64),tclust64(nclust64),'//
     $                'tcut64(nclust64),tcut64cor(nclust64),'//
     $                'trms64(nclust64)')
              endif
           endif

 
           
           if(bbypass_calc_physics.eq.0) then
              call HBNAME(id,'clustphys',ntrack,'ntrack[0,25]:I*4,'//
     $             'ibest[0,25]:I*4,thetarad(ntrack),'//
     $             'phirad(ntrack),energy(ntrack),'//
     $             'xface(ntrack),yface(ntrack),'//
     $             'zface(ntrack),px(ntrack),py(ntrack),pz(ntrack),'//
     $             'ctime_clust(ntrack)')
           endif
           
           call HBNAME(id,'bad_clust',nmax,'nmax[0,25]:I*4,'//
     $          'edge_max(nmax):L,not_enough(nmax):L,'//
     $          'too_long_x(nmax):L,too_long_y(nmax):L,'//
     $          'below_thresh(nmax):L,above_max(nmax):L,'//
     $          'second_max(nmax):L')
        endif

c
c
c
      endif
c     ! For physics analysis  added on Jul 3 2008
        call HBOOK2(10100,'TRACK X1',64, 1.,  65., 200,   200., 900.,0.)
        call HBOOK2(10101,'TRACK Y1',128,1., 129., 200,   200., 900.,0.)
        call HBOOK2(10102,'TRACK Y1',128,1., 129., 200,   200., 900.,0.)
        call HBOOK2(10111,'CER TDC',8, 0.,  5., 200,    1., 1000., 0.)
        call HBOOK2(10112,'CER ADC',8, 0.,  5., 200,    1., 1000., 0.)
        call HBOOK2(10121,'LUC TDCPOS',59,0., 28., 200, 1000., 4000., 0.)
        call HBOOK2(10122,'LUC TDCNEG',59,0., 28., 200, 1000., 4000., 0.)
        call HBOOK2(10125,'LUC ADCPOS',59,0., 28., 200,    0., 4000., 0.)
        call HBOOK2(10126,'LUC ADCNEG',59,0., 28., 200,    0., 4000., 0.)
        call HBOOK2(10200,'BIGCAL' ,33,0., 33.,  56,    0.,   56., 0.)

        call HBNAME(id,'HMSINFO',hms_p,
     $       'hms_p:R*4,hms_e:R*4,hms_theta:R*4,hms_phi:R*4,'//
     $       'hms_ytar:R*4,hms_yptar:R*4,'//
     $       'hms_xptar:R*4,hms_delta:R*4,hms_start:R*4,'//
     $       'rast_x:R*4,rast_y:R*4,'//
     $       'slow_rast_x:R*4,slow_rast_y:R*4,'//
     $       'i_helicity:I*4')

      if(sane_ntuple_type.eq.1) then ! col-wise ntuple
                                     ! for Physics purposses
         call hbset('BSIZE',8176,status)
         call HBNT(id,title,' ')
         call HBNAME(id,'bevinfo',bgid,'bgid:I*4,bgtype:I*4,'//
     $        'btrigtype:I*4')
         call HBNAME(id,'bhits',ngooda,'ngooda:I*4,ngoodt:I*4,'//
     $        'ngoodta:I*4,ngoodtt:I*4,irowmax:I*4,icolmax:I*4,'//
     $        'max_adc:R*4')

         

        call HBNAME(id,'SANEPHYS',n_clust,
     $   'n_clust[1,4]:I*4,'//
     $   'E_clust(n_clust):R*4,'//
     $   'X_clust(n_clust):R*4, Y_clust(n_clust):R*4,'//
     $   'Z_clust(n_clust):R*4,'//
     $   'X_clust_r(n_clust):R*4, Y_clust_r(n_clust):R*4,'//
     $   'Z_clust_r(n_clust):R*4,'//
     $   'luc_h(n_clust)[0,10]:I*4,'//
     $   'X_luc(10,n_clust), Y_luc(10,n_clust), Z_luc(10,n_clust),'//
     $   'X_luc_r(10,n_clust), Y_luc_r(10,n_clust), Z_luc_r(10,n_clust),'//
     $   'trc_hx(n_clust)[0,10]:I*4, X_trc(10,n_clust), Z_trc(10,n_clust),'//
     $   'X_trc_r(10,n_clust), Z_trc_r(10,n_clust),'//
     $       'trc_hy1(n_clust)[0,10]:I*4, Y1_trc(10,n_clust), Z1_trc(10,n_clust),'//
     $       'Y1_trc_r(10,n_clust), Z1_trc_r(10,n_clust),'//
     $       'trc_hy2(n_clust)[0,10]:I*4, Y2_trc(10,n_clust), Z2_trc(10,n_clust),'//
     $       'Y2_trc_r(10,n_clust), Z2_trc_r(10,n_clust),'//
     $       'Tr_Vertex(3,n_clust), Tr_Vertex_r(3,n_clust),'//
     $       'cer_h(n_clust)[0,10]:I*4')
 
      endif

      call HCDIR(sane_ntuple_directory,'R')     ! record ntuple directory

      call HCDIR(directory,' ')          !reset CERNLIB directory

      sane_ntuple_exists = HEXIST(sane_ntuple_id)

      abort = .not.sane_ntuple_exists

      iv(1) = id
      iv(2) = io
      pat = 'Ntuple id#$ [' // sane_ntuple_directory // '/]' //
     $     name // ' IO#$ "' // file // '"'
      call G_build_note(pat,'$',iv,' ',rv,' ',msg)

      call sub_string(msg,'/]','/]')

      if(abort) then
         err = 'unable to create '//msg
         call G_add_path(here,err)
      else
         pat=':created '//msg
         call G_add_path(here,pat)
         call G_log_message('INFO: '//pat)
      endif

      return 


      end