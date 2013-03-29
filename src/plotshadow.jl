# using Winston

function plot_shadow(M::Matrix,data::Matrix)
  bb=get_bounding_box(M)
  xrange=bb[1:2]
  yrange=bb[3:4]
  clims=(min(data),max(data))
  nr=numerical_range(M)
  p = Winston.FramedPlot()
  setattr(p, "xrange", xrange)
  setattr(p, "yrange", reverse(yrange))
  img = Winston.data2rgb(data, clims, Winston._default_colormap)
  Winston.add(p, Winston.Image(xrange, reverse(yrange), img))
  Winston.add(p, Winston.Curve(real(nr),imag(nr), "color", "red" ))
  return p
end
