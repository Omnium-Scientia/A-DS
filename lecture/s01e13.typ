#import "@preview/fletcher:0.5.5": *
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
  semester: "1", 
  chapter_number: "13", 
  video_link: "https://www.youtube.com/watch?v=0bnMHlFUM_o&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=13",
  title: "DP on subsets, DP on profiles"
)

= Dynamic programming on subsets, on profiles

== Dynamic programming on subset

This is when you do dynamic programming and the parameter of your program is a subset. 

$
D[X] - X "is a subset"
$

We already talk a little about that on lecture 12. 

=== Traveling salesman problem

You have a graph, each vertices represent a town, each edge represent a road between two towns. 

Example: 

#align(
  center, 
  diagram(
    node-stroke:1pt,
    let (n0,n1,n2,n3,n4,n5,n6,n7) = (
      (0,0),(0,-2),(-2,-2),(-2,2),(0,2),(2,0),(4,2),(4,-2),
    ),

    node(n0,$$),node(n1,$$),node(n2,text(fill:red)[$S$],stroke:red),node(n3,$$),node(n4,$$),node(n5,$$),node(n6,$$),node(n7,$$),
  
    edge(n0,n2,label:$4$,label-side:left),edge(n0,n3,label:$2$,label-side:right),edge(n0,n4,label:$2$,label-side:left),edge(n0,n5,label:$3$,label-side:right),edge(n1,n2,label:$7$),edge(n1,n5,label:$5$,label-side:right),edge(n1,n7,label:$6$,label-side:left),edge(n2,n3,label:$3$,label-side:right),edge(n3,n4,label:$5$,label-side:right),edge(n4,n5,label:$3$,label-side:right),edge(n4,n6,label:$8$,label-side:right),edge(n5,n7,label:$7$,label-side:right),edge(n6,n7,label:$5$,label-side:right),
  )
)

Goal: you start from #text(fill:red)[$S$] and you need to visit all the cities while minimizing your traveling distance. 

#align(
  center, 
  diagram(
    node-stroke:1pt,
    let (n0,n1,n2,n3,n4,n5,n6,n7) = (
      (0,0),(0,-2),(-2,-2),(-2,2),(0,2),(2,0),(4,2),(4,-2),
    ),

    node(n0,$$),node(n1,$$),node(n2,text(fill:red)[$S$],stroke:red),node(n3,$$),node(n4,$$),node(n5,$$),node(n6,$$),node(n7,$$),
  
    edge(n0,n2,label:$4$,label-side:left),edge(n0,n3,"<-",stroke:green,label:$2$,label-side:right),edge(n0,n4,"->",stroke:green,label:$2$,label-side:left),edge(n0,n5,label:$3$,label-side:right),edge(n1,n2,label:$7$),edge(n1,n5,"<-",stroke:green,label:$5$,label-side:right),edge(n1,n7,"->",stroke:green,label:$6$,label-side:left),edge(n2,n3,"->",label:$3$,label-side:right,stroke:green),edge(n3,n4,label:$5$,label-side:right),edge(n4,n5,"->",stroke:green,label:$3$,label-side:right),edge(n4,n6,label:$8$),edge(n5,n7,label:$7$,label-side:right),edge(n6,n7,"<-",stroke:green,label:$5$,label-side:right),
  )
)

Here our traveling distance is $26$. 

This is a common graph problem. And it is know to be NP-Complete as the knapsack problem (again, we will talk about complexity classes in S02L15). But for now, we just keep in mind that it mean we do nt have an efficient solution. 

But, we can make a working algorithm with complexity of $Omicron(2^n)$ where $n$ is the number of vertices (which is much better than the naive algorithm working in $Omicron(n!)$) to find a solution. And we remember from the precedent lecture that algorithm with complexity of $Omicron(2^n)$ are usable with small $n$. 

When we are running our program, we construct our solution going from 1 vertices to an other. When we arrive on a vertices, the state of our algorithm is the following: 
- we have visited a subset $X$ of $G$ vertices (where $G$ is the subset of all the graph vertices). 
- the path we took to do that is of length $m$. 
- our path end on vertices $V$

From that we have: 

$
D[X,V] eq.def "the minimal cost (shortest path) to visit subset" X "while ending on" V
$

Now, we need to define our transition between 2 states. To do that, you can either find all the previous state or all the next states. Lets see forward in this case and find all our next states. 

