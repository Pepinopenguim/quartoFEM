
#import "@preview/numty:0.1.0" as nt

#let array2mat(data, delim:"[", digits:4) = {
  let rounded-data = data.map(
    row => row.map(
      value => calc.round(value, digits: digits)
    )
  )

  math.mat(..rounded-data, delim:delim)
}

#let r4(v) = {
  calc.round(v, digits: 4)
}

#let scalar_matrix_mult(scalar, matrix) = {
  matrix.map(
    row => row.map(
      v => v * scalar
    )
  )
}

#let bmat(..args) = math.mat(..args, delim: "[")

#let inv2(A) = {
  let a = A.at(0).at(0)
  let b = A.at(0).at(1)
  let c = A.at(1).at(0)
  let d = A.at(1).at(1)

  let det = nt.det(A)
  assert(det != 0, message:"Singular matrix")

  nt.mult(
    1 / det,
    (
      ( d, -b ),
      ( -c, a ),
    ),
  )
}

#let inv3(A) = {
  let a = A.at(0).at(0)
  let b = A.at(0).at(1)
  let c = A.at(0).at(2)

  let d = A.at(1).at(0)
  let e = A.at(1).at(1)
  let f = A.at(1).at(2)

  let g = A.at(2).at(0)
  let h = A.at(2).at(1)
  let i = A.at(2).at(2)

  let det ={
    a * (e * i - f * h)
    - b * (d * i - f * g)
    + c * (d * h - e * g)}

  assert(det != 0, message: "Singular matrix")

  (
    (
      (e * i - f * h) / det,
      (c * h - b * i) / det,
      (b * f - c * e) / det,
    ),
    (
      (f * g - d * i) / det,
      (a * i - c * g) / det,
      (c * d - a * f) / det,
    ),
    (
      (d * h - e * g) / det,
      (b * g - a * h) / det,
      (a * e - b * d) / det,
    ),
  )
}

// ====================================================================================================
#set math.equation(numbering: n => [(4.4.8.#n)], supplement: none)

The two-element mesh was designed to simulate self-weight in a structure under plane stress conditions. Each element has dimensions $1 times 1 "m"$. Considering full integration, compute:

*a.* The stiffness matrix for each element.

*b.* The equivalent nodal loads corresponding to the body force.

*c.* The global stiffness matrix and the global force vector.

*d.* The nodal displacements and reactions.

*e.* The strain and stress vectors at the integration points of element 1.

*f.* Check if the vertical stress at a lower integration point of element 1 is close to the analytical value $gamma h$.

#figure(image("448.png", width: 70%), caption: [Two-element mesh simulating self-weight with $E = 20 "GPa"$, $nu = 0.25$, $gamma = 25 "kN/m"^3$, and $"thickness" = 0.2 "m"$])

== Solution

This solution aims to be a review of all ideas presented in the chapters preceding it. Thus, for each cell of julia code, a small definition of all elements will be defined.

------------

=== (a)

First step if to define the elements's stiffness matrix. Well, from the definition of virtual work, which, in simpler terms, relates the effects of deformations and virtual displacements:

$
  integral_(bold(Omega)^((e))) delta bold(epsilon) dot bold(sigma) "dV" = integral_(bold(Omega)^((e))) delta bold(u) dot bold(b) "dV" + integral_(bold(Gamma)_t^((e))) delta bold(u) dot bold(t) "dS"
$ <bigboy>

Both strains and virtual displacements can be defined relating to the nodal displacements $delta bold(U)$

$
  delta bold(u) = bold(N) delta bold(U)^((e))
$

$
  delta bold(xi) = bold(B) delta bold(U)^((e))
$

Which can simplify #ref(<bigboy>) into:

$
  integral_(bold(Omega)^((e))) bold(B)^T  bold(sigma) "dV"
  =
  integral_(bold(Omega)^((e))) bold(N)^T  bold(b) "dV"
  +
  integral_(bold(Gamma)_t^((e))) bold(N)^T bold(t) "dS"
$ <smallboy>

As I see it, #ref(<smallboy>) relates the internal tensions in the body with forces applied to it, let it be internal (like body mass or eletromagnetic forces) or external (standard forces, water pressure, etc.). So, our stiffness matrix is defined in the left side of the equation #ref(<smallboy>).

For *small-strain linear elasticity* we have:

$
  bold(sigma = D B U^((e)))
$

Hence,

$
  integral_(bold(Omega)^((e))) bold(B)^T  bold(sigma) "dV"
  =
  (
  integral_(bold(Omega)^((e))) bold(B)^T  bold(D B) "dV"
  ) bold(U^((e)))
  =
  bold(K^((e)) U^((e)))
