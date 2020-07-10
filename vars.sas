/*************************************************
##################################################
*************************************************/;

%macro vars(dset);
  proc sql noprint;
    select name
      into :vars separated by " "
        from dictionary.columns
          where libname = "WORK" & memname = "%upcase(&dset.)";
  quit;
%mend;

/************************************************/;

%macro case(dset, case);
  %local list;

  proc sql noprint;
    select cats(name, "=", &case.(name))
      into :list separated by " "
        from dictionary.columns
          where libname = "WORK" & memname = "%upcase(&dset.)";
  quit;
  
  proc datasets library = work nolist;
    modify &dset.;
    rename &list.;
  quit;
%mend;

/************************************************/;

%macro excl(vars, list);
  %sysfunc(prxchange(s/\b%sysfunc(tranwrd(&list.,%str( ),%str(\b|\b)))\b//,-1,&vars.));
%mend;

/*************************************************
##################################################
*************************************************/;