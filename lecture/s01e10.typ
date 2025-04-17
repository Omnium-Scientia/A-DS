#import "@preview/fletcher:0.5.5": *
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
  semester: "1", 
  chapter_number: "10", 
  video_link: "https://www.youtube.com/watch?v=_jK_sJrvrkY&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=10",
  title: "Dynamic Programming - PART I"
)

= Dynamic Programming - PART I

Dynamic programming is one of the basic technique of algorithm theory. It is used in various algorithms to solve various type of problems. 

In this first part we are going to see common simple problem that will make us understand the basics of dynamic programming.

== Fibonacci sequence 

=== Definition 

$
F_0 = 0; F_1 = F_2 = 1; \
forall n > 1, F_n = F_(n-1) + F_(n-2)
$

=== Naive implementation 

```
def F(n)
    if n == 0 
        return 0 
    if n <= 2
        return 1 
    else 
        return f(n-1) + f(n-2)
```

This solution is totally correct, but its time complexity is far too big. 

$
T(n) &= 1 + T(n - 1) + T(n - 2) \ 
     &>= F_n \
     &>= phi^n \ 
     &= Omicron(2^n)
$

An exponential complexity is not usable in real life. Lets try to understand why our complexity is that big. Then we will try to decrease it. 

#align(center, diagram(
  let (N, H,I, Q,R,S,T, L,M,O,P,U,V,W,Y) = (
    (-1.5,0), 
    (-2.75,1),(-0.25, 1), 
    (-3.25, 2),(-2.25, 2),(-0.75, 2),(0.25, 2), 
    (-3.5, 3),(-3, 3),(-2.5, 3),(-2, 3),(-1, 3),(-0.5, 3),(0, 3),(0.5, 3)
  ),

  node(N, $F(10)$),
  
  node(H, $F(9)$), node(I, $F(8)$, stroke:blue, shape:shapes.pill), 
  
  node(Q, $F(8)$, stroke:blue, shape:shapes.pill), node(R, $F(7)$, stroke:red, shape:shapes.pill), node(S, $F(7)$, stroke:red, shape:shapes.pill), node(T, $F(6)$),

  node(L, $F(7)$, stroke:red, shape:shapes.pill), node(M, $...$), node(O, $...$), node(P, $...$),
  node(U, $...$), node(V, $...$), node(W, $...$), node(Y, $...$),

  edge(N, H, "->"), edge(N, I, "->"),

  edge(H, Q, "->"), edge(H, R, "->"),
  edge(I, S, "->"), edge(I, T, "->"),

  edge(Q, L, "--"), edge(Q, M, "--"),
  edge(R, O, "--"), edge(R, P, "--"),
  edge(S, U, "--"), edge(S, V, "--"),
  edge(T, W, "--"), edge(T, Y, "--"),

))

As we can see, we are computing the same value multiple time (red and blue nodes for example). Our objective is that our next implementation compute each value only one time. 

In order to do that, we will use memoization. We save the Fibonacci number for each $n$. When we will have to use again that number, we will get it from our saved array instead of computing it again.

=== Memoization 

The objective here is to  save the Fibonacci number for each $n$. When we will have to use again that number, we will get it from our saved array instead of computing it again.

```
def F(n)
    res[0] = 0, res[1] = res[2] = 1
    if res[n] != null 
        return res[n]
    else 
        res[n] = F(n - 1) + F(n - 2)
    return res[n]
```

Since we do the recursive call $1$ time for each $n$ and that the call of get in our array is $Omicron(1)$, we have: 

$
T(n) = Omicron(n)
$

Our new call tree is now: 

