; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
;    File: sur_air_temp.ncl
;  Author: Yagnesh Raghava Yakkala <hi@yagnesh.org>
; Created: Friday, September  9 2011
;

; Description:
;

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

  a = addfile("./wrfout_d03_2008-12-25_00:00:00.nc","r")
  tvalues = (/ 0,47,90,92,94,96 /)   ;specify desired timestep outputs must be even

; four_day = "yes"               ; yes or comment out
  if ( isdefined("four_day") ) then
    a = addfile("./wrfout_d03_2008-12-23_00:00:00.nc","r")
    tvalues = tvalues + 96
  end if

  level=1

  type = "ps"
  out = "air_temp_at_level_" + level      ;out put file name

  wks = gsn_open_wks(type,out)

  res = True
  ; res@MainTitle = "Water Vapour Mixing Ration"
  res@Footer = False
  res@gsnSpreadColors = True    ;spread Colors
  res@lbLabelBarOn        = False           ; turn off individual cb's

  mpres  = True  ; Map resources
  pltres = True ; Plot resources
  mpres@mpDataBaseVersion    = "HighRes"
  mpres@mpGeophysicalLineThicknessF = 2.0

  times  = wrf_user_list_times(a)  ; get times in the file
  ntimes = dimsizes(times)         ; number of times in the file

  noft = dimsizes(tvalues)
  plot = new(noft,graphic)

  do it = 0, noft - 1, 1   ; LOOP NAME
; do it = 60, ntimes-1, 2  ; LOOP NAME
    print("tvalue: " + tvalues(it))


    print("Working on time: " + times(tvalues(it)))
    res@TimeLabel = times(tvalues(it))   ; Set Valid time to use on plots
    ; res@gsnLeftString = times(tvalues(it))   ; Set Valid time to use on plots

    tc = wrf_user_getvar(a,"tk",tvalues(it))

    res@gsnDraw              = False              ; Do not draw plot
    res@gsnFrame             = False              ; Do not advance frame
    res@cnInfoLabelOn = False        ; turn off contour info label

    opts = res
    opts@cnFillOn         = True
    opts@cnFillColor = True
    opts@ContourParameters = (/ 265.,275., 0.5 /)
    opts@InitTime = False

    pltres@NoTitles = True
    pltres@PanelPlot = True
    pltres@FramePlot = False
    pltres@MainTitlePos= False

    mpres@gsnMaximize = True

    ; contour = wrf_contour(a,wks,tc(level,:,:),opts)
    contour = wrf_contour(a,wks,tc(level,:,:),opts)
    plot(it) = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
    delete(contour)

  end do

  pres                = True              ; mod panel plot
  pres@lbLabelStride  = 10              ; skip every other label
  pres@gsnPanelBottom = 0.05              ; add some space at bottom
  pres@gsnPanelLabelBar = True                   ; add common colorbar
  pres@gsnMaximize = True

  pres@txString         = "Air Temperature in at level " + level     ; add common title
  gsn_panel(wks,plot,(/noft/2 , 2/),pres)        ; create panel plot

end
