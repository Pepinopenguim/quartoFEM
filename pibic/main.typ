#import "@preview/cetz:0.5.2": canvas, draw
#import "@preview/wordometer:0.1.5": word-count, total-words
#import "@preview/lovelace:0.3.1": *


// ==========================================
// PERSONALIZAÇÕES E DEFINIÇÕES
// ==========================================

#show figure.where(kind: table): set figure.caption(position: top)

#let norma = [ABNT NBR 6118:2026]

#set bibliography(style: "associacao-brasileira-de-normas-tecnicas")

#let fmt(n) = {calc.round(n, digits:3)}

#let screenshot_height = 10cm

#let dumb(eq) = {
  set math.equation(numbering: none)
  eq
}

#let pretty-table(..args, color-rows: true) = table(
  stroke: (x, y) => {
    if y == 0 {
      gray
    } else {
      luma(210)
    }
  },

  inset: (x, y) => {
    if x == 0 {
      (left: 8pt, right: 8pt, top: 7pt, bottom: 7pt)
    } else {
      (left: 10pt, right: 10pt, top: 7pt, bottom: 7pt)
    }
  },
  
  fill: (x, y) => {
    if y == 0 {
      rgb("#404040")
    } else if color-rows and calc.even(y) {
      rgb("#F5F5F5")
    } else {
      white
    }
  },

  ..args,
)

// Definição da função para simular os "Drawers" do aplicativo
#let drawer(title, body) = block(
  breakable:false,
  width: 100%,
  stroke: 1pt + rgb("#371E30"),
  radius: 6pt,
  clip: true,
)[
  #block(
    width: 100%,
    fill: rgb("#C1EEFF"), 
    inset: (x: 12pt, y: 10pt),
    stroke: (bottom: 1pt + rgb("#371E30")),
  )[
    // Título do Drawer
    #text(weight: "bold", fill: rgb("#333333"))[#title]
  ]
  #block(
    width: 100%,
    inset: 12pt,
    fill: white,
  )[
    // Remove indentação apenas dentro do drawer e ajusta espaçamento
    #set par(first-line-indent: 0pt, leading: 0.45em)
    #set text(size: 10pt)
    #v(-1.5em)
    #body
  ]
]

// ==========================================
// DEFINIÇÃO REL
// ==========================================

#let header = [
  #box(height: 8pt)

  #let logos = (
    ("assets/logos/official/cnpq.png", 55%,),
    ("assets/logos/official/fapdf.png", 65%,),
    ("assets/logos/official/iniciacao_cientifica.png", 65%,),
    ("assets/logos/official/proiclogo.png", 65%,),
    ("assets/logos/official/unb_logo.png", 65%,),
    ("assets/logos/official/logoGetec.png", 67%),
  )
  
  #block(
  fill: rgb("#d8d2c6"),
  width: 100%,
  height: 100%,
  outset: (x: 2.5cm, y: 6pt),
  grid(
    columns: 2 * logos.len() - 1,
    align: center,
    ..logos.map(arr => [
      #image(arr.at(0), height: arr.at(1))
      #box(width: 2cm)
    ])
    )
  )
]


#let pibit_report(
  title: "",
  author: "",
  advisor: "",
  abstract: "",
  keywords: (),
  body
) = {
  // Configuração geral do documento
  set document(title: title, author: author)
  set page(
    paper: "a4", 
    margin: (left: 2.3cm, top: 3cm, right: 2cm, bottom: 2cm),
  )
  set text(font: "Liberation Serif", size: 12pt, lang: "pt")
  
  set heading(numbering: "1.1.")

  // --- CAPA ---
  align(center)[
    // Tempbox para o Logo da UnB
    #v(1cm)
    #text(size: 14pt)[Vítor Luís Costa Azevedo] \
    #v(.3cm)
    #text(size: 16pt, weight: "bold")[#title] \
    #v(.3cm)
    #text(size: 14pt)[#advisor] \
    #v(.3cm)
    #text(size: 14pt)[Programa de Iniciação Científica] \
    #v(.3cm)
    
    #text(size: 12pt)[#datetime.today().year()]
  ]

  pagebreak()

  // --- RESUMO E PALAVRAS-CHAVE ---
  align(center)[#text(size: 14pt, weight: "bold")[RESUMO]]
  
  
  v(1em)
  
  abstract
  
  v(1em)

  [*Palavras-chave:* #keywords.join("; ")]

  // Função que cria um parágrafo invisível para forçar a indentação no texto seguinte
  let force-indent(it) = {
    it
    par(text(size: 0pt, ""))
    v(-1.2em)
  }

  pagebreak()

  outline()


  pagebreak()

  // --- CORPO DO TEXTO ---
  // Reinicia o espaçamento para o texto principal
  set par(justify: true, leading: .9em,  first-line-indent: (amount: 1cm, all: true))


  // number equations
  set math.equation(numbering: "Eq. (1.1)")

  set page(numbering: "1")
  
  body
}

// ==========================================
// PREENCHIMENTO DOS DADOS DO PROJETO
// ==========================================

#show: pibit_report.with(
  title: "Desenvolvimento de Módulos de Dimensionamento de Elementos Estruturais em Concreto Armado com uso de Dart",
  author: "Vítor Luís Costa Azevedo",
  advisor: "Marcos Honorato de Oliveira",
  abstract: [
  #set par(justify: true)
  Este trabalho apresenta o desenvolvimento do BeamCan, um aplicativo multi-plataforma voltado para o dimensionamento e detalhamento de seções transversais de vigas de concreto armado, utilizando a linguagem _Dart_ e o ecossistema Flutter. Seu objetivo principal é atuar na transição entre o modelo matemático teórico e a execução física, oferecendo uma plataforma eficiente de cálculo, com enfoque especial na didática e referência à norma. A validação do sistema foi conduzida por meio da comparação com soluções analíticas de problemas clássicos de engenharia. Para analisar a eficiência e  velocidade do algoritmo, foi analisado o tempo de execução de milhares de problemas.
],
  keywords: ("Concreto Armado", "Dart", "Dimensionamento Estrutural", "Engenharia Civil")
)

// ==========================================
// ESTRUTURA DO ARTIGO
// ==========================================




= INTRODUÇÃO

O concreto armado é um dos sistemas construtivos mais utilizados na engenharia civil brasileira, exigindo rigorosos critérios de segurança, durabilidade e economia em seu dimensionamento. Para garantir o cumprimento das diretrizes estabelecidas pela Associação Brasileira de Normas Técnicas, especificamente a #norma, o uso de ferramentas computacionais tornou-se indispensável, conferindo precisão e agilidade ao processamento matemático do cálculo estrutural.

Observa-se, porém, uma lacuna no que tange a ferramentas ágeis, móveis e transparentes. Soluções que detalhem o passo a passo algébrico e permitam a verificação rápida de seções isoladas são demandadas tanto no ambiente acadêmico, para fins didáticos, quanto nos canteiros de obra, para conferências pontuais e tomadas de decisão.

Neste contexto, o presente documento detalha o desenvolvimento do *BeamCan*, um aplicativo voltado para o dimensionamento e detalhamento de seções transversais de vigas de concreto armado. Projetado para atuar na transição entre o modelo teórico e a execução física, o software tem como diferencial a automação iterativa do empacotamento de armaduras com bitolas comerciais e a geração de memoriais de cálculo auditáveis.

O presente texto apresenta as bases normativas empregadas, a definição da arquitetura do software, a modelagem dos algoritmos heurísticos de otimização e, por fim, a validação numérica dos resultados por meio da análise de problemas estruturais clássicos.

#figure(
  grid(
    columns: 2,
    image("assets/logos/BEAMCAN_squircle.svg", width: 70%),
    image("assets/logos/icon-positivo_DB.svg", width: 70%)
  ),
  caption: [Marca visual do BeamCan]
) <figLogosBeamcan>

#pagebreak()

== Contextualização

=== Estado da Arte <secEstadoArte>

A adoção de softwares para aumento de produtividade em cálculos de engenharia, especialmente considerando obrigações normativas, é um processo altamente difundido e desenvolvido na atualidade.

// TQS e eberick
Softwares comerciais desktop, em destaque o _TQS_ #cite(<tqs_informatica>) e o _AltoQi Eberick_ #cite(<altoqi_eberick>) apresentam suítes completas de cálculo para estruturas de concreto armado, possuem _plugins_ que os mantêm atualizados em relação à norma atual, compatibilização BIM (_Building Information Modeling_) e uma grande variedade de opções e otimização das seções escolhidas. Porém, exigem licenças de alto custo para uso profissional, possuem curva de aprendizado íngrime e, frequentemente, carecem de memoriais de cálculo explicitamente didáticos e transparentes, possuindo uma característica mais objetiva.

//cypecad
Outras alternativas, como o _CYPECAD_ #cite(<cypecad>), embora menos incidentes no mercado brasileiro se comparados às soluções nacionais, apresentam limitações similares: a dependência de um ambiente _desktop_ e a alta complexidade na entrada de dados para consultas pontuais.

// vigaframe
No que se refere a soluções _mobile_, especificamente no contexto estrutural, destaca-se o aplicativo _VigaFrame_ #cite(<lucena_vigaframe>). Desenvolvido em _Dart_, apresenta-se como um analisador estrutural 2D para vigas, pórticos e treliças, possuindo um solucionador por meio do Método da Rigidez Direta. Embora realize verificações normativas brasileiras e o cálculo da área teórica de aço ($A_s$), diferentemente da proposta do BeamCan, o aplicativo não oferece a automação do empacotamento real de barras comerciais, tampouco a emissão de memoriais de cálculo analíticos detalhados.


=== Objetivo Geral
Desenvolver uma ferramenta computacional móvel ágil, eficiente e intuitiva, denominada BeamCan, dedicada ao dimensionamento e detalhamento de seções transversais de vigas de concreto armado, com foco na otimização combinatória do empacotamento de armaduras.

Para alcançar o objetivo proposto, estabelecem-se as seguintes metas específicas:
- Implementar as diretrizes de cálculo analítico e verificações de limites normativos estipulados pela #norma$""$;
- Desenvolver um algoritmo de empacotamento automático que converta a área de aço teórica ($A_s$) em arranjos físicos viáveis com bitolas comerciais, calculando a altura útil efetiva iterativamente;
- Estruturar a emissão de memoriais de cálculo transparentes e didáticos, evidenciando o passo a passo das equações formuladas;
- Disponibilizar um ambiente propício para uso pedagógico e para a conferência ágil de detalhamentos gerados por softwares de grande porte em canteiros de obra.

= REFERENCIAL TEÓRICO


