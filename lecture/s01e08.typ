#import "@preview/fletcher:0.5.5": *
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
  semester: "1", 
  chapter_number: "8", 
  video_link: "https://www.youtube.com/watch?v=vq5u09x2Kzo&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=8",
  title: "Disjoint sets (Union-Find)"
)

= Disjoint sets (Union-Find)

== Definition 

Disjoint sets is a pretty simple data structure. But this structure is important and will be used mostly in our semester 3 (about graph). 

Imagine that you have objects and these objects are separated in disjoint sets, we want to perform 2 operations on those sets: 
- #text(fill:red)[\*]Union: it take two of our sets as input and output one set which is the union of those two. 

#align(center, diagram(
  node-corner-radius: 4pt,
  let (n1, n2, n3, n4, n5, n6, n7) = (
    (0,0),(1,0),(2,0),(0.5,1),(0.5,2),(1.5,1),(1.5,2),  
  ),
  
  node(n1, $1$),
  node(n2, $2$),
  node(n3, $5$),
  node(n4, $3$),
  node(n5, $6$),
  node(n6, $7$),
  node(n7, $4$),
  
  {
    let tint(c) = (stroke: c, inset: 8pt)
    node(enclose: (n1,n2,n3), ..tint(black))
    node(enclose: (n4,n5), ..tint(black))
    node(enclose: (n6,n7), ..tint(black))
    edge((0,0.5),(0,2.6),(2,2.6),(2,0.5),(0,0.5), stroke:red)
  },
))

- Find: it take an element $x$ as input and return in which set the element is.
  - To do that, we use two type of object, the set and the element. 
  - #text(fill:blue)[\*]To not be bothered by that, we are going to mark one element in each set. This element is unique and will represent the set so that our return type is also an element. 

  #align(center, diagram(
    node-corner-radius: 4pt,
    let (n1, n2, n3, n4, n5, n6, n7) = (
      (0,0),(1,0),(2,0),(0.5,1),(0.5,2),(1.5,1),(1.5,2),  
    ),
    
    node(n1, $1$),
    node(n2, $2$),
    node(n3, $5$, stroke:1pt+red),
    node(n4, $3$, stroke:1pt+red),
    node(n5, $6$),
    node(n6, $7$, stroke:1pt+red),
    node(n7, $4$),
    
    {
      let tint(c) = (stroke: c, inset: 8pt)
      node(enclose: (n1,n2,n3), ..tint(black))
      node(enclose: (n4,n5), ..tint(black))
      node(enclose: (n6,n7), ..tint(black))
    },
  ))

  In this example: 
    - $"find"(6) -> 3$
    - $"find"(5) -> 5$
    - $"find"(2) -> 5$
  Element of the same set return the same result for find.

#pagebreak()
  
== Basic implementation

For this simple representation, we make an array of size $n$. For each object, we store in the array the representative element of his set: 

$
p: [ &5 "  " 5 "  " 3 "  " 7 "  " 5 "  " 3 "  " 7 ] \ 
     &1 "  " 2 "  " 3 "  " 4 "  " 5 "  " 6 "  " 7
$ 

$p$ is our disjoint set from the previous example. 

=== Find 
  
```
def find(x)
    return p[x]
```

=== Union 

  In order to make our union operation between $X$ and $Y$, we want to change the representative element of the elements of $X$ to the representative element of $Y$. 

  #align(center, diagram(
    node-corner-radius: 4pt,
    let (n1, n2, n3, n4, n5, n6, n7) = (
      (0,0),(1,0),(2,0),(0.5,1),(0.5,2),(1.5,1),(1.5,2),  
    ),
    
    node(n1, $1$),
    node(n2, $2$),
    node(n3, $5$),
    node(n4, $3$, stroke:1pt+red),
    node(n5, $6$),
    node(n6, $7$, stroke:1pt+red),
    node(n7, $4$),
    
    {
      let tint(c) = (stroke: c, inset: 8pt)
      node(enclose: (n1,n2,n3), ..tint(black))
      node(enclose: (n4,n5), ..tint(black))
      node(enclose: (n6,n7), ..tint(black))
      edge((0,0.5),(0,2.6),(2,2.6),(2,0.5),(0,0.5), stroke:red)
    },
  
    node((0.5,1.5), text(fill:red)[$X$]),
    node((1.5,1.5), text(fill:red)[$Y$])
  ))

  Here, to join our sets, we need to find in $p$ all the elements that have $3$ has a representative element and change it to $7$. 

  ```
  def union(X,Y)
      x = find(X), y = find(Y)
      for i = 1..n
          if p[i] = x
              p[y] = y
  ```

  The complexity of this union function is #text(fill:red)[$Omicron(n)$]. 

