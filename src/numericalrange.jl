function numerical_range(A::Matrix,resolution::FloatingPoint)
  th=[0:resolution:2*pi]
  w=[]
  for j=th
    Ath=exp(1im * -j)*A
    Hth=(Ath+Ath')/2
    e,r=eig(Hth)
    m=max(e)
    s=findin(e,m)
    if length(s)==1 then
      p=r[:,s]'*A*r[:,s]
      w=[w,p]
    else
      Kth=1im*(Hth-Ath)
      pKp=r[:,s]'*Kth*r[:,s]
      ee,rr=eig(pKp)
      mm=min(ee)
      sm=findin(ee,mm)
      p=rr[:,sm[0]]'*r[:,s]'*A*r[:,s]*rr[:,sm[0]]
      w=[w,p]
      mM=max(ee)
      sm=findin(ee,mM)
      p=rr[:,sM[0]]'*r[:,s]'*A*r[:,s]*rr[:,sM[0]]
      w=[w,p]
    end
  end
  return w
end

function get_bounding_box(A::Matrix)
    reA=(A+A')/2.0
    imA=-1im*(A-A')/2.0
    reEig::Float=eig(reA)[1]
    imEig::Float=eig(imA)[1]
    mx,Mx,my,My=min(reEig), max(reEig), min(imEig), max(imEig)
    return [mx,Mx,my,My]
end


function numerical_range(A::Matrix)
  return numerical_range(A::Matrix,0.01)
end