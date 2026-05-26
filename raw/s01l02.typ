#import "@preview/fletcher:0.5.5": *
#import "@preview/lovelace:0.3.1": line-label
#import "../functions.typ": pseudocode-alg, pseudocode-alg-nt, c_red, c_blue

#cite(label("ads-s1-e2"), form: none)

== Data structures

We learned what is an algorithm, now let's tackle the other big part of problem solving in computer science. When algorithms takes input --- in order to make operations on them to get an answer --- it need to come arranged in a certain way, this way is a data structures (e.g. the array of a sorting algorithm). \ 
Data structures are important. One may say that when solving a problem, the data structure choice come before the algorithm internals. 

OK, but why? Because data structures are way to arrange information. The way we arrange the data is going to make some operations easy and some hard. So when you are designing an algorithm, you need to think about what operations you need to do on your data (e.g. access, add, delete elements) because the choice you will make will groom your ability to solve your problem efficiently. \ 
To ease this choice, we have categorised data structures into classes, each data structure classes have a set of operations that they optimise. To analyse the operations, we analyse their complexity (e.g. in an array, the $"get"$ operation as a complexity of $Omicron(1)$). \ 
This way to analyse the capability of the data structures are in reality the same as our previous sorting algorithms, this is simply because our data structures are themselves implemented using algorithms. 

== Binary heap

- From a the data structure classes of heap (priority queue)
- contain set of elements
- two basic operations
  - $"insert"(x)$
  - $"remove_min"()$

=== Let's try use simpler data structure to implement those operations

==== Array

#grid(
  columns: (1fr, 1fr), 
  pseudocode-alg(title: "Insert operation")[
    + fun insert :: A:[int] -> x:int -> void
      - $A_n$ = x 
      - n += 1
  ], 
  pseudocode-alg(title: "Remove minimum operation")[
    + fun remove_min :: A:[int] -> int
      - j = 0 
      + *for* i = 0..n-1
        - if $A_i < A_j$
          - j = 1
      + swap $A_j$ $A_(n-1)$
      - n -= 1
      - return $A_n$ 
  ] 
)

==== Sorted array (desc)

#grid(
  columns: (1fr, 1fr), 
  pseudocode-alg(title: "Insert operation")[
    + fun insert :: S:[int] -> x:int -> void
      + $A_n$ = x 
      - n += 1
      + *while* i > 0 && $A_i > A_(i-1)$
        - swap $A_i$ $A_(i-1)$
        - i -= 1
  ], 
  pseudocode-alg(title: "Remove minimum operation")[
    + fun remove_min :: S[int] -> int
      - n -= 1 
      - return $A_n$
  ] 
)

=== Now let's construct a real binary heap

==== Heap properties and construction

We take a complete binary tree, each layer is complete except for the last one that can be empty on the right-hand side. We index the tree from left to right and top to bottom --- red in @bin-heap. \ 
In order to get the wanted complexity for our operations, we keep the following property true: for a given element, its child are inferior or equal to it --- blue in @bin-heap.

#let index(n) = text(c_red, $" "#n$)
#let rules_l = text(c_blue, $gt.slant$)
#let rules_r = text(c_blue, $lt.slant$)
#let (N, H, I, Q, R, S, T, L, M, O) = (
      (0, 0),
      (-2, 1),
      (2, 1),
      (-3, 2),
      (-1, 2),
      (1, 2),
      (3, 2),
      (-3.5, 3),
      (-2.5, 3),
      (-1.5, 3),
    )
#figure(
  caption: [Binary heap layout using ten nodes.],
  align(center, diagram(
    node(N, $circle^index(0)$),
  
    node(H, $circle^index(1)$),
    node(I, $circle^index(2)$),
  
    node(Q, $circle^index(3)$),
    node(R, $circle^index(4)$),
    node(S, $circle^index(5)$),
    node(T, $circle^index(6)$),
  
    node(L, $circle^index(7)$),
    node(M, $circle^index(8)$),
    node(O, $circle^index(9)$),
  
    edge(N, H, "-", label: rules_l, label-side: center, label-angle: left),
    edge(N, I, "-", label: rules_r, label-side: center, label-angle: right),
  
    edge(H, Q, "-", label: rules_l, label-side: center, label-angle: left),
    edge(H, R, "-", label: rules_r, label-side: center, label-angle: right),
    edge(I, S, "-", label: rules_l, label-side: center, label-angle: left),
    edge(I, T, "-", label: rules_r, label-side: center, label-angle: right),
  
    edge(Q, L, "-", label: rules_l, label-side: center, label-angle: left),
    edge(Q, M, "-", label: rules_r, label-side: center, label-angle: right),
    edge(R, O, "-", label: rules_l, label-side: center, label-angle: left),
  ))
) <bin-heap>