The number of union operation that we can make in our structure is $<= n - 1$. 

$->$ If at the beginning all the object are in a different set, we have $n$ sets. At the end, all of our elements will be in the same set. Since each time we call the union we decrease the number of set by 1. We have at most $n - 1$ unions operations in our structure. 

So we can compute the cost of all our union calls.

For this union function: $T("total union") = Omicron(n^2)$. 

=== Union optimization

To optimize the union function, we are going to maintain $n$ list each list are going to store all the element that the object is the referent of. 

In our previous example we would have: 

$
"lists": &1:  \
         &2:  \
         &3: 3,6 \
         &4:  \
         &5: 2,5,1 \
         &6:  \
         &7: 7,4 \
$

We rewrite the union function using this new structure: 

```
def union(X,Y)
    x = find(X), y = find(Y)
    for i: lists[x]
        p[i] = y
        lists[y].add(i)
    lists[x].clear()
```

Did we changed our total cost? 

It depends, it is still possible to have: $T("total union") = Omicron(n^2)$.

#grid(
  columns: (50%,50%),
  $
  "lists": &1: 1 \
           &2: 2 \
           &3: 3 \
           &4: 4 \
           &5: 5 \
           &6: 6 \
           &7: 7 
  $, 
  $"union": 1, 2 \ T = 1$
)

#grid(
  columns: (50%,50%),
  $
  "lists": &1: 2 \
           &2: 2 \
           &3: 3 \
           &4: 4 \
           &5: 5 \
           &6: 6 \
           &7: 7 
  $, 
  $"union": 2, 3 \ T = 2$
)

#grid(
  columns: (50%,50%),
  $
  "lists": &1: 3 \
           &2: 3 \
           &3: 3 \
           &4: 4 \
           &5: 5 \
           &6: 6 \
           &7: 7 \
           &"..."
  $, 
  $"union": 3, 4 \ T = 3$
)

In this case, we have $sum T tilde.eq Omega(n^2)$. 

We did not reduced our asymptotic cost. But with this structure, we can actually reduce it with a simple trick: instead of always changing the the reference of the same set, we change the reference of the set that is the smaller. 

Our union function is then: 

```
def union(X,Y)
    x = find(X), y = find(Y)
    if lists(x).size > lists(y).size
        swap(x,y)
    for i: lists[x]
        p[i] = y
        lists[y].add(i)
    lists[x].clear()
```

With change, the previous example cannot occur again. Lets compute our new $T("total union")$: 

#grid(
  columns: (50%,50%),
  $
  "lists": &1: 1 \
           &2: 2 \
           &3: 3 \
           &4: 4 \
           &5: 5 \
           &6: 6 \
           &7: 7 
  $, 
  $"union": 1, 2 \ T = 1$
)

#grid(
  columns: (50%,50%),
  $
  "lists": &1: 2 \
           &2: 2 \
           &3: 3 \
           &4: 4 \
           &5: 5 \
           &6: 6 \
           &7: 7 
  $, 
  $"union": 2, 3 \ T = 1$
)

#grid(
  columns: (50%,50%),
  $
  "lists": &1: 2 \
           &2: 2 \
           &3: 2 \
           &4: 4 \
           &5: 5 \
           &6: 6 \
           &7: 7 \
           &"..."
  $, 
  $"union": 3, 4 \ T = 1$
)

We have: $sum T = Omega(n)$, we have made our operation linear. 

But now our worst case has changed, it is when we merge two sets of equal size. 

Lets look at our element lifetime, how many times $p[x]$ changes? This will give us our $T("total union")$ since our complexity come from there. 

