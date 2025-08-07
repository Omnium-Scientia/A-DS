#import "@preview/fletcher:0.5.5": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
    semester: "1", 
    chapter_number: "1", 
    video_link: "https://www.youtube.com/watch?v=oWgLjhM-6XE     list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4", 
    title: "Algorithm, Time complexity, Merge sort"
)


= Algorithm, Time complexity, Merge sort

== What is an algorithm?

Formalized way to solve some problems. 

#align(center, diagram(
    node((0,0), $"Input data"$, name: <I>),
    node((+1,0), $"Algorithm"$, name: <A>),
    node((+2,0), $"Output data"$, name: <O>),

    edge(<I>, "->", <A>), 
    edge(<A>, "->", <O>)
))

Example: Sum of elements of an array 

$
"input": a[0..n-1] \ 
"output": sum_(i) a[i]
$

```
s = 0 
for i = 0..n-1: 
    s += a[i]
print(s)
```

== Time complexity 

Our main way to measure the efficiency of an algorithm. 

$ "Unit" = "number of operations" $

To know what is an operation, we need a computational model. 

A computational model is a mathematical abstraction that is a simplified version of our processor. 

=== RAM Model 

Ram: 

#align(center, diagram(
    node((0,0), $0$),
    node((5,0), $n-1$),

    edge((0,0), "-", (5,0), $i$), 
))

We can access an element $i$ of the memory in constant time (not the case in all computational model). 

Example: let's take our previous example back 

#codly(
    annotation-format: none,
    annotations: (
        (
            start:3, end: 4,
            content: "n times, 2 op in for declaration & 3 op in for body"
        ),
        (
            start: 1, end: none,
            content: "1 op",
        ),
        (
            start: 6, end: none,
            content: "1 op",
        ),
    )
)
```
s = 0 

for i = 0..n-1: 
    s += a[i]

print(s)
```

$ 
T(n) &= cancel(2, stroke: #(paint: red, thickness: 1pt,),) +cancel(5, stroke: #(paint: red, thickness: 1pt,),)n \
&= Omicron(n)
$

== Big-O notation

=== Big-$Omicron$

$ 
&f(n) = Omicron(g(n)) \
<==> &exists " " n_(0), c | forall n >= n_(0)," " f(n) <= c dot.op g(n)
$

Let's prove that: $2+5n = Omicron(n)$

$ 
-> &f(n) = 2 + 5n \
&g(n) = n \
&n_(0) = 2 \
&c = 6
$

$Omicron(.)$ is an upper bound of our real complexity. One could say that that $n = Omicron(n^2)$ which is true with $n_(0), c = 1$. 

$ Omicron(f(n)) = "not slower" $

=== Big-$Omega$

$ 
     &f(n) = Omega(g(n)) \
<==> &forall n >= n_(0), " " f(n) >= c dot.op g(n)
$

Which mean $Omega$ is a lower bound of our complexity. 

For our sum example, we can show that $2 + 5n = Omega(n)$ with $n_0, c = 1$

=== Big-$Theta$

We have shown for our example that: 

$ 
T(n) = Omicron(n) \
T(n) = Omega(n)
$

If we have those two properties, we say that $T(n) = Theta(n)$. 

When we invent a new algorithm we try to prove both $Omicron$ & $Omega$. Proving $Omicron$ is sufficient that we are fast enough. $Omega$ is useful to show that we are not faster than. 

=== Common time complexity 

For loop: 

#codly(
    annotation-format: none,
    annotations: (
        (
            start: 1, end: none,
            content: text(red, $" " Omicron(n) "                                                                                            "$),
        ),
    )
)
```
for i = 0..n-1 
```

#codly(
    annotation-format: none,
    annotations: (
        (
            start: 1, end: 2,
            content: text(red, $" " Omicron(n^2) "                                                                                             "$),
        ),
    )
)
```
for i = 0..n-1 
    for j = 0..n-1
```

#codly(
    annotation-format: none,
    annotations: (
        (
            start: 1, end: 2,
            content: text(red, $" " Omicron(n^2) "                                                                                             "$),
        ),
    )
)
```
for i = 0..n-1 
    for j = 0..i-1 
```

#pagebreak()

For loop are trivial, while loop can be trickier: 

