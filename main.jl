using LinearAlgebra


function main()

    X = [
        4 0;
        4 4;
        3 2;
    ]

    dNdxi(xi) = [
        xi - 1/2;
        xi + 1/2;
        -2 * xi
    ]


    # define quad_2 values
    quad_2 = [
        (-1 / sqrt(3), 1.0),
        ( 1 / sqrt(3), 1.0)
    ]

    # shape functions as vector
    N(xi) = [
        (xi/2*(xi-1)) 0;
        0 (xi/2*(xi-1));
        (xi / 2 * (xi + 1)) 0;
        0 (xi / 2 * (xi + 1));
        (1 - xi^2) 0;
        0 (1 - xi^2);
    ]



    function normal(xi)
        J = X' * dNdxi(xi)
        hatJ = J / norm(J)
        return [
            hatJ[2];
            -hatJ[1];
        ]
    end

    result = zeros(6)

    for (xi, w) in quad_2
        result += N(xi) * normal(xi) * norm(X' * dNdxi(xi)) * w
    end

    return result
end

main() 