When we are on $V$, we can use an edge to go on vertices $U$. 
$
(X,V) -> (X union {U}, U)
$

We can do this for each $U$ that we can access from $V$ that are not already in $X$. 

```
def traveling_salesman(S,graph)
    D[1<<S,S] = 0
    for X = 0..(2**n - 1)
        for V = 0..n-1
            for V -> U: out(V)
                if X & (1<<U) = 0 // U not in X 
                    Y = X + (1<<U)
                    D[Y,U] = min(D[Y,U],D[X,V] + len(V,U))
    ans = 0 
    for V = 0..n-1 
        ans = min(ans, D[(1<<n) - 1, V])
```

This is an example of problem that you can solve using dynamic programming on a subset. These kind of problems are represented by state of dynamic programming that are dependent of a subset of objects (here our visited vertices). 

#pagebreak()

== Dynamic programming on profiles (Domino tilling)

We have a rectangle of size $n times m$. We fill this rectangle with small rectangles of size $1 times 2$. 

The objective is to count the number of ways to fill this rectangle with $1 times 2$ rectangle. 

Example with $n=6, m=7$: 

#align(
  center,
  diagram(
    let (x,y) = (3.5,3), 
    let (c0,c1,c2,c3) = ((0,0),(x,0),(0,y),(x,y)), 

    edge(c0,c1),edge(c0,c2),edge(c1,c3),edge(c2,c3),

    edge((0.5,0),(0.5,3),stroke:blue),
    edge((1,0.5),(1,1.5),stroke:blue),
    edge((1.5,0),(1.5,3),stroke:blue),
    edge((2,0),(2,1),stroke:blue),edge((2,1.5),(2,2.5),stroke:blue),
    edge((2.5,0),(2.5,1.5),stroke:blue),edge((2.5,2.5),(2.5,3),stroke:blue),
    edge((3,1.5),(3,2.5),stroke:blue),

    edge((0.5,0.5),(1.5,0.5),stroke:blue),edge((2.5,0.5),(3.5,0.5),stroke:blue),
    edge((0,1),(0.5,1),stroke:blue),edge((1.5,1),(3.5,1),stroke:blue),
    edge((0.5,1.5),(3.5,1.5),stroke:blue),
    edge((0,2),(1.5,2),stroke:blue),edge((2,2),(3,2),stroke:blue),
    edge((0.5,2.5),(3.5,2.5),stroke:blue),
  )
)

_Note: We can find this solution in polynomial time using algebra and graphs but this is not the objective here and much more complicated. See further reading for article on Domino Tilling._

Here, what we want to do here is to fill the rectangle column by column from left to right. 

=== Full profile approach 

#align(
  center,
  diagram(
    let (x,y) = (6,3), 
    let (c0,c1,c2,c3) = ((0,0),(x,0),(0,y),(x,y)), 

    edge(c0,c1),edge(c0,c2),edge(c1,c3),edge(c2,c3),

    let (ox,oy,x,y) = (2.5,0.02,3.5,0.48), 
    let (c0,c1,c2,c3) = ((ox,oy),(x,oy),(ox,y),(x,y)), 
    edge(c0,c1,stroke:green),edge(c0,c2,stroke:green),edge(c1,c3,stroke:green),edge(c2,c3,stroke:green),
    let (ox,oy,x,y) = (3,1.02,3.5,1.98), 
    let (c0,c1,c2,c3) = ((ox,oy),(x,oy),(ox,y),(x,y)), 
    edge(c0,c1,stroke:green),edge(c0,c2,stroke:green),edge(c1,c3,stroke:green),edge(c2,c3,stroke:green),
    let (ox,oy,x,y) = (2.5,2.52,3.5,2.98), 
    let (c0,c1,c2,c3) = ((ox,oy),(x,oy),(ox,y),(x,y)), 
    edge(c0,c1,stroke:green),edge(c0,c2,stroke:green),edge(c1,c3,stroke:green),edge(c2,c3,stroke:green),

    let (ox,oy,x,y) = (3,0.52,4,0.98), 
    let (c0,c1,c2,c3) = ((ox,oy),(x,oy),(ox,y),(x,y)), 
    edge(c0,c1,stroke:red),edge(c0,c2,stroke:red),edge(c1,c3,stroke:red),edge(c2,c3,stroke:red),
    let (ox,oy,x,y) = (3,2.02,4,2.48), 
    let (c0,c1,c2,c3) = ((ox,oy),(x,oy),(ox,y),(x,y)), 
    edge(c0,c1,stroke:red),edge(c0,c2,stroke:red),edge(c1,c3,stroke:red),edge(c2,c3,stroke:red),

    let x = 3.54,
    edge((x,0),(x,0.48),(x+0.52,0.48),(x+0.52,1.02),(x,1.02),(x,1.98),(x+0.52,1.98),(x+0.52,2.52),(x,2.52),(x,3),stroke:blue),
    edge((x,3.5),(x,3.1),"->",stroke:blue),

    node((0.25,-0.3),text(8pt)[$0$]),node((3.25,-0.3),text(8pt)[$i-1$]),
  )
)