#align(
  center,
  diagram(
    let (n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,0),(-0.5,1),(0.5,1),(-1,2),(0,2),(-1.5,3),(-0.5,3),(-2,4),(-1,4),
    ),
    node(n1,$F(10)$),node(n2,$F(9)$),node(n3,$F(8)$),node(n4,$F(8)$),node(n5,$F(7)$),node(n6,$F(7)$),node(n7,$F(6)$),node(n8,$F(6)$),node(n9,$F(5)$),
    edge(n1,n2),edge(n1,n3),edge(n2,n4),edge(n2,n5),edge(n4,n6),edge(n4,n7),edge(n6,n8),edge(n6,n9),

    edge(n8,(-2.25,4.5),".."),edge(n1,(-2.4,4.5),bend:-30deg,stroke:red,text(fill:red)[$n$ elt])
  )
)

=== Bottom up approach 

Lets simplify the procedure using for-loop instead of recursion. 

```
def F(n)
    res[0] = 0, res[1] = res[2] = 1
    for i = 3..n
        res[i] = res[i-1] + res[i-2]
    return res[n]
```

_Note 1: if you want you can make this function keeping only the 2 previous result to achieve the computation of $F_n$ in order to optimize the memory usage. But it is not the object of this session._

_Note 2: Fibonacci sequence is well know and we can achieve even better complexity to compute it. If you want to see cool technique to do that such as fast Fourier transform and other things, see the video $->$ #link("https://www.youtube.com/watch?v=KzT9I1d-LlQ&t=1333s", [One second to compute the largest Fibonacci number I can])._

== Grasshopper problem

We are given an array, a grasshopper is on the leftmost cell of this array. This grasshopper want  to go to the rightmost cell of the array. 

It can make a small jump:
- from index $i$ to $i+1$
and big jump: 
- from $i$ to $i+2$

We want to calculate the number of different path that exist between leftmost and rightmost position. 

Example: 

#align(
  center, 
  diagram(
    let y = 0,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    node(n0,$0$),node(n1,$1$),node(n2,$2$),node(n3,$3$),node(n4,$4$),node(n5,$5$),node(n6,$6$),node(n7,$7$),node(n8,$8$),node(n9,$9$),

    let y = -0.25,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    edge(n0,n1,"|-"),edge(n1,n2,"|-"),edge(n2,n3,"|-"),edge(n3,n4,"|-"),edge(n4,n5,"|-"),edge(n5,n6,"|-"),edge(n6,n7,"|-"),edge(n7,n8,"|-"),edge(n8,n9,"|-|"),

    node((0,-0.5),text(fill:green)[$circle$]),
  )
)

If we have a path that make us arrive on the cell $9$: 
- It means that we either came from cell $8$ with a small jump 
- Or cell $7$ from a big jump

The number of path to the cell $9$ is then the number of path from cell $8 +$ the number of path from the cell $7$. 

Lets define: 
$
D[n] eq.def "number of path to cell" n \
D[n] = D[n-1] + D[n-2]
$

We have the same recursion relation than for the Fibonacci sequence. But here our initial values are: 

$
D[0] = D[1] = 1
$

```
def grasshopper(n)
    D[0] = D[1] = 1
    for i = 2..n
        D[i] = D[i-1] + D[i-2]
    return D[n]
```

#pagebreak()

Example answer: 

#align(
  center, 
  diagram(
    let y = 0,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    node(n0,$0$),node(n1,$1$),node(n2,$2$),node(n3,$3$),node(n4,$4$),node(n5,$5$),node(n6,$6$),node(n7,$7$),node(n8,$8$),node(n9,$9$),

    let y = -0.25,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    edge(n0,n1,"|-"),edge(n1,n2,"|-"),edge(n2,n3,"|-"),edge(n3,n4,"|-"),edge(n4,n5,"|-"),edge(n5,n6,"|-"),edge(n6,n7,"|-"),edge(n7,n8,"|-"),edge(n8,n9,"|-|"),

    node((4.5,-0.5),text(fill:green)[$circle$]),

    let y = 0.3,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    node(n0,$1$),node(n1,$1$),node(n2,$2$),node(n3,$3$),node(n4,$5$),node(n5,$8$),node(n6,$13$),node(n7,$21$),node(n8,$34$),node(n9,$55$),

    node((-0.25,0.3),$D[$),node((4.7,0.3),$]$),
  )
)

