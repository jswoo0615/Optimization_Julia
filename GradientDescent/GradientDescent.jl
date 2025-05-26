include("../DescentMethod.jl")

struct GradientDescent <: DescentMethod
    α   # step factor
end

init!(M::GradientDescent, f, ∇f, x) = M
function step!(M::GradientDescent, f, ∇f, x)
    α, g = M.α, ∇f(x)
    return x - α * g
end