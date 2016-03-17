function numerical_range(A::Matrix,resolution::FloatingPoint)
  th=[0:resolution:2*pi]
  w=[]
  for j=th
    Ath=exp(1im * -j)*A
    Hth=(Ath+Ath')/2
    e,r=eig(Hth)
    m=maximum(e)
    s=findin(e,m)
    if length(s)==1 then
      p=r[:,s]'*A*r[:,s]
      w=[w,p]
    else
      Kth=1im*(Hth-Ath)
      pKp=r[:,s]'*Kth*r[:,s]
      ee,rr=eig(pKp)
      mm=minimum(ee)
      sm=findin(ee,mm)
      p=rr[:,sm[1]]'*r[:,s]'*A*r[:,s]*rr[:,sm[1]]
      w=[w,p]
      mM=maximum(ee)
      sM=findin(ee,mM)
      p=rr[:,sM[1]]'*r[:,s]'*A*r[:,s]*rr[:,sM[1]]
      w=[w,p]
    end
  end
  return w
end

function get_bounding_box(A::Matrix)
    reA=complex128((A+A')/2.0)
    imA=complex128(-1im*(A-A')/2.0)
    reEig::Vector=eigvals(reA)
    imEig::Vector=eigvals(imA)
    mx,Mx,my,My=minimum(reEig), maximum(reEig), minimum(imEig), maximum(imEig)
    return [mx,Mx,my,My]
end

function numerical_range(A::Matrix)
  return numerical_range(A::Matrix,0.01)
end
