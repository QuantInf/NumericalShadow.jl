function numericalrange(A::Matrix, resolution::Real=0.01)
  th = 0:resolution:2π
  w = ComplexF64[]
  for j in th
    Ath = exp(1im * -j)*A
    Hth = Hermitian((Ath+Ath'))/2
    e, r = eigen(Hth)
    m = maximum(e)
    s = findall(in(e), m)
    if length(s)==1
      p = r[:,s]'*A*r[:,s]
      append!(w, p)
    else
      Kth = 1im*(Hth-Ath)
      pKp = r[:,s]'*Kth*r[:,s]
      ee,rr = eig(pKp)
      mm = minimum(ee)
      sm = findall(in(ee), mm)
      p = rr[:,sm[1]]'*r[:,s]'*A*r[:,s]*rr[:,sm[1]]
      append!(w, p)
      mM = maximum(ee)
      sM = findall(in(ee), mM)
      p = rr[:,sM[1]]'*r[:,s]'*A*r[:,s]*rr[:,sM[1]]
      append!(w, p)
    end
  end
  return w
end

function get_bounding_box(A::Matrix)
    reA = Hermitian((A+A')/2.0)
    imA = Hermitian(-1im*(A-A')/2.0)
    reEig = eigvals(reA)
    imEig = eigvals(imA)
    return boundingbox(minimum(reEig), maximum(reEig), minimum(imEig), maximum(imEig))
end
