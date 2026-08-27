#import "misc.typ": *

#let A_var = (
    (1, 2, 0),
    (2, 4, 1),
    (0, 1, 3),
  )

#let b_var = (1, 0, 2)

#let problem_a = [
  
  #let a_solution = 0

  #for i in range(3) {
    a_solution += A_var.at(i).at(i)
  }

  *a)* $bold(A)_(i i)$

    $
      bold(A)_(i i) -> sum_i^3 bold(A)_(i i) = #(
        for i in range(1,4) {
        [$A_(#i #i)$]
        if (i != 3) {
          [$+$]
        }
      }) = "trace"(A) = #a_solution
    $
]

#let problem_b = [
  #let b_solution = (0, 0, 0)
  #for i in range(0,3) {
    let v = 0
    for j in range(0, 3) {
      v += A_var.at(i).at(j) * b_var.at(j)
    }
    b_solution.at(i) = v
  }

  *b)* $bold(A)_(i j) bold(b)_j$

    $
      c_i =
      A_(i j) b_j
      ->
      sum_j^3
      A_(i j) b_j
      =
      #(
        for j in range(1,4) {
        [$A_(i #j) b_(#j)$]
        if (j != 3) {
          [$+$]
        }
      })
      =
    $

    $
      =
      #(
        vec2mat(
          (
            $A_(1 1) b_1 + A_(1 2) b_2 + A_(1 3) b_3$ ,
            $A_(2 1) b_1 + A_(2 2) b_2 + A_(2 3) b_3$ ,
            $A_(3 1) b_1 + A_(3 2) b_2 + A_(3 3) b_3$ ,
          )
        )
      )
      = #vec2mat(b_solution)
    $
]

#let problem_c = [
  #let c_solution = (0, 0, 0)

  #for i in range(0,3) {
    let v = 0
    for j in range(0, 3) {
      v += A_var.at(j).at(i) * b_var.at(j)
    }
    c_solution.at(i) = v
  }

  *c)* $A_(j i) b_j$

    $
      c_i =
      A_(j i) b_j
      ->
      sum_j^3
      A_(j i) b_j
      =
      #(
        for j in range(1,4) {
        [$A_(#j i) b_(#j)$]
        if (j != 3) {
          [$+$]
        }
      })
      =
    $

    $
      =
      #(
        vec2mat(
          (
            $A_(1 1) b_1 + A_(2 1) b_2 + A_(3 1) b_3$ ,
            $A_(1 2) b_1 + A_(2 2) b_2 + A_(3 2) b_3$ ,
            $A_(1 3) b_1 + A_(2 3) b_2 + A_(3 3) b_3$ ,
          )
        )
      )
      = #vec2mat(c_solution)
    $

    #text(fill: red.darken(65%))[Note: results for $(b)$ and $(c)$ are the same by coincidence]
]

#let problem_d = [
  #let d_literal = ()
  #let d_solution = (
    (0,0,0),
    (0,0,0),
    (0,0,0),
  )
  #for i in range(0,3) {
    let ar = ()
    for j in range(0, 3) {
      let v = b_var.at(i) * b_var.at(j)
      d_solution.at(i).at(j) = v
      ar.push($b_#(i+1) b_#(j+1)$)
    }
    d_literal.push(ar)
  }


  *d)* $b_i b_j$

    $
      A_(i j) = b_i b_j
      = 
      #array2mat(d_literal)
      =
      #array2mat(d_solution)
    $
]

#let problem_e = [
  #let e_literal = ()
  #let e_solution = 0

  #for i in range(1,4) {
    let line = ()
    for j in range(1, 4) {
      line.push([$A_(#i #j) A_(#j #i)$])
      e_solution += A_var.at(i - 1).at(j - 1) * A_var.at(j - 1).at(i - 1)
    }
    e_literal.push(line.join(" + "))
  }

  #let e_literal = e_literal.join("+\n")

  *e)* $A_(i j) A_(j i)$
      
      $
        alpha = sum_i^3 sum_j^3
        A_(i j) A_(j i)
        =
      $
      #align(center)[#e_literal]
      $
        = #e_solution
      $
]

#cell(
  "Problem 1.1.1",
  [
    Given the tensors

    $
      bold(A) = #(array2mat(A_var))
      "and"
      bold(b) = #(vec2mat(b_var))
    $

    Solve:
  ],
  [
    #problem_a
    #problem_b
    #problem_c
    #problem_d
    #problem_e
    
  ]
)

#let problem_a = [
  *a)* $a_i b_i$

  $
  alpha = a_i b_i
  =
  sum_i^3 a_i b_i
  =
  bold(a) dot bold(b)
  $
]

