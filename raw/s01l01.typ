#import "@preview/fletcher:0.5.5": *
#import "@preview/lovelace:0.3.1": line-label
#import "../functions.typ": pseudocode-alg, pseudocode-alg-nt, c_red, c_lblue

#cite(label("ads-s1-e1"), form: none)

== What is an algorithm?

An algorithm is a formalised way to solve a problem. Taking input parameters of the problem (e.g. position, temperature), it outputs the solution to it (e.g. next move, energy needed).

#align(center, diagram(
  node-shape: shapes.rect,
  node-stroke: 0.5pt,
  node((0, 0), "Input data", name: <I>),
  node((+1, 0), "Algorithm", name: <A>),
  node((+2, 0), "Output data", name: <O>),

  edge(<I>, "->", <A>),
  edge(<A>, "->", <O>),
))

For example, given an array $(A_i | i in bracket.stroked.l 1, n bracket.stroked.r)$ we can make the @array-sum to compute $sum_(i) A_i$.

#pseudocode-alg(title: [Sum of an array])[
    - s = 0 
    - *for* i = 1..=n 
      - s += $A_i$
    - return s
] <array-sum>


== Time complexity

We denote the time complexity function as $T$ taking in parameter the size / value of the parameters (e.g. for @array-sum, we want to compute $T(n)$ were $n$ is the size of the inputted array). \ 
The unit or the complexity is the _number of operations_. To know how to calculate the number of operation, we need a computational model (i.e. a mathematical abstraction that is a simplified version of our processor). 

=== Random Access Machine Model

In the Random Access Machine (RAM) model, our memory is a big array of size $n$ ($(A_i | i in bracket.stroked.l 1, n bracket.stroked.r)$). We can access an element $A_i$ of the memory in constant time (which is not the case of all computational model).

If we take back @array-sum, we have: 
- 1 operation to instantiate $s$. 
- $n$ iterations of the *for* loop with: 
  - 2 operations for: increment $i$ and compare it to $n$. 
  - 3 operations for: adding $A_i$ to $s$. 
- 1 operation to return $s$.

In the end, we have: $ T(n) = 2 + 5n $

== Big-O notation

=== Big-$Omicron$

$
       forall n in NN, f(n) = Omicron(g(n)) 
  <==> exists n_(0), c in NN | forall n gt.slant n_(0), f(n) lt.slant c dot g(n)
$

Let's prove that for @array-sum, $T(n) = Omicron(n)$. We use the previous definition with $f(n) = T(n)$ and $g(n) = n$. \ With $n_0 = 2$ and $c = 6$, we obtain: $f(2) = 10 lt.slant 6 dot g(2) = 12$. 

The $Omicron(.)$ represent an asymptotic upper bound. This means that if a function $f$ is $Omicron(g)$ bounded, we can be certain that $f$ does not grow faster than $g$. \ 
This is generally the bound we aim to establish when analysing algorithms, as it provides a guarantee of our worst-case performance for large size input. It is often the simplest bound to prove because it only requires the dominant term that limits the growth rate. \ 
In other words, proving $Omicron$ is sufficient that we are fast enough. 

=== Big-$Omega$

$
       forall n in NN, f(n) = Omega(g(n)) 
  <==> exists n_(0), c in NN | forall n gt.slant n_(0), f(n) gt.slant c dot g(n)
$

Let's prove that for @array-sum, $T(n) = Omega(n)$. We use the previous definition with $f(n) = T(n)$ and $g(n) = n$. \ With $n_0 = c = 1$, we obtain: $f(1) = 7 gt.slant g(1) = 1$. 

The $Omega(.)$ represent an asymptotic lower bound. This means that is a function $f$ is $Omega(g)$ bounded, we can be certain that $f$ grows at least as fast as $g$. \ 
This is generally used when we want to prove that a problem requires a minimum amount of computational resources. \ 
In other words, proving $Omega$ is useful to show that we are not faster than. 

=== Big-$Theta$

This represent a tight bound, meaning that our function $f$ is bounded above and below by the same growth rate $g$. Formally:  

$
       forall n in NN, f(n) = Theta(g(n)) 
  & <==> exists n_(0), c_1, c_2 in NN | forall n gt.slant n_(0), c_2 dot g(n) gt.slant f(n) gt.slant c_1 dot g(n) \
  & <==> forall n in NN, f(n) = Omicron(g(n)) and f(n) = Omega(g(n))