O software foi baseado nos processos de dimensionamento de vigas sob momentos fletores não oblíquos apresentados na #norma, e revisados no livro "Cálculo e Detalhamento de Estruturas Usuais de Concreto Armado" #cite(<carvalho2024>). 

== Parâmetros do bloco de tensões

Segundo o processo de cálculo, inicialmente, definem-se os parâmetros do bloco de tensões da flexão, propriedades adimensionais dependentes da resistência do concreto:

$
  alpha_c = cases(
  0.85 "se" f_(c k) <= 50 "MPa",
  0.85 dot [1.0 - (f_(c k) - 50)/200] "se" f_(c k) > 50 "MPa"
  )
$ <eqAlphac>

$
  lambda_c = cases(
  0.8 "se" f_(c k) <= 50 "MPa",
  0.8 - (f_(c k) - 50)/(400) "se" f_(c k) > 50 "MPa"
)
$ <eqLambdac>

$
  eta_c = cases(
  1.0 "se" f_(c k) <= 40 "MPa",
  ((40)/(f_(c k)))^("1/3") "se" f_(c k) > 40 "MPa"
  )
$ <eqEtac>

Para as equações #ref(<eqAlphac>, supplement: none), #ref(<eqLambdac>, supplement: none) e #ref(<eqEtac>, supplement: none), $f_(c k)$ é a resistência característica do concreto, em $"MPa"$. 

== Flexão Simples (Seção Retangular)

A @figDiagComp descreve o comportamento clássico de uma viga sob esforço fletor.

#figure(
  align(center)[
    #canvas({
      import draw: *

      // --- Vista Frontal (Cross Section) ---

      // y
      line((-.3, 3), (-.3,4), mark: (end: "|", start: "|"))
      content((-.8 ,3.5), $lambda_c x$)

      // d dim 
      line((1.8, 0 + 0.4), (1.8,4), mark: (end: "|", start: "|"))
      content((2.1 ,4.4/2), $d$)
      
      // Main beam outline
      rect((0, 0), (1.5, 4), name: "beam")
      
      // Compression zone
      rect((0, 3), (1.5, 4), fill: gray.lighten(70%))
      
      // Rebars
      circle((0.4, 0.4), radius: 0.1, fill: black)
      circle((1.1, 0.4), radius: 0.1, fill: black)
      
      // Labels
      content((0.75, 5), [Vista frontal])
      content((-0.5, 0.4), $A_s$)
      line((-0.2, 0.4), (0.2, 0.4)) // Callout line for As
      line((0,-0.3), (1.5,-0.3), mark: (end: "|", start: "|"))
      content((0.75, -0.7), $b_w$)


      // --- Deformações (Strain Diagram) ---

      // Vertical reference line
      line((4, 0), (4, 4), stroke: (dash: "dashed", paint: gray)) 
      
      // Strain distribution line (Linear)
      line((4 - 1.5, 0.4), (4 + 1.5, 4), name: "strain_line")
      
      // Strain arrows
      line((4 - 1.5, 0.4), (4, 0.4), mark: (end: ">", fill: black)) 
      line((4 + 1.5, 4), (4, 4), mark: (end: ">", fill: black)) 
      
      // Labels
      content((4, 5), [Deformações])
      content((4.8, 4.2), $epsilon_c$)
      content((3.2, 0.2), $epsilon_s$)
      


      // x dim
      line((4 - .3, 2.2), (4 - .3, 4), mark: (end: "|", start: "|"))
      content((4 - .6,4 - (4-2.2)/2), $x$)


      // --- 3. Tensões (Stress Block) ---
      // Vertical reference line
      line((7, 0), (7, 4), stroke: (dash: "dashed", paint: gray))
      
      // Rectangular stress block
      rect((7, 3), (8, 4), fill: none)
      
      // Stress distribution arrows
      for y in (3.2, 3.5, 3.8) {
        line((8, y), (7, y), mark: (end: ">", fill: black))
      }
      
      // Resultant forces (Fc and Fs)
      line((9, 3.5), (8.2, 3.5), mark: (end: ">", fill: blue), stroke: (paint: blue, thickness: 1.5pt))
      content((9.3, 3.5), text(blue)[$F_c$])
      
      line((6, 0.4), (7, 0.4), mark: (end: ">", fill: blue), stroke: (paint: blue, thickness: 1.5pt))
      content((5.7, 0.4), text(blue)[$F_s$])
      
      // Lever arm (z)
      line((10, 0.4), (10, 3.5), mark: (start: "|", end: "|"))
      content((9.8, 1.95), $z$)
      
      // Labels
      content((7.5, 5), [Tensão])
      content((7.5, 4.3), $alpha_c dot eta_c dot f_(c d)$)
    })
  ],
  caption: [Diagramas de tensões e deformações reproduzidos]
) <figDiagComp>

Deve-se dimensionar a área de aço de tração de modo a contrapor, por meio de um binário com o bloco de tensões, o momento fletor gerado pelos esforços.

Em posse dos parâmetros de bloco de tensões da flexão, calcula-se a profundidade da linha neutra (onde o momento é matematicamente nulo) denominada por $x$ na @eqLinNeu. 


$ x = (d - sqrt(d^2 - (2 M_d) / (b_w eta_c alpha_c f_(c d)))) / lambda_c $ <eqLinNeu>

Assim, obtém-se o braço de alavanca do sistema de equilíbrio $z$ por meio da @eqZ, e a área de aço $A_s$ pela @eqAs:

$ z = d - (lambda_c x)/2 $ <eqZ>
$ A_s = M_d / (z f_(y d)) $ <eqAs>



// =============================================

== Armadura Dupla

Em casos particulares, quando uma viga é submetida a momentos fletores muito elevados, o valor da razão $x/d$ cresce para limites acima  dos permitidos em norma. Para garantir um comportamento dúctil, pode-se adotar armadura dupla para reequilibrar o sistema, sem precisar alterar as dimensões físicas da viga. 