== Number of binary vector not containing \`11\`

We have a binary vector of length $n$. We want a vector not to contain the sequence \`11\`. 

How many different vectors to not contain \`11\` are they for a given $n$? 

Lets define: 
$
D[n] eq.def "number of different vectors without `11`" \
D[n] = underbrace(D[n-1],#text(fill:blue)[our vector end by \`0\`]) + underbrace(D[n-2],#text(fill:blue)[our vector end by \`01\`])
$

We have $D[0] = 0$, $D[1] = 2$. 

This kind of problems can occurs in some encoding theory algorithm. It is more practical than the other problems but not so much. 

== Grasshopper with $k$ jumps

=== $3$ jumps

We simply add one more layer to our first grasshopper algorithm.

```
def grasshopper_3(n)
    D[0] = D[1] = 1, D[2] = 2
    for i = 3..n
        D[i] = D[i-1] + D[i-2] + D[i-3]
    return D[n]
```

The algorithm begin to be bad. We have many special case, which is never a good thing. 

This will become a real problem if we add more jumps. 

=== $k$ jumps

Now our grasshopper may do $k$ types of jumps: 
- $i^("th") "cell" -> (i+1)^("th") "cell"$
- $i^("th") "cell" -> (i+2)^("th") "cell"$
- #align(center,$...$)
- $i^("th") "cell" -> (i+k)^("th") "cell"$

In this case we cannot use the same technique of just adding more layer as the one for $3$ jumps. 

We can only compute the first value by hand: 
$
D[0] = 1
$

The idea is to make a cycle for all the possible jump in our loop. We check if the jump is possible, if so, we add this value to our result. 

```
def grasshopper_k(n,k)
    D[0] = 1
    for i = 0..n
        for j = 1..k
            if i - j >= 0
                D[i] += D[i-j]
    return D[n]
```

The complexity here is $Omicron(n dot k)$. This can be easily done in $Omicron(n)$ using prefix sum instead of the second loop. 

== Grasshopper with cell cost

Now, each cell the grasshopper can hop on as a cost. 

#align(
  center, 
  diagram(
    let y = 0,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    node(n0,$0$),node(n1,$3$),node(n2,$2$),node(n3,$6$),node(n4,$7$),node(n5,$1$),node(n6,$5$),node(n7,$4$),node(n8,$3$),node(n9,$0$),

    node((-0.25,y),$c:$),

    let y = -0.25,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    edge(n0,n1,"|-"),edge(n1,n2,"|-"),edge(n2,n3,"|-"),edge(n3,n4,"|-"),edge(n4,n5,"|-"),edge(n5,n6,"|-"),edge(n6,n7,"|-"),edge(n7,n8,"|-"),edge(n8,n9,"|-|"),

    node((0,-0.5),text(fill:green)[$circle$]),
  )
)

You want to go from the leftmost to the rightmost element spending the less amount of coins. 

We do the same as before, split the different path in some sets. 

If you want to reach the $n^("th")$ cell then the last jump was: 
+ from $(n-1)^("th")$ cell
+ from $(n-1)^("th")$ cell

$
D[n] eq.def "miminum cost to reach the cell" n
$

$
D[n] = underbrace(min,"optimal cost")(underbrace(D[n-1],1),underbrace(D[n-2],2)) + underbrace(c[n],"cost of last jump")
$

Lets see the result for our example: 

#align(
  center, 
  diagram(
    let y = 0,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    node(n0,$0$),node(n1,$3$),node(n2,$2$),node(n3,$6$),node(n4,$7$),node(n5,$1$),node(n6,$5$),node(n7,$4$),node(n8,$3$),node(n9,$0$),

    node((-0.25,y),$c:$),

    let y = -0.25,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    edge(n0,n1,"|-"),edge(n1,n2,"|-"),edge(n2,n3,"|-"),edge(n3,n4,"|-"),edge(n4,n5,"|-"),edge(n5,n6,"|-"),edge(n6,n7,"|-"),edge(n7,n8,"|-"),edge(n8,n9,"|-|"),

    node((4.5,-0.5),text(fill:green)[$circle$]),

    let y = 0.3,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    node(n0,$0$),node(n1,$3$),node(n2,$5$),node(n3,$9$),node(n4,$12$),node(n5,$10$),node(n6,$15$),node(n7,$14$),node(n8,$17$),node(n9,$14$),

    node((-0.25,y),$D[$),node((4.7,y),$]$),
  )
)

```
def grasshopper_cost(n,c)
    D[0] = 0, D[1] = c[1]
    for i = 1..n
        D[i] = min(D[i-1],D[i-2]) + c[i]
    return D[n]