$
#text(10pt,fill:blue)[$"profile" = 010010$]
$

At this state, we have filled column $0$ to $i-1$. To fill the column $i$, I want to know what tile is straddling column $i-1$ and $i$#text(fill:red)[\*]. 

We want to remember the profile of the blue line. To do that, we use a bit sequence#text(fill:blue)[\*]: 
- $0$ mean that the tile is not straddling 
- $1$ mean that the tile is straddling 

We encode those bits as the number $p$ and we can define our state as: 

$
D[i,p] eq.def "number of ways to fill the first" i "columns with the profile" p
$

Now that we have our dynamic programming state, lets find our transitions. 

#align(
  center,
  diagram(
    let (x,y) = (6,3), 
    let (c0,c1,c2,c3) = ((0,0),(x,0),(0,y),(x,y)), 

    edge(c0,c1),edge(c0,c2),edge(c1,c3),edge(c2,c3),

    let (ox,oy,x,y) = (3.5,0.02,4.5,0.48), 
    let (c0,c1,c2,c3) = ((ox,oy),(x,oy),(ox,y),(x,y)), 
    edge(c0,c1),edge(c0,c2),edge(c1,c3),edge(c2,c3),

    let (ox,oy,x,y) = (3.5,1.02,4,1.98), 
    let (c0,c1,c2,c3) = ((ox,oy),(x,oy),(ox,y),(x,y)), 
    edge(c0,c1),edge(c0,c2),edge(c1,c3),edge(c2,c3),

    let (ox,oy,x,y) = (3.5,2.52,4.5,2.98), 
    let (c0,c1,c2,c3) = ((ox,oy),(x,oy),(ox,y),(x,y)), 
    edge(c0,c1),edge(c0,c2),edge(c1,c3),edge(c2,c3),

    let x = 3.46,
    edge((x,0),(x,0.52),(x+0.52,0.52),(x+0.52,0.98),(x,0.98),(x,2.02),(x+0.52,2.02),(x+0.52,2.48),(x,2.48),(x,3),stroke:blue),

    let x = 3.54,
    edge((x+1,0),(x+1,0.52),(x+0.52,0.52),(x+0.52,2.48),(x+1,2.48),(x+1,3),stroke:red),

    node((0.25,-0.3),text(8pt)[$0$]),node((3.25,-0.3),text(8pt)[$i-1$]),
  )
)

$
#text(10pt,fill:blue)[$p = 010010$], #text(10pt,fill:red)[$q = 100001$] 
$

$
(i,p) -> (i+1,q)
$

To check if we can go from profile $p$ to $q$: 
- When we have 2 profiles, there is a space between the 2 profiles. If this space can be filled by our tiles, then we can go from profile $p$ to $q$. 

Our first state is $0$ column filled and then an empty profile $-> D[0,0] = 1$. 

```
def solution(n,m) 
    D[0,0] = 1 
    for i = 0..m-1
        for p = 0..(2**n - 1)
            for q = 0..(2**n - 1)
                if comp(p,q)
                    D[i+1,q] += D[i,p]
    return D[m,0]
```

When $i = m-1$ we do not need to iterate over all $q$ just $0$. 

Check that we can go from $p$ to $q$: 
- if $p = 0, q = 1$ you have to put an horizontal tile 
- if $p = 0, q = 0$ you have to put a vertical tile 

If there is a solution, it is unique. But in some case we could not be able to put a tile, for example when we want to put a vertical tile, we need two consecutive bits to have the same configuration. If we do not have that we can go from $p$ to $q$. 

