include("../DescentMethod.jl") 

const phi = (1 + sqrt(5)) / 2 # 황금 비율 정의 (함수 밖에 있어야 함)

function fibonacci_search(f, a, b, n; epsilon=1e-2)
    s = (1 - sqrt(5)) / (1 + sqrt(5))
    rho = 1 / (phi * (1 - s^(n+1)) / (1 - s^(n)))
    r = (1 - rho) * a + rho * b
    yr, n = f(r), n-1
    
    while n > 0
        if n > 1
            l = rho * a + (1 - rho) * b
        else
            l = epsilon * a + (1 - epsilon) * b 
        end

        rho = 1 / (phi * (1 - s^(n+1)) / (1 - s^(n)))
        yl, n = f(l), n-1
        if yl < yr
            r, b, yr = l, r, yl
        else
            a, b = b, l
        end
    end
    return a < b ? (a, b) : (b, a)
end