#let problem_b = [
  *b)* $a_i b_k c_k$

  $
    c_i = a_i sum_k^3 b_k c_k
    ->
    bold(c) = bold(a) dot (bold(b) dot bold(c))
  $
]

#let problem_c = [
  *c)* $A_(i k) B_(k j)$

  #let c_literal = (
    (),
    (),
    (),
  )

  #for i in range(0, 3) {
    for j in range(0, 3) {
      let cur_str = ()
      for k in range(1, 4) {
        cur_str.push([$A_(#(i+1) #k) B_(#k #(j+1))$])
      }
      c_literal.at(i).push(cur_str.join(" + "))
    }
  }

  $
    C_(i j) = A_(i k) B_(k j) =
  $
  $
    sum_k^3 A_(i k) B_(k j) -> 
  $
  $
    #array2mat(c_literal)
  $
  $
    = bold(A) dot bold(B)
  $
]

#let problem_d = [
  *d)* $A_(k i) B_(k l) A_(l j)$

  Assuming the answer as $D_(i j)$, since only i and j are non repeating, assume
  $
  C_(i l) = A_(k i) B_(k l) -> bold(C) = bold(A)^T dot bold(B)
  $
  Then
  $
    D_(i j) = C_(i l) A_(l j) -> bold(D) = bold(C) dot bold(A)
  $
  Finally
  $
    bold(D) = bold(A)^T dot bold(B) dot bold(A)
  $

  Another approach is:

  Assume

  $
    E_(k j) = B_(k l) A_(l j) -> bold(E) = bold(B) dot bold(A)
  $

  Then

  $
    D_(i j) = A_(k i) E_(k j) -> bold(D) = bold(A)^T dot bold(E)
  $

  Which, of course, results in the same value!

  $
    bold(D) = bold(A)^T dot bold(B) dot bold(A)
  $
  
]

#let problem_e = [
  *e)* $a_i A_(j k) b_k$

  #let e_literal_1 = ()

  #for k in range(1,4) {
    e_literal_1.push($A_(j #k) b_#k$)
  }

  #let e_literal_2 = (
    (),
    (),
    (),
  )

  #for i in range(3) {
    for j in range(3) {
      e_literal_2.at(i).push($a_#(i+1) c_#(j+1)$)
    }
  }

  Let the answer be a matrix $D_(i j)$.

  Let $c_j = A_(j k) b_k$

  $
    c_j = #(e_literal_1.join("+")) -> bold(c) = bold(A) dot bold(b)
  $

  then, 

  $
    D_(i j) = a_i c_j -> array2mat(#e_literal_2) = bold(a) dot bold(c)^T
  $

  Thus

  $
    bold(D) = bold(a) dot (bold(A) dot bold(b))^T 
  $

  


]

#let problem_f = [
  *f)* $a_i A_(i k) b_k$

  From the previous question, we know that

  $
    c_i = A_(i k) b_k -> bold(c) = bold(A) dot bold(b)
  $

  And, simply

  $
    alpha = a_i c_i = bold(a) dot bold(c) 
  $

  The answer is

  $
    alpha = bold(a) dot bold(A) dot bold(b)
  $
]

#cell(
  "Problem 1.1.2",
  [
    Given the expressions in index notation, write the corresponding expressions in abstract tensor notation.
  ],
  [
    #problem_a
    #problem_b
    #problem_c
    #problem_d
    #problem_e
    #problem_f
  ]
)


#cell(
  "Problem 1.2.1",
  [
    Show that $delta_(i j) delta_(j i) = 3$.
  ],
  [
    #let I = (
      (1,0,0),
      (0,1,0),
      (0,0,1),
    )
    #let literal = ()
    #let result = 0

    #for i in range(3) {

      for j in range(3) {
        result += I.at(i).at(j) * I.at(j).at(i)
      }

    }


    $
      delta_(i j) delta_(j i)
      =
      array2mat(#I)
      dot
      array2mat(#I)^T
      =
      1 dot 1 + 1 dot 1 + 1 dot 1
      =
      #result
    $

  ]
)

#cell(
  "Problem 1.2.2",
  [
    Find the expression in index notation for

    $
      #partial_frac(
        $bold(v)$,
        $bold(v)$
      )
    $

    where $bold(v)$ is a vector.
  ],
  [
    #let literal = ()

    #for i in range(1,4) {
      let arr = ()
      for j in range(1,4) {
        arr.push(
          partial_frac(
            $v_#i$,
            $v_#j$,
          )
        )
      }
      literal.push(arr)
    }
    $
      bold(A)
      =
      #partial_frac(
        $bold(v)$,
        $bold(v)$
      )
      =
      #array2mat(
        literal
      )
      ->
      A_(i j)
      =
      #partial_frac(
        $v_i$,
        $v_j$
      )
    $

    It is known that

    $
      #partial_frac(
        $v_l$,
        $v_m$
      )
      =
      cases(
        1 "if" l = m,
        0 "else"
      )
    $
    Then it is safe to assume that

    $
      #partial_frac(
        $v_i$,
        $v_j$
      )
      =
      delta_(i j)
    $
  ]
)