#codly(
    annotation-format: none,
    annotations: (
        (
            start: 2, end: 3,
            content: text(red, $" " Omicron(sqrt(n)) "                                                                                             "$),
        ),
    )
)
```
i = 0
while i * i < n 
    i += 1
```

#codly(
    annotation-format: none,
    annotations: (
        (
            start: 2, end: 3,
            content: text(red, $" " Omicron(log_2n) " = " Omicron(log n) "                                                                         "$),
        ),
    )
)
```
i = 1
while i < n
    i += 2
```

_Constant does not affect asymptotic time_.

== Recursive algorithms 

To compute the complexity of $f(n)$ we need to compute the number of time we call $f(n)$ & the number of operations in each $f(n)$ call. 

=== Example: 

#codly(
    annotation-format: none,    
    annotations: (
        (
            start: 2, end: none,
            content: text(fill:red)[$" " Omicron(1) "                                                                                                "$],
        ),
    )
)
```
def f(n)
    if n = 0
        return 
    f(n - 1)
```

The number of operation is constant. The number of call is $n$. Therefore complexity of $f$ is $Omicron(n)$. 

=== Example 2: 

#codly(
    annotation-format: none,    
    annotations: (
        (
            start: 2, end: none,
            content: text(fill:red)[$" " Omicron(1) "                                                                                                "$],
        ),
    )
)
```
def f(n)
    if n = 0 
        return 
    f(n / 2)
```

Here the number of operation is still constant. But, we call: 

#align(center, diagram(
    $ 
    f(n) edge(->, shift: #0pt) 
    & f(n / 2) edge(->, shift: #0pt) 
    & ... edge(->, shift: #0pt) 
    & f(0) 
    $
))

which make $log n$ recursive call. Overall the complexity of $f$ is $Omicron(log n)$. 

=== Example 3: 

#codly(
    annotation-format: none,    
    annotations: (
        (
            start: 2, end: none,
            content: text(fill:red)[$" " Omicron(1) "                                                                                                "$],
        ),
    )
)
```
def f(n)
    if n = 0 
        return 
    f(n / 2)
    f(n / 2)    
```

#pagebreak()

Let's compute the number of call to $f$: 

#align(center, diagram(
    let (N, H,I, Q,R,S,T, L,M,O,P,U,V,W,Y) = (
        (-1.5,0), 
        (-2.75,1),(-0.25, 1), 
        (-3.25, 2),(-2.25, 2),(-0.75, 2),(0.25, 2), 
        (-3.5, 3),(-3, 3),(-2.5, 3),(-2, 3),(-1, 3),(-0.5, 3),(0, 3),(0.5, 3)
    ),

    node(N, $f(n)$),
    
    node(H, $f(n / 2)$), node(I, $f(n / 2)$), 
    
    node(Q, $f(n / 4)$), node(R, $f(n / 4)$), node(S, $f(n / 4)$), node(T, $f(n / 4)$),

    node(L, $f(0)$), node(M, $f(0)$), node(O, $f(0)$), node(P, $f(0)$),
    node(U, $f(0)$), node(V, $f(0)$), node(W, $f(0)$), node(Y, $f(0)$),

    edge(N, H, "->"), edge(N, I, "->"),

    edge(H, Q, "->"), edge(H, R, "->"),
    edge(I, S, "->"), edge(I, T, "->"),

    edge(Q, L, "--"), edge(Q, M, "--"),
    edge(R, O, "--"), edge(R, P, "--"),
    edge(S, U, "--"), edge(S, V, "--"),
    edge(T, W, "--"), edge(T, Y, "--"),

    edge((1.5, 0), (1.5, 3), "<->", stroke: red, label: text(red, $H = log_2 n$), label-side: left)
))

#linebreak()

The height of the calling tree is $log_2 n$. The number of call to $f$ is the number of nodes in the tree which is $Omicron(2^H)$. 

Explanation: 

