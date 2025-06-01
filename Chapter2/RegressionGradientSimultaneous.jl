include("../DescentMethod.jl")

using LinearAlgebra
struct SPSA <: DescentMethod
    delta::Float64
    m::Int64

    SPSA(delta::Real=1e-4, m::Int64=1000) = new(Float64(delta), Int64(m))
end

function compute_gradient(method::SPSA, f, x)
    n = length(x)
    grad = zeros(n)

    delta = method.delta
    num_iterations = method.m

    for _ in 1:num_iterations
        # Ensure z is an N-element vector (column vector)
        # z = randn(n) # This is the correct way for vector operations
        z = map(val -> rand() < 0.5 ? 1.0 : -1.0, zeros(n))

        f_plus = f(x + delta*z)
        f_minus = f(x - delta*z)

        # This line will now correctly perform element-wise division of a scalar by a vector,
        # resulting in a vector, which is then added to `grad`.
        grad_contribution = (f_plus - f_minus) / (2 * delta) * (1 ./ z)
        grad += grad_contribution
    end

    return grad ./ num_iterations
end