$

For @array-sum, we proved that both bound so we have $T(n) = Theta(n)$. 

Here, $f$ grows precisely the same way as $g$ ignoring constant factors. This is the bound we try to prove when we invent a new algorithm to show that its behaviour is consistent across all input size.

=== Common time complexity <common-compl>

#grid(
  columns: (1fr, 1fr, 1fr), 
  column-gutter: 0pt,
  pseudocode-alg-nt(title: [For loop ($Omicron(n)$)])[- *for* i = 1..=n ],
  pseudocode-alg-nt(title: [For loop ($Omicron(n^2)$)])[
    - *for* i = 1..=n 
      - *for* j = 1..=n
  ],
  pseudocode-alg-nt(title: [For loop ($Omicron(n^2)$)])[
    - *for* i = 1..=n 
      - *for* j = 1..=i
  ]
)

#linebreak()
For loop are trivial, while loop can be trickier:

#grid(
  columns: (1fr, 1fr), 
  column-gutter: 0pt,
  pseudocode-alg-nt(title: [While loop ($Omicron(sqrt(n))$)])[
    - i = 1
    - *while* i \* i $lt.slant$ n
      - i += 1
  ],
  pseudocode-alg-nt(title: [While loop ($Omicron(log_2n) = O(log n)$)])[
    - i = 1
    - *while* i $lt.slant$ n
      - i += 2
  ],
  [
    
  ]
)

_Constant does not affect asymptotic time_.

== Recursive algorithms

A recursive function $f$ is a function that call itself, to compute its complexity like we did for @array-sum, we need to calculate 2 things: 
- the number of operation in one $f$ (the same way we did for @array-sum). 
- the number of time a call to $f$ is made. 

=== Examples

#let call_tree_note = [
  A *call tree* is a graph/tree where nodes represent individual function invocations. Edges are directed from the caller to the callee. In recursive algorithms, the total node count reflects the algorithm's time complexity, it is also useful to calculate memory usage and call stack size. For more info see @call-tree. 
]

#grid(
  columns: (40%, 1fr), 
  row-gutter: 10pt,
  align: horizon,
  pseudocode-alg-nt(title: "Example 1")[
    - fun m :: n:int -> void 
      - if n == 0 
        - return 
      - minus n-1
  ], 
  [
    Here, we execute a constant number of operation each time we call $m$ (check if $n = 0$ and call $m$ decrementing $n$). And, we call $m$ $n$ times. Therefore, complexity of $m$ is $Omicron(n)$.
  ], 
  pseudocode-alg-nt(title: "Example 2")[
    - fun h :: n:int -> void 
      - if n == 0 
        - return 
      - h n/2
  ],
  [
    In this example, we do the same constant amount of operation in each call to $h$ than with $m$. But, we call: 

    #align(center, diagram(
      $
        h(n) edge(->, shift: #0pt) & h(n / 2) edge(->, shift: #0pt) & h(n / 4) edge(->, shift: #0pt) & ... edge(->, shift: #0pt) & h(0)
      $,
    ))
    
    which make $log n$ recursive call. Overall the complexity of $h$ is $Omicron(log n)$.
  ], 
  pseudocode-alg-nt(title: "Example 3")[
    - fun h :: n:int -> void 
      - if n == 0 
        - return 
      - h n/2
      - h n/2
  ],
  [
    Again, we have the same constant number of operation inside $h$ but instead of making one recursive call, we do two of them. The call-tree#footnote(call_tree_note) of the function (@call-2) allows us to compute the number of call to $h$ by counting its number of node. Therefore, our function complexity is the bound of the node number. \
    We call the total number of nodes $c$. We have: 
    $
      c = 1 + 2 + 4 + dots.h + 2^H "where" H = "tree height" 
    $
    In our case, the height of the calling tree is $log_2 n$. The time complexity of $h$ is: 
    $T(h(n)) & = Omicron(2^(log_2 n)) = Omicron(n)$
  ], 
  pseudocode-alg-nt(title: "Example 4")[
    - fun h :: n:int -> void 
      - if n == 0 
        - return 
      - h n/2
      - h n/2
      - h n/2
  ], 
  [
    We use the same technique as before graphing the call-tree (@call-3). \ 
    The height of the tree is the same but the total number of call will now be $Omicron(3^H)$ because we make three recursive call to 
    
    The time complexity for this new $h$ is: 
    $
      T(h(n)) = Omicron(3^(log_2 n)) = Omicron(n^(log_2 3)) tilde.eq Omicron(n^1.7)
    $
  ]
) 

