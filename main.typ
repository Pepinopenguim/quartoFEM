
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

