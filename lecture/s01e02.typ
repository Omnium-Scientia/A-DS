#import "@preview/fletcher:0.5.5": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
  semester: "1", 
  chapter_number: "2", 
  video_link: "https://www.youtube.com/watch?v=koyuy564TZ8&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=2", 
  title: "Data structures, binary heap, heap sort"
)


= Data structures, binary heap, heap sort

== Data structures 

Structures that contains some data. We want specific structures because we want to make operations on our data. 

When thinking about a program, we think about what operations we need to do on our data structure. When we know what operations we need, we chose our data structure. 

There are multiple classes of data structure, each of them have dedicated operations. 

When we analyze a data structure, we want to analyze the complexity of each operations they allow us. 

Example: For an array we have the operations $"get"(i) " " amp " " "put"(i, v)$

Data structure are closely related to algorithm because we need algorithm to implement data structures operations and algorithm run with specific data structure. 

== Binary heap

- From a the data structure classes of heap (priority queue)
- contain set of elements 
- two basic operations 
  - $"insert"(x)$
  - $"remove_min"()$

=== Let's try use simpler data structure to implement those operations:

==== Array 

#codly(
  annotation-format: none,    
  annotations: (
    (
      start:1, end: 3,
      content: text(red, $Omicron(1) "                                                                                            "$)
    ),
  )
)
```
def insert(x) 
    a[n] = x 
    n += 1
```

#codly(
  annotation-format: none,    
  annotations: (
    (
      start:1, end: 8,
      content: text(red, $Omicron(n) "                                                                                            "$)
    ),
  )
)
```
def remove_min() 
    j = 0 
    for i = 0..n-1 
        if a[i] < a[j]
            j = i
    swap(a[j], a[n-1])
    n -= 1 
    return a[n]
```


#pagebreak(weak: true)

==== Sorted array (desc) 


#codly(
  annotation-format: none,    
  annotations: (
    (
      start:1, end: 7,
      content: text(red, $Omicron(n) "                                                                                            "$)
    ),
  )
)
```
def insert(x) 
    a[n] = x 
    n += 1 
    i = n-1 
    while i > 0 and a[i] > a[i-1] 
        swap(a[i], a[i-1])
        i -= 1
```


#codly(
  annotation-format: none,    
  annotations: (
    (
      start:1, end: 3,
      content: text(red, $Omicron(n) "                                                                                            "$)
    ),
  )
)
```
def remove_min() 
    n -= 1 
    return a[n]
```

=== Now let's do a binary heap 

==== Heap properties and construction. 

We take a complete binary tree, each layer is complete except for the last one that can be empty on the right. 

#text(red, "*")Heap property is that each sub-layer elt is bigger than the one in the upper layer. 

#text(purple, "*")Node are indexed from left to right, top to bottom. 

Since the tree structure for a given number of node will always be the same, we can put the node into an array. We will know the position in the tree given the index in the array. 

Indeed, if the index of a node is $i$, the index of its left child will be $2i + 1$ and is right child $2i + 2$. While its parent index will be $floor.l (i-1) / 2 floor.r$. 

Given those construction rules, let's see the skeleton of the binary heap with ten node: 
#linebreak()

