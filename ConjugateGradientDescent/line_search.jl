include("minimize.jl")
function line_search(f, x, d)
    objective = α-> f(x + α*d)
    a, b = bracket_minimum(objective)
    α = minimize(objective, a, b)
    return x + α*d
end