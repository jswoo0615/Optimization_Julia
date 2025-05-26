# run_trust_region_example.jl

using Plots

# 필요한 정의들을 다른 파일에서 불러옵니다.
include("../DescentMethod.jl")
include("TrustRegionDescent.jl")
include("OptimizationLoop.jl")


# --- 1. 목적 함수, 그래디언트, 헤시안 정의 ---
f_objective(x) = (x[1] - 1.0)^2 + (x[2] - 2.0)^2
∇f_objective(x) = [2.0 * (x[1] - 1.0), 2.0 * (x[2] - 2.0)]
H_objective(x) = [2.0 0.0; 0.0 2.0]


# --- 2. 최적화 실행 ---
trust_region_method = TrustRegionDescent(1.0, 0.001, 0.75, 0.5, 2.0)
start_x_tr = [0.0, 0.0]
max_accepted_iterations_tr = 50

println("\n\n=== Trust Region Optimization Example (Fully Modularized) ===")
final_x_tr, x_history_tr, f_history_tr = iterated_descent(
    trust_region_method, f_objective, ∇f_objective, H_objective, start_x_tr, max_accepted_iterations_tr
)

println("\n--- 최종 최적화 결과 ---")
println("최종 위치 (근사 최적점) x = ", final_x_tr)
println("실제 함수의 최솟값은 x = [1.0, 2.0] 입니다.")
println("최종 함수 값 f(final_x_tr) = ", f_objective(final_x_tr))
println("최종 그래디언트 ∇f(final_x_tr) = ", ∇f_objective(final_x_tr))


# --- 3. 최적화 경로 시각화 ---
println("\n그래프를 생성 중입니다. 잠시 기다려 주세요...")

x1_range = -1.0:0.1:3.0
x2_range = -0.5:0.1:4.0

# Z 계산 방식은 그대로 둡니다.
Z = [f_objective([x1, x2]) for x1 in x1_range, x2 in x2_range]

# Add these lines to define explicit contour levels
min_Z = minimum(Z)
max_Z = maximum(Z)
num_levels = 20
explicit_levels = collect(LinRange(min_Z, max_Z, num_levels))

# ---------- 이 부분을 수정합니다! ----------
# Z 행렬을 전치(transpose)하여 넘겨줍니다.
# Plots.jl의 contourf는 Z 행렬이 (y축 길이, x축 길이) 형태를 기대할 수 있습니다.
contourf(x1_range, x2_range, Z', # <--- Z' (Z를 전치)
    levels=explicit_levels,
    color=cgrad(:viridis),
    colorbar_title="f(x)",
    xlabel="x1",
    ylabel="x2",
    title="Trust Region Optimization Path (Modularized Example)",
    legend=:topright
)
# -----------------------------------------------

# 최적화 경로 추가
x1_coords = [x[1] for x in x_history_tr]
x2_coords = [x[2] for x in x_history_tr]

plot!(x1_coords, x2_coords,
    label="Optimization Path",
    marker=:circle,
    markersize=4,
    color=:red,
    line=3,
    linecolor=:red
)

# 시작점, 최종점, 실제 최솟값 표시
scatter!([x_history_tr[1][1]], [x_history_tr[1][2]],
    label="Start Point", marker=:star, markersize=8, color=:yellow, lw=0
)
scatter!([x_history_tr[end][1]], [x_history_tr[end][2]],
    label="End Point", marker=:diamond, markersize=8, color=:green, lw=0
)
scatter!([1.0], [2.0],
    label="Actual Minimum [1,2]", marker=:cross, markersize=8, color=:purple, lw=0
)

display(current())

println("\nPress Enter to close the plot and exit.")
readline() # 사용자로부터 입력을 기다립니다. Enter 키를 누를 때까지 스크립트 실행이 멈춥니다.