$

The following script will then, as defined by the last problem, calculate $bold(K)$ with the integral defined above:

---------------

#let littlek = (
( 1.95556e9,  6.66667e8, -1.15556e9, -1.33333e8, -9.77778e8, -6.66667e8,  1.77778e8,  1.33333e8 ),
( 6.66667e8,  1.95556e9,  1.33333e8,  1.77778e8, -6.66667e8, -9.77778e8, -1.33333e8, -1.15556e9 ),
(-1.15556e9,  1.33333e8,  1.95556e9, -6.66667e8,  1.77778e8, -1.33333e8, -9.77778e8,  6.66667e8 ),
(-1.33333e8,  1.77778e8, -6.66667e8,  1.95556e9,  1.33333e8, -1.15556e9,  6.66667e8, -9.77778e8 ),
(-9.77778e8, -6.66667e8,  1.77778e8,  1.33333e8,  1.95556e9,  6.66667e8, -1.15556e9, -1.33333e8 ),
(-6.66667e8, -9.77778e8, -1.33333e8, -1.15556e9,  6.66667e8,  1.95556e9,  1.33333e8,  1.77778e8 ),
( 1.77778e8, -1.33333e8, -9.77778e8,  6.66667e8, -1.15556e9,  1.33333e8,  1.95556e9, -6.66667e8 ),
( 1.33333e8, -1.15556e9,  6.66667e8, -9.77778e8, -1.33333e8,  1.77778e8, -6.66667e8,  1.95556e9 )
)

Thus, 

#{
  set text(9pt)
$
  k_1 ^((e)) = k_2 ^((e)) =
  #array2mat(scalar_matrix_mult(1e-9, littlek))
  10^(-9)
$
}

------------
=== (b)

Next, we determine the equivalent nodal loads corresponding to the body force (self-weight). From the right side of the virtual work equation #ref(<smallboy>), the external virtual work due to body forces is:

$
  delta W_("ext", b) = integral_(bold(Omega)^((e))) delta bold(u) dot bold(b) "dV"
$

Substituting the virtual displacement interpolation $delta bold(u) = bold(N) delta bold(U)^((e))$, we get:

$
  delta W_("ext", b) = (delta bold(U)^((e)))^T integral_(bold(Omega)^((e))) bold(N)^T bold(b) "dV"
$

Equating this to the work done by the discrete equivalent nodal forces, $(delta bold(U)^((e)))^T bold(F)_b^((e))$, we obtain the fundamental expression for the element body force vector:

$
  bold(F)_b^((e)) = integral_(bold(Omega)^((e))) bold(N)^T bold(b) "dV"
$

For a 2D plane stress element with thickness $h$, mapping the volume differential to the natural coordinates $(xi, eta)$ yields:

$
  bold(F)_b^((e)) = h integral_(-1)^(1) integral_(-1)^(1) bold(N)^T bold(b) J "d"xi "d"eta
$

Since the structure is subjected to self-weight, the body force vector acts purely in the vertical direction, meaning $bold(b) = mat(0; -gamma)$. The following script will evaluate this integral numerically to compute the equivalent load vector for each element.

-----------------
=== (c)

After obtaining the individual element stiffness matrices and equivalent load vectors, the next step is to combine them into a single global algebraic system that represents the entire structure. This global system of equations is given by:

$
  bold(K) bold(U) = bold(F)
$

The assembly process builds this system by enforcing compatibility between adjacent elements through their shared nodal degrees of freedom. Each element's stiffness matrix $bold(K)^((e))$ and load vector $bold(F)^((e))$ are accumulated into the global stiffness matrix $bold(K)$ and the global force vector $bold(F)$. 

The exact placement of these element contributions into the global system is determined by the element's location vector $ell^((e))$, which maps the element's local degrees of freedom to the correct rows and columns in the global arrays. 

The element will be defined according to the following matrix, that relates the node coordinates with their $"DOF"$:

$
  mat(
    0, 0;
    1, 0;
    1, 1;
    0, 1;
    1, 2;
    0, 2;
  )
  =
  mat(
    1, 2;
    3, 4;
    5, 6;
    7, 8;
    9, 10;
    11, 12;
  )
  =
  mat(
    i, i+1
    ;
    dots.v, dots.v
  )
$