#let first-layer = $h(n / 2)$
#let second-layer = $h(n / 4)$
#let last-layer = $h(0)$
#let (N, H, I, Q, R, S, T, L, M, O, P, U, V, W, Y) = (
      (-1.5, 0),
      (-2.75, 1),
      (-0.25, 1),
      (-3.25, 2),
      (-2.25, 2),
      (-0.75, 2),
      (0.25, 2),
      (-3.5, 3),
      (-3, 3),
      (-2.5, 3),
      (-2, 3),
      (-1, 3),
      (-0.5, 3),
      (0, 3),
      (0.5, 3),
    )

#figure(
  caption: [Call tree making two recursive call.],
  align(center, diagram(  
    node(N, $h(n)$),
  
    node(H, first-layer),
    node(I, first-layer),
  
    node(Q, second-layer),
    node(R, second-layer),
    node(S, second-layer),
    node(T, second-layer),
  
    node(L, last-layer),
    node(M, last-layer),
    node(O, last-layer),
    node(P, last-layer),
    node(U, last-layer),
    node(V, last-layer),
    node(W, last-layer),
    node(Y, last-layer),
  
    edge(N, H, "->"),
    edge(N, I, "->"),
  
    edge(H, Q, "->"),
    edge(H, R, "->"),
    edge(I, S, "->"),
    edge(I, T, "->"),
  
    edge(Q, L, "--"),
    edge(Q, M, "--"),
    edge(R, O, "--"),
    edge(R, P, "--"),
    edge(S, U, "--"),
    edge(S, V, "--"),
    edge(T, W, "--"),
    edge(T, Y, "--"),
  
    edge((1.5, 0), (1.5, 3), "<->", stroke: c_red, label: text(c_red, $H = log_2 n$), label-side: left, label-angle: right),

    node((-4.5, 0), text(c_red, $1 "call "$)),
    node((-4.5, 1), text(c_red, $2 "calls "$)),
    node((-4.5, 2), text(c_red, $4 "calls "$)),
    node((-4.5, 3), text(c_red, $2^H "calls "$)),

    edge((-4.5, 2), (-4.5, 3), "--", stroke: c_red),
  ))
) <call-2>

