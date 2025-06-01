include("../finiteDifferenceMethods.jl")
using Test
using Zygote

@testset "NumericalDifferenceMethod Tests" begin
    # 테스트 함수 정의
    f1(x) = x^2
    f2(x) = sin(x)
    f3(x) = exp(x)
    f4(x) = x^3

    df1_true(x) = Zygote.gradient(f1, x)[1]
    df2_true(x) = Zygote.gradient(f2, x)[1]
    df3_true(x) = Zygote.gradient(f3, x)[1]
    df4_true(x) = Zygote.gradient(f4, x)[1]

    tol = 1e-5

    @testset "ForwardDiff Tests" begin
        method = ForwardDiff()

        # f1(x) = x^2 at x = 2.0
        x_val = 2.0
        approx_grad = compute_gradient(method, f1, x_val)
        true_grad = df1_true(x_val)
        @test approx_grad ≈ true_grad atol=tol
        println("ForwardDiff f1(x)=x^2 at x=$x_val: approx=$(round(approx_grad, digits=7)), true=$(round(true_grad, digits=7))")

        # f2(x) = sin(x) at x = pi/4
        x_val = pi/4
        approx_grad = compute_gradient(method, f2, x_val)
        true_grad = df2_true(x_val)
        @test approx_grad ≈ true_grad atol=tol
        println("ForwardDiff f2(x)=sin(x) at x=$x_val: approx=$(round(approx_grad, digits=7)), true=$(round(true_grad, digits=7))")
    end

    @testset "CentralDiff Tests" begin
        method = CentralDiff()

        # f3(x) = exp(x) at x = 0.0
        x_val = 0.0
        approx_grad = compute_gradient(method, f3, x_val)
        true_grad = df3_true(x_val)
        @test approx_grad ≈ true_grad atol=tol
        println("CentralDiff f3(x)=exp(x) at x=$x_val: approx=$(round(approx_grad, digits=7)), true=$(round(true_grad, digits=7))")

        # f4(x) = x^3 at x = 5.0
        x_val = 5.0
        approx_grad = compute_gradient(method, f4, x_val)
        true_grad = df4_true(x_val)
        @test approx_grad ≈ true_grad atol=tol
        println("CentralDiff f4(x)=exp(x) at x=$x_val: approx=$(round(approx_grad, digits=7)), true=$(round(true_grad, digits=7))")
    end

    @testset "Backward Tests" begin
        method = BackwardDiff()

        # f1(x) = x^2 at x = 2.0
        x_val = 2.0
        approx_grad = compute_gradient(method, f1, x_val)
        true_grad = df1_true(x_val)
        @test approx_grad ≈ true_grad atol=tol
        println("BackwardDiff f1(x)=x^2 at x=$x_val: approx=$(round(approx_grad, digits=7)), true=$(round(true_grad, digits=7))")
    end

    @testset "Accuracy with different h values (vs Zygote)" begin
        f_test_h(x) = x^3
        df_test_h_true(x) = Zygote.gradient(f_test_h, x)[1]

        x_val = 1.0
        true_grad = df_test_h_true(x_val)

        # h가 너무 크면 부정확해집니다.
        method_large_h = CentralDiff(1e-2)
        approx_grad_large_h = compute_gradient(method_large_h, f_test_h, x_val)
        # Zygote 참값과 비교하여 1e-9 오차 범위 내에서 실패해야 함 (정밀도 낮음)
        @test !isapprox(approx_grad_large_h, true_grad, atol=1e-9) 
        # 하지만 1e-2와 같은 큰 오차 범위에서는 통과할 수 있습니다.
        @test approx_grad_large_h ≈ true_grad atol=1e-2 
        println("CentralDiff f(x)=x^3 at x=$x_val with h=1e-2: approx=$(round(approx_grad_large_h, digits=7)), true=$(round(true_grad, digits=7))")

        # h가 너무 작으면 부동소수점 오차 때문에 부정확해집니다.
        method_tiny_h = CentralDiff(1e-20) 
        approx_grad_tiny_h = compute_gradient(method_tiny_h, f_test_h, x_val)
        # Zygote 참값과 비교하여 1e-9 오차 범위 내에서 실패할 가능성이 높습니다.
        @test !isapprox(approx_grad_tiny_h, true_grad, atol=1e-9) 
        println("CentralDiff f(x)=x^3 at x=$x_val with h=1e-20: approx=$(round(approx_grad_tiny_h, digits=7)), true=$(round(true_grad, digits=7))")
    end
end