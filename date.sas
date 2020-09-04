/*************************************************
##################################################
*************************************************/;

options yearcutoff = 1950;

/*************************************************
##################################################
*************************************************/;

%global yymmdd_cur;
%let    yymmdd_cur = %sysfunc(today(), yymmddn6.);

/*************************************************
##################################################
*************************************************/;

%macro yymmdd  (yymmdd = &yymmdd_cur., lag = 1);
  %sysfunc(intnx(day, %sysfunc(inputn(&yymmdd., yymmdd6.)), -&lag.), yymmddn6.)
%mend;

%macro yyyymmdd(yymmdd = &yymmdd_cur., lag = 1);
  %sysfunc(intnx(day, %sysfunc(inputn(&yymmdd., yymmdd6.)), -&lag.), yymmddn8.)
%mend;

/************************************************/;

%macro ww      (yymmdd = &yymmdd_cur., lag = 1);
  %sysfunc(intnx(day, %sysfunc(inputn(&yymmdd., yymmdd6.)), -&lag.), weekv2.  )
%mend;

/*************************************************
##################################################
*************************************************/;

%global yymm_cur;
%let    yymm_cur = %sysfunc(today(), yymmn4.);

/*************************************************
##################################################
*************************************************/;

%macro diff_yymm(yymm1, yymm2);
  %sysfunc(diff_yymm(&yymm1., &yymm2.))
%mend;

/*************************************************
##################################################
*************************************************/;

%macro mon_beg(yymm = &yymm_cur., lag = 1);
  %sysfunc(intnx(month, %sysfunc(inputn(&yymm., yymmn4.)), -&lag., b))
%mend;

%macro mon_end(yymm = &yymm_cur., lag = 1);
  %sysfunc(intnx(month, %sysfunc(inputn(&yymm., yymmn4.)), -&lag., e))
%mend;

/************************************************/;

%macro qua_beg(yymm = &yymm_cur., lag = 1);
  %sysfunc(intnx(quarter, %mon_beg(yymm = &yymm., lag = &lag.), 0, b))
%mend;

%macro qua_end(yymm = &yymm_cur., lag = 1);
  %sysfunc(intnx(quarter, %mon_beg(yymm = &yymm., lag = &lag.), 0, e))
%mend;

/************************************************/;

%macro yea_beg(yymm = &yymm_cur., lag = 1);
  %sysfunc(intnx(year, %mon_beg(yymm = &yymm., lag = &lag.), 0, b))
%mend;

%macro yea_end(yymm = &yymm_cur., lag = 1);
  %sysfunc(intnx(year, %mon_beg(yymm = &yymm., lag = &lag.), 0, e))
%mend;

/*************************************************
##################################################
*************************************************/;

%macro qq    (yymm = &yymm_cur., lag = 1);
  %substr(%sysfunc(intnx(month, %sysfunc(inputn(&yymm., yymmn4.)), -&lag.), yyqz4. ), 3)
%mend;

%macro mm    (yymm = &yymm_cur., lag = 1);
  %substr(%sysfunc(intnx(month, %sysfunc(inputn(&yymm., yymmn4.)), -&lag.), yymmn4.), 3)
%mend;

/************************************************/;

%macro yy    (yymm = &yymm_cur., lag = 1);
  %sysfunc(intnx(month, %sysfunc(inputn(&yymm., yymmn4.)), -&lag.), year2.)
%mend;

%macro yyyy  (yymm = &yymm_cur., lag = 1);
  %sysfunc(intnx(month, %sysfunc(inputn(&yymm., yymmn4.)), -&lag.), year4.)
%mend;

/************************************************/;

%macro yymm  (yymm = &yymm_cur., lag = 1);
  %sysfunc(intnx(month, %sysfunc(inputn(&yymm., yymmn4.)), -&lag.), yymmn4.)
%mend;

%macro yyyymm(yymm = &yymm_cur., lag = 1);
  %sysfunc(intnx(month, %sysfunc(inputn(&yymm., yymmn4.)), -&lag.), yymmn6.)
%mend;

/************************************************/;

%macro yyqq  (yymm = &yymm_cur., lag = 1);
  %sysfunc(intnx(month, %sysfunc(inputn(&yymm., yymmn4.)), -&lag.), yyq4.)
%mend;

%macro yyyyqq(yymm = &yymm_cur., lag = 1);
  %sysfunc(intnx(month, %sysfunc(inputn(&yymm., yymmn4.)), -&lag.), yyq6.)
%mend;

/*************************************************
##################################################
*************************************************/;

%macro yymm_mon(yymm = &yymm_cur., lag = 1);
  %local l;
  %let   l = jan feb mar apr may jun jul aug sep oct nov dec;                    
  
  %local i;
  %let   i = 1;
   
  %do %while(%scan(&l., &i.) ^= %str( ));
    %local v;
    %let   v = %scan(&l., &i.);
    
    %global yymm_&v.;
    %let    yymm_&v. = %sysfunc(intnx(month, %yea_beg(yymm = &yymm., lag = &lag.), %eval(&i.-1)), yymmn4.);
  
    %let i = %eval(&i.+1);
  %end;
  
  %let v =; %let i =; %let l =;
%mend;

/*************************************************
##################################################
*************************************************/;

%macro yymmzz(yymm = &yymm_cur., lag = 1);
  %local i;
  
  %do i = 0 %to 24;
    %local zz;
    %let   zz = %sysfunc(putn(&i./01, z2.));
    
    %global yymm&zz.;
    %let    yymm&zz. = %yymm(yymm = &yymm., lag = %eval(&lag.+&i.));
    
    %global mon_beg_yymm&zz.;
    %global mon_end_yymm&zz.;
    %let    mon_beg_yymm&zz. = %mon_beg(yymm = &yymm., lag = %eval(&lag.+&i.));
    %let    mon_end_yymm&zz. = %mon_end(yymm = &yymm., lag = %eval(&lag.+&i.));    
  %end;
%mend;

/************************************************/;

%macro yyqqzz(yymm = &yymm_cur., lag = 1);
  %local i;
  
  %do i = 0 %to 24 %by 3;
    %local zz;
    %let   zz = %sysfunc(putn(&i./03, z2.));
    
    %global yyqq&zz.;
    %let    yyqq&zz. = %yyqq(yymm = &yymm., lag = %eval(&lag.+&i.));

    %global qua_beg_yyqq&zz.;
    %global qua_end_yyqq&zz.;
    %let    qua_beg_yyqq&zz. = %qua_beg(yymm = &yymm., lag = %eval(&lag.+&i.));
    %let    qua_end_yyqq&zz. = %qua_end(yymm = &yymm., lag = %eval(&lag.+&i.));    
  %end; 
%mend;

/************************************************/;

%macro yyyyzz(yymm = &yymm_cur., lag = 1);
  %local i;
  
  %do i = 0 %to 24 %by 3;
    %local zz;
    %let   zz = %sysfunc(putn(&i./12, z2.));
    
    %global yyyy&zz.;
    %let    yyyy&zz. = %yyyy(yymm = &yymm., lag = %eval(&lag.+&i.));

    %global yea_beg_yyyy&zz.;
    %global yea_end_yyyy&zz.;
    %let    yea_beg_yyyy&zz. = %yea_beg(yymm = &yymm., lag = %eval(&lag.+&i.));
    %let    yea_end_yyyy&zz. = %yea_end(yymm = &yymm., lag = %eval(&lag.+&i.));    
  %end; 
%mend;

/*************************************************
##################################################
*************************************************/;
