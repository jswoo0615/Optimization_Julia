include("../DescentMethod.jl")
using LinearAlgebra

struct RandomSampleGradient <: DescentMethod
    m::Int64
    delta::Float64

    RandomSampleGradient(m::Int=100, delta::Real=1e-3) = new(m, Float64(delta))
end

function compute_gradient(method::RandomSampleGradient, f, x)
    n = length(x)

    m_val = method.m
    delta_val = method.delta

    # DeltaX : m개의 무작위 단위 벡터에 delta_val을 곱한 값을 스택한 행렬
    DeltaX = stack(delta_val .* normalize(Delta_x) for Delta_x in eachrow(randn(n, m_val)))

    # Delta_f : 각 DeltaX에 대한 함수 값 변화 Delta_f 계산
    Delta_f = [f(x + Delta_x) - f(x) for Delta_x in eachrow(DeltaX)]

    # DeltaX \ Delta_f
    return DeltaX \ Delta_f
end