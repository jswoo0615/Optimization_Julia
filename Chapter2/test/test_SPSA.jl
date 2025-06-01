include("../RegressionGradientSimultaneous.jl")
using Test
@testset "SPSA Gradient Computation" begin
    # 테스트 1 : 간단한 이차 함수 (f(x) = x_1^2 + x_2^2)
    # 실제 기울기는 [2x_1, 2x_2]
    # x = [1.0, 2.0] 일 때 실제 기울기는 [2.0, 4.0]
    @testset "Quadratic Function" begin
        f_quadratic(x) = x[1]^2 + x[2]^2
        x0 = [1.0, 2.0]

        # m 값을 1,000,000으로 늘려 정확도를 높이고, delta도 조정
        spsa_method = SPSA(1e-3, 10000000)

        estimated_grad = compute_gradient(spsa_method, f_quadratic, x0)
        expected_grad = [2.0 * x0[1], 2.0 * x0[2]]

        @test estimated_grad isa Vector{Float64}
        @test length(estimated_grad) == length(x0)
        @test isapprox(estimated_grad, expected_grad, atol=1e-2)
        println("Quadratic Function Test:")
        println("  Estimated Gradient: ", estimated_grad)
        println("  Expected Gradient:  ", expected_grad)
        println("  Difference:         ", abs.(estimated_grad - expected_grad))
    end

    # 테스트 2 : 단일 변수 함수 (f(x) = x^2)
    # 실제 기울기는 2x
    @testset "Single Variable Function" begin
        f_single_var(x) = x[1]^2
        x0_single = [3.0]

        spsa_method_single = SPSA(1e-3, 10000000)
        estimated_grad_single = compute_gradient(spsa_method_single, f_single_var, x0_single)
        expected_grad_single = [2.0 * x0_single[1]]

        @test estimated_grad_single isa Vector{Float64}
        @test length(estimated_grad_single) == length(x0_single)
        @test isapprox(estimated_grad_single, expected_grad_single, atol=1e-10)
        println("\nSingle Variable Function Test:")
        println("  Estimated Gradient: ", estimated_grad_single)
        println("  Expected Gradient:  ", expected_grad_single)
        println("  Difference:         ", abs.(estimated_grad_single - expected_grad_single))
    end

    # 테스트 3 : 선형 함수 (f(x) = 2x_1 + 3x_2)
    # 실제 기울기는 [2.0, 3.0]
    @testset "Linear Function" begin
        f_linear(x) = 2x[1] + 3x[2]
        x0_linear = [5.0, 6.0]

        spsa_method_linear = SPSA(1e-3, 10000000)
        estimated_grad_linear = compute_gradient(spsa_method_linear, f_linear, x0_linear)
        expected_grad_linear = [2.0, 3.0]

        @test estimated_grad_linear isa Vector{Float64}
        @test length(estimated_grad_linear) == length(x0_linear)
        @test isapprox(estimated_grad_linear, expected_grad_linear, atol=0.1)
        println("\nLinear Function Test:")
        println("  Estimated Gradient: ", estimated_grad_linear)
        println("  Expected Gradient:  ", expected_grad_linear)
        println("  Difference:         ", abs.(estimated_grad_linear - expected_grad_linear))
    end

    # 테스트 4 : SPSA 구조체의 기본값 확인
    @testset "SPSA Constructor Defaults" begin
        spsa_default = SPSA()
        @test spsa_default.delta == 1e-4
        @test spsa_default.m == 1000

        spsa_custom = SPSA(0.01, 2000)
        @test spsa_custom.delta == 0.01
        @test spsa_custom.m == 2000
    end

end