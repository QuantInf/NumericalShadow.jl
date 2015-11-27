function numerical_range(A::Matrix, resolution::Real=0.01)
  w = Complex128[]
  for j=0:resolution:2*pi
    Aθ = exp(1im * -j) * A
    Hθ = (Aθ + Aθ')/2
    e, r = eig(Hθ)
    m = maximum(e)
    s = findin(e, m)
    if length(s) == 1
      p = r[:,s]' * A * r[:,s]
      push!(w, p[1])
    else
      Kθ = 1im * (Hθ - Aθ)
      pKp = r[:,s]' * Kθ * r[:,s]
      ee, rr = eig(pKp)
      mm = minimum(ee)
      sm = findin(ee, mm)
      p = rr[:,sm[1]]' * r[:,s]' * A * r[:,s] * rr[:,sm[1]]
      push!(w, p[1])
      mM=maximum(ee)
      sm=findin(ee, mM)
      p=rr[:,sM[1]]' * r[:,s]' * A * r[:,s] * rr[:,sM[1]]
      push!(w, p[1])
    end
  end
  return w
end

function get_bounding_box(A::Matrix)
    reA = complex128((A + A') / 2)
    imA = -1im * (A-A') / 2
    reEig = eigvals(reA)
    imEig = eigvals(imA)
    mx,Mx,my,My=minimum(reEig), maximum(reEig), minimum(imEig), maximum(imEig)
    return [mx,Mx,my,My].*1.05 ## Ugly hack
end
