#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/lovelace:0.3.1": *
#import "misc.typ": *

#set text(lang: "pt")

#let flowchart-diagram = [
  
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

      // Início
      node((0,0), align(center)[*Obter Dados* \ *de Projeto*]),
      
      // Seta 1 -> 2
      edge((0,0), (1,0), "-|>", align(center)[Algoritmo de \ dimensionamento], label-side: center),
      
      // Catálogo
      node((1,0), align(center)[*Apresentação do Catálogo* \ *de Soluções*]),
      
      // Seta 2 -> 3 (Descendo)
      edge((1,0), (1,1), "-|>", align(center)[Escolha da \ Seção], label-side: center),
      
      // Armadura Longitudinal
      node((1,1), align(center)[*Definição da Armadura* \ *Longitudinal*]),
      
      // Seta 3 -> 4 (Esquerda)
      edge((1,1), (0,1), "-|>", align(center)[Escolha dos \ Estribos], label-side: center),
      
      // Relatório
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
  dx: 2.5cm, // Adjust to fit inside the template's borders
  dy: 18.5cm,
  offy: 2.5cm, 
  debug: false, // Turn to false before final print!
  title: [Desenvolvimento de Módulos de Dimensionamento de  \ Elementos  Estruturais em Concreto Armado com uso de Dart],
  authors: [Vítor Luís Azevedo, Marcos Honorato de Oliveira],
  department: [Departamento de Engenharia Civil - UnB]
)[
  = Introdução

  O cenário atual de softwares de concreto armado apresenta suítes extremamente eficientes, porém apresentam alto custo, curva de aprendizado íngrime e, frequentemente, atuam como "caixas-pretas". Neste contexto, a presente pesquisa apresenta o BeamCan, uma aplicativo multi-plataforma voltado para o dimensionamento e detalhamento de seções transversais de vigas de concreto armado.

  

  #grid(
    columns: (60%, 1fr),
    gutter: 2cm,
    [
      #let logo-height = 10%
      #figure(
        grid(
          columns: 3,
          image("assets/logos/BEAMCAN_squircle.svg", height: logo-height),
          box(width: logo-height / 3),
          image("assets/logos/icon-positivo_DB.svg", height: logo-height)
        ),
        caption: [Marca visual do BeamCan]
      )
    ],
    [
      Seu objetivo é desenvolver uma ferramenta ágil, eficiente e intuitiva, com foco na otimização combinatória do empacotamento de armaduras.
    ]
  )

  
  

  = Metodologia
  Adoção do _Framework Flutter_ para desenvolvimento multi-plataforma que garanta os seguintes objetivos:

  - Implementação das diretrizes de cálculo propostas na ABNT NBR 6118:2026;
  - Determinação de um Algoritmo de empacotamento que converta a área de aço necessária em arranjos viáveis;
  - Emissão de memoriais de cálculo transparentes e didáticos

  #figure(
    flowchart-diagram,
    caption: [Fluxo de utilização do beamCan]
  )

  O principal diferencial do BeamCan existe em seu motor iterativo de empacotamento. Diferente das abordagens tradicionais, o algoritmo realiza uma varredura combinatória exaustiva do espaço de soluções. Ele posiciona fisicamente as barras comerciais, valida os espaçamentos normativos, recalcula a altura útil efetiva e disponibiliza um catálogo otimizado de opções viáveis para o usuário.

  // #figure(
  //   image("assets/Estrutura_arquivos.pdf", width: 70%),
  //   caption: [Estrutura de Arquivos do Software]
  // ) <arq>
  // 
  #figure(
    pseudocode-list[
  + *for each* arranjo de barras *do*
    + Distribuir barras em camadas
    + *if* arranjo extrapolar o espaço físico da seção *then*
      + Descartar solução
      + *continue*
    + *end if*
    + Recalcular ($d_"real"$) com base no novo centro de gravidade
    + *if* $ h > 60 "cm"$ *do* armadura de pele *end if*
    + *if* atender aos limites normativos *then*
      + Salvar solução válida no catálogo
    + *end if*
  + *end for*
  + *Return* catálogo de Soluções
],
caption: [Algoritmo de Empacotamento de Barras],
supplement: "Listagem",
kind: table
  )

  

  = Resultados e Conclusões

Para análise de performance, foram analisadas mais de 3000 vigas com condições, métodos e soluções variadas:

#figure(
  box(
    clip: true,
    height: 21.7cm,
    //stroke: 5pt,
    move(
      dy: -8%,

      image("assets/plots/performance_plot.pdf", width: 90%)
    )
  ),
  caption: [Gráfico Número de Soluções Encontradas vs tempo de Resolução],
)

#let qr-size = 8cm


#grid(
  columns: (50%, 40%),
  gutter: 1cm,          // Espaçamento entre o texto e as imagens
  align: horizon,       // Centraliza tudo verticalmente
  
  [
    Dessa forma, o BeamCan consolida-se como uma excelente ferramenta de apoio pedagógico e de verificação em campo, traduzindo formulações complexas em detalhamentos executáveis de forma instantânea. 
  ],
  

  grid(
    columns: 2,
    gutter: 0.5cm,
    align: center,
    
    stack(
      spacing: 15pt,
      image("assets/qrcodes/app-qr.png", width: qr-size), // Mude para .svg se possível
      text(size: 24pt, weight: "bold")[Acesse o App]
    ),
    
    // Agrupando QR Code 2 com sua legenda
    stack(
      spacing: 15pt,
      image("assets/qrcodes/refs-qr.png", width: qr-size), // Mude para .svg se possível
      text(size: 24pt, weight: "bold")[Referências]
    )
  )
)
]