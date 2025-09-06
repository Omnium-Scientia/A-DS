#import "@preview/fletcher:0.5.5": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
    semester: "2", 
    chapter_number: "1", 
    video_link: "https://www.youtube.com/watch?v=s3bnguhHttM&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=18&pp=iAQB", 
    title: "Segment tree"
)


= Segment tree

You want to solve the following problem: 
- You ahve an array of $a$ size $n$. 
- You want to perform the following operation on your array: 
    - `set(i,v)`: set the $i^("th")$ element to the value $v$. 
    - `op(l,r)`: perform the operation `op` on the segment $[l,r[$

== Sum segment tree <S2L1S11>

Let's begin with `op = sum` where $"sum"(l,r) = sum_(i = l)^(r-1) a[i]$. 

Segment trees are binary tree where: 
- each leaf is an element of $a$ 
- each parent is (in the case of sum), the sum of its 2 children. 

Example with $a[5;1;3;2;6;2;4;7]$:

#align(center, diagram(
    let y = 1,
    let (N, H,I, Q,R,S,T, L,M,O,P,U,V,W,Y) = (
        (-1.5,0), 
        (-2.75,y),(-0.25,y), 
        (-3.25,2*y),(-2.25,2*y),(-0.75,2*y),(0.25,2*y), 
        (-3.5,3*y),(-3,3*y),(-2.5,3*y),(-2,3*y),(-1,3*y),(-0.5,3*y),(0,3*y),(0.5,3*y)
    ),

    node(N, $30$),
    
    node(H, $11$), node(I, $19$), 
    
    node(Q, $6$), node(R, $5$), node(S, $8$), node(T, $11$),

    node(L, $5$), node(M, $1$), node(O, $3$), node(P, $2$),
    node(U, $6$), node(V, $2$), node(W, $4$), node(Y, $7$),

    edge(N, H, "-"), edge(N, I, "-"),

    edge(H, Q, "-"), edge(H, R, "-"),
    edge(I, S, "-"), edge(I, T, "-"),

    edge(Q, L, "-"), edge(Q, M, "-"),
    edge(R, O, "-"), edge(R, P, "-"),
    edge(S, U, "-"), edge(S, V, "-"),
    edge(T, W, "-"), edge(T, Y, "-"),
))

_Note: Here, we work with tree where $n = 2^k$. We can also imagine non-balanced tree as:_

#align(center, diagram(
    let y = 0.75,
    let (N, H,I, Q,R) = (
        (-1.5,0), 
        (-2.75,y),(-0.25,2*y), 
        (-3.25,2*y),(-2.25,2*y)
    ),

    node(N, $circle$),
    
    node(H, $circle$), node(I, $circle$), 
    
    node(Q, $circle$), node(R, $circle$),

    edge(N, H, "-"), edge(N, I, "-"),

    edge(H, Q, "-"), edge(H, R, "-"),
))

_We will not consider them in this lecture but they work well too, they are just less convenient to use for educational puspose._

Why we can do that? Because in the case of $n != 2^k$ we can always add empty element so we have $n' = 2^k < 2n$ leaves. Since we are going to work mostly on assymptotics this will not matter that much. 

The number of nodes in our segment tree willl be $2n - 1$. 

The height of our segment tree is $log_2 n$. With that, both our `set` and `sum` complexity will be $Omicron(log n)$.

How the tree work? Each node of our tree is accountable for the sum of a segment. So each leaf is accountable for the sum of 1 element and the root of the tree is acocuntable for the sum of the whole segment. 

== Set operation 

- We change the leaf. 
- We change each node accountable for a sum that contain our leaf. 

This represent 1 node per layer and we go from leaf to root so we have at much $log_2 n$ sum to do. Set then as a complexity of $Omicron(log n)$ (which, for now does not appear as something good because set operation are $Omicron(1)$ complexity in classical array).

Recall the tree example we gave in @S2L1S11, let's change last 2 by 5 `set(5,5)`: 

#align(center, diagram(
    let y = 1,
    let (N, H,I, Q,R,S,T, L,M,O,P,U,V,W,Y) = (
        (-1.5,0), 
        (-2.75,y),(-0.25,y), 
        (-3.25,2*y),(-2.25,2*y),(-0.75,2*y),(0.25,2*y), 
        (-3.5,3*y),(-3,3*y),(-2.5,3*y),(-2,3*y),(-1,3*y),(-0.5,3*y),(0,3*y),(0.5,3*y)
    ),

    node(N, text(red)[$33$]),
    
    node(H, $11$), node(I, text(red)[$22$]), 
    
    node(Q, $6$), node(R, $5$), node(S, text(red)[$11$]), node(T, $11$),

    node(L, $5$), node(M, $1$), node(O, $3$), node(P, $2$),
    node(U, $6$), node(V, text(red)[$5$]), node(W, $4$), node(Y, $7$),

    edge(N, H, "-"), edge(N, I, "<-", stroke: red),

    edge(H, Q, "-"), edge(H, R, "-"),
    edge(I, S, "<-", stroke: red), edge(I, T, "-"),

    edge(Q, L, "-"), edge(Q, M, "-"),
    edge(R, O, "-"), edge(R, P, "-"),
    edge(S, U, "-"), edge(S, V, "<-", stroke: red),
    edge(T, W, "-"), edge(T, Y, "-"),
))

== Sum operation 

The objective to take precalculated segments to combine then and make our sum. 

The question is now : how to get each segment of the sum in $Omicron(log n)$ time?

The idea is to make a recursion from root to leaf to find the ones that are in our segment sum. But since doing that would make us recurse on all the tree, we need to add 2 optimisations: 
- If the current node is the sum of a segment that do not overlap with our wanted segment, we return early. 
- If the current node is the sum of a segment that is completely in our wanted range, we add it to the result and return early. 

