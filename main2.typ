
#set math.equation(numbering: n => [(4.6.3.#n)], supplement: none)

Find all nodal displacements in the truss using the penalty method and the Lagrange multiplier method. Consider $E A$ = 600 kN, $P$ = 10 kN, and $alpha$ = 30°. The lengths of elements 1, 2, and 3 are 3 m, 4 m, and 5 m, respectively. Compare the results.



#figure(image("463.png", width: 50%), caption: [])

== Solution

There are 3 Constrains, thus b is a 3x1 vector. For 6 degrees of freedom (displacements), thus A must be a 3x6 matrix:

$
  bold(A U = b)
$

$
  mat(
    1,0,0,0,0,0;
    0,1,0,0,0,0;
    0,0,0,0,-sin(alpha), cos(alpha)
  )
  mat(
    u_(1x);
    u_(1y);
    u_(2x);
    u_(2y);
    u_(3x);
    u_(3y);
  )
  =
  mat(
    0;
    0;
    0;
    0;
    0;
    0;
  )
$

The following code then solves the problem above defined, using the Direct Stiffness Method.

