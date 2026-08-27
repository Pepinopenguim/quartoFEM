#let round(v, digits: 3) = calc.round(v, digits: digits)

#let partial_frac(a, b) = $(partial #a) / (partial #b)$

#let vec2mat(vec, transpose: false) = {
  if transpose {
    math.mat(
      ..vec
    )
  } else {
    let rows = vec.map(x => (x,))
    math.mat(
      ..rows
    )
  }
}

#let array2mat(array) = {
  math.mat(
    ..array.map(row => row.map(x => x))
  )
}

#let array3mat(array) = {
  math.mat(
    ..array.map(mat => array2mat(mat))
  )
}

#let cell(title, prompt, content, ..args) = {
  block(
    width: 100%,
    fill: white,
    stroke: 0.7pt + gray.lighten(65%),
    radius: 7pt,
    clip: true,
    above: 8pt,
    below: 8pt,
    [
      // Title
      #block(
        width: 100%,
        fill: red.lighten(88%),
        inset: (x: 12pt, y: 8pt),
        [
          #text(
            title,
            weight: "bold",
            size: 12pt,
            fill: red.darken(50%),
          )
        ],
      )

      // Prompt
      #block(
        width: 100%,
        fill: gray.lighten(96%),
        inset: (x: 12pt, y: 10pt),
        [
          #text(weight: "bold", size: 9pt, fill: gray.darken(20%))[PROMPT]
          #v(3pt)
          #prompt
        ],
      )

      // Solution
      #block(
        width: 100%,
        inset: (x: 12pt, y: 12pt),
        [
          #text(weight: "bold", size: 9pt, fill: red.darken(15%))[SOLUTION]
          #v(5pt)
          #content
        ],
      )
    ],
    ..args,
  )
}

#let leci-vita(a) = {
  if a.len() != 3 {
    return // error!, return null
  }

  // check if any is equal
  if (
    a.at(0) == a.at(1) or
    a.at(0) == a.at(2) or
    a.at(1) == a.at(2)
  ) {
    return 0
  }

  // count inversions
  let inversions = 0
  if a.at(0) > a.at(1) {
    inversions += 1 
  }
  if a.at(0) > a.at(2) {
    inversions += 1 
  }
  if a.at(1) > a.at(2) {
    inversions += 1 
  }

  if (calc.rem(inversions, 2) == 1) {
    return -1
  } else {
    return 1
  }
}
