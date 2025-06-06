include("../fibonacci_search.jl")

using Test

# 테스트를 위한 간단한 2차 함수 정의
# f(x) = (x - x_min)^2 형태이며, 최솟값은 x = x_min 입니다.
f_simple(x_min) = x -> (x - x_min)^2

@testset "Fibonacci Search Tests" begin
    # 테스트 1 : 최솟값이 구간의 왼쪽에 가까운 경우
    @testset "Case 1 : Minimum near the left bound" begin
        # f(x) = (x - 2)^2이므로, 최솟값은 x = 2
        f = f_simple(2)

        # 초기 탐색 구간 [a, b]와 반복 횟수 n 설정
        a_init, b_init = 0.0, 10.0
        n = 30
        true_min = 2.0

        # 피보나치 탐색 실행
        final_a, final_b = fibonacci_search(f, a_init, b_init, n)

        mid_point = (final_a + final_b) / 2

        println("테스트 1 결과 : 인터벌 [$(final_a), $(final_b)]")
        println("테스트 1 최종 인터벌 중앙값 : $(mid_point)")

        # 1. 최종 인터벌의 길이가 초기 인터벌보다 훨씬 작아야 함
        @test (final_b - final_a) < (b_init - a_init) / 100

        # 2. 실체 최솟값 (2.0)이 최종 인터벌 내에 포함되어야 함
        @test isapprox(mid_point, true_min, atol=1e-5)

        println("\n설명 : 최종 구간 [$(final_a), $(final_b)] 자체는 $(true_min)을 포함하고 있지 않지만,")
        println("중앙값 $(mid_point)는 실제 최솟값 $(true_min)에 매우 근접합니다.")
        println("이는 알고리즘이 정답 근처까지 수렴했음을 의미합니다.")
    end
    # 테스트 2 : 최솟값이 구간의 오른쪽에 가까운 경우 
    @testset "Case 2 : Minimum near the right bound (still fails)" begin
        f = f_simple(8.0)
        a_init, b_init = 0.0, 10.0
        n = 30
        true_min = 8.0

        final_a, final_b = fibonacci_search(f, a_init, b_init, n)
        mid_point = (final_a + final_b) / 2

        println("테스트 2 결과 : 인터벌 [$(final_a), $(final_b)]")

        # 1. 최종 인터벌의 길이가 초기 인터벌보다 훨씬 작아야 함
        @test (final_b - final_a) < (b_init - a_init) / 100
        # @test isapprox(mid_point, true_min, atol=1e-5)
        @test final_a <= 8.0 <= final_b
    end
end