```

== Grasshopper with cell cost + $k$ jumps

The idea is the same but instead of having the minimum of the $k$ previous element: 

$
D[n] eq.def "miminum cost to reach the cell" n
$

$
D[n] = min_(i in bracket.double.l 1,k bracket.double.r) (D[n-i]) + c[n]
$

```
def grasshopper_k_jump(n,k,c)
    D[0] = 1
    for i = 1..n
        D[i] = + inf
        for j = i..k 
            if i-j >= 0 
                D[i] = min(D[i],D[i-j]+c[i])
    return D[n]
```

The complexity here is also $Omicron(n dot k)$. Again, this can be improved to $Omicron(n)$ using sliding windows and maintaining is minimum.

Now that we now the cost of the optimal path, we want to get the path itself. 

The idea is to start from the $n^("th")$ cell and check where are we coming from. Then we repeat that for our result until we arrive on the first cell. 

Analyzing that, we see that we are just running the algorithm backward. So what we want to do is to maintain an other array. Lets call it $P$. Where: 

$
P[n] eq.def "the last cell on the path"
$

For our previous example we got: 

#align(
  center, 
  diagram(
    let y = 0,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    node(n0,$0$),node(n1,$3$),node(n2,$2$),node(n3,$6$),node(n4,$7$),node(n5,$1$),node(n6,$5$),node(n7,$4$),node(n8,$3$),node(n9,$0$),

    node((-0.25,y),$c:$),

    let y = -0.25,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    edge(n0,n1,"|-"),edge(n1,n2,"|-"),edge(n2,n3,"|-"),edge(n3,n4,"|-"),edge(n4,n5,"|-"),edge(n5,n6,"|-"),edge(n6,n7,"|-"),edge(n7,n8,"|-"),edge(n8,n9,"|-|"),

    node((4.5,-0.5),text(fill:green)[$circle$]),

    let y = 0.3,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    node(n0,$0$),node(n1,$3$),node(n2,$5$),node(n3,$9$),node(n4,$12$),node(n5,$10$),node(n6,$15$),node(n7,$14$),node(n8,$17$),node(n9,$14$),

    node((-0.25,y),$D[$),node((4.7,y),$]$),

    let y = 0.6,
    let (n0,n1,n2,n3,n4,n5,n6,n7,n8,n9) = (
      (0,y),(0.5,y),(1,y),(1.5,y),(2,y),(2.5,y),(3,y),(3.5,y),(4,y),(4.5,y),
    ),

    node(n0,$-1$),node(n1,$0$),node(n2,$0$),node(n3,$1$),node(n4,$2$),node(n5,$3$),node(n6,$5$),node(n7,$5$),node(n8,$7$),node(n9,$6$),

    node((-0.25,y),$P[$),node((4.7,y),$]$),
  )
)

To get our path when we have P, we start from $P[n]$ and go on the next index until reaching $-1$.

```
def grasshopper_path(n,k,c)
    D[0] = 0
    for i = 1..n
        D[i] = + inf
        for j = i..k
            if i-j >= o
                 if D[i-j] + c[i] < D[i]
                    D[i] = D[i-j] + c[i]
                    P[i] = i-j
    x = n 
    while x != -1
        path.add(x)
        x = P[x]
    return D[n], reverse(path)