- We begin with $x$ alone in a set, we combine it with another set of size $>= 1$. 
- $x$ is now in a set of size $>= 2$, we combine it with a set of size $>= 2$. 
- $x$ is now in a set of size $>= 4$, we combine it with a set of size $>= 4$. 
- And again with sets of size $>= 8$... 

$x$ then changes less than $log n$ times.

In the worst case: 
$
T("total union") = sum T = Omicron(n log n)
$

This is a simple yet important technique if you want to make a mergable data structure. You want to put the smallest of the two element by element in the second, which will give $Omicron(n log n)$ total moves.

== Efficient implementation (rank & path compression)

#align(center, diagram(
  node-corner-radius: 4pt,
  let (n1, n2, n3, n4, n5, n6, n7, n8) = (
    (0,0),(1,0),(2,0),(0,1),(1,1),(2,1),(0.5,2),(1.5,2),
  ),
  
  node(n1, $1$),
  node(n2, $2$, stroke:1pt+red),
  node(n3, $4$),
  node(n4, $6$, stroke:1pt+red),
  node(n5, $5$),
  node(n6, $3$, stroke:1pt+red),
  node(n7, $7$),
  node(n8, $8$, stroke:1pt+red),
  
  {
    let tint(c) = (stroke: c, inset: 8pt)
    node(enclose: (n1,n2,n3), ..tint(black))
    node(enclose: (n4,n5,n6), ..tint(black))
    node(enclose: (n7,n8), ..tint(black))
  },
))

We have our sets and there reference elements. 

The idea is to store the sets as tree with the reference element as root. 

#grid(
  columns: (40%,30%,30%), 
  align: center+horizon, 
  diagram(
    node-stroke: 1pt,
    let (n1,n2,n3) = ((0,0),(-0.75,1),(0.75,1)),

    node(n1,$2$),node(n2,$1$),node(n3,$4$),
    edge(n2,n1,"->"),edge(n3,n1,"->"),edge(n1,n1,"->",bend:135deg,loop-angle:120deg)
  ),
  diagram(
    node-stroke: 1pt,
    let (n1,n2,n3) = ((0,0),(0,1),(0,2)),

    node(n1,$3$),node(n2,$5$),node(n3,$6$),
    edge(n3,n2,"->"),edge(n2,n1,"->"),edge(n1,n1,"->",bend:135deg,loop-angle:120deg)
  ),
  diagram(
    node-stroke: 1pt,
    let (n1,n2) = ((0,0),(0,1)),

    node(n1,$8$),node(n2,$7$),
    edge(n2,n1,"->"),edge(n1,n1,"->",bend:135deg,loop-angle:120deg)
  )
)

$p: p[x] dash.em "parent of "x$

$
p: [ &2 "  " 2 "  " 3 "  " 2 "  " 3 "  " 5 "  " 8 "  " 8] \ 
     &1 "  " 2 "  " 3 "  " 4 "  " 5 "  " 6 "  " 7 "  " 8
$ 

=== Find 

```
def find(x)
    while p[x] != x
        x = p[x]
    return x
```

=== Union 

We need to do a find before just as in the previous implementation. 

Then, we need to merge trees. The simplest way is to make $x$ point to $y$. 

```
def uinion(x,y)
    x = find(x), y = find(y)
    p[x] = y
```

The complexity of our union function is the same as the one of our find function.

So, what is the complexity of the find function? 

Is it possible to have $T("find") = Omicron(n)$? 

Yes, as before, if we make the merge in a bad order. 

This is not a good news we need to work on our find function to improve its time complexity. 

=== Balance the tree

To avoid long path, we need to make the tree balanced. To do that, lets use the rank heuristic. 

Rank heuristic: we maintain the rank of each node (the number of node between the node and a leaf): 

#align(center, diagram(
  node((0,0), $X$, stroke:1pt), node((0,1.5), $$, stroke:1pt), 
  edge((0,0),(0,1.5),"~"), 
  edge((-1.5,1.85),(1.5,1.85)),edge((-1.5,1.85),(0,-0.7),(1.5,1.85)),
  edge((2,-0.7),(2,1.85),"<->", $r[X]$, label-side:left)
))

