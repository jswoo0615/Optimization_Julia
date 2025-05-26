include("../DescentMethod.jl")
mutable struct ConjugateGradientDescent <: DescentMethod
    d       # Previous search direction
    g       # Previous gradient
end

function init!(M::ConjugateGradientDescent, f, ∇f, x)
    M.g = ∇f(x)
    M.d = -M.g
    return M
end

function step!(M::ConjugateGradientDescent, f, ∇f, x)
    d, g = M.d, M.g
    g′ = ∇f(x)
    β = max(0, g′ ⋅ (g′ - g) / (g ⋅ g))
    d′ = -g′ + β * d
    x′ = line_search(f, x, d′)
    M.d, M.g = d′, g′
    return x′
end