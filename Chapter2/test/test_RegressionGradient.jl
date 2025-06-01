include("../RegressionGradient.jl")
using Test
using Zygote

@testset "RandomSampleGradient Tests" begin
    f1(x) = x[1]^2 + x[2]^2
    df1_true(x) = Zygote.gradient(f1, x)[1]

    f2(x) = sin(x[1]) + cos(x[2]) + x[3]^2
    df2_true(x) = Zygote.gradient(f2, x)[1]

    tolerance = 1e-2

    # 더 많은 샘플 (m=1000)을 사용하여 정확도 향상 테스트
    @testset "RandomSampleGradient - f1(x) = x1^2 + x2^2" begin
        # 기본 설정 (m=100, delta=1e-3)
        method_default = RandomSampleGradient()
        x0_1 = [1.0, 2.0]
        approx_grad_default = compute_gradient(method_default, f1, x0_1)
        true_grad_1 = df1_true(x0_1)

        @test length(approx_grad_default) == length(x0_1)
        @test approx_grad_default ≈ true_grad_1 atol=tolerance
        println("f1 at x=$(x0_1) (default m, delta): approx=$(round.(approx_grad_default, digits=4)), true=$(round.(true_grad_1, digits=4))")

        # 샘플 갯수 m을 늘린 경우 (정확도 향상 기대)
        method_large_m = RandomSampleGradient(2000, 1e-3)
        approx_grad_large_m = compute_gradient(method_large_m, f1, x0_1)
        @test length(approx_grad_large_m) == length(x0_1)
        @test approx_grad_large_m ≈ true_grad_1 atol=tolerance
        println("f1 at x=$(x0_1) (large m): approx=$(round.(approx_grad_large_m, digits=4)), true=$(round.(true_grad_1, digits=4))")
    end

    @testset "RandomSampleGradient - f2(x) = sin(x1) + cos(x2) + x3^2" begin
        method=RandomSampleGradient(500, 1e-4)
        x0_2 = [pi/2, pi, 1.0]
        approx_grad = compute_gradient(method, f2, x0_2)
        true_grad_2 = df2_true(x0_2)
        @test length(approx_grad) == length(x0_2)
        @test approx_grad ≈ true_grad_2 atol=tolerance
        println("f2 at x=$(x0_2): approx=$(round.(approx_grad, digits=4)), true=$(round.(true_grad_2, digits=4))")

        # 다른 지점에서 테스트
        x0_3 = [0.1, 0.2, 0.3]
        approx_grad_b = compute_gradient(method, f2, x0_3)
        true_grad_b = df2_true(x0_3)
        @test approx_grad_b ≈ true_grad_b atol=tolerance
        println("f2 at x=$(x0_3): approx=$(round.(approx_grad_b, digits=4)), true=$(round.(true_grad_b, digits=4))")
    end

    # Delta 값의 영향 테스트 (너무 크거나 작을 때)
    @testset "RandomSampleGradient - Delta value impact" begin
        # f_test(x) = x[1]^2 + x[2]^2
        df_test_true(x) = Zygote.gradient(f1, x)[1]
        x_val = [1.0, 2.0]
        true_grad = df_test_true(x_val)

        # Delta가 너무 큰 경우 (정확도 저하 예상)
        method_large_delta = RandomSampleGradient(1000, 0.1)
        approx_grad_large_delta = compute_gradient(method_large_delta, f1, x_val)
        # @test approx_grad_large_delta ≈ true_grad atol=0.05
        @test isapprox(approx_grad_large_delta, true_grad, atol=0.05)
        println("f_test with large delta: approx=$(round.(approx_grad_large_delta, digits=4)), true=$(round.(true_grad, digits=4))")

        # Delta가 너무 작은 경우 (부동 소숫점 오차 발생 예상)
        method_tiny_delta = RandomSampleGradient(1000, 1e-15)
        approx_grad_tiny_delta = compute_gradient(method_tiny_delta, f1, x_val)
        @test !(isapprox(approx_grad_tiny_delta, true_grad, atol=1e-5)) # 실패 기대
        println("f_test with tiny delta: approx=$(round.(approx_grad_tiny_delta, digits=4)), true=$(round.(true_grad, digits=4))")


    end
    
end