#align(center, diagram(
    let (N, H,I, Q,R,S,T, L,M,O,P,U,V,W,Y) = (
        (-1.5,0), 
        (-2.75,1),(-0.25, 1), 
        (-3.25, 2),(-2.25, 2),(-0.75, 2),(0.25, 2), 
        (-3.5, 3),(-3, 3),(-2.5, 3),(-2, 3),(-1, 3),(-0.5, 3),(0, 3),(0.5, 3)
    ),

    node(N, $circle$),
    
    node(H, $circle$), node(I, $circle$), 
    
    node(Q, $circle$), node(R, $circle$), node(S, $circle$), node(T, $circle$),

    node(L, $circle$), node(M, $circle$), node(O, $circle$), node(P, $circle$),
    node(U, $circle$), node(V, $circle$), node(W, $circle$), node(Y, $circle$),

    edge(N, H, "->"), edge(N, I, "->"),

    edge(H, Q, "->"), edge(H, R, "->"),
    edge(I, S, "->"), edge(I, T, "->"),

    edge(Q, L, "--"), edge(Q, M, "--"),
    edge(R, O, "--"), edge(R, P, "--"),
    edge(S, U, "--"), edge(S, V, "--"),
    edge(T, W, "--"), edge(T, Y, "--"),

    node((1.5, 0), text(red, $1 "call "$)),
    node((1.5, 1), text(red, $2 "calls "$)),
    node((1.5, 2), text(red, $4 "calls "$)),
    node((1.5, 3), text(red, $2^H "calls "$)),

    edge((1.5, 2), (1.5, 3), "--", stroke: red)
))

Total number of nodes: 

$
"nb_nodes" &= 1 + 2 + 4 + ... + 2^H \ 
           &= 2^(H+1) \
           &= Omicron(2^H)
$

In our case 

$
f(n) &= Omicron(2^(log_2 n)) \
     &= Omicron(n)
$

#pagebreak()

=== Example 4: 

```
def f(n)
    if n = 0 -- O(1)
        return 
    f(n / 2)
    f(n / 2)
    f(n / 2)
```

#align(center, diagram(
    let (N, H,I,G, Q,R,J,S,T,K,E,F,X, L,M,O,P,U,V,W,Y,A,B,C,D) = (
        (-0.75,0), 
        

        (-3,1),(-0.75, 1),(1.5, 1),
        

        (-3.75, 2),(-2.25, 2),(-3, 2), 
        (-1.5, 2),(0, 2),(-0.75, 2),
        (0.75, 2),(2.25, 2),(1.5, 2),
        

        (-4.25, 3),(-3.75, 3),
        (-2.75, 3),(-2.25, 3),

        (-1.5, 3),(-1, 3),
        (-0.5, 3),(0, 3),

        (0.75, 3),(1.25, 3),
        (1.75,3),(2.25,3),
    ),

    node(N, $f(n)$),
    
    node(H, $f(n / 2)$), node(I, $f(n / 2)$), node(G, $f(n / 2)$), 
    
    node(Q, $f(n / 4)$), node(R, $f(n / 4)$), node(J, $f(n / 4)$), 
    node(S, $f(n / 4)$), node(T, $f(n / 4)$), node(K, $f(n / 4)$),
    node(E, $f(n / 4)$), node(F, $f(n / 4)$), node(X, $f(n / 4)$),

    edge(N, H, "->"), edge(N, I, "->"), edge(N, G, "->"), 

    edge(H, Q, "->"), edge(H, R, "->"), edge(H, J, "->"),
    edge(I, S, "->"), edge(I, T, "->"), edge(I, K, "->"),
    edge(G, E, "->"), edge(G, F, "->"), edge(G, X, "->"),

    let dx = 0,
    let y = 0.75,
    edge(Q, (-3.75, 3), "--"), edge(R, (-3.75+2*y, 3), "--"), edge(J, (-3.75+y, 3), "--"), edge(S, (-3.75+3*y, 3), "--"), edge(T, (-3.75+5*y, 3), "--"), edge(K, (-3.75+4*y, 3), "--"), edge(E, (-3.75+6*y, 3), "--"), edge(F, (-3.75+8*y, 3), "--"), edge(X, (-3.75+7*y, 3), "--"),

    let dx = 0.2,
    let y = 0.75,
    edge(Q, (-3.75+dx, 3), "--"), edge(R, (-3.75+2*y+dx, 3), "--"), edge(J, (-3.75+y+dx, 3), "--"), edge(S, (-3.75+3*y+dx, 3), "--"), edge(T, (-3.75+5*y+dx, 3), "--"), edge(K, (-3.75+4*y+dx, 3), "--"), edge(E, (-3.75+6*y+dx, 3), "--"), edge(F, (-3.75+8*y+dx, 3), "--"), edge(X, (-3.75+7*y+dx, 3), "--"),

    let dx = -0.2,
    let y = 0.75,
    edge(Q, (-3.75+dx, 3), "--"), edge(R, (-3.75+2*y+dx, 3), "--"), edge(J, (-3.75+y+dx, 3), "--"), edge(S, (-3.75+3*y+dx, 3), "--"), edge(T, (-3.75+5*y+dx, 3), "--"), edge(K, (-3.75+4*y+dx, 3), "--"), edge(E, (-3.75+6*y+dx, 3), "--"), edge(F, (-3.75+8*y+dx, 3), "--"), edge(X, (-3.75+7*y+dx, 3), "--"),

    edge((2.75, 0), (2.75, 3), "<->", stroke: red, label: text(red, $H = log_2 n$), label-side: left, label-angle: right)
))