#figure(
  caption: [Call tree making two recursive call.],
  align(center, diagram(
    let (N, H, I, G, Q, R, J, S, T, K, E, F, X, L, M, O, P, U, V, W, Y, A, B, C, D) = (
      (-0.75, 0),
      (-3, 1),
      (-0.75, 1),
      (1.5, 1),
      (-3.75, 2),
      (-2.25, 2),
      (-3, 2),
      (-1.5, 2),
      (0, 2),
      (-0.75, 2),
      (0.75, 2),
      (2.25, 2),
      (1.5, 2),
      (-4.25, 3),
      (-3.75, 3),
      (-2.75, 3),
      (-2.25, 3),
      (-1.5, 3),
      (-1, 3),
      (-0.5, 3),
      (0, 3),
      (0.75, 3),
      (1.25, 3),
      (1.75, 3),
      (2.25, 3),
    ),
  
    node(N, $h(n)$),
  
    node(H, first-layer),
    node(I, first-layer),
    node(G, first-layer),
  
    node(Q, second-layer),
    node(R, second-layer),
    node(J, second-layer),
    node(S, second-layer),
    node(T, second-layer),
    node(K, second-layer),
    node(E, second-layer),
    node(F, second-layer),
    node(X, second-layer),
  
    edge(N, H, "->"),
    edge(N, I, "->"),
    edge(N, G, "->"),
  
    edge(H, Q, "->"),
    edge(H, R, "->"),
    edge(H, J, "->"),
    edge(I, S, "->"),
    edge(I, T, "->"),
    edge(I, K, "->"),
    edge(G, E, "->"),
    edge(G, F, "->"),
    edge(G, X, "->"),
  
    let dx = 0,
    let y = 0.75,
    edge(Q, (-3.75, 3), "--"),
    edge(R, (-3.75 + 2 * y, 3), "--"),
    edge(J, (-3.75 + y, 3), "--"),
    edge(S, (-3.75 + 3 * y, 3), "--"),
    edge(T, (-3.75 + 5 * y, 3), "--"),
    edge(K, (-3.75 + 4 * y, 3), "--"),
    edge(E, (-3.75 + 6 * y, 3), "--"),
    edge(F, (-3.75 + 8 * y, 3), "--"),
    edge(X, (-3.75 + 7 * y, 3), "--"),
  
    let dx = 0.2,
    let y = 0.75,
    edge(Q, (-3.75 + dx, 3), "--"),
    edge(R, (-3.75 + 2 * y + dx, 3), "--"),
    edge(J, (-3.75 + y + dx, 3), "--"),
    edge(S, (-3.75 + 3 * y + dx, 3), "--"),
    edge(T, (-3.75 + 5 * y + dx, 3), "--"),
    edge(K, (-3.75 + 4 * y + dx, 3), "--"),
    edge(E, (-3.75 + 6 * y + dx, 3), "--"),
    edge(F, (-3.75 + 8 * y + dx, 3), "--"),
    edge(X, (-3.75 + 7 * y + dx, 3), "--"),
  
    let dx = -0.2,
    let y = 0.75,
    edge(Q, (-3.75 + dx, 3), "--"),
    edge(R, (-3.75 + 2 * y + dx, 3), "--"),
    edge(J, (-3.75 + y + dx, 3), "--"),
    edge(S, (-3.75 + 3 * y + dx, 3), "--"),
    edge(T, (-3.75 + 5 * y + dx, 3), "--"),
    edge(K, (-3.75 + 4 * y + dx, 3), "--"),
    edge(E, (-3.75 + 6 * y + dx, 3), "--"),
    edge(F, (-3.75 + 8 * y + dx, 3), "--"),
    edge(X, (-3.75 + 7 * y + dx, 3), "--"),
  
    edge((2.75, 0), (2.75, 3), "<->", stroke: c_red, label: text(c_red, $H = log_2 n$), label-side: left, label-angle: right),
  ))
) <call-3>

== Sorting

#let in_place = [
  An algorithm is considered in-place if it transforms its input using a constant amount of auxiliary space. In the context of sorting, this means the algorithm reorganises the elements within the original array a rather than allocating and returning $A$ new array $B$. This approach allows better memory performances and avoid some performance costs about dynamic memory allocations. 
]

A sorting algorithm is an algorithm that takes an array $A$ of sortable elements (i.e. numbers, strings) as input and output an array $B$ of the same elements but in sorted order. _We can also make sorting algorithm that sorts elements in-place#footnote(in_place)._ In our examples, the arrays are of length $n$ and contains integers for simplicity. 

=== Insertion sort

Insertion sort is the first sort algorithm we learn largely because it is intuitive; it is analogous to what we do when we sort cards when playing board games. It is an in-place sorting algorithm. 

==== Algorithm

The principle is easy, to sort the element $A_i$, we swap $A_i$ with the previous element $A_(i-1)$ while $A_i lt.slant A_(i-1)$. \ Let's schematise the insertion sort with the array $A[3,1,4,2]$.

