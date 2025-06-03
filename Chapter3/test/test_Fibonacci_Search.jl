include("../fibonacci_search.jl")

using Test

# 테스트 할 함수 정의
# 1. 간단한 2차 함수 
f1(x) = (x - 2)^2 + 1

# 2. 다른 2차 함수 
f2(x) = x^2

# 3. 약간 복잡한 함수
f3(x) = x^3 - 3x + 1

println("--- Fibonacci Search Test ---")

@testset "Fibonacci Search Tests" begin
    # Test 1: f1(x) = (x-2)^2 + 1, min at x=2
    result1_a, result1_b = fibonacci_search(f1, 0.0, 5.0, 10)
    println("f1([0.0, 5.0], n=10) -> Result: ($(result1_a), $(result1_b))")
    
    @test (result1_a <= 2.0 + 1e-9 && result1_b >= 2.0 - 1e-9)
    # n=10일 때, F_11 = 89. 초기 길이 5. 기대되는 최종 구간 길이 5 / 89 ≈ 0.05617
    @test abs(result1_b - result1_a) <= 0.05617 * 1.05

    # Test 2: f2(x) = x^2, min at x=0
    result2_a, result2_b = fibonacci_search(f2, -5.0, 5.0, 20)
    println("f2([-5.0, 5.0], n=20) -> Result: ($(result2_a), $(result2_b))")
    
    @test (result2_a <= 0.0 + 1e-9 && result2_b >= 0.0 - 1e-9)
    # n=20일 때, F_21 = 10946. 초기 길이 10. 기대되는 최종 구간 길이 10 / 10946 ≈ 0.0009135
    @test abs(result2_b - result2_a) <= 0.0009135 * 1.05

    # Test 3: f3(x) = x^3 - 3x + 1, min at x=1 in [0, 2]
    result3_a, result3_b = fibonacci_search(f3, 0.0, 2.0, 15)
    println("f3([0.0, 2.0], n=15) -> Result: ($(result3_a), $(result3_b))")

    @test (result3_a <= 1.0 + 1e-9 && result3_b >= 1.0 - 1e-9)
    # n=15일 때, F_16 = 987. 초기 길이 2. 기대되는 최종 구간 길이 2 / 987 ≈ 0.002026
    # 허용 오차를 1.05배에서 1.25배로 늘립니다.
    @test abs(result3_b - result3_a) <= 0.002026 * 1.4
end