#figure(
  align(center)[
    #canvas({
      import draw: *

      // --- Vista Frontal (Cross Section) ---

      // Main beam outline
      rect((0, 0), (1.5, 4), name: "beam")
      
      // Compression zone
      rect((0, 2.8), (1.5, 4), fill: gray.lighten(70%))
      
      // Lower Rebars
      circle((0.4, 0.4), radius: 0.12, fill: black)
      circle((1.1, 0.4), radius: 0.12, fill: black)
      
      // Higher Rebars
      circle((0.4, 3.3), radius: 0.075, fill: black)
      circle((1.1, 3.3), radius: 0.075, fill: black)
      
      // Labels
      content((0.75, 5), [Vista frontal])
      
      content((-0.5, 0.4), $A_s$)
      line((-0.2, 0.4), (0.2, 0.4)) // Callout line for As

      content((-0.5, 3.3), $A_s'$)
      line((-0.2, 3.3), (0.2, 3.3)) // Callout line for As
      
      line((0,-0.3), (1.5,-0.3), mark: (end: "|", start: "|"))
      content((0.75, -0.7), $b_w$)

      // Moment arc
      arc((1.5+.5,1.4), start: -45deg, stop: 45deg, mark: (end: ">"))
      content((2.8, 2.0), $M_d$)

      // Equals
      content((3.6, 2.0), $=$)

      // 
      // Second beam outline
      rect((4, 0), (5.5, 4), name: "beam2")
      
      // Compression zone
      rect((4, 2.8), (4+1.5, 4), fill: gray.lighten(70%))
      
      // Lower Rebars
      circle((4+0.4, 0.4), radius: 0.1, fill: black)
      circle((4+1.1, 0.4), radius: 0.1, fill: black)
      

      
      // Labels
      content((4+0.75, 5), [Armadura de Tração])
      content((7.4, .4), text(blue)[$F_s$])
      content((7.4, 3.3), text(blue)[$F_c$])
      
      content((3.5, 0.4), $A_(s 1)$)
      line((3.8, 0.4), (4.2, 0.4)) // Callout line for As

      // Moment arc
      arc((5.5+.5,1.4), start: -45deg, stop: 45deg, mark: (end: ">"))
      content((4+3, 2.0), $M_"limite"$)

      // Forces
      line((7, 3.3), (6,3.3), mark:(end:">"), stroke: blue)
      line((6, .4), (7,.4), mark:(end:">"), stroke: blue)

      // Lever arm (z)
      line((8, 0.4), (8, 3.3), mark: (start: "|", end: "|"))
      content((8+.5, 1.95), $z_(l i m)$)
      
      // sUMS
      content((9, 2.0), $+$)

      // 
      // Third beam outline
      rect((4.5+5, 0), (4.5+6.5, 4), name: "beam3", stroke: (dash: "dashed"))

      
      // Lower Rebars
      circle((9.5+0.4, 0.4), radius: 0.07, fill: black)
      circle((9.5+1.1, 0.4), radius: 0.07, fill: black)

      // Higher Rebars
      circle((9.5+0.4, 3.6), radius: 0.04, fill: black)
      circle((9.5+1.1, 3.6), radius: 0.04, fill: black)
      
      // Labels
      content((9.5+0.75, 5), [Armadura Dupla])
      content((5.5+7.4, .4), text(blue)[$F_(s 2)$])
      content((5.5+7.4, 3.6), text(blue)[$F'_s$])
      
      content((9.5+.75, 2.8), [$A'_s$])
      line((9.5+.75, 3.2), (9.5+0.4, 3.6))
      line((9.5+.75, 3.2), (9.5+1.1, 3.6))

      content((9.5+.75, 1.2), [$A_(s 2)$])
      line((9.5+.75, .8), (9.5+0.4, .4))
      line((9.5+.75, .8), (9.5+1.1, .4))

      // Moment arc
      arc((11+.5,1.4), start: -45deg, stop: 45deg, mark: (end: ">"))
      content((9.5+3, 2.0), $M_(e x c)$)

      // Forces
      line((8+4.5, 3.6), (7+4.5,3.6), mark:(end:">"), stroke: blue)
      line((7+4.5, .4), (8+4.5,.4), mark:(end:">"), stroke: blue)
      
      // Lever arm (d-d')
      line((13.5, 0.4), (13.5, 3.5), mark: (start: "|", end: "|"))
      content((13.5+.7, 1.95), $d-d'$)
      
    })
  ],
  caption: [Diagramas de tensões e deformações reproduzidos]
) <figArmDup>

Na @figArmDup, o momento de cálculo $M_d$ é decomposto em dois valores, $M_"limite"$ e $M_"exc"$. Isso garante o comportamento da viga no domínio 3, ao custo de potencialmente super-dimensionar a seção. A @tabArmaduraDupla apresenta as equações de cálculo utilizadas para armadura dupla:

#figure(
  pretty-table(
    columns: (5cm, 1fr),
    align: (x, y) => if y == 0 { center + horizon } else if x == 0 { left + horizon } else { center + horizon },
    
    // Cabeçalho
    text(white, weight: "bold")[Definição], text(white, weight: "bold")[Equação],

    // Linha 1
    [Braço de alavanca limite], 
    [ $ z_(l i m) = d - 0.5 lambda_c x_(l i m) $ <eqAlavlim> ],

    // Linha 2
    [Momento máximo suportado pela seção simples], 
    [ $ M_(l i m) = b_w (lambda_c x_(l i m)) alpha_c f_(c d) z_(l i m) $ <eqMlim> ],

    // Linha 3
    [Momento excedente suportado pela armadura dupla], 
    [ $ M_(e x c) = M_d - M_(l i m) $ <eqMexc> ],

    // Linha 4
    [Deformação na armadura de compressão], 
    [ $ epsilon_(s c) = ((x_(l i m) - d') / x_(l i m)) epsilon_(c u) $ <eqEpsSc> ],

    // Linha 5
    [Tensão na armadura de compressão], 
    [ $ sigma_(s d)' = min(E_s epsilon_(s c), f_(y d)) $ <eqSigmaSd> ],

    // Linha 6
    [Área de aço de compressão ($A_s'$)], 
    [ $ A_s' = M_(e x c) / ((d - d') sigma_(s d)') $ <eqAsComp> ],

    // Linha 7
    [Área de aço de tração ($A_s$)], 
    [ $ A_s = M_(l i m) / (z_(l i m) f_(y d)) + M_(e x c) / ((d - d') f_(y d)) $ <eqAsTrac> ]

  ),
  caption: [Equações para o cálculo de seção transversal com armadura dupla.]
) <tabArmaduraDupla>

== Viga-T

O método da "Viga-T" pode ser adotado em casos em que a viga e a laje atuam como uma estrutura monolítica. No caso, define-se uma área de influência da laje de concreto, que será deformada junto com a viga, colaborando em sua resistência. A @figVigT ilustra a absorção, pelas abas, de parte do momento atuante na viga.

#figure(
  align(center)[
    #canvas({
      import draw: *

      // ==========================================
      // PART 1: The Full T-Beam (Left)
      // ==========================================
      
      // Neutral axis line
      line((-1.5, 2.3), (9, 2.3), stroke: (dash: "dashed"))
      content((-1.8, 2.35), $x$)
      
      // Main beam outline (T-shape)
      line((0,0), (0,3), (-1,3), (-1,4), (3,4), (3,3), (2,3), (2,0), (0,0), name: "full_beam")
      
      // Compression zone (Flanges + Web down to x)
      line((0,2.3), (0,3), (-1,3), (-1,4), (3,4), (3,3), (2,3), (2,2.3), (0,2.3), fill: gray.lighten(70%))
      
      // Lower Rebars
      circle((0.4, 0.4), radius: 0.12, fill: black)
      circle((2-0.4, 0.4), radius: 0.12, fill: black)
      
      // Labels & Callouts
      content((1, 5), [Vista frontal])
      content((-0.7, 0.4), $A_s$)
      line((-0.3, 0.4), (0.2, 0.4)) 
      
      // --- Dimensions (Cotas) ---
      // b_w (web width)
      line((0, -0.3), (2, -0.3), mark: (start: "|", end: "|"))
      content((1, -0.6), $b_w$)
      
      // b_f (flange width)
      line((-1, 4.3), (3, 4.3), mark: (start: "|", end: "|"))
      content((1, 4.6), $b_f$)
      
      // h_f (flange height)
      line((3.5, 3), (3.5, 4), mark: (start: "|", end: "|"))
      content((3.9, 3.5), $h_f$)

      // Equals Sign
      content((4.8, 2.0), $=$)


      // ==========================================
      // PART 2: Web Section (Middle)
      // ==========================================
      
      let off2 = 6.0 // offset for the second drawing
      
      // Web outline (dashed above, solid below)
      rect((0+off2, 0), (2+off2, 4), stroke: (dash: "dashed"))
      
      // Web compression zone
      rect((0+off2, 2.3), (2+off2, 4), fill: gray.lighten(70%), stroke: (paint: black, thickness: 1pt))
      
      // Lower Rebars (A_s1)
      circle((0.4+off2, 0.4), radius: 0.1, fill: black)
      circle((2-0.4+off2, 0.4), radius: 0.1, fill: black)
      
      // Labels
      content((1+off2, 5), [Alma])
      content((-0.6+off2, 0.4), $A_(s 1)$)
      line((-0.2+off2, 0.4), (0.2+off2, 0.4)) 
      
      // Forces
      line((2.8+off2, 3.15), (2.2+off2, 3.15), mark:(end:">"), stroke: blue)
      content((3.3+off2, 3.15), text(blue)[$F_(c 1)$])
      
      line((2.2+off2, 0.4), (2.8+off2, 0.4), mark:(end:">"), stroke: blue)
      content((3.3+off2, 0.4), text(blue)[$F_(s 1)$])

      // Plus Sign
      content((4.5+off2, 2.0), $+$)


      // ==========================================
      // PART 3: Flanges Section (Right)
      // ==========================================
      
      let off3 = 11.5 // offset for the third drawing
      
      // Flanges outline (dashed core)
      rect((-1+off3, 3), (0+off3, 4), stroke: (dash: "dashed"))
      rect((2+off3, 3), (3+off3, 4), stroke: (dash: "dashed"))
      
      // Flanges compression zone
      rect((-1+off3, 3), (0+off3, 4), fill: gray.lighten(70%), stroke: (paint: black, thickness: 1pt))
      rect((2+off3, 3), (3+off3, 4), fill: gray.lighten(70%), stroke: (paint: black, thickness: 1pt))
      
      // Dashed web to show context
      rect((0+off3, 0), (2+off3, 4), stroke: (dash: "dashed", paint: gray))
      
      // Lower Rebars (A_sf / A_s2)
      circle((0.6+off3, 0.4), radius: 0.07, fill: black)
      circle((2-0.6+off3, 0.4), radius: 0.07, fill: black)
      
      // Labels
      content((1+off3, 5), [Abas])
      content((-0.6+off3, 0.4), $A_(s f)$)
      line((-0.2+off3, 0.4), (0.4+off3, 0.4)) 
      
      // Forces
      line((3.8+off3, 3.5), (3.2+off3, 3.5), mark:(end:">"), stroke: blue)
      content((4.3+off3, 3.5), text(blue)[$F_(c f)$])

      
      line((3.2+off3, 0.4), (3.8+off3, 0.4), mark:(end:">"), stroke: blue)
      content((4.3+off3, 0.4), text(blue)[$F_(s f)$])

      // dim forces
      line((5.1+off3, .4), (5.1+off3, 3.5), mark: (start: "|", end: "|"))
      content((4.1+off3, (.4+3.5)/2), $d - 0.5h_f$)
    })
  ],
  caption: [Decomposição das tensões em vigas de seção T (assumindo linha neutra na alma).]
) <figVigT>


Define-se o Momento absorvido pelas abas ($M_"abas"$) pela @eqMAbas e o momento restante na alma pela @eqMAlma:
$ M_(a b a s) = (b_f - b_w) h_f alpha_c f_(c d) (d - 0.5 h_f) $ <eqMAbas>

$ M_(a l m a) = M_d - M_(a b a s) $ <eqMAlma>
$ x = (d - sqrt(d^2 - (2 M_(a l m a)) / (b_w eta_c alpha_c f_(c d)))) / lambda_c $

== Cisalhamento 

Como funcionalidade final do BeamCan, de modo a caracterizar um dimensionamento mais completo da viga, também foi introduzido um algoritmo de cálculo e dimensionamento de estribos.

A @tabCisalhamento sintetiza as principais equações para o dimensionamento ao cisalhamento de elementos lineares de concreto armado conforme os Modelos I e II da #norma, considerando estribos a 90°. As expressões abrangem a verificação das bielas de compressão, a parcela de resistência atribuída ao concreto, a força cortante absorvida pela armadura transversal e o cálculo das áreas de aço necessária e mínima. 

#let cis-table() = {
  set text(size: 10pt) // only for table
  [#figure(
    pretty-table(
      color-rows: false,
      columns: (3cm, 2cm, 1fr),
      fill: (x, y) => {
        if (y == 0) {
          rgb("#404040")
        } else if (y in (1,2,5,8)) {
          rgb("#f5f5f5")
        } else {
          white
        }
      },
      align: (x, y) => if y == 0 { center + horizon } else if x == 0 { left + horizon } else { center + horizon },
      
      // Cabeçalho
      text(white, weight: "bold")[Definição], 
      text(white, weight: "bold")[Modelo], 
      text(white, weight: "bold")[Equação],
  
      // Linha 1 - Biela de compressão
      table.cell(rowspan: 2)[Força resistente da biela de compressão], 
      [I], 
      [ $ V_(R d 2) = 0.27 (1 - f_(c k)/250) f_(c d) b_w d $ <eqVRd2_mod1> ],
      
      // Linha 2
      [II], 
      [ $ V_(R d 2) = 0.54 (1 - f_(c k)/250) f_(c d) b_w d sin^2(theta) cot(theta) $ <eqVRd2_mod2> ],
  
      // Linha 3 - Parcela do concreto
      table.cell(rowspan: 2)[Parcela resistida pelo concreto], 
      [I], 
      [ $ V_(c 1) = V_(c 0) = 0.6 f_(c t d) b_w d $ <eqVc1_mod1> ],
  
      // Linha 4
      //rowspan
      [II], 
      [ $ V_(c 1) = V_(c 0) ((V_(R d 2) - V_d) / (V_(R d 2) - V_(c 0))) $ <eqVc1_mod2> ],
  
      // Linha 5 - Força cortante absorvida
      [Força cortante absorvida pelos estribos],
      [I e II], 
      [ $ V_(s w) = max(0, V_d - V_(c 1)) $ <eqVsw> ],
  
      // Linha 6 - Armadura transversal (Modelo I)
      table.cell(rowspan: 2)[Armadura transversal necessária], 
      [I], 
      [ $ A_(s w) / s = V_(s w) / (0.9 d f_(y w d)) $ <eqAsw_mod1> ],
  
      // Linha 7
      //rowspan
      [II], 
      [ $ A_(s w) / s = V_(s w) / (0.9 d f_(y w d) cot(theta)) $ <eqAsw_mod2> ],
  
      // Linha 8 - Armadura mínima
      [Armadura transversal mínima],
      [I e II],
      [ $ (A_(s w, m i n)) / s = 0.2 (f_(c t m) / f_(y w k)) b_w $ <eqAsw_min> ]
  
    ),
    caption: [Equações para o cálculo de cisalhamento (Modelos I e II da NBR 6118) para estribos a 90°.]
  )<tabCisalhamento>]
}

#cis-table()


= METODOLOGIA

== Escolha de Tecnologia

A concepção inicial do software previa uma arquitetura dividida em duas tecnologias distintas: a linguagem Python, responsável pelo _backend_ e pelo processamento matemático intensivo, e a linguagem _Dart_ (junto ao _framework_ Flutter) atuando no frontend. A escolha do _Dart_ justificou-se, primordialmente, por sua capacidade multiplataforma, permitindo a compilação de uma única base de código para aplicações Web (executadas diretamente em navegadores), dispositivos móveis (Android e iOS) e sistemas desktop (Windows, Linux e macOS).

Contudo, durante o avanço do desenvolvimento, ficou claro que a dependência de uma API (_Application Programming Interface_) para a comunicação entre o _backend_ e o frontend inseria uma camada desnecessária de complexidade, aumentando o tamanho final do aplicativo e o tempo de resposta (latência) nas requisições de cálculo. Diante disso, optou-se pela reescrita integral do motor de cálculo em puro _Dart_. Essa transição unificou o ambiente de desenvolvimento em uma arquitetura monolítica, conferindo maior leveza computacional ao programa.

== Algoritmo de Empacotamento

O algoritmo de empacotamento foi estruturado para atuar na transição direta entre a resposta matemática teórica e o detalhamento físico executável. O método opera de forma heurística e iterativa: a partir da demanda inicial de área de aço ($A_s$), geram-se combinações a partir de um catálogo de bitolas comerciais e tenta organizá-las na largura da viga, respeitando rigorosamente os cobrimentos e os espaçamentos horizontais mínimos exigidos pela norma. 

Quando o espaço físico na primeira camada se esgota, o algoritmo distribui as barras verticalmente em múltiplas camadas. Esse remanejamento geométrico desloca o centro de gravidade do conjunto de armaduras, alterando a altura útil efetiva da seção ($d_("real")$). Consequentemente, o sistema recalcula a nova demanda de área de aço e reinicia a verificação física em *loop* iterativo até a convergência, garantindo que as soluções apresentadas ao usuário sejam, simultaneamente, seguras contra a ruína e fisicamente executáveis no canteiro de obras.

== Critérios de Validação 

Para validação dos resultados obtidos pelo BeamCan, foram escolhidos três problemas característicos, com diferentes qualidades e propriedades. Pela comparação dos resultados, e análise da seção escolhida, será observada a precisão e qualidade das soluções apresentadas no catálogo.

- O primeiro problema apresenta uma viga retangular comum, de altura considerável, que exigirá do software a adoção de armadura de pele. 

- O segundo problema, por outro lado, apresenta um carregamento alto, que forçará ao software a realizar o cálculo pelo método da armadura dupla.

- O terceiro problema, finalmente, será similar ao anterior, agora considerando a influência da laje.

= DESENVOLVIMENTO COMPUTACIONAL

== Arquitetura do App

A linguagem _Dart_, mantida pela Google, é fundamentada na Programação Orientada a Objetos (POO). Essa estrutura garante a criação de um código modular, escalável e com alto grau de reaproveitamento de código para modelar as entidades físicas do problema (como vigas, seções transversais e armaduras).

Aliado ao _Dart_, a construção da Interface de Usuário (UI) foi viabilizada pela vasta disponibilidade de componentes do _framework_ Flutter, denominados _widgets_. De forma simplificada, esses componentes operam de maneira declarativa, permitindo a estruturação dinâmica e intuitiva de elementos visuais. Os widgets são responsáveis por gerenciar a entrada de dados do usuário, organizar a apresentação dos resultados, viabilizar a renderização gráfica via Canvas e apresentar as explicações das etapas de cálculo conforme as exigências normativas.

Em sua estruturação interna, o BeamCan foi modularizado em seis arquivos principais, visando o princípio da responsabilidade única (separando a lógica de interface, o armazenamento de dados e o processamento matemático). A @lemon ilustra o fluxograma arquitetural do projeto e a comunicação entre esses módulos, enquanto a @tabFiles sumariza, a função específica de cada arquivo.

#figure(
  image("assets/Estrutura_arquivos.pdf", width: 65%),
  caption: [Estrutura de Arquivos do Programa]
) <lemon>

#let tabela_estrutura_arquivos() = {
  let captions = (
    "Nome do Arquivo",
    "Função"
  )

  let values = (
  `main.dart`, "Define a interface gráfica e o layout da aplicação, gerenciando o estado e orquestrando a comunicação entre os demais módulos conforme a interação do usuário.",
  `beam_models.dart`, "Define a estrutura de dados do programa, estabelecendo as classes e tipagens padronizadas para o tráfego de informações entre as etapas de cálculo e apresentação.",
  `bending.dart`, [Atua como o motor de cálculo à flexão. Determina a linha neutra, as áreas de aço necessárias e executa a otimização combinatória para o empacotamento físico das barras longitudinais. (@algoSol)],
  `shearing.dart`, [Constitui o módulo de dimensionamento ao cisalhamento. Avalia a resistência das bielas de compressão e determina a área e o espaçamento ideal da armadura transversal (estribos), dada uma solução de flexão escolhida pelo usuário. (@algoShear)],
  `painter.dart`, "Contém a lógica de renderização gráfica. Desenha dinamicamente a geometria da seção, as camadas de aço, os estribos e as cotas dimensionais diretamente em um Canvas virtual.",
  `pdf_service.dart`, "Responsável pela rotina de exportação. Estrutura a memória de cálculo, os desenhos vetoriais e os metadados do projeto em um relatório PDF formal e paginado."
)

  pretty-table(
    columns: (30%, 70%),
    // Cabeçalho
    table.cell(
      [#text("Nome do Arquivo", weight: "bold", fill: white)],
      align: left,
    ),
    table.cell(
      [#text("Função", weight: "bold", fill: white)],
      align: left,
    ),

    // Dados
    ..values,
  )
}
// ================================================================
// TABELA DE EXPLICAÇÃO DOS ARQUIVOS
// ----------------------------------------------------------------
#figure(
  tabela_estrutura_arquivos(),
  caption: [Explicação dos arquivos componentes do programa]
) <tabFiles>
// ================================================================






== Interface de usuário

O desenvolvimento do cálculo é separado em três etapas, "Dimensionamento", "Resultados e Otimização" e "Dimensionamento de Esforço Cortante". A interface do usuário foi adaptada para ser simples de utilizar, tanto num dispositivo móvel quanto num computador. Um grande diferencial do BeamCan é que, ao se deparar com um valor não imediatamente óbvio ou estritamente normativo, o usuário pode clicar no ícone de dúvida (definido por um círculo azul com um ponto de interrogação) e receber uma explicação do que está alterando, assim como uma referência direta à norma (#norma). 

As unidades de medida são fixas, respeitando a melhor dimensão do valor. Essa escolha simplifica consideravelmente a programação do problema, e agiliza o processo de preenchimento dos dados.

=== Dimensionamento 

Nessa tela, o usuário irá inserir valores já definidos pelas demandas de projeto, como o Momento Fletor de _Design_ (isto é, já majorado conforme o disposto na norma) $M_d$, e a geometria (base, altura, e elementos da "Viga T").

Ao clicar no ícone no canto superior direito, o usuário abrirá a sub-página de parâmetros de projeto, onde poderá definir qualidades do material (resistência do concreto, e tipo de aço a ser utilizado pelas barras), assim como condições da estrutura e carregamento definidos em norma, acompanhados de sua devida explicação.

Na @dimPage, são apresentadas as duas janelas:


#figure(
  grid(
    columns: 3,
    stack(
      image("assets/screenshots/dimensionamento_page.png", height: screenshot_height),
      align(center)[ $""$ \ (a) \ $""$]
    ),
    box(width: .3cm),
    stack(
      image("assets/screenshots/dimensionamento_parametros_subpage.png", height: screenshot_height),
      align(center)[ $""$ \ (b) \ $""$]
    ),
  ),
  caption: [
    Páginas de Dimensionamento do aplicativo.
    
    (a) Introdução do esforço e das qualidades geométricas
    
    (b) Definição dos parâmetros de projeto
  ],
) <dimPage>

Neste exemplo, puramente teórico, em (a)  o usuário está definindo uma viga para resistir o esforço de  $M_d = 400 "kN.m"$, adotando o método da "Viga T", que considera a resistência das lajes na estrutura. Em (b), pode-se observar que, ao clicar no ícone de dúvida, o software explica a função da "Classe de Agressividade", e orienta o leitor a buscar a referência na norma.

=== Resultados e Otimização

Ao clicar em "calcular", o software realiza as contas iniciais, com valores padrão, descritos para o exemplo apresentado na @dimPage. Como será visto posteriormente, este processo é rápido e eficiente, mesmo diante de centenas de possíveis soluções. 


#figure(
  grid(
    columns: 3,
    stack(
      image("assets/screenshots/results_page1.png", height: screenshot_height),
      align(center)[ $""$ \ (a) \ $""$]
    ),
    box(width: .3cm),
    stack(
      image("assets/screenshots/results_page2.png", height: screenshot_height),
      align(center)[ $""$ \ (b) \ $""$]
    ),
  ),
  caption: [
    Páginas de Resultados do aplicativo.
    
    (a) Detalhamento da seção escolhida
    
    (b) Memorial de Cálculo
  ],
) <resPage>

Na @resPage, a interface exibe a primeira de 10 soluções encontradas no "catálogo" pelo algoritmo combinatório, listando-as, por padrão, em ordem decrescente de economia de aço (configurável na tabela de otimização, como será visto). Em (a), o usuário visualiza o detalhamento físico da seção transversal. É possível navegar facilmente pelo "catálogo" de opções geradas utilizando as setas inferiores ou deslizando a própria imagem. Logo abaixo, em (b), encontra-se o Memorial de Cálculo expansível. Este módulo detalha o passo a passo da formulação matemática, desde a busca da linha neutra até o balanço final de áreas de aço, além de emitir alertas caso a solução demande atenção especial (como o uso de armadura dupla ou bitolas incomuns de 32 mm, por exemplo).

#figure(
  image("assets/screenshots/otimizacao_page.png", height: screenshot_height),
  caption: [Página de otimização dos resultados]
) <optPage>

Caso o usuário deseje refinar as soluções apresentadas, basta acessar o menu superior direito para abrir a aba de Otimização, ilustrada na @optPage. Diferente do cálculo reativo convencional, esta aba não impõe uma bitola específica, mas sim as "regras" matemáticas que o algoritmo deve respeitar ao gerar as soluções. A @tabOpt detalha os principais parâmetros customizáveis desta seção.

#let tabela_opcoes_otimizacao() = {
  set text(size: 10pt)
  let values = (
    `N° máx. de Barras`, "Limita a quantidade total de barras longitudinais permitidas em uma mesma solução, evitando arranjos demasiadamente congestionados.",
    `N° máx. de Soluções`, "Define o número de soluções que o Software deve procurar e apresentar à fila, com valor padrão igual a 10.",
    `Variação máx. de bitolas`, "Define o limite de diâmetros diferentes que podem ser misturados em uma única solução (por exemplo, limitar a combinação de apenas 10.0 mm e 12.5 mm).",
    `Diâmetro (mín. e máx.)`, "Restringe o leque de opções de bitolas comerciais que o algoritmo pode tentar utilizar para a armadura principal.",
    `Tolerância de Área (%)`, "Define uma margem aceitável de aceitação de área de aço provida pela combinação em relação à área teórica mínima exigida pelo cálculo.",
    `Restringir Barras Interiores`, "Força o algoritmo a limitar as camadas superiores de tração a apenas 2 barras, facilitando a passagem do vibrador de concreto na obra, e evitando barras 'flutuantes' na solução.",
    `Preferência no Projeto`, "Critério mestre para o ranqueamento do catálogo de soluções. Pode priorizar opções pelo Menor Desperdício de Aço, Menor Número de Barras ou Uniformidade de Diâmetros.",
    `Tipo de Brita`, "Tipo de Brita utilizada no Concreto, fator que afeta o espaçamento das barras na solução.",
    `Preferir Simetria`, "Busca soluções que garantem simetria.",
  )

  pretty-table(
    columns: (20%, 80%),
    // Cabeçalho
    table.cell(
      [#text("Parâmetro de\nOtimização", weight: "bold", fill: white)],
      align: left,
    ),
    table.cell(
      [#text("Função", weight: "bold", fill: white)],
      align: left,
    ),

    // Dados
    ..values,
  )
}

#figure(
  tabela_opcoes_otimizacao(),
  caption: [Descrição dos parâmetros do algoritmo de otimização disponíveis na interface.]
) <tabOpt>

  === Dimensionamento de Esforço Cortante

Após encontrar e selecionar a melhor solução longitudinal no catálogo, o fluxo de projeto avança para a etapa transversal ao clicar no botão "Definir Estribos" (localizada na @resPage#"a"). A aba gerada é ilustrada na @shearPage.

Nesta janela, insere-se a força cortante de projeto ($V_d$). O usuário também pode definir o número de ramos e alternar entre os modelos de cálculo da NBR 6118 (Modelo I com biela fixa a $45 degree$, ou Modelo II com biela variável entre $30 degree$ e $45 degree$). Ao clicar em "Calcular Espaçamentos", o sistema checa o esmagamento da biela e retorna as opções de estribos fisicamente exequíveis. Ao confirmar a escolha, o aplicativo automaticamente atualiza a renderização da viga com a nova bitola transversal, recalcula a altura útil real ($d_"real"$) para atestar que as barras continuam cabendo na seção, e adiciona essas novas verificações ao Memorial de Cálculo principal.

#figure(
  image("assets/screenshots/shear_page.png", height: screenshot_height),
  caption: [Aba de Dimensionamento da Força Cortante]
) <shearPage>


Por fim, o usuário poderá salvar a seção escolhida pelo botão "Gerar Relatório" (localizado na @resPage#"b") no fim da página, salvando um arquivo pdf com todas as informações inseridas. 

== Algoritmo de Empacotamento <secAlgos>

O grande diferencial do software se apresenta no algoritmo que determina as soluções de flexão, de forma iterativa, e cria o catálogo de soluções. Ao receber o _payload_ de cálculo, isto é, o definido na tela de dimensionamento, o algoritmo segue o exposto na @algoIn:

#figure(
  image("assets/flowcharts/algoritmoInicial.pdf", width: 80%),
  caption: [Algoritmo de Determinação do caso de Viga (`bending.dart`)]
) <algoIn>



Nesta etapa inicial, o algoritmo determina a condição atual da viga, seu formato (retangular ou "T"), se necessita de armadura dupla, e por fim invoca o algoritmo de empacotamento de barras.

A transição entre o cálculo teórico e o detalhamento executivo é realizada por um motor de otimização combinatória. Abordagens tradicionais de solução de vigas adotam métodos heurísticos para encontrar uma única solução satisfatória, enquanto o algoritmo do BeamCan mapeia o espaço de soluções por meio de uma varredura exaustiva e filtragem física. Esse processo é demonstrado na @algoSol.

#figure(
  image("assets/flowcharts/algoritmoSolucoes.pdf", width: 80%),
  caption: [Algoritmo de Empacotamento de Barras (`bending.dart`)]
) <algoSol>



Ao receber a área de aço, conhecidas as propriedades da viga e parâmetros do usuário, o algoritmo realiza quatro etapas:

+ Define o subconjuntos de barras por meio de um _loop de complexidade_;
+ Executa o empacotamento físico, isto é, determina um conjunto de listas de barras, na qual cada lista irá compor uma camada de bitolas na viga. Nesta etapa é garantido o espaçamento mínimo horizontal;
+ Com as combinações definidas, as camadas são distribuídas verticalmente, garantindo o espaçamento vertical normativo mínimo;
+ Finalmente, as soluções encontradas passam por um filtro final, que poderá descartar a solução, ou aceitá-la. O algoritmo também poderá avisar o usuário caso recomendações não sejam atingidas, mas irá considerar a solução como aceita.

Obtém-se, então, um catálogo de soluções viáveis, que são ordenadas segundo a preferência do usuário (menor área de aço, uniformidade de bitolas, menor quantidade de barras e menor altura de camada) prontas para serem renderizadas na interface.

// do not allow page break between both
#block(breakable: false)[
  == Algoritmo de Solução Cortante <secAlgoShear>

  A solução de cortante é determinada após escolha da seção. A @algoShear delimita este algoritmo:

  #figure(
    image("assets/flowcharts/AlgoShear.pdf", width: 80%),
    caption: [Algoritmo de Soluções de Cortante do programa (`shearing.dart`)]
  ) <algoShear>
]