#grid(
  columns: (40%, 1fr), 
  row-gutter: 10pt,
  align: horizon,
  figure( 
  caption: [Insertion sort for $A[3,1,4,2]$],
    align(center, diagram(
      node-stroke: 1pt + c_red,
      node-shape: rect,
    
      let (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) = (
        (0, 0),
        (0.5, 0),
        (1, 0),
        (1.5, 0),
        (0, 1),
        (0.5, 1),
        (1, 1),
        (1.5, 1),
        (0, 2),
        (0.5, 2),
        (1, 2),
        (1.5, 2),
        (0, 3),
        (0.5, 3),
        (1, 3),
        (1.5, 3),
      ),
    
      node(a, $3$, stroke: c_lblue),
      node(b, $1$),
      node(c, $4$),
      node(d, $2$),
    
      node(e, $1$, stroke: c_lblue),
      node(f, $3$, stroke: c_lblue),
      node(g, $4$),
      node(h, $2$),
    
      node(i, $1$, stroke: c_lblue),
      node(j, $3$, stroke: c_lblue),
      node(k, $4$, stroke: c_lblue),
      node(l, $2$),
    
      node(m, $1$, stroke: c_lblue),
      node(n, $2$, stroke: c_lblue),
      node(o, $3$, stroke: c_lblue),
      node(p, $4$, stroke: c_lblue),
    
      edge(b, a, "<->", bend: +90deg),
      edge((1, 1.5), g, "->"),
      edge(l, k, "<->", bend: +90deg),
      edge(k, j, "<->", bend: +90deg),
    ))
  ),
  [
    #pseudocode-alg(title: "Insertion sort")[
      - fun insertion_sort :: A:[int] -> void
        + #line-label(<for-insert>) for i = 1..n-1
          - j = i 
          + #line-label(<while-insert>) while j > 0 and $A_j < A_(j-1)$
            - swap $A_j$ $A_(j-1)$
            - j -= 1
        - return 
    ] <insert-sort>
  ]
)

Let's prove that this algorithm is correct using *for-loop* invariant on @for-insert.  To do that, we have to prove that after iteration $i$ of @for-insert, the array $A$ is sorted from index $0$ to $i$ (i.e. $A_(0:i)$ is sorted). \
Using induction: 
- Before the first iteration, the slice of $a$ from index $0$ to $0$ is sorted. 
- At the $i^"th"$ iteration, we have $A_(0:i-1)$ sorted. We are swapping $A_j$ until $A_j gt.slant A_(j-1)$ and the previous iteration of @while-insert gives us that $A_j < A_(j+1)$. So, at the end we have: $A_(j-1) lt.slant A_j < A_(j+1) lt.slant A_i$ (i.e. we have sorted a new element in a previously sorted array).
- When we have iterated over all the $n$ elements of $A$, we have sorted the entire array. 

==== Complexity

Now, let's calculate the algorithm complexity. What is tricky here is that the complexity may vary from an input to another.

===== Best case

The best case complexity of insertion sort is when the array is already sorted. Indeed, we do not enter the while-loop so we have a constant operation by iteration of @for-insert so we have a complexity of $Omicron(n)$. 

===== Worst case

The worst case of execution is when the array is sorted invertedly of the way we want to sort it (i.e. sorted in decreasing order for @insert-sort). In this case, we iteration over @while-insert up until $j = 1$ each time. So the complexity is $Omicron(n^2)$. \
Without assumption or specific understanding of input, we always take the worst case complexity for the study of algorithms. 

==== Usefulness 

Since the overhead (i.e. the constant value in front of $n^2$ inside $T("insertion_sort"(n))$) is smaller than in algorithm with better asymptotic complexity, it is faster for small input size (up until $n tilde.eq 2^5 "or" 2^6$). \
This is why algorithms of standard libraries generally uses hybrid algorithms that use an algorithm with faster asymptotic --- such as merge sort#footnote[see @merge-sort] or quick-sort#footnote[see TODO add ref to section 3.2] --- when input is large and switch to insertion sort when input is small enough. 

It is also useful when you know you are in a case where the array is almost sorted. Here the algorithm will be really fast. 

=== Merge sort <merge-sort>

#let divide_conquer = [
  The Divide & Conquer method is an important piece of algorithm methodology. It consists of breaking a problem into smaller sub-problems that are simpler to solve. We then solve all the simpler sub-problems individually, and we merge their solutions to reach the answer to our main problem. It is used to solve many common problems efficiently (e.g. Multiplication, Fast Fourier Transform). For more insight on this technique see @divide-conquer
]

As a second study on sorting, we will examine merge sort. A very common algorithm and arguably the most straightforward method to achieve a better complexity than $Omicron(n^2)$ --- precisely $Omicron(n log n)$. \
This algorithm uses two functions to work. The main one is a recursive sort function based on the Divide & Conquer#footnote[#divide_conquer] method. 

The logic behind it is following three steps: 
- Divide: we divide recursively the array until it is divided in $n$ sub-arrays of length one.  
- Conquer: we recognise that an array of length one is sorted. 
- Merge: we recursively combine these small arrays into larger sorted ones until the entire array is reconstructed in order.

==== Merge function