Since the tree is filed left to right and that a layer need to be full to begin filling the next one, the structure of a tree for a given number of nodes is known. \ 
Given a binary tree of $n$ nodes, and using the fact that we know the structure of the tree, we can use an array as a container for our nodes. For the node of index $i$ in the array we have: 
- left child at index $2i + 1$.

- right child at index $2i + 2$.
- its parent at index $floor((i-1) / 2)$.

==== Insertion

In order to insert a new element in the tree: 
- we append it in at the end of the array as in @adding-elt. 
- we check if the heap property is satisfied: 
  - if it is, we stop there. 
  - else, we swap the new element with its parent until the property is satisfied as in @swap. 

#let P = (-0.5, 3)
#figure(
  caption: [Append new node.],
  align(center, diagram(
    node(N, $circle^index(0)$),
  
    node(H, $circle^index(1)$),
    node(I, $circle^index(2)$),
  
    node(Q, $circle^index(3)$),
    node(R, $circle^index(4)$),
    node(S, $circle^index(5)$),
    node(T, $circle^index(6)$),
  
    node(L, $circle^index(7)$),
    node(M, $circle^index(8)$),
    node(O, $circle^index(9)$),
    node(P, text(c_red, $circle^index(10)$)),
  
    edge(N, H, "-", label: rules_l, label-side: center, label-angle: left),
    edge(N, I, "-", label: rules_r, label-side: center, label-angle: right),
    
    edge(H, Q, "-", label: rules_l, label-side: center, label-angle: left),
    edge(H, R, "-", label: rules_r, label-side: center, label-angle: right),
    edge(I, S, "-", label: rules_l, label-side: center, label-angle: left),
    edge(I, T, "-", label: rules_r, label-side: center, label-angle: right),
    
    edge(Q, L, "-", label: rules_l, label-side: center, label-angle: left),
    edge(Q, M, "-", label: rules_r, label-side: center, label-angle: right),
    edge(R, O, "-", label: rules_l, label-side: center, label-angle: left),
    edge(R, P, "-", label: text(c_red, $gt.slant$), label-side: center, label-angle: right, stroke: c_red),
  ))
) <adding-elt>

#figure(
  caption: [Swapping new node with parent.],
  align(center, diagram(
    node(N, $circle^index(0)$),
  
    node(H, $circle^index(1)$),
    node(I, $circle^index(2)$),
  
    node(Q, $circle^index(3)$),
    node(R, text(c_red, $circle^index(4)$)),
    node(S, $circle^index(5)$),
    node(T, $circle^index(6)$),
  
    node(L, $circle^index(7)$),
    node(M, $circle^index(8)$),
    node(O, $circle^index(9)$),
    node(P, $circle^index(10)$),
  
    edge(N, H, "-", label: rules_l, label-side: center, label-angle: left),
    edge(N, I, "-", label: rules_r, label-side: center, label-angle: right),
    
    edge(H, Q, "-", label: rules_l, label-side: center, label-angle: left),
    edge(H, R, "-", label: rules_r, label-side: center, label-angle: right),
    edge(I, S, "-", label: rules_l, label-side: center, label-angle: left),
    edge(I, T, "-", label: rules_r, label-side: center, label-angle: right),
    
    edge(Q, L, "-", label: rules_l, label-side: center, label-angle: left),
    edge(Q, M, "-", label: rules_r, label-side: center, label-angle: right),
    edge(R, O, "-", label: rules_l, label-side: center, label-angle: left),
    edge(R, P, "-", label: rules_r, label-side: center, label-angle: right),
    edge(R, P, "<->", stroke: c_red, bend: -40deg),
  ))
) <swap>

In @insert, the complexity comes from @sift_up, this operation is called sift up. It take a node $i$ and swap it with its parent until it respect the heap property, its complexity is $Omicron(log n)$ because we go up at each iteration. At most, we go from the bottom layer to the first. And since there is at most $log_2 n$ layer in a binary the complexity of sift up is $Omicron(log n)$.

==== Remove minimum

