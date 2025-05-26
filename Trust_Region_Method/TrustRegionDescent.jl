include("../DescentMethod.jl")
# TrustRegionDescent.x3d = rand(100)
using Convex, ECOS
using LinearAlgebra

mutable struct TrustRegionDescent <: DescentMethod
    δ::Float64      # Trust Region Radius
    η1::Float64     # Improvement ratio down-scale threshold
    η2::Float64     # Improvement ratio up-scale threshold
    γ1::Float64     # Down-scale multiplier
    γ2::Float64     # Up-scale multiplier
end

# TrustRegionDescent에 대한 초기화 함수
init!(M::TrustRegionDescent, f, ∇f, x) = nothing

# TrustRegionDescent의 step! 함수
function step!(M::TrustRegionDescent, f, ∇f, H, x)
    δ, η1, η2, γ1, γ2 = M.δ, M.η1, M.η2, M.γ1, M.γ2

    x_candidate, y_predicted = solve_trust_region_subproblem(f, ∇f, H, x, δ)

    actual_reduction = f(x) - f(x_candidate)
    predicted_reduction = f(x) - y_predicted

    if abs(predicted_reduction) < 1e-10
        η = 0.0
    else
        η = actual_reduction / predicted_reduction
    end

    accepted_step = false

    if η < η1
        M.δ *= γ1
    else
        accepted_step = true
        if η > η2
            M.δ *= γ2
        end
    end

    return accepted_step ? x_candidate : x, accepted_step, M.δ
end


# 신뢰 영역 부분 문제 해결 함수
function solve_trust_region_subproblem(f_original, ∇f, H, x0, δ)
    dim = length(x0)
    p_var = Variable(dim)

    model_objecrtive = dot(∇f(x0), p_var) + quadform(p_var, H(x0)) / 2
    constraints = [norm(p_var) <= δ]

    problem = minimize(model_objecrtive, constraints)

    solve!(problem, ECOS.Optimizer; silent_solver=true)

    p_value = p_var.value
    p_value_vec = vec(p_value)
    x_candidate = x0 + p_value_vec
    y_predicted = f_original(x0) + problem.optval

    return (x_candidate, y_predicted)
end
