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



function get_B(C, xi, eta)
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


# for plane stress (2D problem, with no stress in the z direction)
get_D(E, ν) = [
    1 ν 0;
    ν 1 0;
    0 0 (1 - ν) / 2;
] * E / (1 - ν ^ 2)


quad_2 = [
    (-1 / sqrt(3), 1.0),
    ( 1 / sqrt(3), 1.0)
]

function get_k(C, D, h)

    quad_2 = [
        (-1 / sqrt(3), 1.0),
        ( 1 / sqrt(3), 1.0)
    ]

    result = zeros(8,8)

    # final integration
    for (xi, wi) in quad_2
        for (eta, wj) in quad_2
            B = get_B(C, xi, eta)
            result += h * B' * D * B * det(Jacobian(C, xi, eta)) * wi * wj 
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

k1 = get_k(C1, get_D(E, ν), h) 
k2 = get_k(C2, get_D(E, ν), h) 

# ================== ITEM B =======================

function body_force(C, γ, h)
    N_matrix(xi, eta) = hcat(
        [N(xi, eta)[i]*Matrix(1I, 2, 2) for i in 1:4]...
    )

    # assuming b will always be applied by gravity
    b = γ * [0;-1]

    # functions are bilinear (2x2)



    result = zeros(2*4)
    for (xi, wi) in quad_2
        for (eta, wj) in quad_2
            result += N_matrix(xi, eta)' * b * det(Jacobian(C, xi, eta)) * wi * wj
        end
    end
    return result * h
end

bf1 = body_force(C1, γ, h)
bf2 = body_force(C2, γ, h)

println([bf1 bf2])

# ================== ITEM C =======================

global_index_mapper = [
    Dict(
    "coords"=> C1,
    "nodes"=>(1,2,3,4),
    "k"=>k1,
    "f"=>bf1
    ),
    Dict(
    "coords"=> C2,
    "nodes"=>(4,3,5,6),
    "k"=>k2,
    "f"=>bf2
    )
]



function assemble_Stiffness(gim)
    # get dimensions of global stiffness
    num_nodes = length(Set(n for d in global_index_mapper for n in d["nodes"]))

    K = zeros(2num_nodes, 2num_nodes)
    F = zeros(2num_nodes)

    for element in gim
        k, f = element["k"], element["f"]
        nodes = element["nodes"]

        dofs = Int[]

        for n in nodes
            push!(dofs, 2n - 1) # ux
            push!(dofs, 2n )    # uy
        end

        for i in 1:8
            gI = dofs[i]

            F[gI] += f[i]

            for j in 1:8
                gJ = dofs[j]
                K[gI, gJ] += k[i, j]
            end
        end
        
    end

    return K, F
end

K, F = assemble_Stiffness(global_index_mapper)


# ================== ITEM D =======================

# true if there is an imposition
boundary_vector = [
    true;
    true;
    false;
    true;
    false;
    false;
    false;
    false;
    false;
    false;
    false;
    false;
]

function apply_boundary(boundary_vector, K, F)
    K_sys, F_sys = copy(K), copy(F)
    for i in 1:length(F)
        if boundary_vector[i]
            K_sys[i, :] .= 0
            K_sys[:, i] .= 0
            K_sys[i, i] = 1
            F_sys[i] = 0
        end
    end
    return K_sys, F_sys
end

K_sys, F_sys = apply_boundary(boundary_vector, K, F)
U = K_sys \ F_sys

Reactions = K * U - F
;
# ================== ITEM E & F =======================

function get_strain_and_stress(gim, D, U)
    quad_2 = [
        (-1 / sqrt(3), 1.0),
        ( 1 / sqrt(3), 1.0)
    ]

    # 3. Get displacements, strains, and stresses for nodes of interest
    for (elem_idx, d) in enumerate(gim)
        C = d["coords"]
        nodes = d["nodes"]

        dofs = Int[]

        for n in nodes
            push!(dofs, 2n - 1) # ux
            push!(dofs, 2n )    # uy
        end

        # Corrected: iterate directly over the values inside `dofs`
        Ulocal = [U[i] for i in dofs] 
        d["strains"] = []
        d["stresses"] = []

        # 4. Loop over integration points to compute Strain and Stress
        for (xi, wi) in quad_2
            for (eta, wj) in quad_2
                
                # Evaluate B at this integration point
                B = get_B(C, xi, eta)
                
                # Compute strain and stress
                strain = B * Ulocal
                stress = D * strain

                push!(d["strains"], (xi, eta) => strain)
                push!(d["stresses"], (xi, eta) => stress)
                

            end
        end
    end
end

get_strain_and_stress(global_index_mapper, D(E, ν), U)

println("---- (ξ, η) => ϵ ----")
for i in global_index_mapper[1]["strains"]
    println(i)
end

println("---- (ξ, η) => σ ----")
for i in global_index_mapper[1]["stresses"]
    println(i)
end



# we can use the shape functions to get the
# coordinates for the lower integration point
# (ξ, η) = -1/sqrt(3) * (1, 1)

xi_lower, eta_lower = -1/sqrt(3), -1/sqrt(3)
x, y = C1' * N(xi_lower, eta_lower) 
depth = 2.0 - y 

analytical_stress = γ * depth

numerical_stress_vector = first(val for (coords, val) in global_index_mapper[1]["stresses"] if coords == (xi_lower, eta_lower))

numerical_sigma_yy = numerical_stress_vector[2]

println("Analytical σ_yy: ", analytical_stress)
println("Numerical σ_yy:  ", abs(numerical_sigma_yy)) 