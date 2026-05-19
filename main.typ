
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

---



#set math.equation(numbering: n => [(4.2.3.#n)], supplement: none)

Find the matrix $bold(B)$ for a three-node triangular element with nodal coordinates $(x_1, y_1)$, $(x_2, y_2)$, and $(x_3, y_3)$. Why is the matrix $bold(B)$ constant along the element, and what does that imply?

== Solution

First of all, a 3 node triangular element is defined by the following shape functions

$
  bold(N) = mat(
    1 - xi - eta ;
    xi;
    eta;
  )
$

For 

$
  bold(x) = sum_(i=1)^(3) N_i (xi, eta) dot bold(x)_i
$

$
  bold(u) = sum_(i=1)^(3) N_i (xi, eta) dot bold(u)_i
$

$
  bmat(
    epsilon_(x x);
    epsilon_(y y);
    gamma_(x y);
  )
  =
  bold(B) dot
  bmat(
    u_(1x);
    u_(1y);
    u_(2x);
    u_(2y);
    u_(3 x);
    u_(3 y)
  )
$ 

$
  bold(B) = mat(bold(B)_1, bold(B)_2, bold(B)_3)
$

$
  bold(B)_i
  =
  mat(
    (partial N_i) / (partial x), 0;
    0, (partial N_i) / (partial y);
    (partial N_i) / (partial y), (partial N_i) / (partial x)
  )
$

It is known that

$
  (partial bold(N)_i) / (partial bold(x)) = (partial bold(N)_i) / (partial bold(xi)) bold(J)^(-1)
$

$
  x(xi, eta) = (1 - xi - eta) x_1 + xi x_2 + eta x_3 = x_1 + xi(x_2 - x_1) + eta(x_3 - x_1)
$

$
y(xi, eta) = (1 - xi - eta) y_1 + xi y_2 + eta y_3 = y_1 + xi(y_2 - y_1) + eta(y_3 - y_1)
  
$

Thus the Jacobian is

$
  bold(J)
  =
  mat(
    x_2 - x_1, y_2 - y_1;
    x_3-x_1, y_3-y_1
  )
  =
  mat(
    x_(21), y_(21);
    x_(31), y_(31);
  )
$

$
  J = det(bold(J)) = x_21 y_31 - x_31 y_21 = (x_2 - x_1) (y_3 - y_1) - (x_3 - x_1)(y_3 - y_1) 
$

Which, as seen by the shoelace formula, $J = 2A$.

It is known that
$
  bold(J)^(-1) = ("adj"(bold(J))) / (det(bold(J)))
  =
  1/ (2A)
  mat(
    y_31, -x_31;
    -y_21, x_21;
  )
$

For the first node

$
  mat(
    (partial N_1) / (partial x);
    (partial N_1) / (partial y);
  )
  =
  bold(J)^(-1)
    mat(
    (partial N_1) / (partial xi);
    (partial N_1) / (partial eta);
  )
  =
  1/ (2A)
  mat(
    y_31, -x_31;
    -y_21, x_21;
  )
  mat(-1;-1)
$

$
  mat(
    (partial N_1) / (partial x);
    (partial N_1) / (partial y);
  )
  =
  1 / (2A) mat(
    x_31 - y_31;
    x_21 - y_21;
  )
  =
  1 / (2A)
  mat(
    
  )
$