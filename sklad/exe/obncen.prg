para p1,p2
  //p2=1 -без снятия блокировки
LOCAL lRet, aRecDb
p2_r=p2
if p2_r=nil
   p2_r=0
endif
lRet:=.F.
mntov_r=p1
if mntov_r=0
   retu
endif
slccr=select()
tov_r=lower(alias())
if tov_r=='tov'
   sele tov
   reclock()
   ktl_r=ktl
   skl_r=skl
   ot_r=ot
   k1t_r=k1t
   m1t_r=m1t
   osf_r=osf
   osv_r=osv
   osn_r=osn
   osfm_r=osfm
   osvo_r=osvo
   if fieldpos('osfo')#0
      osfo_r=osfo
   else
      osfo_r=0
   endif
   if fieldpos('bon')#0
      bon_r=bon
   else
      bon_r=0
   endif
   dpp_r=dpp
   dpo_r=dpo
   post_r=post
   upak_r=upak
   upakp_r=upakp
   vestar_r=vestar
   drlz_r=drlz
   dizg_r=dizg
   kukach_r=kukach
   ksert_r=ksert
   if gnSkotv=0 //gnOtv=0
      opt_r=opt
   else
      opt_r=0.01
   endif
   c27_r=c27
   optz_r=optz
   if fieldpos('tsz60')#0
      tsz60_r=tsz60
   endif
   if fieldpos('prmn')#0
      prmn_r=prmn
   endif
   if fieldpos('zn')#0
      zn_r=zn
   else
      zn_r=''
   endif
   if fieldpos('inv')#0
      inv_r=inv
   else
      inv_r=0
   endif
   otv_r=otv
   pnsotv_r=pnsotv
endif
sele ctov
if netseek('t1','mntov_r').and.mntov_r#0
  //
   IF mntov_r # ctov->mntov
      #ifdef __CLIP__
        outlog(__FILE__,__LINE__,"ctov netseek('t1','mntov_r').and.mntov_r#0",mntov_r, ctov->mntov)
      #endif
      ALERT("ctov Проблема поиска товара в прайсе;Сообщите администратору")
      #ifdef __CLIP__
        outlog(__FILE__,__LINE__,"ctov !netseek('t1','mntov_r') and run LOCATE FOR",mntov_r, ctov->mntov)
      #endif
      ORDSETFOCUS(0)
      LOCATE FOR mntov_r = ctov->mntov
      IF FOUND()
         lRet:=.T.
      ELSE
         #ifdef __CLIP__
           outlog(__FILE__,__LINE__,"ctov netseek('t1','mntov_r') .and. LOCATE FOR",mntov_r, ctov->mntov)
         #endif
         ALERT("ctov Проблема поиска товара в прайсе;Сообщите администратору; Перезапустите программу")
         lRet:=.F.
      ENdIF
   ELSE
      lRet:=.T.
   ENDIF
  //
else
   #ifdef __CLIP__
     outlog(__FILE__,__LINE__,"ctov !netseek('t1','mntov_r') and run LOCATE FOR",mntov_r, ctov->mntov)
   #endif
   ORDSETFOCUS(0)
   LOCATE FOR mntov_r = ctov->mntov
   IF FOUND()
      lRet:=.T.
   ELSE
      #ifdef __CLIP__
        outlog(__FILE__,__LINE__,"ctov netseek('t1','mntov_r') .and. LOCATE FOR",mntov_r, ctov->mntov)
      #endif
      ALERT("ctov Проблема поиска товара в прайсе;Сообщите администратору; Перезапустите программу")
      lRet:=.F.
   ENdIF
endif

