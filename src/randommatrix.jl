function random_unitary(n::Integer)
     z = (randn(n,n) + 1im*randn(n,n))/sqrt(2.0)
     q,r = qr(complex128(z))
     d = diag(r)
     ph = d./abs(d)
     return q.*repmat(ph,1,size(ph)[1])'
end

function random_orthogonal(n::Integer)
     z = randn(n,n)
     q,r = qr(z)
     d = diag(r)
     ph = d./abs(d)
     return q.*repmat(ph,1,size(ph)[1])'
end

function random_GOE(n::Integer)
    H=randn(n,n)
    return (H+H')/2
end

function random_GUE(n::Integer)
    H=randn(n,n)+1im*randn(n,n)
    return (H+H')/2
end