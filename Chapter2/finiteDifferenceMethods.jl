include("../DescentMethod.jl")
abstract type NumericalDifferenceMethod <: DescentMethod end

struct ForwardDiff <: NumericalDifferenceMethod
    h::Float64
    ForwardDiff(h::Real=1e-9) = new(Float64(h))
end

struct CentralDiff <: NumericalDifferenceMethod
    h::Float64
    CentralDiff(h::Real=1e-9) = new(Float64(h))
end

struct BackwardDiff <: NumericalDifferenceMethod
    h::Float64
    BackwardDiff(h::Real=1e-9) = new(Float64(h))
end

function compute_gradient(method::ForwardDiff, f, x)
    return (f(x+method.h) - f(x)) / method.h
end 

function compute_gradient(method::CentralDiff, f, x)
    return (f(x + method.h/2) - f(x - method.h/2)) / method.h
end

function compute_gradient(method::BackwardDiff, f, x)
    return (f(x) - f(x-method.h)) / method.h
end