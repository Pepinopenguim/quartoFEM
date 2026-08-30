#let poster-content(
  dx: 5cm,
  dy: 10cm,
  debug: true, // Change to false to hide the background box
  title: "Título do plano de trabalho",
  authors: "Autores",
  department: "Departamento",
  body
) = {
  
  // Setup Typography
  // Subtitles (Headings) in 72pts
  show heading.where(level: 1): set text(size: 72pt, weight: "bold")
  show heading.where(level: 1): set block(above: 50pt, below: 30pt)
  
  // Default body text size (Typst defaults to 11pt which is too small for a poster. 
  // ~36pt is standard for a 90x120 poster body)
  set text(size: 36pt) 
  
  // Debug box color
  let debug-fill = if debug { rgb(255, 0, 0, 40) } else { none }

  // Setup the Bounding Box
  pad(
    x: dx, 
    y: dy,
    block(
      width: 100%,
      height: 100%,
      fill: debug-fill,
      [
        // Header Section (Spans the whole width, centered)
        #align(center)[
          #text(size: 90pt, weight: "bold", title) \
          #v(30pt)
          #text(size: 48pt, authors) \
          #text(size: 36pt, department)
        ]
        
        #v(80pt)

        // Two Column Layout for the body
        #columns(2, gutter: 4cm)[
          #body
        ]
      ]
    )
  )
}

// Helper function for the 18/20pt auxiliary text recommendation
#let aux-text(body) = text(size: 20pt, body)