#cell(
  "Problem 1.2.3",
  [
    With the aid of the Kronecker delta, find the expression in index notation for the trace of $bold(a) bold(b)^T$  where $bold(a)$ and $bold(b)$ are vectors.
  ],
  [
    $
      alpha
      =
      "trace"(bold(a) bold(b)^T)
      =
      a_i b_j delta_(i j)
    $

    With the contraction property

    $
      b_j delta_(i j) = b_i
    $

    $
      alpha = a_i dot b_i = bold(a) dot bold(b)
    $
  ]
)

#cell(
  "Problem 1.2.4",
  [
    Simplify the expression 

    $
      (partial ^2) / (partial x_i partial x_j) (x_i x_j)
    $
  ],
  [
    $
      (partial ^2) / (partial x_i partial x_j) (x_i x_j)
      =
      #partial_frac(
        $$,
        $x_i$,
      ) (
        #partial_frac(
          $x_i$,
          $x_j$
        ) x_j
        +
        #partial_frac(
          $x_j$,
          $x_j$
        ) x_i
      )
      =
    $

    $
      =
      #partial_frac(
        $$,
        $x_i$,
      ) (
        0 + delta_(j j) x_i
      )
      =
      3
      #partial_frac(
        $$,
        $x_i$,
      ) (
        x_i
      )
      =
      3 delta_(i i)
      =
      9
    $
  ]
)

#let leci-vita-arr = range(1,4).map(
  i => range(1,4).map(
    j => range(1,4).map(
      k => leci-vita((i, j, k))
    )
  )
)


#cell(
  "Problem 1.3.1",
  [
    Show that

    $
      epsilon.alt_(i j k) a_i a_j = 0
    $
  ],
  [
    #let literal_a = range(1,4).map(
      i => range(1,4).map(
        j => $a_#i a_#j$
      )
    )

    #let literal_b = range(1, 4).map(k => {
      let terms = ()
      // Sum over dummy indices i and j
      for i in range(1, 4) {
        for j in range(1, 4) {
          let val = leci-vita((i, j, k))
          if val != 0 {
            // Format the sign and the variables
            let sign = if val == 1 { $+$ } else { $-$ }
            terms.push($#sign a_#i a_#j$)
          }
        }
      }
      terms.join() 
    })

    *By brute force...*

    Let $A_(i j) = a_i a_j$

    $
      #array3mat(leci-vita-arr)
      dot
      #array2mat(literal_a)
      =
      #vec2mat(literal_b)
      =
      #vec2mat((0,0,0))
    $

    *By triviality*

    Multiplying both sides by the cartesian basis vector:

    $
      epsilon.alt_(i j k) a_i a_j dot bold(hat(e))_i = 0 dot bold(hat(e))_i = 0
    $

    The expression above is the cross product of the vector $bold(a)$.

    $
      epsilon.alt_(i j k) a_i a_j dot bold(hat(e))_i 
      =
      bold(a)
      times
      bold(a)
    $
    By definition, the cross product of a vector by itself is 0, since they are colinear.
  ]
)

#cell(
  "Problem 1.3.2",
  [

  ],
  [
    
  ]
)

#cell(
  "Problem 1.3.3",
  [

  ],
  [
    
  ]
)

#cell(
  "Problem 3.5.?",
  [
    Considering that $s_(i j) = sigma_(i j) - 1/3 sigma_(k k)delta_(i j)$. Calculate
    $
      #partial_frac($bold(s)$, $bold(sigma)$)
    $
  ],
  [
    $
      #partial_frac($bold(s)$, $bold(sigma)$)
      =
      #partial_frac($$, $sigma_(k l)$)
      (sigma_(i j) - 1/3 I_1 delta_(i j))
      =
      delta_(i k) delta_(j l) - 1/3 #partial_frac($I_1$, $sigma_(k l)$) delta_(i j)
      =
      delta_(i k) delta_(j l) - 1/3 delta_(i j) delta_(k l)
    $
    $
      #partial_frac($bold(s)$, $bold(sigma)$)
      =
      bold(II) - 1/3 bold(I) times.o bold(I)
    $
  ]
)