Removing the minimum is made in 2 step, firstly we remove the minimum from the heap (i.e. we remove the first element) @remove_min (@rem_min) by swapping the minimum with the last element and popping it from the heap. \
Since the last element become the root of the tree, our heap does satisfy the heap property anymore. To solve this problem, we use the sift down operation (@sift_down @rem_min), it makes the parent go down a layer if one or both its child are smaller than it. If both child are smaller, we swap the parent with the smaller of them. If only one is smaller we swap it with the parent. Loop runs until the heap property is satisfied. \
Here the complexity is logarithmic for the same reason as in @insert but the complexity comes from the sift down operation instead of sift up (i.e. at most we go from the root to the bottom layer instead of from the bottom layer to the root).  

#grid(
  columns: (1fr, 1fr), 
  [
    #pseudocode-alg(title: "Heap Insertion")[
      + fun insert :: H:[int] -> x:int -> void
        + $H_n = x$
        - n += 1 
        - i = n-1 
        + #line-label(<sift_up>) *while* i > 0 && $A_i < A_((i-1)/2)$
          - swap $A_i$  $A_((i-1)/2)$
          - i = $(i-1)/2$
    ] <insert>
  ],
  [
    #pseudocode-alg(title: "Heap Remove Min")[
      + fun remove_min :: H:[int] -> int
        + #line-label(<remove_min>) swap $H_0$ $H_(n-1)$
        - n -= 1
        - i = 0 
        + #line-label(<sift_down>) *while* $2i + 1 < n$ 
          - j = 2i + 1 
          - if $2i + 2 < n$ && $H_(2i + 2) < H_j$
            - j = 2i + 2 
          - if $H_j gt.slant H_i$
            - break 
          - swap $H_i$ $H_j$
          - i = j
        - return $H_n$
    ] <rem_min>
  ]
)

_Note: here we have implemented the binary heap using an array but can perfectly do it with a tree structure too._

== Heap-sort

The objective here is to create a sorting algorithm using the heap data structure. 

=== Naive version

Our first version is a really naïve one. The idea is simple, given an array $A$ of length $n$, we create a heap $H$ inserting all the elements of $A$ in it using the insertion function. After that, we remove the minimum of $H$ $n$ times and store it in $A$. 

#pseudocode-alg(title: "Naïve Heap Sort")[
  + fun sort :: A:[int] -> void 
    - H = [int; n]
    + *for* i = 0..n-1
      - insert H $A_i$ 
    + *for* i = 0..n-1
      - $A_i$ = remove_min H
]

Here, our overall complexity is simple to calculate, we do two times n operations that have a $Omicron(log n)$ complexity. So our overall complexity is $Omicron(n log n)$. We will not go into further detail because our current implementation as a massive flaw. \ 
This flaw is that we reallocate another array of size $n$ to create $H$. This cost us greatly, in order to improve this algorithm we are going to transform it in way it will be in-place. 

=== In-place version

This version is actually what introduced heap-sort @heapsort. Instead of creating a new array, we heapify (transform an array into a heap) $A$ and we remove the minimum $n$ times. 

#pseudocode-alg(title: "Heap Sort using 1 array")[
  + fun sort :: A:[int] -> void 
    + *for* i = 0..n-1
      - sift_up A i 
    + *for* i = 0..n-1
      - swap $A_0$ $A_i$
      - sift_down A 0 
]

In this version we save space and we achieve $Omicron(1)$ memory complexity. Lets calculate our time complexity: 
$
  T("sort") &= n dot T("sift_up") + n dot T("swap") + n dot T("sift_down") \
            &= n dot Omicron(log n)  + n + n dot Omicron(log n) \
            &= 2n dot Omicron(log n) + Omicron(n) \
            &= Omicron(n log n)
$

=== Linear heapify

#cite(label("treesort"), form: none)

We can improve further, currently the first `for` loop costs us $Omicron(n log n)$. We can make a linear time heapify @treesort.
Let's decompose why the complexity of this first for-loop is $Omicron(n log n)$ in order to improve it.