What we want to do is to connect the tree with the smaller rank to the tree with the bigger rank. 

Rank value after union: 

#align(center, diagram(
  node((0,0), $Y$, stroke:1pt), node((0,1.5), $$, stroke:1pt), 
  edge((0,0),(0,1.5),"~"), 
  edge((-1.5,1.85),(1.5,1.85)),edge((-1.5,1.85),(0,-0.7),(1.5,1.85)),
  edge((2,-0.7),(2,1.85),"<->", text(fill:red)[$r[Y]$], label-side:left, stroke:red),

  node((-5,0), $X$, stroke:1pt), node((-5,1.5), $$, stroke:1pt), 
  edge((-5,0),(-5,1.5),"~"), 
  edge((-1.5-5,1.85),(1.5-5,1.85)),edge((-1.5-5,1.85),(0-5,-0.7),(1.5-5,1.85)),
  edge((-7.5,-0.7),(-7.5,1.85),"<->", $r[X]$, label-side:right),
  edge((-0.5,-0.1),(-7,1.85),"<->", text(fill:red)[$r[X]+1$], label-side:right, bend: -70deg, stroke:red),

  edge((-4.5,0),(-0.5,0),"->")
))

$
"if": r[X] < r[Y] : r[X]+1 <= r[Y] \
"else": r[X] = r[Y] : r[Y]+1
$

```
def union(X,Y)
    x = find(X), y = find(Y)
    if r[x] > r[y]
        swap(x,y)
    p[x] = y
    if r[x] = r[y]
        r[y]++ 
```

Lets prove by induction that if we use this union function, find function as an $Omicron(n log n)$ complexity. 

A set with a reference element $X$ of rank $r[X]$ as at least $2^r[X]$ is our induction property. 

*Initialization:*
- $r[X] = 0 -> $ then our set a only 1 element. $1 > 2^0$ so property is true for $r[X] = 0$. 

*After union operation:* 
- we join 2 trees: 
  - the first as a rank of $r[X]$ and is number of elements is  $>=2^r[X]$
  - the second as a rank of $r[Y]$ and is number of elements is  $>=2^r[Y]$
- if $r[X] < r[Y]:$ 
  - we saw that $r[Y]$ stay the same. 
  - number of element is at least $2^r[Y]$ since number of element os first tree is $>=1$. 
- if $r[X] = r[Y]:$ 
  - $r[Y] = r[Y] + 1$
  - we have at leat $2^(r[Y]+1)$ element in our final tree since both of our trees had at least $2^r[Y]$ element at the beginning. 

The property stay true after the union operation and is true at the beginning, The property is always true. 

Since a tree as at least $2^r[X]$ element, we have $r[X] <= log n$. 

=== Path compressing 

We want to optimize our find even more. 

The first time we call find, we follow this path: 

#align(center, diagram(
    node-stroke: 1pt,
    let (n1,n2,n3,n4) = ((0,0),(0,1),(0,2),(0,3)),

    node(n1,[X]),node(n2,$$),node(n3,$$),node(n4,$Y$),
    edge(n4,n3,"->"),edge(n3,n2,"->"),edge(n2,n1,"->"),edge(n1,n1,"->",bend:135deg,loop-angle:120deg),

    edge((1,3),n4,"->"),node((1,3),[find],stroke:0pt),
))

but, we change our pointer to: 

#align(center, diagram(
    node-stroke: 1pt,
    let (n1,n2,n3,n4) = ((0,0),(0,1),(0,2),(0,3)),

    node(n1,[X]),node(n2,$$),node(n3,$$),node(n4,$Y$),
    edge(n4,n1,"->",bend:40deg),edge(n3,n1,"->",bend:40deg),edge(n2,n1,"->"),edge(n1,n1,"->",bend:135deg,loop-angle:120deg),

    edge((1,3),n4,"->"),node((1,3),[find],stroke:0pt),
))

so that the next time we try to do a find for an element of this set it will be done in constant time.

```
def find(x)
    y = x 
    while p[y] != y 
        y = p[y]
    while p[x] != x
        z = p[x]
        p[x] = y 
        x = z
    return y
```

Path compression costs: $tilde(T)("find") = Omicron(log n)$