IF lRet
   arec:={}
   getrec()
   if tov_r=='tov'
      sele tov
      putrec(nil,'skl,ktl,mntov,ot')

      netrepl('k1t,m1t,osf,osv,osn,osfm,osvo,dpp,dpo,post,upak,upakp,vestar,drlz,dizg,opt,optz,ksert,kukach,otv,pnsotv,c27',;
              'k1t_r,m1t_r,osf_r,osv_r,osn_r,osfm_r,osvo_r,dpp_r,dpo_r,post_r,upak_r,upakp_r,vestar_r,drlz_r,dizg_r,opt_r,optz_r,ksert_r,kukach_r,otv_r,pnsotv_r,c27_r',p2_r)
      if fieldpos('tsz60')#0
         netrepl('tsz60','tsz60_r',p2_r)
      endif
      if fieldpos('prmn')#0
         netrepl('prmn','prmn_r',p2_r)
      endif
      if fieldpos('osfo')#0
         netrepl('osfo','osfo_r',p2_r)
      endif
      if fieldpos('bon')#0
         netrepl('bon','bon_r',p2_r)
      endif
      if fieldpos('zn')#0
         netrepl('zn','zn_r',p2_r)
      endif
      if fieldpos('inv')#0
         netrepl('inv','inv_r',p2_r)
      endif
   //
      if netseek('t1','skl_r,ktl_r')
         IF .NOT. (ktl_r = tov->ktl .AND. skl_r = tov->skl .AND. mntov_r = tov->mntov)
            #ifdef __CLIP__
              outlog(__FILE__,__LINE__,"tov netseek('t1','skl_r,ktl_r')",mntov_r, tov->mntov,skl_r, tov->skl, ktl_r, tov->ktl)
            #endif
            ALERT("tov Проблема поиска товара в прайсе;Сообщите администратору")
         ENDIF
      else
         #ifdef __CLIP__
           outlog(__FILE__,__LINE__,"tov !netseek('t1','skl_r,ktl_r')",mntov_r, tov->mntov,skl_r, tov->skl, ktl_r, tov->ktl)
         #endif
         ALERT("tov Проблема поиска товара в прайсе;Сообщите администратору")
      endif
    //
      sele tovm
      if netseek('t1','skl_r,mntov_r')
      //
         IF .NOT. (mntov_r = tovm->mntov .AND. skl_r = tovm->skl)
            #ifdef __CLIP__
              outlog(__FILE__,__LINE__,"tovm netseek('t1','skl_r,mntov_r')",mntov_r, tovm->mntov, skl_r, tovm->skl)
            #endif
            ALERT("tovm Проблема поиска товара в прайсе;Сообщите администратору")
            ORDSETFOCUS(0)
            LOCATE FOR mntov_r = tovm->mntov .AND. skl_r = tovm->skl
            IF FOUND()
               lRet:=.T.
            ELSE
               #ifdef __CLIP__
                outlog(__FILE__,__LINE__,"tovm netseek('t1','skl_r,mntov_r') .and. LOCATE FOR",mntov_r, tovm->mntov, skl_r, tovm->skl)
               #endif
               ALERT("Проблема поиска товара в прайсе;Сообщите администратору; Перезапустите программу")
               lRet:=.F.
            ENdIF
         ELSE
            lRet:=.T.
         ENDIF
      //
         IF lRet
            reclock()
            skl_r   :=skl
            ot_r    :=ot
            k1t_r   :=k1t
            m1t_r   :=m1t
            osf_r   :=osf
            osv_r   :=osv
            osn_r   :=osn
            osfm_r  :=osfm
            osvo_r  :=osvo
            if fieldpos('osfo')#0
               osfo_r=osfo
            else
               osfo_r=0
            endif
            dpp_r   :=dpp
            dpo_r   :=dpo
            upak_r  :=upak
            upakp_r :=upakp
            vestar_r:=vestar
            drlz_r  :=drlz
            dizg_r  :=dizg
            otv_r   :=otv
            if fieldpos('tsz60')#0
               tsz60_r:=tsz60
            endif

            #ifdef __CLIP__
              TestSeek_skl_r_mntov_r(__FILE__,__LINE__,DATE())
            #endif

            putrec(nil,'skl,mntov')

            netrepl('ktl,ktlm,ot,k1t,m1t,osf,osv,osn,osfm,osvo,dpp,dpo,post,upak,upakp,vestar,drlz,dizg,otv',;
                    '0,0,ot_r,k1t_r,m1t_r,osf_r,osv_r,osn_r,osfm_r,osvo_r,dpp_r,dpo_r,0,upak_r,upakp_r,vestar_r,drlz_r,dizg_r,otv_r',p2_r)
            if fieldpos('osfo')#0
               netrepl('osfo','osfo_r',p2_r)
            endif

            #ifdef __CLIP__
              TestSeek_skl_r_mntov_r(__FILE__,__LINE__,DATE())
            #endif

            if fieldpos('tsz60')#0
               netrepl('tsz60','tsz60_r',p2_r)
            endif
        //
            #ifdef __CLIP__
              TestSeek_skl_r_mntov_r(__FILE__,__LINE__,DATE())
            #endif
        //
         ENDIF
      endif
   endif   // tov_r='tov'

   if tov_r=='tovm'
      sele tovm
      reclock()
      skl_r   :=skl
      ot_r    :=ot
      k1t_r   :=k1t
      m1t_r   :=m1t
      osf_r   :=osf
      osv_r   :=osv
      osn_r   :=osn
      osfm_r  :=osfm
      osvo_r  :=osvo
      osfo_r=osfo
      dpp_r   :=dpp
      dpo_r   :=dpo
      upak_r  :=upak
      upakp_r :=upakp
      vestar_r:=vestar
      drlz_r  :=drlz
      dizg_r  :=dizg
      otv_r   :=otv
      if fieldpos('tsz60')#0
         tsz60_r:=tsz60
      endif

      #ifdef __CLIP__
        TestSeek_skl_r_mntov_r(__FILE__,__LINE__,DATE())
      #endif

      #ifdef __CL_IP__
        dbWrite(aRecDb)
      #else
        putrec(nil,'skl,mntov')
      #endif

      netrepl('ktl,ktlm,ot,k1t,m1t,osf,osv,osn,osfm,osvo,dpp,dpo,post,upak,upakp,vestar,drlz,dizg,otv',;
              '0,0,ot_r,k1t_r,m1t_r,osf_r,osv_r,osn_r,osfm_r,osvo_r,dpp_r,dpo_r,0,upak_r,upakp_r,vestar_r,drlz_r,dizg_r,otv_r',p2_r)
      if fieldpos('osfo')#0
         netrepl('osfo','osfo_r',p2_r)
      endif

      #ifdef __CLIP__
        TestSeek_skl_r_mntov_r(__FILE__,__LINE__,DATE())
      #endif

      if fieldpos('tsz60')#0
         netrepl('tsz60','tsz60_r',p2_r)
      endif
        //
      #ifdef __CLIP__
        TestSeek_skl_r_mntov_r(__FILE__,__LINE__,DATE())
      #endif
        //
   ENDIF
endif
sele &slccr

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  05-30-05   //09:51:18am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION  TestSeek_skl_r_mntov_r(c__FILE__,c__LINE__,DDATE, aRecDb)
  LOCAL lRet
  lRet:=.T.
  if netseek('t1','skl_r,mntov_r')
    IF .NOT. (mntov_r = tovm->mntov .AND. skl_r = tovm->skl)
      #ifdef __CLIP__
        outlog(c__FILE__,c__LINE__,DATE(),"tovm netseek('t1','skl_r,mntov_r')",mntov_r, tovm->mntov,skl_r, tovm->skl)
        //outlog(aRecDb)
      #endif
      lRet:=.F.
      ALERT("tovm Проблема поиска товара в прайсе;Сообщите администратору")
    ENDIF
  ELSE
    #ifdef __CLIP__
      outlog(c__FILE__,c__LINE__,DATE(),"tovm !netseek('t1','skl_r,mntov_r')",mntov_r, tovm->mntov,skl_r, tovm->skl)
      //outlog(aRecDb)
    #endif
    lRet:=.F.
    ALERT("tovm Проблема поиска товара в прайсе;Сообщите администратору")
  endif
  RETURN (lRet)