#let purpled(n) = text(purple, $" "#n$)
#align(center, diagram(
  let (N, H,I, Q,R,S,T, L,M,O) = (
    (0,0), 
    (-2,1),(2, 1), 
    (-3, 2),(-1, 2),(1, 2),(3, 2), 
    (-3.5, 3),(-2.5, 3),(-1.5, 3),
  ),

  node(N, $circle^purpled(0)$),
  
  node(H, $circle^purpled(1)$), node(I, $circle^purpled(2)$), 
  
  node(Q, $circle^purpled(3)$), node(R, $circle^purpled(4)$), node(S, $circle^purpled(5)$), node(T, $circle^purpled(6)$),

  node(L, $circle^purpled(7)$), node(M, $circle^purpled(8)$), node(O, $circle^purpled(9)$),

  edge(N, H, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(N, I, "-", label: text(red, $>=$), label-side: left, label-angle: left),

  edge(H, Q, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(H, R, "-", label: text(red, $>=$), label-side: left, label-angle: left),
  edge(I, S, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(I, T, "-", label: text(red, $>=$), label-side: left, label-angle: left),

  edge(Q, L, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(Q, M, "-", label: text(red, $>=$), label-side: left, label-angle: left), edge(R, O, "-", label: text(red, $>=$), label-side: right, label-angle: left), 
))

==== Insertion

#text(blue, "*")If we want to insert a new element in the tree, we put it in the next index. Then we ensure heap property, we swap the new element with is parent until the property is satisfied everywhere. 

Let's see this on our previous example: 

- First, we place the new node in the next place:

#let purpled(n) = text(purple, $" "#n$)
#align(center, diagram(
  let (N, H,I, Q,R,S,T, L,M,O,P) = (
    (0,0), 
    (-2,1),(2, 1), 
    (-3, 2),(-1, 2),(1, 2),(3, 2), 
    (-3.5, 3),(-2.5, 3),(-1.5, 3),(-0.5, 3)
  ), 

  node(N, $circle^purpled(0)$),
  
  node(H, $circle^purpled(1)$), node(I, $circle^purpled(2)$), 
  
  node(Q, $circle^purpled(3)$), node(R, $circle^purpled(4)$), node(S, $circle^purpled(5)$), node(T, $circle^purpled(6)$),

  node(L, $circle^purpled(7)$), node(M, $circle^purpled(8)$), node(O, $circle^purpled(9)$), node(P, text(blue,$circle^purpled(10)$)), 

  edge(N, H, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(N, I, "-", label: text(red, $>=$), label-side: left, label-angle: left),

  edge(H, Q, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(H, R, "-", label: text(red, $>=$), label-side: left, label-angle: left),
  edge(I, S, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(I, T, "-", label: text(red, $>=$), label-side: left, label-angle: left),

  edge(Q, L, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(Q, M, "-", label: text(red, $>=$), label-side: left, label-angle: left), edge(R, O, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(R, P, "-", label: text(blue, $<=$), label-side: left, label-angle: left, stroke: blue), 
))

- Since the condition $node_4 <= node_10$ is not satisfied, we swap them: 

#let purpled(n) = text(purple, $" "#n$)
#align(center, diagram(
  let (N, H,I, Q,R,S,T, L,M,O,P) = (
    (0,0), 
    (-2,1),(2, 1), 
    (-3, 2),(-1, 2),(1, 2),(3, 2), 
    (-3.5, 3),(-2.5, 3),(-1.5, 3),(-0.5, 3)
  ),

  node(N, $circle^purpled(0)$),
  
  node(H, $circle^purpled(1)$), node(I, $circle^purpled(2)$), 
  
  node(Q, $circle^purpled(3)$), node(R, text(blue, $circle^purpled(4)$)), node(S, $circle^purpled(5)$), node(T, $circle^purpled(6)$),

  node(L, $circle^purpled(7)$), node(M, $circle^purpled(8)$), node(O, $circle^purpled(9)$), node(P,$circle^purpled(10)$), 

  edge(N, H, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(N, I, "-", label: text(red, $>=$), label-side: left, label-angle: left),

  edge(H, Q, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(H, R, "-", label: text(red, $>=$), label-side: left, label-angle: left),
  edge(I, S, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(I, T, "-", label: text(red, $>=$), label-side: left, label-angle: left),

  edge(Q, L, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(Q, M, "-", label: text(red, $>=$), label-side: left, label-angle: left), edge(R, O, "-", label: text(red, $>=$), label-side: right, label-angle: left), edge(R, P, "-", label: text(red, $>=$), label-side: left, label-angle: left,), edge(R, P, "<->", stroke: blue, bend: -40deg,) 
))

#linebreak()

Now the properties are all satisfied, the node is well placed. If the properties were not yet satisfied, we would swap with the node at index 1 and again with the node 0 if it was necessary. 

Let's write that function insert. 

#codly(
  annotation-format: none,    
  annotations: (
    (
      start:1, end: 1,
      content: text(red, $Omicron(log n)$)
    ),
    (
      start:5, end: 7,
      content: text(red, $Omicron(log n)$) + ",  sift_up operation            " 
    ),
  )
)
```
def insert(x) 
    h[n] = x 
    n += 1
    i = n-1 
    while i > 0 and a[i] and a[(i-1) / 2]
        swap(a[i], a[(i-1) / 2])
        i = (i - 1) / 2
```

The $"sift_up"$ operation takes a node $i$ and swap it with its parent until it respect the heap property, its complexity is $Omicron(log n)$ because we go up at each iteration. At most, we go from the bottom layer to the first. And since there is at most $log_2 n$ layer in a binary the complexity is $Omicron(log n)$.

==== Remove minimum 

To remove the minimum element, we swap the root with the last element, we cut the last element. After the swap, the heap does not satisfy the property anymore. 

To satisfy it: 

- if the parent if bigger than both of its child, we swap it with the smallest of the two. 
- if only one child is lesser, we swap the parent with this child. 

Repeat while the parent as at least one smaller child. 

#codly(
  annotation-format: none,    
  annotations: (
    (
      start:1, end: 1,
      content: text(red, $Omicron(log n)$)
    ),
    (
      start:6, end: 14,
      content: text(red, $Omicron(log n)$) + ",  sift_down operation         " 
    ),
  )
)
```
def remove_min()
    swap(h[0], h[n-1])
    n -= 1 
    i = 0 
    
    // at leat 1 child 
    while 2i + 1 < n 
        j = 2i + 1
        if (2i+2 < n) and h[2i+2] < h[j]
            j = 2i + 2 
        if h[j] >= h[i] 
            break 
        swap(h[i], h[j])
        i = j
    
    return h[n]
```

Here the complexity is logarithmic for the same reason as in the $"insert"$ but of going from the bottom layer to the first one, we go from the first one to the bottom one.

_Note: here we have implemented the binary heap using an array but can perfectly do it with a tree structure too._

== Heap sort

=== Naive version

Let's create a basic heap sort that we will improve after. The idea of heap sort is pretty simple when we think about the two operations that we have implemented for our binary heap. 

- First we need to create a binary heap using the $"insert"$ function. (we insert each element in an array using insert)
- Secondly we remove the minimum with the associated function n times and store the result in an array. 

#pagebreak()

There is an implementation of this algorithm: 

#codly(
  annotation-format: none,    
  annotations: (
    (
      start:1, end: none,
      content: text(red, $Omicron(n log n)$)
    ),
    (
      start:3, end: none,
      content: text(red, $Omicron(log n)$) + "                                             " 
    ),
    (
      start:5, end: none,
      content: text(red, $Omicron(log n)$)
    ),
  )
)
```
def sort(a)
    for i = 0..n-1 
        insert(a[i])
    for i = 0..n-1 
        a[i] = remove_min()
```

Here our overall complexity is simple to calculate, we do n times two operations that have a $Omicron(log n)$ so our complexity is $Omicron(n log n)$. 

But, implemented like this, we need two array, $a$ of size $n$ and $h$ of size $n$ too to make the heap. 

We can improve this by doing our heap operation on our sorted array. 

=== With one array

In order to achieve that, we heapify (transform an array into a heap) $a$ and we remove the minimum element each time. 

Let's write the algorithm: 

#codly(
  annotations: (
    (
      start:3, end: none,
      content: text(red, $Omicron(log n)$)
    ),
    (
      start:5, end: 6,
      content: text(red, $Omicron(log n)$) + "                                             " 
    ),
  )
)
```
def sort(a)
    for i = 0..n-1 
        sift_up(i)
    for i = 0..n-1
        swap(a[0], a[i])
        sift_down(0)
```

Our overall complexity is the same, for the same reason. But now we do not need the array $h$ because we are doing all our operations on array $a$.

=== Linear heapify

We still have room for improvement. Indeed we can heapify (the first for-loop in the previous algorithm) in linear time. 

Let's decompose why the complexity of this first for-loop is $Omicron(n log n)$ in order to improve it. 

#linebreak()

#align(center, diagram(
  let y = 0.75,
  let (N, H,I, Q,R,S,T, L,M,O,P,U,V,W,Y) = (
    (-1.5,0), 
    (-2.75,y),(-0.25,y), 
    (-3.25,2*y),(-2.25,2*y),(-0.75,2*y),(0.25,2*y), 
    (-3.5,3*y),(-3,3*y),(-2.5,3*y),(-2,3*y),(-1,3*y),(-0.5,3*y),(0,3*y),(0.5,3*y)
  ),

  node(N, $circle$),
  
  node(H, $circle$), node(I, $circle$), 
  
  node(Q, $circle$), node(R, $circle$), node(S, $circle$), node(T, $circle$),

  node(L, $circle$), node(M, $circle$), node(O, $circle$), node(P, $circle$),
  node(U, $circle$), node(V, $circle$), node(W, $circle$), node(Y, $circle$),

  edge(N, H, "-"), edge(N, I, "-"),

  edge(H, Q, "-"), edge(H, R, "-"),
  edge(I, S, "-"), edge(I, T, "-"),

  edge(Q, L, "--"), edge(Q, M, "--"),
  edge(R, O, "--"), edge(R, P, "--"),
  edge(S, U, "--"), edge(S, V, "--"),
  edge(T, W, "--"), edge(T, Y, "--"),

  node((1.5, -0.5), text(red, "For each node:")),
  node((1.5, 0), text(red, $0 "call to sift_up"$)),
  node((1.5,y), text(red, $1 "call "$)),
  node((1.5,2*y), text(red, $2 "calls "$)),
  node((1.5,3*y), text(red, $log n "calls "$)),

  edge((1.5,2*y), (1.5,3*y), "--", stroke: red)
))

#pagebreak()

So assuming that we are at a layer $gamma$ the number of call to $"sift_up"$ is at most $2^gamma dot gamma$ which makes our total complexity: 

$
sum_gamma^(log n) 2^gamma dot gamma = Omega(n log n)
$

To improve this complexity, we are going to use $"sift_down"$ instead of $"sift_up"$ in the first for-loop. Which gives us this situation. 

#align(center, diagram(
  let y = 0.75,
  let (N, H,I, Q,R,S,T, L,M,O,P,U,V,W,Y) = (
    (-1.5,0), 
    (-2.75,y),(-0.25,y), 
    (-3.25,2*y),(-2.25,2*y),(-0.75,2*y),(0.25,2*y), 
    (-3.5,3*y),(-3,3*y),(-2.5,3*y),(-2,3*y),(-1,3*y),(-0.5,3*y),(0,3*y),(0.5,3*y)
  ),

  node(N, $circle$),
  
  node(H, $circle$), node(I, $circle$), 
  
  node(Q, $circle$), node(R, $circle$), node(S, $circle$), node(T, $circle$),

  node(L, $circle$), node(M, $circle$), node(O, $circle$), node(P, $circle$),
  node(U, $circle$), node(V, $circle$), node(W, $circle$), node(Y, $circle$),

  edge(N, H, "-"), edge(N, I, "-"),

  edge(H, Q, "-"), edge(H, R, "-"),
  edge(I, S, "-"), edge(I, T, "-"),

  edge(Q, L, "--"), edge(Q, M, "--"),
  edge(R, O, "--"), edge(R, P, "--"),
  edge(S, U, "--"), edge(S, V, "--"),
  edge(T, W, "--"), edge(T, Y, "--"),

  node((1.5, -0.5), text(red, "For each node:")),
  node((1.5, 0), text(red, $log n "calls to sift_down"$)),
  node((1.5,y), text(red, $log n-1 "calls "$)),
  node((1.5,2*y), text(red, $1 "calls "$)),
  node((1.5,3*y), text(red, $0 "calls "$)),

  edge((1.5,y), (1.5,2*y), "--", stroke: red)
))

#linebreak()

Which bring our overall complexity to: 


#math.equation(block: true, numbering: "(1)", $sum_gamma^(log n) 2^gamma dot (log n - gamma)$)


Let's show that this is $Omicron(n)$: 

Let's do the following substitution: 

$
h = log n - gamma \
gamma = log n - h
$

then $(1)$ become: 

$
sum_h^(log n) 2^(log n - h) dot h &= n dot sum_h^(log n) h/2^h &&\ 
                                  &= Omicron(n) &&#text(fill:rgb(130, 130, 130))[$"because " sum_k^infinity k / 2^k = 2$]
$

_Note: if you want a more visual prove counting the number of swaps, see the lecture video of Pavel Martin (link below)._