#let y = 0.75
#let (N, H, I, Q, R, S, T, L, M, O, P, U, V, W, Y) = (
  (-1.5, 0),
  (-2.75, y),
  (-0.25, y),
  (-3.25, 2 * y),
  (-2.25, 2 * y),
  (-0.75, 2 * y),
  (0.25, 2 * y),
  (-3.5, 3 * y),
  (-3, 3 * y),
  (-2.5, 3 * y),
  (-2, 3 * y),
  (-1, 3 * y),
  (-0.5, 3 * y),
  (0, 3 * y),
  (0.5, 3 * y),
)
#align(center, diagram(
  node(N, $circle$),

  node(H, $circle$),
  node(I, $circle$),

  node(Q, $circle$),
  node(R, $circle$),
  node(S, $circle$),
  node(T, $circle$),

  node(L, $circle$),
  node(M, $circle$),
  node(O, $circle$),
  node(P, $circle$),
  node(U, $circle$),
  node(V, $circle$),
  node(W, $circle$),
  node(Y, $circle$),

  edge(N, H, "-"),
  edge(N, I, "-"),

  edge(H, Q, "-"),
  edge(H, R, "-"),
  edge(I, S, "-"),
  edge(I, T, "-"),

  edge(Q, L, "--"),
  edge(Q, M, "--"),
  edge(R, O, "--"),
  edge(R, P, "--"),
  edge(S, U, "--"),
  edge(S, V, "--"),
  edge(T, W, "--"),
  edge(T, Y, "--"),

  node((1.5, -0.3), text(c_red, "For each node:")),
  node((1.5, 0), text(c_red, $0 #text[call to `sift_up`]$)),
  node((1.5, y), text(c_red, $1 "call "$)),
  node((1.5, 2 * y), text(c_red, $2 "calls "$)),
  node((1.5, 3 * y), text(c_red, $log n "calls "$)),

  edge((1.5, 2 * y), (1.5, 3 * y), "--", stroke: c_red),
))


So assuming that we are at a layer $gamma$ the number of call to `sift_up` is at most $2^gamma dot gamma$ which makes our total complexity:

$
  sum_gamma^(log n) 2^gamma dot gamma = Omega(n log n)
$

To improve this complexity, we are going to use `sift_down` instead of `sift_up` in the first for-loop. Which gives us this situation.

#align(center, diagram(
  node(N, $circle$),

  node(H, $circle$),
  node(I, $circle$),

  node(Q, $circle$),
  node(R, $circle$),
  node(S, $circle$),
  node(T, $circle$),

  node(L, $circle$),
  node(M, $circle$),
  node(O, $circle$),
  node(P, $circle$),
  node(U, $circle$),
  node(V, $circle$),
  node(W, $circle$),
  node(Y, $circle$),

  edge(N, H, "-"),
  edge(N, I, "-"),

  edge(H, Q, "-"),
  edge(H, R, "-"),
  edge(I, S, "-"),
  edge(I, T, "-"),

  edge(Q, L, "--"),
  edge(Q, M, "--"),
  edge(R, O, "--"),
  edge(R, P, "--"),
  edge(S, U, "--"),
  edge(S, V, "--"),
  edge(T, W, "--"),
  edge(T, Y, "--"),

  node((1.5, -0.3), text(c_red, "For each node:")),
  node((1.5, 0), text(c_red, $log n #text[call to `sift_down`]$)),
  node((1.5, y), text(c_red, $log (n-1) "calls "$)),
  node((1.5, 2 * y), text(c_red, $1 "calls "$)),
  node((1.5, 3 * y), text(c_red, $0 "calls "$)),

  edge((1.5, y), (1.5, 2 * y), "--", stroke: c_red),
))

#linebreak()

Which bring our overall complexity to:

#align(
  center, 
  $      & sum_gamma^(log n) 2^gamma dot (log n - gamma) \ 
  <=> & sum_h^(log n) 2^(log n - h) dot h && #text(fill: rgb(130, 130, 130))[$"using" h = log n - gamma, gamma = log n - h$] \ 
  =   & n dot sum_h^(log n) h/2^h \
  =   & Omicron(n) && #text(fill: rgb(130, 130, 130))[$"because " sum_k^infinity k / 2^k = 2$]$ 
)

This brings our complexity for heap-sort to: 
$
  T("sort") &= Omicron(n) + n dot T("swap") + n dot T("sift_down") \
            &= Omicron(n)  + n + n dot Omicron(log n) \
            &= n dot Omicron(log n) + 2 dot Omicron(n) \
            &= Omicron(n log n)
$

The same overall complexity, but we improved greatly the constant factors. We can further improve the complexity of this sort. Our sift down function need 2 comparisons to find the swapping elements. This improvement consist to do the swap of the heapify loop to only one comparison @heapsort-bu. A detailed analysis would show us that we improve again our constant on linear side of the linear factor. This make heap-sort roughly competitive with quick-sort. In a later version of this book, we will try to further improve heap-sort making it better in term of cache usage increasing performance again @cache-in-sort. 
