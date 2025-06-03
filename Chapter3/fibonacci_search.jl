include("../DescentMethod.jl") # 이 줄은 필요에 따라 유지하거나 제거합니다.
                                # 만약 phi가 DescentMethod.jl에 정의되어 있지 않다면
                                # 아래의 const phi 정의를 사용해야 합니다.

const phi = (1 + sqrt(5)) / 2 # 황금 비율 정의 (함수 밖에 있어야 함)

"""
fibonacci_search(f, a, b, n_total_evals)

주어진 구간 `[a, b]`에서 단일 모드 함수 `f`의 최솟값을 피보나치 탐색법으로 찾습니다.

# 인자
* `f` : 최솟값을 찾을 단일 모드 함수
* `a` : 탐색 구간의 왼쪽 끝
* `b` : 탐색 구간의 오른쪽 끝
* `n_total_evals` : 함수 `f`를 평가할 총 횟수 (n) -> n은 반드시 2 이상이어야 한다.

# 반환 값
* `(a_final, b_final)` : 최솟값을 포함하는 최종 구간

"""

function fibonacci_search(f, a, b, n_total_evals)
    if n_total_evals < 2
        @warn "Fibonacci Search requires at least 2 function evaluations"
        return a < b ? (a, b) : (b, a)
    end

    # 피보나치 수열 생성 : F_0 = 0, F_1 = 1, F_2 = 1, F_3 = 2, ...
    # fib_array[i]는 F_{i-1}을 저장합니다.
    # N번의 함수 평가를 위해 F_{N+1}까지 필요합니다. (L_final = L_0 / F_{N+1})
    fib_array = zeros(Int, n_total_evals + 2)
    fib_array[1] = 0    # F_0 = 0
    fib_array[2] = 1    # F_1 = 1
    for i = 3:(n_total_evals + 2)
        fib_array[i] = fib_array[i-1] + fib_array[i-2]
    end

    # 현재 탐색 구간의 경계
    xl = a
    xr = b

    println("--- Fibonacci Search Iterations (N=$(n_total_evals)) ---")
    println("Initial Interval: [$(xl), $(xr)]")

    # 첫 두 개의 평가점 계산
    # n_total_evals가 N일 때, F_{N+1}이 가장 큰 피보나치 수 입니다.
    # fib_array[k]는 F_{k-1}입니다.
    # 초기점은 L_0 * (F_{N-1} / F_{N+1})와 L_0 * (F_N / F_{N+1})로 설정
    x1 = xl + (xr - xl) * (fib_array[n_total_evals] / fib_array[n_total_evals + 2])
    # x1 = xl + (xr - xl) * (fib_array[n_total_evals] / fib_array[n_total_evals + 1])이 아닌 이유 : 피보나치 탐색 초기 두 점을 설정할 때는 x1 = xl + (xr - xl) * (fib_array[n_total_evals] / fib_array[n_total_evals + 2])를 사용
    # x1 = xl + (xr - xl) * (fib_array[n_total_evals] / fib_array[n_total_evals + 1])은 반복 스텝 내부에서 (남은 구간에 대해) 점을 갱신하거나 구간을 축소할 때 사용되는 비율
    x2 = xl + (xr - xl) * (fib_array[n_total_evals + 1] / fib_array[n_total_evals + 2])

    y1 = f(x1)
    y2 = f(x2)

    println("Iteration 0 (Initial):")
    println("  x1=$(x1), y1=$(y1)")
    println("  x2=$(x2), y2=$(y2)")
    println("  Current Interval: [$(xl), $(xr)]")
    println("  Current Length: $(xr - xl)")
    println("-"^30)

    # 남은 평가 횟수 = n_total_evals - 2
    # 루프는 n_total_evals - 2번 실행됩니다.
    # k_fib_index는 현재 구간을 정의하는 피보나치 수열의 가장 큰 인덱스입니다.
    # 이 값은 n_total_evals + 1 (F_{N+1})에서 시작하여 3 (=F_2)까지 감소합니다.

    for i = 1:(n_total_evals-2)
        # 다음 단계에서 사용할 피보나치 인덱스 : current_fib_val_idx가 실제 피보나치 수열의 `N`값
        # 처음 `i=1`일 때 `current_fib_val_idx`는 `n_total_evals + 1`이 됩니다. (=F_{N+1})
        # 루프를 돌면서 이 값이 줄어들며, F_2까지 갑니다.
        current_fib_val_idx = n_total_evals + 2 - i

        if y1 < y2
            xr = x2     # 구간의 오른쪽 끝을 x2로 좁힘
            x2 = x1     # x1이 새로운 내부 점 x2가 됨
            y2 = y1     # y1이 새로운 y2가 됨

            # 새로운 x1 계산
            # x1 = xl + (xr - xl) * (F_{current_fib_val_idx - 2} / F_{current_fib_val_idx})
            # fib_array 인덱스로는 fib_array[current_fib_val_idx - 1] / fib_array[current_fib_val_idx + 1]
            x1 = xl + (xr - xl) * (fib_array[current_fib_val_idx - 1] / fib_array[current_fib_val_idx + 1])
            y1 = f(x1)
            println("  y1 < y2, new interval [$(xl), $(xr)]")
        else    # y1 >= y2 최솟값은 [x1, xr] 구간에 있음
            xl = x1     # 구간의 왼쪽 끝을 x1으로 좁힘
            x1 = x2     # x2가 새로운 내부 점 x1이 됨
            y1 = y2     # y2가 새로운 y1이 됨
            
            # 새로운 x2 계산
            # x2 = xl + (xr - xl) * (F_{current_fib_val_idx - 1} / F_{current_fib_val_idx})
            # fib_array 인덱스로는 fib_array[current_fib_val_idx - 1] / fib_array[current_fib_val_idx]
            x2 = xl + (xr - xl) * fib_array[current_fib_val_idx - 1] / fib_array[current_fib_val_idx]
            y2 = f(x2)
            println("  y1 >= y2, new interval [$(xl), $(xr)]")
        end
        println("  x1=$(x1), y1=$(y1)")
        println("  x2=$(x2), y2=$(y2)")
        println("  Current Length: $(xr - xl)")
        println("-"^30)
    end

    # 마지막 비교를 통해 최종 구간을 결정합니다.
    # 이 시점에서 구간 [xl, xr]은 최솟값을 포함합니다.
    # abs(xl - xr)은 L_0 / F_{N+1}에 가까워집니다.

    # 마지막 한 번의 평가가 더 필요한 경우 (N번 평가를 엄격히 지킬 때)
    # N번의 평가를 완벽히 수행하고 최종 구간을 반환합니다.
    if y1 < y2
        xr = x2
    else
        xl = x1
    end

    println("Final Comparison:")
    println("  y1=$(y1), y2=$(y2)")
    println("Final Interval: [$(xl), $(xr)]")
    println("Final Length: $(xr - xl)")
    println("="^40)

    return xl < xr ? (xl, xr) : (xr, xl)
end