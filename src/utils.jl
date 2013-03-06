function vkron(v1::Vector,v2::Vector)
  newdim=size(v1)[1]*size(v2)[1]
  return reshape(transpose(kron(v1,v1)),(newdim,1))
end

function mkron(m1::Matrix,m2::Matrix)
  newdim1=size(m1)[1]*size(m2)[1]
  newdim2=size(m1)[2]*size(m2)[2]
  return reshape(transpose(kron(v1,v1)),(newdim1,newdim2))
end

function histogram2d(data::Matrix,xlimits::Vector,ylimits::Vector,xbins::Int,ybins::Int)
  h=zeros(Int,xbins,ybins)
  dx=abs(xlimits[2]-xlimits[1])
  dy=abs(ylimits[2]-ylimits[1])
  xmin,xmax=min(xlimits),max(xlimits)
  ymin,ymax=min(ylimits),max(ylimits)
  datasize=size(data)[1]

  Dx=data[:,1]
  Dy=data[:,2]
  X = linspace(xmin,xmax,xbins)
  Y = linspace(ymin,ymax,ybins)

  for i=1:datasize
    xbin::Int=searchsortedlast(X,Dx[i])
    ybin::Int=searchsortedlast(Y,Dy[i])
    if (xbin>0) && (xbin<=xbins) && (ybin>0) && (ybin<=ybins) 
      h[xbin,ybin]+=1
    else
      println("at ",i," ",xbin," ",ybin, " ",data[i,:])
      println("wrong bin")
    end
  end
  return h
end

function histogram2d(data::Matrix)
  return histogram2d(data,[min(data[:,1]),max(data[:,1])], [min(data[:,2]),max(data[:,2])],10,10)
end

function histogram2d(data::Matrix, xdensity::Int, ydensity::Int)
  return histogram2d(data,[min(data[:,1]),max(data[:,1])], [min(data[:,2]),max(data[:,2])],xdensity,ydensity)
end
