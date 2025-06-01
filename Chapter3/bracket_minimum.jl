include("../DescentMethod.jl")

struct Bracket <: DescentMethod
    s::Float64
    k::Float64
    Bracket(s::Real=1e-3, k::Real=3.0) = new(Float64(s), Float64(k))
end

function bracket_minimum(method::Bracket, f, x0)
    current_s = method.s
    current_k = method.k

    a = x0
    b = x0 + current_s
    fa = f(a)
    fb = f(b)
    
    if fa <= fb
        a, b = b, a
        fa, fb = fb, fa
        current_s = -current_s
    end

    while true
        c = b + current_s
        fc = f(c)

        if fc > fb
            return a < c ? (a, c) : (c, a)
        end

        a, fa = b, fb
        b, fb = c, fc

        current_s *= current_k
    end
end