using LinearAlgebra


function main()
    tn = -1 # kPa

    X = [
        2 2 1;
        0 2 1;
        0 0 2;
        2 0 2;
    ]

    # shape functions as vector
    N(xi, eta) = [
        1/4 * (1 - xi) * (1 - eta);
        1/4 * (1 + xi) * (1 - eta);
        1/4 * (1 + xi) * (1 + eta);
        1/4 * (1 - xi) * (1 + eta);
    ]
    # its derivatives
    dNdxi(xi, eta) = [
        (1/4 * (-1 + eta))   (1/4 * (-1 + xi));
        (1/4 * ( 1 - eta))   (1/4 * (-1 - xi));
        (1/4 * ( 1 + eta))   (1/4 * ( 1 + xi));
        (1/4 * (-1 - eta))   (1/4 * ( 1 - xi));
    ]

    N_matrix(xi, eta) = transpose([
        N(xi, eta)[1] * Matrix(1I, 3,3)
        N(xi, eta)[2] * Matrix(1I, 3,3)
        N(xi, eta)[3] * Matrix(1I, 3,3)
        N(xi, eta)[4] * Matrix(1I, 3,3)
    ])

    Jacobian(xi, eta) = X' * dNdxi(xi, eta)

    function normal(xi, eta)
        J = Jacobian(xi, eta)
        n = cross(J[:, 1], J[:, 2])
        return n / norm(n)
    end

    quad_3 = [
        (-sqrt(3/5), 5/9),
        (0, 8/9),
        (sqrt(3/5), 5/9),
    ]

    # solving the integral
    result = zeros(12)

    for (xi, wi) in quad_3
        for (eta, wj) in quad_3
            J = Jacobian(xi, eta)
            result += N_matrix(xi, eta)' * normal(xi, eta) * sqrt(det(J' * J)) * wi * wj
        end
    end

    return result * tn
end

main() 