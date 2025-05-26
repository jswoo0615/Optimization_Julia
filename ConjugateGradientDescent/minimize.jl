function minimize(f, a, b; tol=1e-5)
    # 황금 비율 (golden ratio)
    ϕ = (1 + sqrt(5)) / 2
    resphi = 2 - ϕ # 1/phi^2

    # 구간의 길이
    h = b - a

    if h < tol
        return (a + b) / 2
    end

    # 두 개의 내부점 계산
    c = a + resphi * h
    d = b - resphi * h

    # 함수 값 계산
    fc = f(c)
    fd = f(d)

    while abs(b - a) > tol
        if fc < fd
            b = d
            d = c
            fd = fc
            h = b - a
            c = a + resphi * h
            fc = f(c)
        else
            a = c
            c = d
            fc = fd
            h = b - a
            d = b - resphi * h
            fd = f(d)
        end
    end
    return (a + b) / 2
end