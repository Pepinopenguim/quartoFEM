
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