To achieve the `comp` function, we could iterate over the bits. But lets use bitwise operation to achieve that in constant time. Lets enumerate our possible state for the bits of $p$ and $q$ ($b_(i,p) eq.def "the" i^"th" "bit of profile" p$): 
- $b_(i,p) = b_(i,q) = 1$, we cannot go from $p$ to $q$.
  - to ensure that we do not have this state, we want $p \& q != 0$
- $b_(i,p) = 1, b_(i,q) = 0$, we can go from $p$ to $q$ and we do not need to put a tile. 
- $b_(i,p) = 0, b_(i,q) = 1$, we can go from $p$ to $q$ and we need to put an horizontal tile. 

- $b_(i,p) = 0, b_(i,q) = 0$, we can go from $p$ to $q$ and we need to put a vertical tile.
  
  But to do that, we need two consecutive row with this state. Which mean that we need: 
  - $(b_(i,p) = 0, b_(i,q) = 0) and (b_(i+1,p) = 0, b_(i+1,q) = 0)$
  - or $(b_(i,p) = 0, b_(i,q) = 0) and (b_(i-1,p) = 0, b_(i-1,q) = 0)$
  to be able to put a vertical tile. 

  We compute: $x = (tilde p \& tilde q)$
  $
  x = 00111101100110
  $

  Where a $1$ in $x$ mean that we have $b_(i,p) = 0, b_(i,q) = 0$. Now, we need to check if all our one can be splited by pair. The easiest way to do this is to divide $x$ by $3$. Because $11_2 = 3_10$. 

  $
  x &= 00111101100110 \ x/3 &= 00010100100010 
  $

  So, if $x mod 3 != 0$, it mean that we cannot divide all our $1$ into pair. 

  Then, we want to check that $y = x/3$ do not have two consecutive $1$. To do that we check that $y \& (y << 1) != 0$. 

We have our `comp` function working in $Omicron(1)$: 

```
def comp(p,q)
    if (p & q != 0) return false 
    x = (~p & ~q)
    if (x%3 != 0) return false 
    y = x/3 
    if (y & (y << 1) != 0) return false
    return true  
```

Now lets check our overall complexity for our solution. It is the product of our for-loop since $T("comp") = Omicron(1)$: 

$
T("solution") = Omicron(m dot 4^n)
$

Using a technique we previously used we can decrease our complexity, instead of iterating over all the possible profile and check if they are compatible, we can iterate only over the compatible ones. This would decrease our complexity to less than $Omicron(m dot 3^n)$ (we get rid of profile containing $b_(i,p) = b_(i,q) = 1$ and containing $b_(i,p) = 0, b_(i,q) = 0$ not in pair). 

=== Broken profile approach

The objective here is to reduce our time and code complexity. 

We face a problem that we already encountered once, we have to many transition between 2 states and this makes our complexity explode. We need to redefine our states and there transitions. Until now, when we were going from $i-1$ to $i$ we were adding $n$ square to our column. From now we want to add only 1 square to our column from 1 state to another.  

We have filled our first $i-1$ columns and the first $j$ rows of the $i^"th"$ column. 

Again, we keep track of the straddling tiles: 

$
D[i,j,p] eq.def &"number of way to fill the first" i "columns" \ &+ j "squares with profile" p
$

Our state looks a bit complicated but we are going to have much simpler transition. 

#align(
  center,
  diagram(
    let (x,y) = (6,3), 
    let (c0,c1,c2,c3) = ((0,0),(x,0),(0,y),(x,y)), 

    edge(c0,c1),edge(c0,c2),edge(c1,c3),edge(c2,c3),

    let x = 3.04,
    edge((x+0.5,0),(x+0.5,0.98),(x,0.98),(x,3),stroke:blue),

    let x = 3.08,
    edge((x+0.5,0),(x+0.5,1.52),(x,1.52),(x,3),stroke:red),

    node((0.25,-0.3),text(8pt)[$0$]),node((3.25,-0.3),text(8pt)[$i$]),node((-0.3,1.25),text(8pt)[$j$]),
  )
) 

$
(i,j) -> (i,j+1) 
$