```

#pagebreak()

== Turtle on a $2D$ grid 

#align(
  center,
  table(
    columns: (1.5em,1.5em,1.5em,1.5em), 
    rows: (1.5em,1.5em,1.5em,1.5em,1.5em),
    [#text(fill:green)[$circle$]],[3],[2],[3],
    [1],[6],[5],[7],
    [2],[3],[1],[2],
    [8],[2],[1],[6],
    [3],[2],[1],[#text(fill:red)[$crossmark$]],
  )
)

We have a turtle on the upper-left corner of a $2D$ grid. This turtle want to go at the bottom right corner. She can only go down or right. On each cell there is an amount of salad. 

What is the maximum amount of salad the turtle can eat on her path. 

The basic idea is the same as the previous problems. We want to maintain an array that contain the maximum for each cell. 

Here we are in $2D$. Our array will then also be in $2D$: 

$
D[i,j] eq.def "max sum to reach cell" (i,j)
$

If we are on the cell $(i,j)$ we either come from: 
- $(i-1,j)$
- $(i,j-1)$

We then need to get the maximum between optimal path for $(i,j-1)$ and $(i-1,j)$ in order to get the optimal one for $(i,j)$. 

The code is the same but with $2$ loops. 

You can actually do the same as this grid problem in any acyclic graph. 

#align(
  center,
  diagram(
    let (n0,n1,n2,n3,n4,n5,n6) = (
      (0,0),(1,0.5),(1,-0.5),(2,0),(3,0.5),(3,-0.5),(4,0),
    ), 

    node(n0,$circle.big$),node(n1,$circle.big$),node(n2,$circle.big$),node(n3,$circle.big$),node(n4,$circle.big$),node(n5,$circle.big$),node(n6,$circle.big$),

    edge(n0,n1,"->"),edge(n0,n2,"->"),edge(n1,n3,"->"),edge(n2,n3,"->"),edge(n1,n4,"->"),edge(n2,n5,"->"),edge(n3,n4,"->"),edge(n3,n5,"->"),edge(n4,n6,"->"),edge(n5,n6,"->"),
  )
)

We will talk about them during the semester 3.

== Grasshopper with jump restrictions

Here we stay with the same base rule than before but we add constrain: 
- if the $j^("th")$ jump was of length $k$ then $(j+1)^"th"$ jump must be of length at least $k$. 


#align(
  center,
  diagram(
    let (n0,n1,n2) = ((0,0),(1.5,0),(3,0)), 

    node(n1,$"  "$,stroke:1pt,shape:shapes.rect),node(n2,$"  "$,stroke:1pt,shape:shapes.rect),

    edge(n0,n1,"->",bend:40deg,label:$<=j$),edge(n1,n2,"->",bend:40deg,label:$j<=k$)
  )
)

There is $2$ way to think about this:
- if we arrive on the $n^"th"$ call with a jump of length $k$: 
  - it mean we came from cell $(n-k)$ and the jump to $(n-k)$ was of length $<= k$ 
  We have 2 parameters for our problem: 
    - landing cell
    - length of the last jump
- lets view our start and end cell as a state. We want to describe our states with at least variable as possible. 

  Here we have 2 of them: 
    - where do we stand 
    - what was our last jump

$
D[n,k] eq.def "number of path to cell" n "with last jump" <= k
$

$
D[n,k] = sum_(j=1)^k D[n-j,j]
$

```
def grasshopper(n,k)
    D[0] = 1
    for i = 1..n
        for h = 1..i
            for j = 1..h 
                D[i,h] += D[i-j,j]
```

Here we have $Omicron(n^3)$ but we can improve to $Omicron(n^2)$.

The same algorithm construction can be made for any optimization problem of minimal cost. 
