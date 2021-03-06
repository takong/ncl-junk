; Created: 2013-04-23 15:55

load "$nsc/yagUtils.ncl"
import("shea_util")

begin
  type = "pdf"
  ; type = "X11"
  varname = "QSNOW"

  out = "wgt_cloud"
  wks = gsn_open_wks(type,out)

  a = set_inputfile()
  times = a->Times
  xlat = a->XLAT(0,:,:)
  xlon = a->XLONG(0,:,:)

  res = True
  res = set_res_cn(res)
  set_res_cn_limits(res, 0, 40, 3)

  res@gsnLeftString   = "Integrated Cloud"
  res@lbLabelStride   = 3
  res@tfDoNDCOverlay = True
  res@lbTitleOn = False
  res = set_res_no_frame(res)
  res = set_res_highres_coast(res)

  do it = 0, dim_len0(times) - 1 , 1
  ; do it = 20, 22 , 1
    vt = it
    system("echo " + vt + ": " + "working with: " + chartostring(times(vt,5:15)))
    wgted_var = wrf_user_getvar_weighted_sum(a,(/"QSNOW"/),vt)

    res = wrf_map_resources(a,res)
    res = set_lb_resources(wgted_var(:,:),res)

    date_string = chartostring(times(vt,5:15))
    res@gsnCenterString = date_string

    delete_attrs(res)
    plot = gsn_csm_contour_map(wks,wgted_var,res)
    printVarInfo(wgted_var, "wgted_var")
    draw(wks)
    frame(wks)
  end do

end
;;; wgt_cloud.ncl