Como visto na @shearPage, o usuário seleciona o esforço, modelo de cálculo, segundo a #norma, e o número de ramos, e pode escolher de acordo com o diâmetro e espaçamento de estribos desejado. Este processo é dinâmico, logo a alteração de valores altera automaticamente a lista de soluções encontradas.



= RESULTADOS E DISCUSSÕES
A validação do aplicativo foi conduzida por meio da comparação direta de seus resultados com resoluções analíticas clássicas da literatura técnica. 

== Validação Numérica

Para avaliar o comportamento primário do motor de flexão simples e a precisão do algoritmo transversal, propôs-se a análise de três vigas, que exijam do motor de cálculo diferentes resoluções.

=== Viga retangular sob esforços moderados

Será considerado o seguinte problema, definido na @prob1:

#let tmp = 60%


#figure(
  pretty-table(
  columns: (tmp, 100% - tmp),

  // titles
  table.cell(text(fill: white)[*Corte*]),
  table.cell(text(fill: white)[*Dados*]),

  table.cell([
    #figure(
      canvas({
        import draw:*

        // main beam
        let bw = 2.5
        let h = 70/25 * bw
        rect((0, 0), (bw, h))
        
        // representative bars
        for x in (bw/4, 3/4*bw) {
          circle((x, h * .1), radius: .15, fill: black)
          line((x, h * .1), (bw/2, .22 * h), stroke: (dash: "dashed"))
        }
        // As 
        content((bw / 2, .3 * h), $A_s$)
        
        // dims
        let dimoffx = .7
        let dimoffy = .5
        line((- dimoffx, h), (- dimoffx, .1*h), mark: (start: "|", end: "|"))
        content((-dimoffx - .3 , 1.1/2*h), $d$)
        line((- 2*dimoffx, h), (- 2* dimoffx, 0), mark: (start: "|", end: "|"))
        content((- 2 * dimoffx - .3 , 1/2*h), $h$)
        line((0, -dimoffy), (bw, -dimoffy), mark: (start: "|", end: "|"))
        content((bw / 2 , -dimoffy - .3), $b_w$)

        
        
      })
    )
  ]), // table.cell
  table.cell([
    $M_d = 400 "kN.m"$ \
    $b_w = 25 "cm"$ \
    $h = 90 "cm"$ \
    $d = 81 "cm"$ \
    $f_(c k) = 20 "MPa"$ \
    $"Aço: CA50"$ \
    Carregamento Normal \
    Classe de Agressividade: I
  ])
  ),
  caption: [Problema de viga retangular com esforços moderados],
  kind: image
) <prob1>

