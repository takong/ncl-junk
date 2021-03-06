; Created: Wednesday, October 12 2011

load "$nsc/yagUtils.ncl"

begin
  a = set_inputfile()
  type = "ps"
  varname = "QSNOW"

  out = "tVq_line" + varname       ;out put file name
  wks = gsn_open_wks(type,out)

  times  = wrf_user_list_times(a)  ; get times in the file
  ntimes = dimsizes(times)         ; number of times in the file

  st = 44
  et = ntimes-1
  nt = et -st + 1

  tt=1

  do it = st, et, 1   ;; LOOP NAME
    vt = it

    print("working with: " + times(vt))
    var_wgt = wrf_user_getvar_weighted_sum(a,varname,vt)

    var_wgt = var_wgt * 1000. ;
    var_wgt@units = "g"

    line = (/  135 ,52  /) ; start x;y & end x;y point
    var_wgt_line = wrf_user_intrp2d(var_wgt,line,45.,False)

    line_lenth=dimsizes(var_wgt_line)
    line_data=new((/nt+1,line_lenth(0)/),typeof(var_wgt_line))
    line_data(tt,:) = var_wgt_line

    tt = tt + 1
  end do
  printVarSummary(line_data)
  con = gsn_csm_hov(wks,line_data,True)
end
