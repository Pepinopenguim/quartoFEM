#let round(v, digits: 3) = calc.round(v, digits: digits)

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