Path compression + rank heuristics costs: 
$
tilde(T)("find") = Omicron(alpha(m,n))
$ where: 
  - $alpha$ is the reverse Ackerman function
  - $n$ is the size of the tree (i.e. the number of element in the set). 
  - $m$ is the number of finds call. 

When: 
$
n arrow.tr => alpha(m,n) arrow.tr \ 
m arrow.tr => alpha(m,n) arrow.br
$

_See the first bonus chapter at the end of this semester for a proof._

In the mean time, we are going to prove the case 
$
m = n => alpha(m,n) = log^* n 
$

#pagebreak()

Where $log^*$ is the iterated logarithm function: 
$
log^* n eq.def cases(0 "if" n <= 1, 1 + log^* (log n))
$

Example for $log^*$: 
$
2^65536 arrow_log 2^16 arrow_log 2^4 arrow_log 2^2 arrow_log 2^1 arrow_log 2^0 => log^*(2^65536) = 5
$

Lets prove that $tilde(T)("find") = Omicron(log^* n)$:

$
T("find") = "length of path between" X "and the root" Y
$

We want $tilde(T)("find")$ so we want the sum of all path in my find call. 

#align(center, diagram(
    node-stroke: 1pt,
    let (n1,n2,n3,n4,n5,n6) = ((0,0),(0,1),(0,2),(0,3),(0,4),(0,5)),

    node(n1,$Y$),node(n2,$$),node(n3,$$),node(n4,$$),node(n5,$$),node(n6,$X$),
    edge(n6,n5,"->"),edge(n5,n4,"->"),edge(n4,n3,"->"),edge(n3,n2,"->"),edge(n2,n1,"->",stroke:blue),edge(n1,n1,"->",bend:135deg,loop-angle:120deg),

    edge((1,5),n6,"->"),node((1,5),[find],stroke:0pt),
))

In each operation we have a last edge#text(fill:blue)[\*].

To calculate the other edge, we split them in two groups: 
- #text(fill:red)[\*]small jump: $r[p[X]] < 1.9^r[X]$
- #text(fill:green)[\*]big jump: $r[p[X]] >= 1.9^r[X]$

The number of big jump is $<= log^* n$ because $r[X] <= log n$.

#pagebreak()

Number of small jump: 

#grid(
  columns: (50%,50%),
  align(center, diagram(
    node-stroke: 1pt,
    let (n1,n2,n3,n4,n5,n6) = ((0,0),(0,1),(0,2),(0,3),(0,4),(0,5)),

    node(n1,$Y$),node(n2,$$),node(n3,$$),node(n4,$$),node(n5,$$),node(n6,$X$),
    edge(n6,n5,"->"),edge(n5,n4,"->"),edge(n4,n3,"->"),edge(n3,n2,"->"),edge(n2,n1,"->",stroke:blue),edge(n1,n1,"->",bend:135deg,loop-angle:120deg),

    edge((1,5),n6,"->"),node((1,5),[find],stroke:0pt),
  )),
  align(horizon)[
    When we call find, $r[p[X]]$ is increasing because the link from: 
    $
    #circle[$1$] -> #circle[$2$]
    $
    and $r[Y] > r[p[X]]$
  ]
)

How many jump will it take for $Y$ to have a jump that is bug and not small?
- for $X$: $<= 1.9^r[X]$ operation until $X -> p[X]$ become a big jump. 
$
sum_x 1.9^r[X] = underbrace(sum_r "cnt"[r] dot 1.9^r, "we group the" X "by rank")
$

The number of node of rank $r$ is $<= n/2^r$ since each tree as at least $2^r$ elements. 

$
sum_r "cnt"[r] dot 1.9^r <= n dot underbrace(sum (1.9 / 2)^r, = Omicron(n))
$

So: 

$
sum T("find") &<= #text(fill:blue)[$m$] + #text(fill:red)[$m dot log^* n$] + #text(fill:green)[$n$] \
              &<= Omicron(n log^* n)
$

since $m = n$ by hypothesis. 

We have proved that $tilde(T)("find") = Omicron(n log^* n)$

This structure can be modified to compute function on the tree, this is wht it is such an important data structure. 
