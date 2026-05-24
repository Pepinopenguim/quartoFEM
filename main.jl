using LinearAlgebra

function solve_truss()
    # Problem Parameters
    EA = 600.0        # kN
    P = 10.0          # kN

    # Nodal Coords (x, y)
    nodes = [
        0.0   0.0;  # Node 1
        2.0   0.0;  # Node 2
        1.0   1.0;  # Node 3
    ]

    # Element Connectivity (Node A, Node B)
    # third element is non-elastic
    elements = [
        (1, 2), # Element 1 
        (1, 3)  # Element 2
    ]

    ndofs = 2 * size(nodes, 1)
    K = zeros(ndofs, ndofs)
    F = zeros(ndofs)

    F[6] = -P 

    for (i, j) in elements
        dx = nodes[j, 1] - nodes[i, 1]
        dy = nodes[j, 2] - nodes[i, 2]
        L = sqrt(dx^2 + dy^2)
        
        c = dx / L
        s = dy / L

        k_local = (EA / L) * [
             c^2   c*s  -c^2  -c*s
             c*s   s^2  -c*s  -s^2
            -c^2  -c*s   c^2   c*s
            -c*s  -s^2   c*s   s^2
        ]

        dofs = [2*i-1, 2*i, 2*j-1, 2*j]
        for r in 1:4
            for c_idx in 1:4
                K[dofs[r], dofs[c_idx]] += k_local[r, c_idx]
            end
        end
    end

    # (A * U = b)
    A = zeros(4, ndofs)
    b = zeros(4)

    A[1, 1] = 1.0 
    
    A[2, 2] = 1.0 
    
    A[3, 4] = 1.0 

    dx3 = nodes[3, 1] - nodes[2, 1]
    dy3 = nodes[3, 2] - nodes[2, 2]
    L3 = sqrt(dx3^2 + dy3^2)
    
    c3 = dx3 / L3
    s3 = dy3 / L3

    A[4, 3] = -c3  
    A[4, 4] = -s3  
    A[4, 5] =  c3  
    A[4, 6] =  s3  

    # ---------------------------------------------------------
    # Lagrange Multiplier Method
    # ---------------------------------------------------------
    println("=== Lagrange Multiplier Method ===")
    
    # Build the augmented block matrix
    K_lag = [K A'; A zeros(4, 4)]
    F_lag = [F; b]

    # Solve the augmented system
    X = K_lag \ F_lag
    
    # Extract displacements and multipliers (reactions / internal forces)
    U_lag = X[1:ndofs]
    Lambda = X[ndofs+1:end]

    println("\nDisplacements (U):")
    display(round.(U_lag, digits=6))
    
    println("\nLagrange Multipliers (Constraint Forces):")
    display(round.(Lambda, digits=6))
end

solve_truss()