With those optimisation, almost all of the calls reslut in one of our optimisation. Indeed, in our segment tree, none of our segment overlap. So in each layer, we have at most 1 segment that contain our left border and also one that contain our right border. So in each layer, we have at most 2 segments continuing the recursion. 

Since we have $log_2 n$ layer in our tree, we have no more than $2 dot log n$ segment of recursion and there is at most $2 dot log n + 1$ nodes that return. This means that we have at most $4 dot log n$ operations in our sum, so we have $T("sum") = Omicron(log n)$. 

#pagebreak()

== Implementation 

```
class Node {
    Node *left, 
    Node *right,
    int value, 
    (int, int) segment 
}
```

This implementation work but is not the most efficient because of the number of class instentiation. 

We are going to use a different one, we assign indexes to nodes the following way (an indexing we previously used): 

#align(center, diagram(
    let y = 1,
    let (N, H,I) = (
        (-1.5,0), 
        (-2.75,y),(-0.25,y), 
    ),

    node(N, $x$),
    node(H, $2x + 1$), node(I, $2x + 2$), 

    edge(N, H, "-"), edge(N, I, "-"),
))

Whith this structure, we can put our array in an array. We also need to know what are the borders of our segments, instead of storing them, we will compute them on the fly. 

$ 
    x attach(arrow.long, t: "borders") [l x, r x] \
    2 dot x + 1 attach(arrow.long, t: "borders") [l x, l x + (r x - l x)/2] \
    2 dot x + 2 attach(arrow.long, t: "borders") [l x + (r x - l x)/2, r x]
$

For set, we have the following recursive procedure with the parameters: 
- $i$, the node we change the value of. 
- $v$, the value we wnat to change $i$ to. 
- $x$, the current node. 
- $l x, r x$, its borders ($l x$ included, $r x$ excluded). 

```
def set(i, v, lx, rx) 
    if rx - lx == 1
        tree[x] = v 
        return 
    m = lx + (rx - lx)/2
    if i < m 
        set(i, v, 2*x+1, lx, m)
    else 
        set(i, v, 2*x+2, m, rx)
    tree[x] = tree[2*x+1] + tree[2*x+2]
```

For sum, we have: 
- $l, r$, left and right borders wewant the sum of. 
- $x$, the current node. 
- $l x, r x$, the current borders. 

```
def sum(l, r, lx, rx)
    if l >= rx || lx >= r // segment outside of the sum 
        return 0
    if l <= lx && r >= rx // segment totally in the sum 
        return tree[x]
    m = lx + (rx - lx)/2
    s1 = sum(l, r, 2*x+1, lx, m)
    s2 = sum(l, r, 2*x+2, m, rx) 
    return s1 + s2
```

== Other functions for operations 

If it were only for sum, the usefulness of this data structure would not be that great, lets see how to implement other operations. 

=== Minimum 

We want to compute the minimum on a segment. Both of the operation work the same but we do minimum instead of sum: 

```
def set(i, v, lx, rx) 
    if rx - lx == 1
        tree[x] = v 
        return 
    m = lx + (rx - lx)/2
    if i < m 
        set(i, v, 2*x+1, lx, m)
    else 
        set(i, v, 2*x+2, m, rx)
    tree[x] = min(tree[2*x+1], tree[2*x+2])
```

```
def minimum(l, r, lx, rx)
    if l >= rx || lx >= r // segment outside of the sum 
        return +inf
    if l <= lx && r >= rx // segment totally in the sum 
        return tree[x]
    m = lx + (rx - lx)/2
    m1 = minimum(l, r, 2*x+1, lx, m)
    m2 = minimum(l, r, 2*x+2, m, rx) 
    return min(m1+m2)
```

More than `min`, we can  imagine making the structure generic taking a custom function in parameter. The only real limitation to the operations we can use in a segment tree is that is shall be associative ($a times.circle (b times.circle c) = (a times.circle b) times.circle c$).

== Persistent segment tree 

We defined persistant data structue in _Semester 1, Lecture 7_ for linked list. We are going to apply that to segment trees. 

The only operation that changes our structure is `set`. When we make a set, we clone the node we change and give it the wanted value. After that, we go up in the tree cloning each upper node and updating their result. 

Example: 
$
    a[6 | 5 | 8 | 11] -> V_1 \ 
    "set"(2,11) \
    a[ | 5 | 11 | 11] -> V_2 \ 
$

#align(center, diagram(
    let y = 1,
    let (N,A, H,I,B, Q,R,S,T,C) = (
        (-1.5,0), (-1,0), 
        (-2.75,y),(-0.25,y), (0.25,y),
        (-3.25,2*y),(-2.25,2*y),(-0.75,2*y),(0.25,2*y),(-0.25,2*y),
    ),

    node(N, $30$), node(A, text(red)[$33$]), 
    
    node(H, $11$), node(I, $19$), node(B, text(red)[$22$]),
    
    node(Q, $6$), node(R, $5$), node(S, $8$), node(T, $11$), node(C, text(red)[$11$]),

    edge(N, H, "-"), edge(N, I, "-"), 
    edge(A, B, "-", stroke: red), edge(A, H, "-", stroke: red, bend: 25deg), 

    edge(H, Q, "-"), edge(H, R, "-"),
    edge(I, S, "-"), edge(I, T, "-"), 
    edge(B, C, "-", stroke: red), edge(B, T, "-", stroke: red), 
))

For each new version we want to keep track off, we add $log n$ new nodes. Then we can do operations on both of the version, just by calling 1 tree root or the other. This is a persistent data structure. 

To implement this, you need to use the class version of the tree because we need pointer to the nodes to make it work.

This will be usefull in some problems that we will se in the later Lectures. 
