include("../bracket_minimum.jl")
using Test

@testset "bracket_minimum Tests" begin
    # test 1
    @testset "Quadratic Function (x-3)^2 + 1" begin
        f_quad(x) = (x - 3.0)^2 + 1.0
        method = Bracket()

        interval1 = bracket_minimum(method, f_quad, 1.0)
        @test interval1[1] <= 3.0 <= interval1[2]
        @test interval1[2] - interval1[1] > 0
        println("Quadratic Test 1 (x=1.0) : $(interval1)")

        interval2 = bracket_minimum(method, f_quad, 5.0)
        @test interval2[1] <= 3.0 <= interval2[2]
        @test interval2[2] - interval2[1] > 0
        println("Quadratic Test 2 (x=5.0) : $(interval2)")

        method_large_s = Bracket(1.0, 3.0)
        interval3 = bracket_minimum(method_large_s, f_quad, 1.0)
        @test interval3[1] <= 3.0 <= interval3[2]
        @test interval3[2] - interval3[1] > 0
        println("Quadratic Test 3 (large s) : $(interval3)")
    end

    @testset "Complex Function sin(x) + (x/5)^2" begin
        f_complex(x) = sin(x) + (x/5.0)^2
        min_val_approx = -1.506
        method = Bracket(0.01, 2.0)
        
        interval = bracket_minimum(method, f_complex, 0.0)
        @test interval[1] <= min_val_approx <= interval[2]
        @test interval[2] - interval[1] > 0 
        println("Complex Function Test (x=0.0) : $(interval)")

        interval2 = bracket_minimum(method, f_complex, -3.0)
        @test interval[1] <= min_val_approx <= interval[2]
        @test interval[2] - interval[1] > 0
        println("Complex Function Test (x=-3.0) : $(interval2)")
    end

    @testset "Monotonically Increasing Function x^2" begin
        f_inc(x) = x^2
        method = Bracket(0.01, 2.0)

        interval = bracket_minimum(method, f_inc, 0.0)
        @test interval[1] <= 0.0 <= interval[2]
        println("Monotonic Inc Test (x=0.0) : $(interval)")

        interval2 = bracket_minimum(method, f_inc, -5.0)
        @test interval2[1] <= 0.0 <= interval2[2]
        println("Monotonic Inc Test (x=-5.0) : $(interval2)")
    end

    @testset "Constant Function" begin
        f_const(x) = 5.0
        method = Bracket()
        println("Constant Function Test : Skipped (Bracket algorithm not designed for constant functions)")
        @test_skip true
    end
end