#linebreak()

The height of the tree is the same but the total number of call will now be $Omicron(3^H)$

In our case: 

$
f(n) &= Omicron(3^(log_2 n)) \
     &= Omicron(n^(log_2 3)) \
     &tilde.eq Omicron(n^1.7)
$

== Sorting 

$
"input:" a[0..n-1] \
"output:" b[0..n-1]
$

$b$ contain the same number as $a$ but in sorted order. 

=== Insertion sort 

==== Algorithm

The principle is easy, swap the $i^"th"$ element with the previous element while the $i^"th"$ is lesser. 

 Let's schematize the insertion sort with the array $a[3,1,4,2]$. 

#align(center, diagram(
    node-stroke: 1pt+red,
    node-shape: rect,
    
    let (a,b,c,d, e,f,g,h, i,j,k,l, m,n,o,p) = (
        (0,0),(0.5,0),(1,0),(1.5,0),
        (0,1),(0.5,1),(1,1),(1.5,1),
        (0,2),(0.5,2),(1,2),(1.5,2),
        (0,3),(0.5,3),(1,3),(1.5,3),
    ), 

    node(a, $3$, stroke: green), node(b, $1$), node(c, $4$), node(d, $2$), 

    node(e, $1$, stroke: green), node(f, $3$, stroke: green), node(g, $4$), node(h, $2$), 

    node(i, $1$, stroke: green), node(j, $3$, stroke: green), node(k, $4$, stroke: green), node(l, $2$), 

    node(m, $1$, stroke: green), node(n, $2$, stroke: green), node(o, $3$, stroke: green), node(p, $4$, stroke: green), 

    edge(b, a, "<->", bend: +90deg),
    edge((1, 1.5), g, "->"), 
    edge(l, k, "<->", bend: +90deg),
    edge(k, j, "<->", bend: +90deg),
))

#linebreak()

Here is the pseudo-code for the insertion sort: 

```
for i = 1..n-1 
    j = i
    while j > 0 and a[j] < a[j-1]
        swap(a[j], a[j-1])
        j -= 1
    // sorted a[0..i]
```

Let's prove that this algorithm works using for invariant. 

Let's prove that after each iterations we have sorted $a[0..i]$. 

By induction: at the $i^"th"$, we have $a[0..i-1]$ sorted. 

We are swapping the $j^"th"$ element until $a[j] > a[j-1]$ and from the previous while iteration we have $a[j] < a[j+1]$. 

So, we finally have: 

#align(center, diagram(
    let (a, j, o, e, c, i, cc) = (
        (0,0), (2, 0.3), (0.35, 0), (4, 0), (2, 0), (3, 0.3), (3, 0)    
    ),
    
    node(a, $a$),
    node(o, $$),
    node(j, $j$), 
    node(i, $i$), 
    node(c, $<= circle.small <$), 
    node(cc,$circle.small$), 
    node(e, $$),
 
    edge(o, c, "|==|"),
    edge(c, cc, "|==|"),
    edge(cc, e, "|==|"),

    edge((0.6, -0.2), (1.7, -0.5), "->"),
    edge((2.1, -0.2), (2.9, -0.5), "->")
))