Adotando os coeficientes de ponderação normais ($gamma_c = 1.4$ e $gamma_s = 1.15$):

#dumb($ f_(c d) = f_(c k) / gamma_c = 20 / 1.4 = #calc.round(20 / 1.4, digits: 3) "MPa" = 1.43 "kN/cm"^2 $)
#dumb($ f_(y d) = f_(y k) / gamma_s = 500 / 1.15 = 434.78 "MPa" = 43.48 "kN/cm"^2 $)

Como a resistência do concreto é $f_(c k) = 20 "MPa" <= 50 "MPa"$, os parâmetros do bloco de tensões assumem seus valores fixos conforme as equações #ref(<eqAlphac>, supplement: none), #ref(<eqLambdac>, supplement: none) e #ref(<eqEtac>, supplement: none):

#dumb(
  $ alpha_c = 0.85, quad lambda_c = 0.8, quad eta_c = 1.0 $
)

Substituindo esses coeficientes junto à geometria da seção ($b_w = 25 "cm"$ e $d = 81 "cm"$) na equação da linha neutra (@eqLinNeu):

#dumb(
  $
x = (81 - sqrt(81^2 - (2 dot 40000) / (25 dot 1.0 dot 0.85 dot 1.43))) / 0.8 = 22.93 "cm"
$
)

Valor este que respeita o limite normativo da ductilidade até 50 MPa ($x/d = 22.93 / 81 = 0.28 < 0.45$). A seguir, calcula-se o braço de alavanca $z$ utilizando a @eqZ:

$ z = 81 - (0.8 dot 22.93) / 2 = 71.83 "cm" $

Por fim, determina-se a área de aço tracionada estritamente necessária ($A_s$) para o equilíbrio da seção aplicando a @eqAs:

$ A_s = 40000 / (71.83 dot 43.48) = 12.81 "cm"^2 $

Em relação ao _software_ BeamCan, os resultados obtidos foram idênticos. A solução foi otimizada diminuindo-se a variação de barras e aumentando o diâmetro da armadura de pele, para obter a seguinte solução:

