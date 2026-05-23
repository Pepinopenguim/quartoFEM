
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