#linebreak()

We have sorted the element in a previously sorted array. 

==== Complexity

Now, let's compute the algorithm complexity. What is tricky here is that the complexity may vary from an input to another.

===== Best case 

In an already sorted array, $Omicron(n)$. 

Each time, we do not enter in the while-loop so constant operation by iteration.

===== Worst case

Inverted sorted array, $Omicron(n^2)$. 

If we do not make the difference for an algorithm, we are talking about the worst case. 

=== Merge sort

==== Merge function 

$
"input": a " " amp " " b "two sorted array" \
"output": c "the merged sorted array"
$

Example: 

$
"input": a[1;5;10] " " amp " " b[2;4;6] \
"output": c[1;2;4;5;6;10]
$

In order to achieve that, we use two pointer technique: 

#align(center, diagram(
    let (a, a1, a2, a3, b, b1, b2, b3, cmp, c, c1, c2, c3) = (
        (0,0), (0.25,0), (0.5,0), (0.75,0), 
        (0,0.75), (0.25,0.75), (0.5,0.75), (0.75,0.75), 
        (2, 0), 
        (1.75,0.75), (2,0.75), (2.25, 0.75), (2.5, 0.75)
    ),

    node(a, $a |$), node(a1, $1$), node(a2, $5$), node(a3, $10$),
    node(b, $b |$), node(b1, $2$), node(b2, $4$), node(b3, $6$),

    edge((0.25, 0.4), a1, "->", $i$, label-side: right),
    edge((0.25, 1.15), b1, "->", $j$, label-side: right),

    edge((1.25,-0.25), (1.25, 1)),
    
    node(cmp, $a[i] < a[j]$), 

    node(c, $c |$), 
    node(c1, $1$), node(c2, " "), node(c3, " ")
))


#align(center, diagram(
    let (a, a1, a2, a3, b, b1, b2, b3, cmp, c, c1, c2, c3) = (
        (0,0), (0.25,0), (0.5,0), (0.75,0), 
        (0,0.75), (0.25,0.75), (0.5,0.75), (0.75,0.75), 
        (2, 0), 
        (1.75,0.75), (2,0.75), (2.25, 0.75), (2.5, 0.75)
    ),

    node(a, $a |$), node(a1, $cancel(1, stroke: #(paint: red, thickness: 1pt,))$), node(a2, $5$), node(a3, $10$),
    node(b, $b |$), node(b1, $2$), node(b2, $4$), node(b3, $6$),

    edge((0.5, 0.4), a2, "->", $i$, label-side: right),
    edge((0.25, 1.15), b1, "->", $j$, label-side: right),

    edge((1.25,-0.25), (1.25, 1)),
    
    node(cmp, $a[i] > a[j]$), 

    node(c, $c |$), 
    node(c1, $1$), node(c2, $2$), node(c3, " ")
))


#align(center, diagram(
    let (a, a1, a2, a3, b, b1, b2, b3, cmp, c, c1, c2, c3) = (
        (0,0), (0.25,0), (0.5,0), (0.75,0), 
        (0,0.75), (0.25,0.75), (0.5,0.75), (0.75,0.75), 
        (2, 0), 
        (1.75,0.75), (2,0.75), (2.25, 0.75), (2.5, 0.75)
    ),

    node(a, $a |$), node(a1, $cancel(1, stroke: #(paint: red, thickness: 1pt,))$), node(a2, $5$), node(a3, $10$),
    node(b, $b |$), node(b1, $cancel(2, stroke: #(paint: red, thickness: 1pt,))$), node(b2, $4$), node(b3, $6$),

    edge((0.5, 0.4), a2, "->", $i$, label-side: right),
    edge((0.5, 1.15), b2, "->", $j$, label-side: right),

    edge((1.25,-0.25), (1.25, 1)),
    
    node(cmp, $a[i] > a[j]$), 

    node(c, $c |$), 
    node(c1, $1$), node(c2, $2$), node(c3, $4$),

    node((1.25, 1.5), $dots.v$)
))

#codly(
    annotation-format: none,    
    annotations: (
        (
            start: 1, end: none,
            content: text(red, $" " Omicron(n "+" m) "                                            "$),
        ),
    )
)
```
def merge(a, b)
    n = len(a)
    m = len(b)
    i, j, k = 0
    c = int[n+m]
    while i < n or j < m 
        if j = m or (i < n and a[i] < b[j])
            c[k++] = a[i++]
        else 
            c[k++] = b[j++] 
    return c 
```

Here, we construct a new array $c$ containing the sorted element. It is possible to do it without but it is more complicated.

==== Algorithm

To use this merge function to make the a sorting algorithm we use the divide & conquer method. 

The objective here is to make recursive call dividing the array by 2 each time until is size is 1. After that we reconstruct the array with our merge function. 

#codly(
    annotation-format: none,    
    annotations: (
        (
            start: 2, end: 5,
            content: text(red, $" " Omicron(n) "                                            "$),
        ),
        (
            start: 7, end: 8,
            content: text(red, $" " T(n/2) " * " 2 "                                            "$),
        ),
        (
            start: 10, end: none,
            content: text(red, $" " Omicron(n) "                                            "$),
        ),
    )
)
```
def sort(a) 
    if len(a) < 2 
        return a 
    b = a[0..(n/2 - 1)]
    c = a[n/2..n-1]
    
    sort(b)
    sort(c)
    
    return merge(b, c)
```

