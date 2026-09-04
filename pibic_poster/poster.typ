#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "misc.typ": *

#set text(lang: "pt")

#let flowchart-diagram = [
  // Reduzi o tamanho da fonte para 14pt (ajuste conforme necessário)
  // e defini a fonte padrão do seu projeto
  
  // Cores do BeamCan para manter a consistência visual
  #let blueCan = rgb("#2596be")
  #let darkBlueCan = rgb("#023047")
  #let toucanWhite = rgb("#fbfdfe")

  #align(center)[
    #set text(size: 30pt)
    #diagram(
      // Estilo global dos nós
      node-stroke: 1.5pt + darkBlueCan, 
      node-fill: gradient.radial(rgb("#C1EEFF"), blueCan, center: (30%, 30%), radius: 110%),
      node-corner-radius: 8pt,
      node-inset: 12pt,
      edge-stroke: 1.5pt + darkBlueCan,
      mark-scale: 1.2,
      spacing: (10em, 5em), 

      // ---------------------------------------------------------
      // NÓS E SETAS
      // ---------------------------------------------------------

      // 1. Início
      node((0,0), align(center)[*Obter Dados* \ *de Projeto*]),
      
      // Seta 1 -> 2
      edge((0,0), (1,0), "-|>", align(center)[Algoritmo de \ dimensionamento], label-side: center),
      
      // 2. Catálogo
      node((1,0), align(center)[*Apresentação do Catálogo* \ *de Soluções*]),
      
      // Seta 2 -> 3 (Descendo)
      edge((1,0), (1,1), "-|>", align(center)[Escolha da \ Seção], label-side: center),
      
      // 3. Armadura Longitudinal
      node((1,1), align(center)[*Definição da Armadura* \ *Longitudinal*]),
      
      // Seta 3 -> 4 (Esquerda)
      edge((1,1), (0,1), "-|>", align(center)[Escolha dos \ Estribos], label-side: center),
      
      // 4. Relatório
      node((0,1), align(center)[*Obtenção de* \ *Relatório*]),
      
      // ---------------------------------------------------------
      // RETORNOS E LOOPS (OTIMIZAÇÃO)
      // ---------------------------------------------------------

      // Retorno do Catálogo para o Início
      edge((1,0), (0,0), "-|>", [Otimização], bend: -35deg),
      
      // Loop do Catálogo nele mesmo
      //edge((1,0), (1,0), "-|>", [Otimização], bend: 130deg)
    )
  ]
]


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
  title: [Desenvolvimento de Módulos de Dimensionamento de Elementos Estruturais em Concreto Armado com uso de Dart],
  authors: [Vítor Luís Azevedo, Marcos Honorato de Oliveira],
  department: [Departamento de Engenharia Civil - UnB]
)[
  = Introdução

  O cenário atual de softwares de concreto armado apresenta suítes extremamente eficientes, porém apresentam alto custo, curva de aprendizado íngrime e, frequentemente, atuam como "caixas-pretas". Neste contexto, a presente pesquisa apresenta o BeamCan, uma aplicativo multi-plataforma voltado para o dimensionamento e detalhamento de seções transversais de vigas de concreto armado.

  Seu objetivo é desenvolver uma ferramenta ágil, eficiente e intuitiva, com foco na otimização combinatória do empacotamento de armaduras.

  #let logo-height = 14cm
  #figure(
    grid(
      columns: 3,
      image("assets/logos/BEAMCAN_squircle.svg", height: logo-height),
      box(width: logo-height / 3),
      image("assets/logos/icon-positivo_DB.svg", height: logo-height)
    ),
    caption: [Marca visual do BeamCan]
  )
  

  = Metodologia
  - Arquitetura Monolítica: Desenvolvido integralmente em Dart/Flutter.

  *O Motor de Empacotamento Iterativo:*
  1. Calcula a área de aço teórica e testa subconjuntos de bitolas comerciais.
  2. Empacota fisicamente as barras, garantindo espaçamento horizontal e cobrimento.
  3. Distribui em camadas verticais e recalcula a altura útil efetiva da seção.
  4. Filtra e ordena as soluções viáveis segundo as preferências do usuário.

  #figure(
    flowchart-diagram
  )


  = Resultados
  #lorem(50)

  #figure(
    image("assets/plots/performance_plot.pdf", width: 100%)
  )

  #lorem(50)

  #aux-text([Note: this is a commentary yippee])
  

  = Conclusões
  #lorem(10)

  Conclusões do PIBIC.

]