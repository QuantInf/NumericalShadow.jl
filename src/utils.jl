function vkron(v1::Vector,v2::Vector)
  newdim=size(v1)[1]*size(v2)[1]
  return reshape(transpose(kron(v1,v1)),(newdim,1))
end

function mkron(m1::Matrix,m2::Matrix)
  newdim1=size(m1)[1]*size(m2)[1]
  newdim2=size(m1)[2]*size(m2)[2]
  return reshape(transpose(kron(v1,v1)),(newdim1,newdim2))
end

function histogram2d(data::Matrix,edgx::Vector,edgy::Vector)
    nx = length(edgx)
    ny = length(edgy)
    h = zeros(Int, nx, ny)
    if nx == 0 || ny == 0
        return h
    end
    firstx = edgx[1]
    lastx = edgx[nx]
    firsty = edgy[1]
    lasty = edgy[ny]

    for i=1:size(data)[1]
      x,y=data[i,:]
        if !isless(lastx, x) && !isless(x, firstx) && !isless(lasty, y) && !isless(y, firsty)
            i = searchsortedlast(edgx, x)
            j = searchsortedlast(edgy, y)
            h[i,j] += 1
        end
    end
    return h
end

function histogram2d(data::Matrix, xlimits::Vector,ylimits::Vector, xbins::Integer, ybins::Integer)
    h = zeros(Int, xbins, ybins)
    if xbins == 0 || ybins == 0
        return h
    end
    lox, hix = minimum(data[:,1]), maximum(data[:,1])
    loy, hiy = minimum(data[:,2]), maximum(data[:,2])
    lox, hix = xlimits
    loy, hiy = ylimits

    if lox == hix
        lox -= div(xbins,2)
        hix += div(xbins,2) + int(isodd(xbins))
    end
    if loy == hiy
        loy -= div(ybins,2)
        hiy += div(ybins,2) + int(isodd(ybins))
    end
    
    binszx = (hix - lox) / xbins
    binszy = (hiy - loy) / ybins

    for i=1:size(data)[1]
        x,y=data[i,:]
        if isfinite(x) && isfinite(y)
            i = iround((x - lox) / binszx + 0.5)
            j = iround((y - loy) / binszy + 0.5)
            h[i > xbins ? xbins : i, j > ybins ? ybins : j] += 1
        end
    end
    return h
end
