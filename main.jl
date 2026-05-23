import Pkg
try
    using BenchmarkTools
catch
    Pkg.add("BenchmarkTools")
    using BenchmarkTools
end

# ================== ITEM A =======================
using LinearAlgebra

# Since all elements have the same materials, firstly we define them

E = 20 * 1e9 # GPa
ν = .25
γ = 25 * 1e3 # kN/m³
h = .2 #m


function Ni(xi_i, eta_i)
    return N(xi, eta) = 0.25 * (1 + xi_i * xi) * (1 + eta_i * eta)
end

function dNi(xi_i, eta_i)
    return dN(xi, eta) = [
        ((xi_i + xi_i * eta_i * eta) / 4) ((eta_i + xi_i * eta_i * xi )/ 4);
    ]
end

N(xi, eta) = [
    Ni(-1, -1)(xi, eta);
    Ni( 1, -1)(xi, eta);
    Ni( 1,  1)(xi, eta);
    Ni(-1,  1)(xi, eta);
]

dNdxi(xi, eta) = [
    dNi(-1, -1)(xi, eta);
    dNi( 1, -1)(xi, eta);
    dNi( 1,  1)(xi, eta);
    dNi(-1,  1)(xi, eta);
]

Jacobian(C, xi, eta) = C' * dNdxi(xi, eta)

# Define stiffness matrix
# We can use the last problem's function to directly obtain the
# local stiffness matrix for each element

function get_k(C, E, ν, h)

    # for plane stress (2D problem, with no stress in the z direction)
    D = [
        1 ν 0;
        ν 1 0;
        0 0 (1 - ν) / 2;
    ] * E / (1 - ν ^ 2)

    


    function B(xi, eta)
        J = Jacobian(C, xi, eta)
        dN_dξη = dNdxi(xi, eta)

        # transform derivatives
        dN_dxdy = dN_dξη * inv(J)

        Bmat = zeros(3, 8)

        for (i, (dx, dy)) in enumerate(eachrow(dN_dxdy))
            Bmat[:, 2i-1:2i] .= [
                dx 0
                0  dy
                dy dx
            ]
        end

        return Bmat
    end 

    quad_2 = [
        (-1 / sqrt(3), 1.0),
        ( 1 / sqrt(3), 1.0)
    ]

    result = zeros(8,8)

    # final integration
    for (xi, wi) in quad_2
        for (eta, wj) in quad_2
            result += h * B(xi, eta)' * D * B(xi, eta) * det(Jacobian(C, xi, eta)) * wi * wj 
        end
    end

    return result
end

C1 = [
    0 0;
    1 0;
    1 1;
    0 1;
]

C2 = [
    0 1;
    1 1;
    1 2;
    0 2;
]
k1 = get_k(C1, E, ν, h) 
k2 = get_k(C2, E, ν, h) 

println("===== Results =====")
println("K1 = ")
println(k2)
println("K2 = ")
println(k2)

# ================== ITEM B =======================

function body_force()
    
end
# ================== ITEM C =======================
