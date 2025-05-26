include("../DescentMethod.jl")

using Printf
using LinearAlgebra

function iterated_descent(M::DescentMethod, f_val, ∇f_val, H_val, x_initial, k_max)
    x = x_initial
    init!(M, f_val, ∇f_val, x)

    println("Optimization Start: Initial x = ", x)
    println("Initial function value f(x) = ", f_val(x))
    println("Initial gradient ∇f(x) = ", ∇f_val(x))
    println("Initial Algorithm Parameter (e.g., Trust Region Radius δ) = ", getfield(M, :δ)) # δ를 직접 접근

    tolerance_gradient = 1e-6 # 그래디언트 노름 임계값

    x_history = typeof(x)[]
    f_history = Float64[]

    push!(x_history, x_initial)
    push!(f_history, f_val(x_initial))

    println("-"^100)
    @printf("%-8s | %-20s | %-15s | %-20s | %-10s | %-10s\n", "Iter", "Current x", "f(x) Value", "∇f(x) Norm", "Alg. Param", "Status")
    println("-"^100)

    k_accepted = 0
    total_attempts = 0

    while k_accepted < k_max
        total_attempts += 1
        x_prev = x

        x_candidate, accepted_step, current_param_after_update = step!(M, f_val, ∇f_val, H_val, x_prev)

        if accepted_step
            x = x_candidate
            k_accepted += 1
            push!(x_history, x)
            push!(f_history, f_val(x))
        end

        current_gradient_norm = norm(∇f_val(x))

        if accepted_step
            @printf("%-8d | %-20s | %-15.6f | %-20.6e | %-10.6f | %-10s\n",
                     k_accepted, @sprintf("[%.3f,%.3f]", x...), f_val(x),
                     current_gradient_norm, current_param_after_update, "Accepted")
        else
            @printf("%-8s | %-20s | %-15.6f | %-20.6e | %-10.6f | %-10s\n",
                     " ", @sprintf("[%.3f,%.3f]", x_prev...), f_val(x_prev),
                     norm(∇f_val(x_prev)), current_param_after_update, "Rejected (Retrying)")
        end

        if current_gradient_norm <= tolerance_gradient
            println("\n✨ Convergence Met! Gradient norm (", @sprintf("%.8e", current_gradient_norm), ") is below tolerance (", @sprintf("%.8e", tolerance_gradient), "). ✨")
            break
        end

        if total_attempts > k_max * 5
            println("\nMax total attempts reached. Optimization terminated.")
            break
        end
    end

    println("-"^100)

    println("Optimization End: Final x = ", x)
    println("Final function value f(x) = ", f_val(x))
    println("Final gradient ∇f(x) = ", ∇f_val(x))
    println("Final Algorithm Parameter (e.g., Trust Region Radius δ) = ", getfield(M, :δ))

    return x, x_history, f_history
end