Let's begin with the last step: merge two sorted array into one sorted array containing all the elements of the two array.

#let two-pointer = [
  The two-pointer technique is a algorithmic technique using two indices (or pointers) to go through a linear data structure --- such as array or linked lists (we will cover them in @ TODO add linked list link) --- simultaneously. Moving the pointers at different speed or directions (e.g. one from left to right and the other from right to left until they cross), we can solve problems involving searching, merging, or partitioning avoiding other method using nested for-loop. Thus, making the complexity $Omicron(n)$ instead $Omicron(n^2)$.
]

To achieve this, we use the two pointer technique#footnote[#two-pointer], let's see the working of the algorithm using an example: we have $A[1,5,10]$ and $B[2,4,6]$ let's merge them into a sorted array $C$ containing the elements of both $A$ and $B$: 

#let (a, a1, a2, a3, b, b1, b2, b3, cmp, c, c1, c2, c3) = (
    (0, 0),
    (0.25, 0),
    (0.5, 0),
    (0.75, 0),
    (0, 0.75),
    (0.25, 0.75),
    (0.5, 0.75),
    (0.75, 0.75),
    (2, 0),
    (1.75, 0.75),
    (2, 0.75),
    (2.25, 0.75),
    (2.5, 0.75),
  )
#align(center, diagram(
  node(a, $A |$),
  node(a1, $1$),
  node(a2, $5$),
  node(a3, $10$),
  node(b, $B |$),
  node(b1, $2$),
  node(b2, $4$),
  node(b3, $6$),

  edge((0.25, 0.4), a1, "->", $i$, label-side: right),
  edge((0.25, 1.15), b1, "->", $j$, label-side: right),

  edge((1.25, -0.25), (1.25, 1)),

  node(cmp, $A_i < B_j$),

  node(c, $C |$),
  node(c1, $1$),
  node(c2, " "),
  node(c3, " "),
))


#align(center, diagram(
  node(a, $A |$),
  node(a1, $cancel(1, stroke: #(paint: c_red, thickness: 1pt))$),
  node(a2, $5$),
  node(a3, $10$),
  node(b, $B |$),
  node(b1, $2$),
  node(b2, $4$),
  node(b3, $6$),

  edge((0.5, 0.4), a2, "->", $i$, label-side: right),
  edge((0.25, 1.15), b1, "->", $j$, label-side: right),

  edge((1.25, -0.25), (1.25, 1)),

  node(cmp, $A_i > B_j$),

  node(c, $C |$),
  node(c1, $1$),
  node(c2, $2$),
  node(c3, " "),
))


#align(center, diagram(
  node(a, $A |$),
  node(a1, $cancel(1, stroke: #(paint: c_red, thickness: 1pt))$),
  node(a2, $5$),
  node(a3, $10$),
  node(b, $B |$),
  node(b1, $cancel(2, stroke: #(paint: c_red, thickness: 1pt))$),
  node(b2, $4$),
  node(b3, $6$),

  edge((0.5, 0.4), a2, "->", $i$, label-side: right),
  edge((0.5, 1.15), b2, "->", $j$, label-side: right),

  edge((1.25, -0.25), (1.25, 1)),

  node(cmp, $A_i > B_j$),

  node(c, $C |$),
  node(c1, $1$),
  node(c2, $2$),
  node(c3, $4$),

  node((1.25, 1.5), $dots.v$),
))

We continue until $i$ and $j$ reach the end or $A$ and $B$. This gives us $C[1,2,4,5,6,10]$.

#pseudocode-alg(title: "Merge function")[
  + fun merge :: A:[int] -> B:[int] -> [int]
    - n = len(A)
    - m = len(B)
    - C = [int; n+m]
    - i, j, k = 0
    + *while* i < n || j < m
      - if j = m || (i < n && $A_i < B_j$)
        - $C_k = A_i$ 
        - i += 1
      - else 
        - $C_k = B_j$
        - j += 1
      - k += 1
    - return C
]

_Note that here we construct a new array $C$ to store our merged array, this is not a necessity but it is way simpler._ 

==== Algorithm

Now that we now how to merge, let's see how the sort function work. The objective here is to make recursive call dividing the array by 2 each time until is size is 1. After that we reconstruct the array with our merge function.

#pseudocode-alg(title: "Merge Sort")[
  + fun merge_sort :: A:[int] -> [int]
    + if len(A) < 2
      - return A
    - m = $n/2$
    + B = merge_sort $A_(0:m-1)$
    + C = merge_sort $A_(m:n-1)$
    + return merge B C
]