==== Time complexity 

$
T(n) &= 2 dot T(n/2) + c dot n \ 
     &= Omicron(n log n)
$

#align(center, diagram(
    let (N, H,I, Q,R,S,T, L,M,O,P,U,V,W,Y) = (
        (-1.5,0), 
        (-2.75,1),(-0.25, 1), 
        (-3.25, 2),(-2.25, 2),(-0.75, 2),(0.25, 2), 
        (-3.5, 3),(-3, 3),(-2.5, 3),(-2, 3),(-1, 3),(-0.5, 3),(0, 3),(0.5, 3)
    ),

    node(N, $n$),
    
    node(H, $n/2$), node(I, $n/2$), 
    
    node(Q, $n/4$), node(R, $n/4$), node(S, $n/4$), node(T, $n/4$),

    node(L, $circle$), node(M, $circle$), node(O, $circle$), node(P, $circle$),
    node(U, $circle$), node(V, $circle$), node(W, $circle$), node(Y, $circle$),

    edge(N, H, "->"), edge(N, I, "->"),

    edge(H, Q, "->"), edge(H, R, "->"),
    edge(I, S, "->"), edge(I, T, "->"),

    edge(Q, L, "--"), edge(Q, M, "--"),
    edge(R, O, "--"), edge(R, P, "--"),
    edge(S, U, "--"), edge(S, V, "--"),
    edge(T, W, "--"), edge(T, Y, "--"),

    node((1.5, 0), text(red, $n "operations"$)),
    node((1.5, 1), text(red, $n "operations"$)),
    node((1.5, 2), text(red, $n "operations"$)),
    node((1.5, 3), text(red, $n "operations"$)),

    edge((1.5, 2), (1.5, 3), "--", stroke: red),

    edge((2.75, 0), (2.75, 3), "<->", stroke: red, label: text(red, $H = log_2 n$), label-side: left, label-angle: right),

    node((1.5,3.5), text(red, $"Overall complexity" = n dot log n$))
))

Another proof: 

$
T(n) &<= 2 dot T(n/2) + c dot n \
     &<= 2c dot n/2 dot log n/2 + c dot n \
     &=    c dot n dot log(n -1) + c dot n \ 
     &= Omicron(n log n)
$

==== Generalization 

Let's generalize such complexity using master theorem. 

We want to determine the complexity of $g(n)$. This function make $a$ calls to $g(n/b)$ and 1 call to $f(n)$. 

$
T(n) &= a dot T(n/b) + f(n) \ 
     &= a^(log_b n) + f(n) \
     &= n^(log_b a) + f(n)
$

From there, multiple case: 

$
f(n) &= Omicron(n^((log_b a) - epsilon)) => T(n) = Omicron(n^(log_b a)) \
f(n) &= Omicron(n^((log_b a) + epsilon)) => T(n) = Omicron(n^((log_b a) + epsilon)) \
f(n) &= Omicron(n^(log_b a)) => T(n) = Omicron(n^(log_b a))
$

_Note that we can use $Theta$ in master theorem_.