#figure(
  image("assets/screenshots/prob1_sol1.png", width: 30%),
  caption: [Solução de menor área obtida para o problema 1]
)

A viga escolhida possui área de aço de tração igual a $12.26 "cm"^2$, área aceitável dentro da tolerância de 5% definida pelo software. Caso necessário, seria possível diminuir essa tolerância. O software também garantiu que a solução apresentada estivesse de acordo com os requisitos mínimos de espaçamento, armadura de pele, e armadura.

A @resultadosRel1 apresenta o relatório criado pelo aplicativo após solução do problema:

#block(breakable: false)[
  #drawer([Área de Aço Requerida])[
  *Armadura Simples*
  - Braço de alavanca ($z = d - 0.5 dot lambda_c dot x$): $71.83 "cm"$
  - $A_(s, "alma") = M_d / (z dot f_(y d))$
  - $A_(s, "alma") = 12.81 "cm"^2$

  *Verificação de Armadura Mínima (NBR 6118)*
  - Módulo de resistência retangular ($W_0 = (b_w dot h^2) / 6$): $33750.00 "cm"^3$
  - Momento de fissuração ($M_(d,"min") = 0.8 dot W_0 dot f_(c t,"sup")$): $77585.70 "N.m"$
  - Área de aço máxima aceitável ($A_(s,"max") = 4% dot b_w dot h$): $90.00 "cm"^2$
  - Área de aço mínima exigida ($A_(s,"min") = M_(d,"min") / (z dot f_(y d))$): $2.48 "cm"^2$

  *RESUMO FINAL DE ÁREAS:*
  - $A_s$ (Tração): $12.81 "cm"^2$
]

#v(.2em)

#drawer([Verificação do Detalhamento Real])[
  *Recálculo com Barras Posicionadas* \
  O valor de $d$ ($90% "de" h$) usado nos cálculos teóricos foi uma estimativa. Após empacotar as barras em camadas, respeitando os espaçamentos, o cobrimento e os estribos, o centro de gravidade real foi aferido:
  
  - Altura útil efetiva ($d_"real"$): $84.43 "cm"$
  - Nova relação $x/d_"real"$: $0.272$

  *Balanço do Detalhamento (Aço Comercial)*
  - Área de tração requerida: $12.81 "cm"^2$
  - Área de tração fornecida: $12.20 "cm"^2$
  
  *Saldo Negativo (Falta):* $0.61 "cm"^2$ a menos. (Aceitável dentro da tolerância de projeto de $5%$).
]

#v(.2em)

#drawer([Armadura de Pele])[
  *Critério NBR 6118* ($h >= 60 "cm"$) \
  A seção exige armadura de pele para controle de fissuração na alma.
  
  - Altura efetiva exposta ($h_"calc"$): $90.00 "cm"$
  - Área da alma ($A_(c,"alma") = b_w dot h_"calc"$): $2250.00 "cm"^2$
  - Área mínima por face ($0.10% A_(c,"alma") "ou" 5 "cm"^2/"m"$ por face): $2.25 "cm"^2$
  - Limite de espaçamento máximo ($s_"max" = min(d/3, 20"cm")$)

  *Detalhamento adotado por face:*
  - $12$ barras de $phi 5.0 "mm"$
  - Área provida por face: $2.35 "cm"^2$
]
]

#figure(
  [],
  kind: image,
  caption: [Relatório de cálculo do BeamCan obtido pela solução do problema 1]
) <resultadosRel1>



=== Viga retangular sob esforços altos  <secAltosEsforcos>

Com o objetivo de analisar uma seção com armadura dupla, propõe-se o problema abaixo (@prob2):

#let tmp=60%

#let diagram_p2 = canvas({
        import draw:*

        // main beam
        let bw = 3
        let h = 17/9 * bw
        rect((0, 0), (bw, h))
        
        // representative bars
        for x in (bw/4, 3/4*bw) {
          circle((x, h * .1), radius: .15, fill: black)
          line((x, h * .1), (bw/2, .22 * h), stroke: (dash: "dashed"))
        }
        for x in (bw/5, 4/5*bw) {
          circle((x, h * .9), radius: .08, fill: black)
          line((x, h * .9), (bw/2, (1-.22) * h), stroke: (dash: "dashed"))
        }
        // As 
        content((bw / 2, .3 * h), $A_s$)
        content((bw / 2, (1-.3) * h), $A'_s$)
        
        // dims
        let dimoffx = .7
        let dimoffy = .5
        line((- dimoffx, h), (- dimoffx, .1*h), mark: (start: "|", end: "|"))
        content((-dimoffx - .3 , 1.1/2*h), $d$)
        line((- 2*dimoffx, h), (- 2* dimoffx, 0), mark: (start: "|", end: "|"))
        content((- 2 * dimoffx - .3 , 1/2*h), $h$)
        line((0, -dimoffy), (bw, -dimoffy), mark: (start: "|", end: "|"))
        content((bw / 2 , -dimoffy - .3), $b_w$)
      })
      
#figure(
  pretty-table(
  columns: (tmp, 100% - tmp),

  // titles
  table.cell(text(fill: white)[*Corte*]),
  table.cell(text(fill: white)[*Dados*]),

  table.cell([
    #figure(
      scale(100%, diagram_p2)
    )
  ]), // table.cell

  table.cell([
    $M_d = 120 "kN.m"$ \
    $b_w = 18 "cm"$ \
    $h = 40 "cm"$ \
    $d = 36 "cm"$ \
    $f_(c k) = 20 "MPa"$ \
    $"Aço: CA50"$ \
    Carregamento Normal \
    Classe de Agressividade: I
  ])
  ),
  caption: [Problema de viga retangular com altos esforços],
  kind: image
) <prob2>

A determinação algébrica inicial da linha neutra resultaria em $x = 27.36 "cm"$, o que gera uma relação $x/d = 0.76$, superior ao limite normativo. Para evitar uma ruptura frágil, o sistema fixa a profundidade da linha neutra em seu valor limite ($x = x_(l i m) = 0.45 dot 36 = 16.2 "cm"$) e aciona automaticamente o cálculo para armadura dupla. O momento limite é calculado pela @eqMlim.

#dumb($ M_(l i m) = b_w (0.8 x_(l i m)) 0.85 f_(c d) (d - 0.4 x_(l i m)) \ = 83.62 "kN.m" $)

O momento fletor excedente é então definido pela @eqMexc:

#dumb($
M_(e x c) = 120 - 83.62 = 36.38 "kN.m"
$) 

Assumindo um centro de gravidade das armaduras superiores de $d' approx 4.0 "cm"$, comprova-se por semelhança de triângulos (@eqEpsSc) que a deformação na armadura de compressão ultrapassa a deformação de escoamento do aço CA-50 

$ epsilon_(s c) = ((16.2 " cm" - 4" cm") / (16.2 " cm")) dot 3.5 %_o = 2.63 %_o $

Logo, a tensão no aço comprimido atinge sua capacidade máxima de projeto $f_(y d) = 43.48 "kN/cm"^2$ (@eqSigmaSd).

A @tabArmDuplaRes resume os valores algébricos obtidos neste passo a passo analítico e os confronta com os dados gerados pelo motor iterativo do BeamCan.

#figure(
  pretty-table(
    columns: (auto, 1fr, 1fr),
    
    // Cabeçalho
    text(white, weight: "bold")[Parâmetro Avaliado], 
    text(white, weight: "bold")[Resolução Analítica], 
    text(white, weight: "bold")[Resultado BeamCan],

    // Linhas de dados
    [Linha Neutra Adotada ($x = x_(l i m)$)], [$16.20 "cm"$], [$16.20 "cm"$],
    [Momento Limite ($M_(l i m)$)], [$83.62 "kN.m"$], [$83.62 "kN.m"$],
    [Momento Excedente ($M_(e x c)$)], [$36.38 "kN.m"$], [$36.38 "kN.m"$],
    [Área de Aço Compressão ($A_s'$)], [$2.61 "cm"^2$], [$2.57 "cm"^2$],
    [Área de Aço Tração ($A_s$)], [$9.13 "cm"^2$], [$9.08 "cm"^2$]
  ),
  caption: [Comparativo de validação numérica para seção transversal sob armadura dupla.]
) <tabArmDuplaRes>

Após otimização dos resultados, foi obtida a seguinte solução, definida pela @sol2:

#figure(
  image("assets/screenshots/prob2_sol1.png", width: 30%),
  caption: [Solução obtida pelo BeamCan para o problema 2]
) <sol2>

Pode-se observar, da @tabArmDuplaRes, que os resultados obtidos são compatíveis com a solução analítica, variando em pequenas quantidades em função de arredondamentos no cálculo. Deve-se observar, porém, que a presente solução, apresenta os seguintes avisos (@resultadosRel2):

#block(breakable: false)[
      #drawer("Avisos")[
        *Atenção*: A armadura de tração não pode ser considerada concentrada ($a > 0.10h$).
        
        *Atenção*: A seção exige armadura dupla. Isto é um indicativo de carregamentos elevados para a geometria atual, o que pode levar a um detalhamento congestionado.
      ]
      
      #v(.2em)
      
      #drawer("Cálculos de Armadura Dupla")[
        *Armadura Dupla (Alma)*
        - Braço de alavanca limite ($z_"lim" = d - 0.5 dot lambda_c dot x_"lim"$): $29.52 "cm"$
        - Momento limite suportado pelo concreto ($M_"lim" = R_"cc" dot z_"lim"$): $83620.88 "N.m"$
        - Momento excedente ($M_"excedente" = M_"alma" - M_"lim"$): $36379.12 "N.m"$
      ]
      
      #v(.2em)
      
      #drawer("Verificação do Detalhamento Real")[
        *Recálculo com Barras Posicionadas* \
        O valor de $d$ ($90% "de" h$) usado nos cálculos teóricos foi uma estimativa. Após empacotar as barras em camadas, respeitando o cobrimento e os estribos, o centro de gravidade real foi conferido:
        
        - Altura útil efetiva ($d_"real"$): $35.36 "cm"$
        - Nova relação $x/d_"real"$: $0.458$
        
        *Balanço do Detalhamento (Aço Comercial)*
        - Área de tração requerida: $9.08 "cm"^2$
        - Área de tração fornecida: $8.63 "cm"^2$
        - Área de compressão requerida: $2.57 "cm"^2$
      ]

  
  #figure(
    [], 
    kind: image,
    caption: [Excerto do memorial de cálculo gerado pelo BeamCan para o problema 2, destacando cálculos de armadura dupla]
  ) <resultadosRel2>
]


