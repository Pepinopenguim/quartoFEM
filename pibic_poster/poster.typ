#import "misc.typ": *

#set page(
  width: 35.4306in,
  height: 47.25in,
  margin: 0pt,
)

#place(
  image("assets/POSTER-CIC-26.pdf"),
)

// Call the function
#poster-content(
  dx: 5.5cm, // Adjust to fit inside the template's borders
  dy: 20.5cm, 
  debug: true, // Turn to false before final print!
  title: [Seu Título Aqui],
  authors: [João da Silva, Maria Orientadora],
  department: [Departamento de Ciência da Computação - UnB]
)[
  = Introdução

  #lorem(50)
  #lorem(50)
  #lorem(50)

  = Metodologia
  #lorem(50)
  #lorem(50)

  = Resultados
  #lorem(50)
  #lorem(50)

  #aux-text([Note: this is a commentary yippee])
  

  = Conclusões
  #lorem(50)

  Conclusões do PIBIC.
  Conclusões do PIBIC.
  #lorem(50)
  = Agradecimentos
  Agradeço ao CNPq / FAPDF.
  #lorem(50)

]