// AI wrote this bit but the code is mine gimme a break like
#let K = (
( 1.95556e9,  6.66667e8, -1.15556e9, -1.33333e8, -9.77778e8, -6.66667e8,  1.77778e8,  1.33333e8,  0.0,        0.0,        0.0,        0.0       ),
( 6.66667e8,  1.95556e9,  1.33333e8,  1.77778e8, -6.66667e8, -9.77778e8, -1.33333e8, -1.15556e9,  0.0,        0.0,        0.0,        0.0       ),
(-1.15556e9,  1.33333e8,  1.95556e9, -6.66667e8,  1.77778e8, -1.33333e8, -9.77778e8,  6.66667e8,  0.0,        0.0,        0.0,        0.0       ),
(-1.33333e8,  1.77778e8, -6.66667e8,  1.95556e9,  1.33333e8, -1.15556e9,  6.66667e8, -9.77778e8,  0.0,        0.0,        0.0,        0.0       ),
(-9.77778e8, -6.66667e8,  1.77778e8,  1.33333e8,  3.91111e9, -2.38419e-7, -2.31111e9,  2.98023e-8,  1.77778e8, -1.33333e8, -9.77778e8,  6.66667e8),
(-6.66667e8, -9.77778e8, -1.33333e8, -1.15556e9, -2.38419e-7,  3.91111e9,  0.0,         3.55556e8,  1.33333e8, -1.15556e9,  6.66667e8, -9.77778e8),
( 1.77778e8, -1.33333e8, -9.77778e8,  6.66667e8, -2.31111e9, -5.96046e-8,  3.91111e9,  2.38419e-7, -9.77778e8, -6.66667e8,  1.77778e8,  1.33333e8),
( 1.33333e8, -1.15556e9,  6.66667e8, -9.77778e8, -2.98023e-8,  3.55556e8,  2.38419e-7,  3.91111e9, -6.66667e8, -9.77778e8, -1.33333e8, -1.15556e9),
( 0.0,        0.0,        0.0,        0.0,         1.77778e8,  1.33333e8, -9.77778e8, -6.66667e8,  1.95556e9,  6.66667e8, -1.15556e9, -1.33333e8),
( 0.0,        0.0,        0.0,        0.0,        -1.33333e8, -1.15556e9, -6.66667e8, -9.77778e8,  6.66667e8,  1.95556e9,  1.33333e8,  1.77778e8),
( 0.0,        0.0,        0.0,        0.0,        -9.77778e8,  6.66667e8,  1.77778e8, -1.33333e8, -1.15556e9,  1.33333e8,  1.95556e9, -6.66667e8),
( 0.0,        0.0,        0.0,        0.0,         6.66667e8, -9.77778e8,  1.33333e8, -1.15556e9, -1.33333e8,  1.77778e8, -6.66667e8,  1.95556e9)
)

-----------

// AI wrote this bit but the code is mine gimme a break like
#let K = (
( 1.95556e9,  6.66667e8, -1.15556e9, -1.33333e8, -9.77778e8, -6.66667e8,  1.77778e8,  1.33333e8,  0.0,        0.0,        0.0,        0.0       ),
( 6.66667e8,  1.95556e9,  1.33333e8,  1.77778e8, -6.66667e8, -9.77778e8, -1.33333e8, -1.15556e9,  0.0,        0.0,        0.0,        0.0       ),
(-1.15556e9,  1.33333e8,  1.95556e9, -6.66667e8,  1.77778e8, -1.33333e8, -9.77778e8,  6.66667e8,  0.0,        0.0,        0.0,        0.0       ),
(-1.33333e8,  1.77778e8, -6.66667e8,  1.95556e9,  1.33333e8, -1.15556e9,  6.66667e8, -9.77778e8,  0.0,        0.0,        0.0,        0.0       ),
(-9.77778e8, -6.66667e8,  1.77778e8,  1.33333e8,  3.91111e9, -2.38419e-7, -2.31111e9,  2.98023e-8,  1.77778e8, -1.33333e8, -9.77778e8,  6.66667e8),
(-6.66667e8, -9.77778e8, -1.33333e8, -1.15556e9, -2.38419e-7,  3.91111e9,  0.0,         3.55556e8,  1.33333e8, -1.15556e9,  6.66667e8, -9.77778e8),
( 1.77778e8, -1.33333e8, -9.77778e8,  6.66667e8, -2.31111e9, -5.96046e-8,  3.91111e9,  2.38419e-7, -9.77778e8, -6.66667e8,  1.77778e8,  1.33333e8),
( 1.33333e8, -1.15556e9,  6.66667e8, -9.77778e8, -2.98023e-8,  3.55556e8,  2.38419e-7,  3.91111e9, -6.66667e8, -9.77778e8, -1.33333e8, -1.15556e9),
( 0.0,        0.0,        0.0,        0.0,         1.77778e8,  1.33333e8, -9.77778e8, -6.66667e8,  1.95556e9,  6.66667e8, -1.15556e9, -1.33333e8),
( 0.0,        0.0,        0.0,        0.0,        -1.33333e8, -1.15556e9, -6.66667e8, -9.77778e8,  6.66667e8,  1.95556e9,  1.33333e8,  1.77778e8),
( 0.0,        0.0,        0.0,        0.0,        -9.77778e8,  6.66667e8,  1.77778e8, -1.33333e8, -1.15556e9,  1.33333e8,  1.95556e9, -6.66667e8),
( 0.0,        0.0,        0.0,        0.0,         6.66667e8, -9.77778e8,  1.33333e8, -1.15556e9, -1.33333e8,  1.77778e8, -6.66667e8,  1.95556e9)
)