O primeiro aviso é específico da solução adotada, e trata-se de um valor inconsistente na armadura concentrada, em função da baixa altura da viga. Uma alternativa seria considerar a opção "Menor altura de camada" no menu "Preferência de projeto", que definiria uma solução relativamente econômica sem o presente aviso.

O segundo aviso ocorre em qualquer solução para o presente problema, e serve apenas como sugestão de revisão de geometria. Este aviso sempre ocorrerá em casos que armadura dupla for necessária.

=== Viga-T sob esforços moderados

Com base no problema apresentado na @secAltosEsforcos, este será resolvido com o método da viga-T. A @prob3 apresenta o problema:

#let tmp=60%
#figure(
  pretty-table(
  columns: (tmp, 100% - tmp),

  // titles
  table.cell(text(fill: white)[*Corte*]),
  table.cell(text(fill: white)[*Dados*]),

  table.cell([
    #figure(
      canvas({
        import draw:*

        // main T-beam dimensions
        let bw = 1.5
        let h = 4
        let hf = 1.2
        let bfl = 1.5 // left flange overhang
        let bfr = 1.5 // right flange overhang
        
        // T-Beam outline
        line(
          (0, 0), 
          (bw, 0), 
          (bw, h - hf), 
          (bw + bfr, h - hf), 
          (bw + bfr, h), 
          (-bfl, h), 
          (-bfl, h - hf), 
          (0, h - hf), 
          (0, 0),
          fill: none
        )
        
        // representative bars (lower)
        for x in (bw/4, 3/4*bw) {
          circle((x, h * .1), radius: .15, fill: black)
          line((x, h * .1), (bw/2, .22 * h), stroke: (dash: "dashed"))
        }
        
        // As 
        content((bw / 2, .3 * h), $A_s$)
        
        // dims
        let dimoffx = .7
        let dimoffy = .5
        
        // d
        line((-bfl - dimoffx, h), (-bfl - dimoffx, .1*h), mark: (start: "|", end: "|"))
        content((-bfl - dimoffx - .3 , 1.1/2*h), $d$)
        
        // h
        line((-bfl - 2*dimoffx, h), (-bfl - 2*dimoffx, 0), mark: (start: "|", end: "|"))
        content((-bfl - 2 * dimoffx - .3 , 1/2*h), $h$)
        
        // bw
        line((0, -dimoffy), (bw, -dimoffy), mark: (start: "|", end: "|"))
        content((bw / 2 , -dimoffy - .3), $b_w$)
        
        // bf (top)
        line((-bfl, h + dimoffy), (bw + bfr, h + dimoffy), mark: (start: "|", end: "|"))
        content((bw / 2, h + dimoffy + .3), $b_f$)
        
        // hf (right)
        line((bw + bfr + dimoffx, h), (bw + bfr + dimoffx, h - hf), mark: (start: "|", end: "|"))
        content((bw + bfr + dimoffx + .3, h - hf/2), $h_f$)

      })
    )
  ]), // table.cell

  table.cell([
    $M_d = 120 "kN.m"$ \
    $b_w = 18 "cm"$ \
    $h = 40 "cm"$ \
    $d = 36 "cm"$ \
    $h_f = 15 "cm"$ \
    $f_(c k) = 20 "MPa"$ \
    $"Aço: CA50"$ \
    Carregamento Normal \
    Classe de Agressividade: I \
    Vão Efetivo ($L$): $8 "m"$ \
    Apoio: Simplesmente Apoiada \
    Aba Esq.: $2 "m"$ (entre vigas) \
    Aba Dir.: $3 "m"$ (borda livre)
  ])
  ),
  caption: [Problema de Viga-T],
  kind: image
) <prob3>

Novamente, após otimização das opções pelo software, fora obtida a seguinte solução, apresentada pela @sol3:

#figure(
  image("assets/screenshots/prob3_sol1.png", width: 40%),
  caption: [Solução obtida pelo BeamCan para o problema 3]
) <sol3>

Comparando a solução analítica com a proposta pelo software, nota-se, na @tabVigaTRes, que são exatamente iguais:

#figure(
  pretty-table(
    columns: (auto, 1fr, 1fr),
    
    // Cabeçalho
    text(white, weight: "bold")[Parâmetro Avaliado], 
    text(white, weight: "bold")[Resolução Analítica], 
    text(white, weight: "bold")[Resultado BeamCan],

    // Linhas de dados
    [Largura Colaborante Efetiva ($b_f$)], [$178.00 "cm"$], [$178 "cm"$],
    [Posição da Linha Neutra ($x$)], [$1.97 "cm"$], [$1.97 "cm"$],
    [Comportamento da Seção], [Falsa Viga-T ($x < h_f$)], [Falsa Viga-T ($x < h_f$)],
    [Braço de Alavanca ($z$)], [$35.21 "cm"$], [$35.21 "cm"$],
    [Área de Aço Tração ($A_s$)], [$7.84 "cm"^2$], [$7.84 "cm"^2$],
    [Área de Aço da Solução ($A_s$)], [-], [$7.50 "cm"^2$],
  ),
  caption: [Comparativo de validação numérica para seção Viga-T.]
) <tabVigaTRes>

#block(breakable: false)[
  #drawer(
    "Parâmetros de Viga T",
    [
      *Cálculo da Largura Colaborante (bf)*
      
      Distância entre nós de momento nulo (a): $800.00 "cm"$
      
      Limite de aba da NBR 6118 ($0.1 dot a$): $80.00 "cm"$
      
      Valor de a encontrado: $800 "cm"$

      *Aba Esq.* (entre vigas):
      - Comprimento real (b): $200.00 "cm"$
      - Limite geométrico ($"b_max" = 0.5 dot b$): $100.00 "cm"$
      - Contribuição efetiva min($0.1 dot a$, $b_max$): $80.00 "cm"$
      
      *Aba Dir.* (livre):
      - Comprimento real (b): 300.00 cm
      - Limite geométrico ($b_"max" = b$): 300.00 cm
      - Contribuição efetiva min($0.1 dot a$, $b_"max"$): $80.00 "cm"$
      Largura efetiva final ($"bf" = "bw" + "abas"$): $178.00 "cm"$
    ]
  )

  #v(.2em)

  #drawer(
    "Área de Aço Requerida",
    [
      *Armadura Simples*
      
      Braço de alavanca ($z = d - 0.5 dot lambda_c dot x$): $35.21 "cm"$
      
      $A_"s,alma" = M_d / (z dot f_"yd")$
      
      $A_"s,alma" = 7.84 "cm"^2$
      
      *Verificação de Armadura Máxima e Mínima (NBR 6118)*
      
      Módulo de resistência retangular ($W_0 = b_w dot h^2 / 6$): $4800.00 "cm"^3$
      
      Momento de fissuração ($M_"d,min" = 0.8 dot W_0 dot f_"ct,sup"$): 11034.41 N.m

      Área de aço máxima aceitável ($A_"s,max" = b_w dot h dot 4%$): $28.80 "cm"^2$

      Área de aço mínima exigida ($A_"s,min" = M_"d,min" / (z dot f_"yd")$): $0.72 "cm"^2$

      *RESUMO FINAL DE ÁREAS:*

      $A_s$ (Tração): $7.84 "cm"^2$

      *Balanço do Detalhamento*
      Área de tração requerida: $7.84 "cm"^2$
      
      Área de tração fornecida: $7.50 "cm"^2$
      
      Saldo Negativo (Falta): $0.34 "cm"^2$ a menos. (Aceitável dentro da tolerância de 5%).

    ]
  )

  #figure(
    [],
    kind: image,
    caption: [Excerto do memorial de cálculo gerado pelo BeamCan para o problema 3, destacando as etapas de cálculo de viga-T]
  )
]

== Performance

A criação do catálogo de soluções pelo software requer uma sequência de recursões, logo, qualquer ineficiência no motor de cálculo pode gerar tempos de carregamento extremamente longos. A escolha de utilizar o _dart_ para a execução do programa aumentou de forma considerável a performance, em testes iniciais, quando comparado ao _python_. A varredura exaustiva do espaço combinatório de barras longitudinais apresentou latência na ordem de milissegundos. O aplicativo manteve a fluidez mesmo durante o recálculo interativo acionado pelos parâmetros de otimização, justificando plenamente a escolha do _framework_ Flutter para este tipo de aplicação.

Para analisar a performance do programa, o seguinte _script_ foi concebido. Sua função é executar o cálculo de aproximadamente 3000  vigas, variando sua geometria e esforços, considerando os dois métodos de solução (retangular e viga-T). A @algoGeracaoTestes apresenta seu pseudo-código:


#figure(
  kind: "algorithm",
  supplement: [Listagem],
  caption: [Pseudocódigo do gerador automatizado para testes de estresse combinatório.],
  
  pseudocode-list(title: [*Algoritmo* Geração de Casos de Estresse])[
    + *Iniciar* lista vazia `casosDeEstresse`
    + *Iniciar* `contador` = 1
    + 
    + *Para* `bw` de 15.0 até 40.0, passo 2.0 *faça*
      + *Para* `h` de 40.0 até 120.0, passo 10.0 *faça*
        + *Para* `md` de 80.0 até 400.0, passo 25.0 *faça*
          + // 1. Seção Retangular
          + `vigaRetangular` = CriarViga(md, bw, h, fck = 25.0)
          + Adicionar `vigaRetangular` a `casosDeEstresse`
          + `contador` = `contador` + 1
          + 
          + // 2. Seção Viga-T
          + `hf` = ArredondarParaBaixo(h \* 0.20)
          + *Se* `hf` < 10.0 *então*
            + `hf` = 10.0
          + *Fim Se*
          + 
          + `vigaT` = CriarVigaT(md, bw, h, hf, fck = 25.0, apoios)
          + *Adicionar* `vigaT` a `casosDeEstresse`
          + `contador` = `contador` + 1
        + *Fim Para*
      + *Fim Para*
    + *Fim Para*
    +
    + *Retornar* `casosDeEstresse`
  ]
) <algoGeracaoTestes>

O algoritmo, então, retornou os seguintes dados:

#figure(
  image("assets/plots/performance_plot.pdf"),
  caption: [Tempo de execução em função do Número de Soluções]
) <plot1>

Da @plot1, ficam evidentes alguns comportamentos:

- Vigas retangulares tendem a possuir maior catálogo de soluções, quando comparadas com vigas-T. Isto ocorre, principalmente, pela redução do momento fletor na alma e menor espaço para distribuição de barras

- Há uma relação aproximadamente linear entre o número de soluções encontradas e a performance do programa, salvo casos em que não há solução possível.

- Mesmo em casos extremos, em que o catálogo de soluções ultrapassa mais de 2500 opções, o tempo de execução não ultrapassa o valor de $0.2 "segundos"$.

