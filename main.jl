using LinearAlgebra

C = [
    0 0;
    4 2;
    4 4;
    0 2;
]

print(C)

function N(node, xi, eta)
    return 1/4 * (node[1] - xi) * (node[2] - eta)
end

function partialN(node, xi, eta)
    return (-node[2] + eta , -node[1] + xi)
end

N((-1,-1), -1, 1)
partialN((-1,-1), .5, .2)

function Jacobian(global_points, xi, eta)
    Jacobian = [0 0;0 0]
    nodes = [(-1,-1), (1,-1), (1,1), (-1,1)]

    

end