Thus:

#let F = (
    (0.0,),
  (-6250.0,),
   (   0.0,),
(  -6250.0,),
(      0.0,),
( -12499.999999999998,),
(      0.0,),
( -12499.999999999998,),
(      0.0,),
 ( -6249.999999999998,),
 (     0.0,),
 ( -6249.999999999998,),
)


#{
  set text(8pt)
  $
    K=
    #array2mat(scalar_matrix_mult(1e-9, K), digits:2)
    10^(-9)
  $

  $
    F=
    #array2mat(scalar_matrix_mult(1e-3, F), digits:2)
    10^(-3) N
  $
}


=== (d)

With the global system assembled, we apply the essential boundary conditions to find the unknown nodal displacements and support reactions. This is achieved by partitioning the global system $bold(K) bold(U) = bold(F)$ into free (subscript 1) and constrained (subscript 2) degrees of freedom:

$
  mat(
    bold(K)_11, bold(K)_12;
    bold(K)_21, bold(K)_22
  )
  mat(
    bold(U)_1;
    bold(U)_2
  )
  =
  mat(
    bold(F)_1;
    bold(F)_2
  )
$

The unknown displacements $bold(U)_1$ are found by solving the first set of equations:

$
  bold(U)_1 = bold(K)_11^(-1) (bold(F)_1 - bold(K)_12 bold(U)_2)
$

Once the displacement field is fully known, the unknown reaction forces $bold(F)_2$ at the supports are recovered using the second set of equations:

$
  bold(F)_2 = bold(K)_21 bold(U)_1 + bold(K)_22 bold(U)_2
$

Although possible, the realocation of matrices can become very heavy on the computer memory. Another method, much simples programatically, is to enforce the known displacements into the matrix for all given supports, like done in the snipped below


--------

#let Ufound = (
 (    0.0,),
 ( 0.0,),
 ( 5.223880597014928e-7,),
 ( 0.0,),
 ( 4.1744402985074784e-7,),
 (-1.8621735074626889e-6,),
 ( 1.049440298507476e-7,),
 (-1.8621735074626863e-6,),
 ( 3.1250000000000484e-7,),
 (-2.500000000000003e-6,),
 ( 2.0988805970149732e-7,),
 (-2.4999999999999994e-6,),
)

#let reactions =(
    (0.0,),
 (1250.0,),
 (   0.0,),
 (1250.0,),
 (   0.0,),
 (   0.0,),
 (   0.0,),
 (   0.0,),
 (   0.0,),
 (   0.0,),
 (   0.0,),
 (   0.0,),
)
Thus,
$
  U
  =
  #array2mat(
    scalar_matrix_mult(1e6, Ufound)
  )
  10^(-6) m

    "     R"
  =
  #array2mat(
    reactions
  )
  "kN"
$

=== (e)

Once the global displacement vector $bold(U)$ is found, the displacement vector for a specific element is recovered using its location vector $bold(ell)^((e))$:

$
  bold(U)^((e)) = bold(U)(bold(ell)^((e)))
$

To find the strains and stresses within the element, we evaluate them at the numerical integration points. The strain vector $bold(epsilon)_i$ at an integration point $i$ is obtained by multiplying the strain-displacement matrix $bold(B)_i$ by the element displacement vector. Subsequently, the stress vector $bold(sigma)_i$ is computed using the material's constitutive matrix $bold(D)$:

$
  bold(epsilon)_i = bold(B)_i bold(U)^((e))
$

$
  bold(sigma)_i = bold(D) bold(epsilon)_i
$

The following script will extract the nodal displacements for element 1, evaluate the $bold(B)$ matrix at its respective integration points, and compute the resulting strain and stress vectors.