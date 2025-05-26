include("ConjugateGradientDescent.jl")
include("line_search.jl")
include("bracket_minimum.jl")
using Printf
using LinearAlgebra
using Zygote
using Plots
pyplot()

# 한글 폰트 설정 (이전 대화에서 경사 하강법 코드에 추가했던 부분입니다. 공액 기울기법에도 필요하다면 추가해주세요.)
# default(
#     fontfamily="NanumGothic", # 또는 "Malgun Gothic", "AppleGothic" 등
#     titlefont=(12, "NanumGothic"),
#     legendfont=(10, "NanumGothic"),
#     guidefont=(10, "NanumGothic"),
#     tickfont=(8, "NanumGothic")
# )

# 2. 최적화할 이차 함수 정의
function f_quadratic(x::Vector{Float64})
    A = [2.0 1.0; 1.0 2.0]
    b = [2.0; 0.0]
    return 0.5 * dot(x, A * x) - dot(b, x)
end

# 기울기 함수 ∇f(x)
function grad_f_quadratic(x::Vector{Float64})
    A = [2.0 1.0; 1.0 2.0]
    b = [2.0; 0.0]
    return A * x - b
end

# 3. 최적화 실행
initial_x = [0.0; 0.0]
cg_method = ConjugateGradientDescent(zeros(2), zeros(2))
init!(cg_method, f_quadratic, grad_f_quadratic, initial_x)

current_x = initial_x
x_history = [initial_x]

num_iterations = 20
tolerance = 1e-7

println("--------------------------------------------------")
println("           공액 기울기법 (Conjugate Gradient)     ")
println("--------------------------------------------------")
println("반복 0: x = $(@sprintf("[%.4f, %.4f]", current_x[1], current_x[2])), f(x) = $(@sprintf("%.6f", f_quadratic(current_x)))")

for i in 1:num_iterations
    global current_x
    prev_x = current_x
    current_x = step!(cg_method, f_quadratic, grad_f_quadratic, current_x)
    push!(x_history, current_x)

    println("반복 $(i): x = $(@sprintf("[%.4f, %.4f]", current_x[1], current_x[2])), f(x) = $(@sprintf("%.6f", f_quadratic(current_x)))")

    if norm(current_x - prev_x) < tolerance || norm(grad_f_quadratic(current_x)) < tolerance
        println("공액 기울기법: 수렴 조건 만족. $(i)번째 반복에서 종료합니다.")
        break
    end
end
println("\n최종 x 값: $(@sprintf("[%.4f, %.4f]", current_x[1], current_x[2]))")
println("최종 f(x) 값: $(@sprintf("%.6f", f_quadratic(current_x)))")
println("이론적 최적해: [1.3333, -0.6667]")

# 4. 시각화 (2D 등고선 플롯)
x1_range = -2.0:0.1:3.0
x2_range = -2.0:0.1:1.0
Z = [f_quadratic([x1, x2]) for x2 in x2_range, x1 in x1_range]

# 플롯 생성
p = plot(x1_range, x2_range, Z, st=:contourf, levels=20, colorbar=true,
     c = :jet, # <-- 이 부분을 변경합니다. (예: :jet, :plasma, :hot, :cividis)
     title="Conjugate Gradient Path on Quadratic Function",
     xlabel="x1", ylabel="x2", aspect_ratio = :equal)

# 최적화 경로 그리기
x_coords = [p[1] for p in x_history]
y_coords = [p[2] for p in x_history]
scatter!(p, x_coords, y_coords, label="CG Path", marker=:circle, markersize=4, color=:red, linestyle=:solid, linealpha=0.8)

# 이론적 최적해 표시
scatter!(p, [4/3], [-2/3], label="Optimal Solution", marker=:star5, markersize=8, color=:black)

display(p)

println("\nPress Enter to close the plot and exit.")
readline()