==== Time complexity

Time complexity here is the time complexity of each recursive call added to the time complexity of the merge function. \
We have: 
$
  T("merge_sort"(n)) = 2 dot T("merge_sort"(n/2)) + T("merge"(n)) = 2 dot T("merge_sort"(n/2)) + c dot n = Omicron(n log n)
$

A proof using call-tree: 
#align(center, diagram(
  let (N, H, I, Q, R, S, T, L, M, O, P, U, V, W, Y) = (
    (-1.5, 0),
    (-2.75, 1),
    (-0.25, 1),
    (-3.25, 2),
    (-2.25, 2),
    (-0.75, 2),
    (0.25, 2),
    (-3.5, 3),
    (-3, 3),
    (-2.5, 3),
    (-2, 3),
    (-1, 3),
    (-0.5, 3),
    (0, 3),
    (0.5, 3),
  ),

  node(N, $n$),

  node(H, $n/2$),
  node(I, $n/2$),

  node(Q, $n/4$),
  node(R, $n/4$),
  node(S, $n/4$),
  node(T, $n/4$),

  node(L, $circle$),
  node(M, $circle$),
  node(O, $circle$),
  node(P, $circle$),
  node(U, $circle$),
  node(V, $circle$),
  node(W, $circle$),
  node(Y, $circle$),

  edge(N, H, "->"),
  edge(N, I, "->"),

  edge(H, Q, "->"),
  edge(H, R, "->"),
  edge(I, S, "->"),
  edge(I, T, "->"),

  edge(Q, L, "--"),
  edge(Q, M, "--"),
  edge(R, O, "--"),
  edge(R, P, "--"),
  edge(S, U, "--"),
  edge(S, V, "--"),
  edge(T, W, "--"),
  edge(T, Y, "--"),

  node((1.5, 0), text(c_red, $n "operations"$)),
  node((1.5, 1), text(c_red, $n "operations"$)),
  node((1.5, 2), text(c_red, $n "operations"$)),
  node((1.5, 3), text(c_red, $n "operations"$)),

  edge((1.5, 2), (1.5, 3), "--", stroke: c_red),

  edge((2.75, 0), (2.75, 3), "<->", stroke: c_red, label: text(c_red, $H = log_2 n$), label-side: left, label-angle: right),

  node((1.5, 3.5), text(c_red, $"Overall complexity" = n dot log n$)),
))

Another proof:
$
  & "    "   T("merge_sort"(n)) \ 
  & lt.slant 2 dot T("merge_sort"(n/2)) + T("merge"(n)) \
  &  lt.slant 2c dot n/2 dot log n/2 + c dot n \
  & = c dot n dot log(n -1) + c dot n \
  & = Omicron(n log n)
$

==== Usefulness 

Merge sort is interesting for two main reasons: 
- Its stability: this means that if there are multiple occurrences of the same element in the unsorted array, they are in the same order in the sorted array. 
- Parallelism capabilities: the divide & conquer recurrences are independent of each other. Therefore, they can be run in parallel. 

== Time complexity: Master theorem

Let's generalise the complexity pattern of merge sort for all divide and conquer recurrences, this results is called the master theorem@master-theo.

We want to determine the complexity of $g(n)$. This function make $a$ calls to $g(n/b)$ and 1 call to $f(n)$.

$
  T(g(n)) & = a dot T(g(n/b)) + T(f(n)) \
          & = a^(log_b n) + T(f(n)) \
          & = n^(log_b a) + T(f(n))
$

From there, multiple case:

$
  T(f(n)) & = Omicron(n^((log_b a) - epsilon)) && => T(g(n)) = Omicron(n^(log_b a)) \
  T(f(n)) & = Omicron(n^((log_b a) + epsilon)) && => T(g(n)) = Omicron(n^((log_b a) + epsilon)) \
  T(f(n)) & = Omicron(n^(log_b a))             && => T(g(n)) = Omicron(n^(log_b a))
$

_Note that we can use $Theta$ in master theorem_.