- O maior tempo de execução observado foi de $188.7 "ms"$, para uma viga retangular com 2070 soluções.

- Vigas retangulares sem solução tendem a levar $50$ a $100 "ms"$. Além disso, a adoção de Viga-T apresentou pouquíssimos casos sem solução, para o intervalo de momento apresentado na @algoGeracaoTestes.

= CONSIDERAÇÕES FINAIS

== Síntese

Diante do exposto, fica evidente que todos os objetivos apresentados foram alcançados. 

O BeamCan segue à risca os conceitos apresentados pela #norma, ao longo de todo o seu motor de cálculo, e utiliza duas diretrizes para admitir ou rejeitar soluções. Para o usuário, todos os fatores e dados obtidos da norma são referenciados no aplicativo, por meio do botão de dúvidas que acompanha determinado _widget_.

Por meio do algoritmo de empacotamento, grande diferencial do projeto, o usuário poderá escolher um vasto catálogo de soluções (quando aplicável). O menu de otimização permite a completa customização dos fatores de projeto, referentes à escolha de barras, quantidade, e outras preferências de projeto.

O processo de cálculo é dinâmico e eficiente. A adoção de _Dart_ como linguagem única, para o _frontend_ (pelo _framework_ Flutter) e _backend_ traz ao usuário uma experiência intuitiva e rápida. Pequenos erros, como inserção de valores não numéricos em campos numéricos são prontamente notificados. Além disso, em casos em que nenhuma solução é encontrada, há apresentação do memorial de cálculo para revisão das inconsistências. 

Por fim, o aplicativo sucede no uso pedagógico, apresentando uma _UI_ amigável a iniciantes e simples de ser utilizada. Por meio do memorial de cálculo, é possível comparar resultados analíticos com o software de forma rápida e objetiva. 

== Trabalhos futuros

Ao priorizar uma experiência de cálculo ágil e focada em seções isoladas, o BeamCan prescinde da modelagem da estrutura como um todo, o que o difere de soluções mais abrangentes do mercado. Nesse sentido, uma das principais melhorias previstas para o software é a implementação de um solucionador estrutural baseado no Método da Rigidez Direta. Isso viabilizaria a análise de vigas contínuas e o detalhamento da armadura transversal ao longo de todo o vão. Além disso, projeta-se a expansão do aplicativo com a criação de módulos dedicados ao dimensionamento de lajes e pilares, mantendo a mesma filosofia didática e transparente.


// ==========================================
// REFERÊNCIAS BIBLIOGRÁFICAS (Opcional, mas exigido pelo PROIC)
// Descomente e adicione seu arquivo .bib quando necessário.
// ==========================================
// #bibliography("referencias.bib", style: "associacao-brasileira-de-normas-tecnicas")

#pagebreak()

#bibliography("refs.bib", style: "associacao-brasileira-de-normas-tecnicas", title: "Referências")

/*

== Verificações de Solução <secVerSol>

=== Armadura Longitudinal Mínima e Máxima

A #norma apresenta um patamar mínimo e máximo para a área de aço longitudinal $A_s$ calculada. A armadura mínima (@eqArmMin) é determinada ao dimensioná-la em relação a um momento fletor mínimo, dada pela @eqMdMin, denominado momento de fissuração.

$ W_0 = (b_w h^2) / 6 $
$ M_(d, m i n) = 0.8 W_0 f_(c t, s u p) $ <eqMdMin>

$ A_(s, m i n) = M_(d, m i n) / (z f_(y d)) $ <eqArmMin>

No que se refere à armadura longitudinal máxima, esta é simplesmente obtida em relação à área de concreto:

$ A_(s, m a x) = 4% dot A_c = 4% dot b_w h $

=== Armadura Concentrada <secArmConcentrada>
//17-2-4-1

A #norma estabelece que a distância entre o centro de gravidade da armadura longitudinal ao ponto mais afastado da linha neutra, deve ser menor que 10% de h:

#figure(
  align(center)[
    #canvas({
      import draw: *

      // Variáveis principais da seção
let bw = 1.5
let h = 4.0

rect((0,0), (bw, h))

// Detalhamento das armaduras
let c = 0.2 // Cobrimento / altura da primeira camada
let e = 0.3 // Espaçamento vertical entre camadas
let r = 0.05 // Raio da barra

// Posição exata do centroide (CG) para 4 camadas uniformes
let d_prime = c + 1.5 * e 

// Altura útil
content((-.8, (h + d_prime) / 2), $d$)
line((-.4, d_prime), (-.4, h), mark: (start: "|", end: "|"))


// a
content((bw + 1.6, d_prime / 2), $a < 10% dot h$)
line((bw + 0.4, 0), (bw + 0.4, d_prime), mark: (start: "|", end: "|"))

// Centroide
circle((bw / 2, d_prime), radius: 0.04, fill: none, stroke: gray)
line((bw / 2 - 0.1, d_prime), (bw / 2 + 0.1, d_prime), stroke: gray)
line((bw / 2, d_prime - 0.1), (bw / 2, d_prime + 0.1), stroke: gray)


let x_coords = (c, 0.38 * bw, bw - 0.38 * bw, bw - c)

for i in range(4) {
  let y = c + i * e
  for x in x_coords {
    circle((x, y), radius: r, fill: black)
  }
}
    })
  ],
  caption: [Condição de armadura concentrada]
)

=== Armadura de Pele

De acordo com a #norma, vigas com altura ($h$) superior a $60 "cm"$ devem obrigatoriamente possuir armadura de pele instalada nas faces laterais. Seu objetivo é controlar a fissuração decorrente da retração e de tensões tangenciais na alma do concreto.

A área de aço da armadura de pele deve ser de, no mínimo, $0.10%$ da área da seção de concreto por face, não sendo necessário ultrapassar $5.0 "cm"^2/"m"$ por face.

O espaçamento vertical ($s$) entre as barras de pele deve respeitar o limite máximo estipulado pela norma:
$ s_(m a x) <= min(d / 3, 20 "cm") $

=== Condições Mínimas de Espaçamento

Para garantir que o concreto fresco penetre em todos os espaços da forma, envolva completamente as armaduras e atue em conjunto com o aço garantindo a aderência, a #norma impõe distâncias mínimas horizontais ($a_h$) e verticais ($a_v$) entre as barras longitudinais. 

Esses espaçamentos livres são dados pelas seguintes relações:



#grid(
  columns: 2,
  $ a_h >= "max"cases(2.0 "cm", phi_(l o n g), 1.2 d_(a g)) $,
  $ a_v >= "max"cases(2.0 "cm", phi_(l o n g), 0.5 d_(a g)) $
)


Em que $phi_(l o n g)$ é o diâmetro da maior barra longitudinal da camada e $d_(a g)$ é a dimensão máxima característica do agregado graúdo. A @figEspacamento ilustra geometricamente estas exigências no empacotamento das barras.


#figure(
  align(center)[
    #canvas({
      import draw: *

      // Viga base
      rect((0, 0), (4, 6), name: "beam")
      
      // Estribo
      rect((0.4, 0.4), (3.6, 6 - .4), stroke: (paint: gray, thickness: 1.5pt), radius: 0.2)
      
      // Barras (Primeira Camada)
      circle((0.8, 0.8), radius: 0.2, fill: black)
      circle((2.0, 0.8), radius: 0.2, fill: black)
      circle((3.2, 0.8), radius: 0.2, fill: black)
      
      // Barras (Segunda Camada)
      circle((0.8, 1.8), radius: 0.2, fill: black)
      circle((2.0, 1.8), radius: 0.2, fill: black)
      circle((3.2, 1.8), radius: 0.2, fill: black)

      let dimoffset = -.4
      
      // Cota: Espaçamento Horizontal Livre (ah)
      line((1.0, dimoffset), (1.8, dimoffset), mark: (start: "|", end: "|"), stroke: red)
      line((1.0, dimoffset + .15), (1.0, .8), stroke: (paint:red, dash: "dashed"))
      line((1.8, dimoffset + .15), (1.8, .8), stroke: (paint:red, dash: "dashed"))
      content((1.4, dimoffset - .2), text(red)[$a_h$])

      // Cota: Espaçamento Vertical Livre (av)
      line((4-dimoffset, 1), (4-dimoffset, 1.6), mark: (start: "|", end: "|"), stroke: blue)
      line((3.4, 1), (4-dimoffset - .2, 1), stroke: (paint:blue, dash: "dashed"))
      line((3.4, 1.6), (4-dimoffset - .2, 1.6), stroke: (paint:blue, dash: "dashed"))
      content((4 - dimoffset + .3, 1.3), text(blue)[$a_v$])
      
      // Cota: Cobrimento (c)
      line((0, dimoffset), (0.4, dimoffset), mark: (start: "|", end: "|"), stroke: green.darken(30%))
      line((0, dimoffset + .15), (0, dimoffset + .6), stroke: (paint:green.darken(30%), dash: "dashed"))
      line((.4, dimoffset + .15), (.4, .8), stroke: (paint:green.darken(30%), dash: "dashed"))
      content((.2, dimoffset - 0.2), text(green.darken(30%))[$c$])

      // Labels informativas
      //content((4.8, 1.3), text(blue)[$a_v >= max(2"cm", phi, 0.5 d_(a g))$])
      //content((4.8, 0.8), text(red)[$a_h >= max(2"cm", phi, 1.2 d_(a g))$])

    })
  ],
  caption: [Espaçamentos livres mínimos horizontais ($a_h$) e verticais ($a_v$) entre barras.]
) <figEspacamento>

Também é necessário garantir um cobrimento ($c$) mínimo, em função da classe de agressividade ambiental da região que a viga se encontra. Este, pode ser determinado pela @tabAgress.

#figure(
  pretty-table(
    columns: 4,

    table.cell(text(fill: white)[CAA]),
    table.cell(text(fill: white)[Agressividade]),
    table.cell(text(fill: white)[Risco]),
    table.cell(text(fill: white)[$c$]),

    // Line 1
    table.cell("I"),
    table.cell("Fraca"),
    table.cell("Insignificante"),
    table.cell($25 "mm"$),

    // Line 1
    table.cell("II"),
    table.cell("Moderada"),
    table.cell("Pequeno"),
    table.cell($30 "mm"$),

    // Line 1
    table.cell("III"),
    table.cell("Forte"),
    table.cell("Grande"),
    table.cell($40 "mm"$),

    // Line 1
    table.cell("IV"),
    table.cell("Muito Forte"),
    table.cell("Elevado"),
    table.cell($50 "mm"$),
    
    
  ),

  caption: [Valores do cobrimento em relação à classe de agressividade. @ABNT6118]
) <tabAgress>

*/