There are 2 possibilities for $(i,j)$: 
+ The square we want to fill is already filled (by a straddling tile).
  
  It mean that $b_(j,p) = 1$, it become $0$ in the profile $q$ ($b_(j,q) = 0$). The next state is: 
  $
  b_(j,p) = 1 => (i,j,p) -> (i,j+1,q) "where" b_(j,q) = 1
  $
+ It is empty, then 2 choices: 
  - put an horizontal tile: 
    $
    b_(j,p) = 0 => (i,j,p) -> (i,j+1,q) "where" b_(j,q) = 1
    $
  - put a vertical tile. To do that, we need $b_(j+1,p) = 0$
    $
    b_(j,p) = 0 and b_(j+1,p) = 0 => (i,j,p) -> (i,j+1,q) "where" b_(j,q) = 0 and b_(j+1,q) = 1
    $

```
def solution(n,m)
    D[0,0,0] = 1
    for i = 0..m-1 
        for j = 0..n-1 
            for p = 0..(2**n - 1)
                if p & (1 << j) != 0 
                    q = p - (1 << j)
                    D[i,j+1,q] += D[i,j,p]
                else 
                    q = p + (1 << j)
                    D[i,j+1,q] += D[i,j,p]
                    if (j < n-1) && (p & (1 << (j+1)) == 0)
                        q = p + (1 << (j+1))
                        D[i,j+1,q] += D[i,j,p]
        for p = 0..(2**n - 1) 
            D[i,n,p] = D[i+1,n,p] // Transition from i -> i+1
    return D[m,0,0]
```

Our overall complexity is $Omicron(m dot 2^n)$ 

These techniques are useful when you build a solution layer by layer only using the previous layer. Mostly in $2D$ grid problems that we fill row by row or column by column. 

Here we counted the number of way to fill the grid but we can imagine optimization problems too, where for example each square as a cost and the manner of filling it cost less or more. 

== A second problem on profile (Grid coloring) 

#align(center,grid(
  stroke:0.5pt,
  columns: (1em,1em,1em,1em,1em,1em,1em,1em,1em,1em,),
  rows: (1em,1em,1em,1em,1em),
  [$$],[],[],[],[],[],[],[],[],[],
  [$$],[],[],[],[],[],[],[],[],[],
  [$$],[],[],[],[],[],[],[],[],[],
  [$$],[],[],[],[],[],[],[],[],[],
  [$$],[],[],[],[],[],[],[],[],[],
))

We have an $n times m$ rectangle. We color each $1 times 1$ square in black or white in such way that neither of those pattern exist: 

#grid(
  columns: (50%,50%), 
  align(center,grid(
    align: center+horizon,
    stroke:0.5pt,
    columns: (1em,1em),
    rows: (1em,1em),
    align(center + top)[$square.filled$],align(center + top)[$square.filled$],
    [$square.filled$],[$square.filled$],
  )), 
  align(center,grid(
  stroke:0.5pt,
  columns: (1em,1em),
  rows: (1em,1em),
    [$$],[],
    [$$],[],
  ))  
)

Here, we can see that is we are coloring column by column, we only meed to know the state of the last colored column to fill the new one. 

Using the broken profile approach, we do: 

#align(
  center,
  diagram(
    let (x,y) = (6,3), 
    let (c0,c1,c2,c3) = ((0,0),(x,0),(0,y),(x,y)), 

    edge(c0,c1),edge(c0,c2),edge(c1,c3),edge(c2,c3),

    let x = 2.50,
    edge((x+0.5,0),(x+0.5,0.5),(x,0.5),(x,3),stroke:black),
    let x = 3.04,
    edge((x+0.5,0),(x+0.5,0.98),(x,0.98),(x,3),stroke:black),

    let x = 3.08,
    edge((x+0.5,0),(x+0.5,1.52),(x,1.52),(x,3),stroke:red),

    node((0.25,-0.3),text(8pt)[$0$]),node((3.25,-0.3),text(8pt)[$i$]),node((-0.3,1.25),text(8pt)[$j$]),

    edge((2.75,3.5),(2.75,3.1),"->",stroke:black),node((2.75,3.6),$p$)
  )
) 

- If each adjacent square are the same color, then we have no other choice than coloring our current square with the other color. 
- Else, we can do both. 

The algorithm is basically the same but $p$ is of length $n+1$ because we need to keep track of the adjacent square of position $(i-1,j-1)$. 
