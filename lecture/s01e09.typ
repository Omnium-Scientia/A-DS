#import "@preview/fletcher:0.5.5": *
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
    semester: "1", 
    chapter_number: "9", 
    video_link: "https://www.youtube.com/watch?v=Dt3LDjl4jEc&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=9",
    title: "Fibonacci Heap"
)

= Fibonacci Heap

This is a heap that support more operations than a classical one. 

Classical operations are: 
- $"add"(x)$
- $"remove_min()"$
New one are: 
- $"merge"(H_1,H_2) ->$ merge two heap into 1 big one
- $"decrease_key"(x,y) ->$ change the value of node $x$ by $y$, can only be done when $y < x$

For binary heap, we have: 
- $"add"(x) -> log n$
- $"remove_min()" -> log n$
- $"decrease_key"(x,y) -> log n$

== Binomial trees 

Before going onto the Fibonacci heap, we are going to talk about binomial trees and heap. This will ease our comprehension when we slide to the Fibonacci heap. 

#grid(
    columns: (10%,20%,30%,40%), 
    align: center+top, 
    diagram(
        node-stroke: 1pt,
        let (b,n1) = ((0,-0.6),(0,0),),

        node(b,$B_0$,stroke:none),
        node(n1,$$),
        ),
        diagram(
        node-stroke: 1pt,
        let (b,n1,n2) = ((0,-0.6),(0,0),(0,1)),

        node(b,$B_1$,stroke:none),
        node(n1,$$),node(n2,$$),
        edge(n1,n2,"-"),
        ),
        diagram(
        node-stroke: 1pt,
        let (b,n1,n2,n3,n4) = ((0,-0.6),(0,0),(0,1),(1,1),(1,2)),

        node(b,$B_2$,stroke:none),
        node(n1,$$),node(n2,$$),node(n3,$$),node(n4,$$),
        edge(n1,n2,"-"),edge(n1,n3,"-"),edge(n3,n4,"-"),
        ),
        diagram(
        node-stroke: 1pt,
        let (b,n1,n2,n3,n4) = ((0,-0.6),(0,0),(0,1),(1,1),(1,2)),

        node(b,$B_3$,stroke:none),
        node(n1,$$),node(n2,$$),node(n3,$$),node(n4,$$),
        edge(n1,n2,"-"),edge(n1,n3,"-"),edge(n3,n4,"-"),

        let (n5,n6,n7,n8) = ((2,1),(2,2),(3,2),(3,3)),
        node(n5,$$),node(n6,$$),node(n7,$$),node(n8,$$),
        edge(n5,n6,"-"),edge(n5,n7,"-"),edge(n7,n8,"-"),
        edge(n1,n5),
    ),
)

#linebreak()

#grid(
    columns: (60%,40%), 
    align: center+top, 
    diagram(
        node-stroke: 1pt,
        let (b,n1,n2,n3,n4,n5) = ((0,-0.6),(0,0),(0,1),(1,1),(2.1,1),(3.3,1)),
        
        node(b,$B_k$,stroke:none),
        node(n1,$$),
        edge(n1,n2,"-"),edge(n1,(1,0.471),"-"),edge(n1,(2.1,0.471),"-"),edge(n1,(3.3,0.471),"-"),
        
        node(n2, align(center)[$B_0$], shape: shapes.triangle),
        node(n3, align(center)[$B_1$], shape: shapes.triangle,),
        node(n4, align(center)[$B_2$], shape: shapes.triangle),
        node(n5, align(center)[$B_(k-1)$], shape: shapes.triangle),

        node((2.6,1), $...$, stroke: 0pt)
        ),
        diagram(
            node-stroke: 1pt,
        let (b,n1,n2,n3,n4,n5) = ((0,-0.6),(0,0.4),(0,1),(1,1),(2.1,1),(1.5,1)),

        node((-1,0.5),$=$,stroke:0pt),
        node(b,$B_k$,stroke:none),
        edge((0,-0.12),(1.5,0.494),"-"),
        node(n1, align(center)[$B_(k-1)$], shape: shapes.triangle),
        node(n5, align(center)[$B_(k-1)$], shape: shapes.triangle),
    ),
)

#linebreak()

Number of nodes in $B_k = 2^k$.

#pagebreak()

== Binomial heap

=== Definition

We build a heap on top of binomial tree like we did with binary tree. 

Example with $n = 8$: 

#align(center,    
    diagram(
        node-stroke: 1pt,
        let (n1,n2,n3,n4) = ((0,0),(0,1),(1,1),(1,2)),

        node(n1,$1$),node(n2,$5$),node(n3,$6$),node(n4,$8$),
        edge(n1,n2,"-", text(fill:red)[$<=$], label-angle:-90deg),edge(n1,n3,"-", text(fill:red)[$<=$], label-angle:-45deg, label-pos: 0.8),edge(n3,n4,"-", text(fill:red)[$<=$], label-angle:-90deg),

        let (n5,n6,n7,n8) = ((2,1),(2,2),(3,2),(3,3)),
        node(n5,$3$),node(n6,$9$),node(n7,$10$),node(n8,$25$),
        edge(n5,n6,"-", text(fill:red)[$<=$], label-angle:-90deg),edge(n5,n7,"-", text(fill:red)[$<=$], label-angle:-45deg),edge(n7,n8,"-", text(fill:red)[$<=$], label-angle:-90deg),
        edge(n1,n5, text(fill:red)[$<=$], label-angle:-30deg),
    ),
)

But if $n eq.not 2^k$ for example $n = 11$. 

Then, we take multiple tree: 

#align(center,    
    diagram(
        node-stroke: 1pt,
        let (n1,n2,n3,n4) = ((0,0),(0,1),(1,1),(1,2)),

        node(n1,$1$),node(n2,$5$),node(n3,$6$),node(n4,$8$),
        edge(n1,n2,"-", text(fill:red)[$<=$], label-angle:-90deg),edge(n1,n3,"-", text(fill:red)[$<=$], label-angle:-45deg, label-pos: 0.8),edge(n3,n4,"-", text(fill:red)[$<=$], label-angle:-90deg),

        let (n5,n6,n7,n8) = ((2,1),(2,2),(3,2),(3,3)),
        node(n5,$3$),node(n6,$9$),node(n7,$10$),node(n8,$25$),
        edge(n5,n6,"-", text(fill:red)[$<=$], label-angle:-90deg),edge(n5,n7,"-", text(fill:red)[$<=$], label-angle:-45deg),edge(n7,n8,"-", text(fill:red)[$<=$], label-angle:-90deg),
        edge(n1,n5, text(fill:red)[$<=$], label-angle:-30deg),


        let (n9,n10) = ((4,0),(4,1)),

        node(n9,$2$),node(n10,$7$), 
        edge(n9,n10,"-", text(fill:red)[$<=$], label-angle:-90deg), 


        let n11 = (5,0), 

        node(n11,$17$),


        edge(n1,n9,"--"),edge(n9,n11,"--")
    ),
)

For a given number of element, the tree structure will be the same. And it will be composed of trees from decomposition in power of 2 (the minimum number of tree). 

Two consequences: 
+ All the ranks are different because if 2 trees have the same rank, we can use the superior power of binomial tree. 
+ number of trees $<= log n$. 

#pagebreak()

=== Add

#align(center,    
    diagram(
        node-stroke: 1pt,
        let (n1,n2,n3,n4) = ((0,0),(0,1),(1,1),(1,2)),

        node(n1,$1$),node(n2,$5$),node(n3,$6$),node(n4,$8$),
        edge(n1,n2,"-", text(fill:red)[$<=$], label-angle:-90deg),edge(n1,n3,"-", text(fill:red)[$<=$], label-angle:-45deg, label-pos: 0.8),edge(n3,n4,"-", text(fill:red)[$<=$], label-angle:-90deg),

        let (n5,n6,n7,n8) = ((2,1),(2,2),(3,2),(3,3)),
        node(n5,$3$),node(n6,$9$),node(n7,$10$),node(n8,$25$),
        edge(n5,n6,"-", text(fill:red)[$<=$], label-angle:-90deg),edge(n5,n7,"-", text(fill:red)[$<=$], label-angle:-45deg),edge(n7,n8,"-", text(fill:red)[$<=$], label-angle:-90deg),
        edge(n1,n5, text(fill:red)[$<=$], label-angle:-30deg),


        let (n9,n10) = ((4,0),(4,1)),

        node(n9,$2$),node(n10,$7$), 
        edge(n9,n10,"-", text(fill:red)[$<=$], label-angle:-90deg), 


        let n11 = (5,0), 

        node(n11,$17$),


        edge(n1,n9,"--"),edge(n9,n11,"--")
    ),
)

We want to add the node $4$ to this binomial heap. The node $4$ is a binomial tree of rank $0$. What we want to do is to add the node as a tree in our heap. 
- if $B_0$ is not already present in our heap, we add it to the heap as $B_0$. 
- otherwise, we merge the $B_0$ of our heap and the node we want to add. 
    - to do that we take the minimal root and set it as the root of our $B_1$ tree. 
    Now, we only have a $B_1$ tree to add to the binomial heap. 
- the same process is repeated, if $B_1$ is not already present in our heap, we add it to the heap as $B_1$. 
- otherwise, we merge the $B_1$ of our heap and the node we want to add. 
    - to do that we take the minimal root and set it as the root of our $B_2$ tree. 
    Now, we only have a $B_2$ tree to add to the binomial heap. 

We do the same until we merge a $B_k$ that is not in our heap. 

Lets see what our example gives us: 
- $B_0$ is in our tree, so we merge our node $4$ with the $B_0$ of the heap, we obtain: 
    #align(center, diagram(
        node-stroke:1pt,
        let (n9,n10) = ((4,0),(4,1)),

        node(n9,$4$),node(n10,$17$), 
        edge(n9,n10,"-"), 
    ))
- $B_1$ is in our tree, so we merge our $B_1$ with the $B_1$ of the heap: 
    #align(center, diagram(
        node-stroke: 1pt,
        let (n1,n2,n3,n4) = ((0,0),(0,1),(1,1),(1,2)),

        node(n1,$2$),node(n2,$7$),node(n3,$4$),node(n4,$17$),
        edge(n1,n2,"-"),edge(n1,n3,"-"),edge(n3,n4,"-"),
    ))
- $B_2$ is not in our tree so we can add it to the binomial heap and get our resulting heap after adding: 

    #align(center,    
    diagram(
        node-stroke: 1pt,
        let (n1,n2,n3,n4) = ((0,0),(0,1),(1,1),(1,2)),
    
        node(n1,$1$),node(n2,$5$),node(n3,$6$),node(n4,$8$),
        edge(n1,n2,"-"),edge(n1,n3,"-"),edge(n3,n4,"-"),
    
        let (n5,n6,n7,n8) = ((2,1),(2,2),(3,2),(3,3)),
        node(n5,$3$),node(n6,$9$),node(n7,$10$),node(n8,$25$),
        edge(n5,n6,"-"),edge(n5,n7,"-"),edge(n7,n8,"-"),
        edge(n1,n5),
    
    
        let (n9,n10) = ((4,0),(4,1)),
    
        node(n9,$2$),node(n10,$7$), 
        edge(n9,n10,"-"), 
    
    
        let (n11,n12) = ((5,1),(5,2)), 
    
        node(n11,$4$),node(n12,$17$),
        edge(n9,n11,"-"),edge(n11,n12),
    
        edge(n1,n9,"--"),
    ),
    )

Since our addition is based on merged, to have a fast addition, we need to have a fast merge operation.

=== Merge 

#align(
    center, 
    diagram(
        node-stroke: 1pt,
        let (b,n1,n2,n3,n4,n5) = ((0,-0.6),(0,0.4),(0,1),(1,1),(2.1,1),(1.5,1)),

        node(b,$B_k+1$,stroke:none),
        edge((0,-0.12),(1.5,0.494),"-"),
        node(n1, align(center)[$B_(k_1)$], shape: shapes.triangle),
        node(n5, align(center)[$B_(k_2)$], shape: shapes.triangle),
    )
)

With $B_(k_1)$ root less than $B_(k_2)$ root. 

This can be done in constant time if we use a good data structure to make our trees. 

We represent the child of a node as a linked list. The parent has access to the first and last element of the linked list (i.e. the first and the last child). 

Example fort $B_3$:

#align(center,    
    diagram(
        node-stroke: 1pt,
        let (n1,n2,n3,n4) = ((0,0),(0,1),(1,1),(1,2)),

        node(n1,$$),node(n2,$$),node(n3,$$),node(n4,$$),
        edge(n1,n2,"->", stroke:red),edge(n3,n4,"->", stroke:red, bend:30deg),edge(n3,n4,"->", stroke:red, bend:-30deg),

        let (n5,n6,n7,n8) = ((2,1),(2,2),(3,2),(3,3)),
        node(n5,$$),node(n6,$$),node(n7,$$),node(n8,$$),
        edge(n5,n6,"->", stroke:red),edge(n5,n7,"->", stroke:red),edge(n7,n8,"->", stroke:red),
        edge(n1,n5,"->", stroke:red),

        edge(n2,n3,"<->"),edge(n3,n5,"<->"),edge(n6,n7,"<->"),
    ),
)

With this representation, we can just merge our elements only by putting the root element of our second heap at the end of the child list of the root of the first heap.

With this technique that allow us to merge two trees of same rank in constant time, our merge function will work in $Omicron(log n)$. 

Indeed our technique to merge is the same idea as the merge sort: 
- We put a pointer on the smallest tree of each heap
- If the size of the tree for both pointer is the same we merge them, 
    - We try to put our result in the resulting heap
- Otherwise we take the smallest, 
    - We try to put the smallest tree in the result heap
- To add it in the result heap, 
    - We check if a tree of the same size is in already in the heap, 
    - If not we add it at the end of our heap
    - Otherwise, we merge the two and try add the result in the result heap
    - We repeat that until we are able to place the tree in the heap

// Add schema

With this technique the time complexity of our merge function is $Omicron(m)$ where $m$ is the number of tree in the heap. And since there is at most $log n$ tree in a heap, the merging complexity is $Omicron(log n)$. 

=== Remove minimum

The minimum is at the root of the frist tree, we remove the root and take it child.

All of those children are the root of a binomial heap of different length, so we make a heap of those child. Now, we have two binomial heap, the one we just made with the child of the first tree. And the part that was left in our beginning tree. 

We just merge the two of them in order to have one only tree. 

// Add schema

This put the complexity of our remove minimum function to $Omicron(log n)$. 

=== Decrease key 

The idea is to do the same as in the binary heap: 
- Change the value
- Sieve up to recover heap properties. 

== Fibonacci heap

The idea of Fibonacci heap is to have the same function as the binomial heap but with a complexity of $Omicron(1)$ for some of them. 

Our goal is: 
- $T("add") = Omicron(1)$
- $T("merge") = Omicron(1)$
- $tilde(T)("decrease key") = Omicron(1)$
- $T("remove min") = Omicron(log n)$

=== Add 

By removing the property that all tree must have different rank, adding in constant time is a trivial problem. 

We just take the element we want to add and add it at the end of the heap as a $B_0$. 

#align(center, diagram(
    node-stroke: 1pt,
    let (n1,n2,n3,n4) = ((0,0),(0,1),(1,1),(1,2)),

    node(n1,$$),node(n2,$$),node(n3,$$),node(n4,$$),
    edge(n1,n2,"-"),edge(n1,n3,"-"),edge(n3,n4,"-"),

    let (n5,n6) = ((2,0),(3,0)), 
    node(n5,$$),node(n6,$x$),
    edge(n1,n5,"--"),edge(n5,n6,"--")
))

=== Merge

With our rank property gone, merging has become as hard as adding. 

#align(center, diagram(
    node-stroke: 1pt,
    let (n1,n2,n3,n4) = ((0,0),(0,1),(1,1),(1,2)),

    node(n1,$$),node(n2,$$),node(n3,$$),node(n4,$$),
    edge(n1,n2,"-"),edge(n1,n3,"-"),edge(n3,n4,"-"),

    let (n5,n6) = ((2,0),(2,1)), 
    node(n5,$$),node(n6,$$),
    edge(n1,n5,"--"),edge(n5,n6,"-"),

    let (n1,n2,n3,n4) = ((0+4,0),(0+4,1),(1+4,1),(1+4,2)),

    node(n1,$$),node(n2,$$),node(n3,$$),node(n4,$$),
    edge(n1,n2,"-"),edge(n1,n3,"-"),edge(n3,n4,"-"),

    let (n5,n6) = ((2+4,0),(2+4,1)), 
    node(n5,$$),node(n6,$$),
    edge(n1,n5,"--"),edge(n5,n6,"-"),

    edge((2,0),(4,0),"--"), 
    edge((3,-0.5),(3,2.5),stroke:blue), 
    node((2.5,2.5),text(fill:blue)[$H_1$], stroke:0pt),node((3.5,2.5),text(fill:blue)[$H_2$], stroke:0pt),
))

We then have our merge of complexity $Omicron(1)$.

=== Remove minimum 

We need to maintain a pointer to the minimum element: 
- When we add, we check if our new element is less than our current minimum
- Same for merging, both of the tree have a minimum, we keep the smaller. 

With this, we can just remove the minimum element. After that, we take each child as a tree and add them in the heap. 

Now we need to find the new minimum we need to check for each tree and we have at most $n$ of them. Since this operation is going to cost us some time, we are going to use it to balance our trees. 

Lets take an array listing the rank of trees and if 2 trees have the same rank, we merge them. 

From this: 

#align(center, diagram(
    node-stroke: 1pt,
    let (n1,n2,n3,n4) = ((0,0),(0,1),(1,1),(1,2)),

    node(n1,$$),node(n2,$$),node(n3,$$),node(n4,$$),
    edge(n1,n2,"-"),edge(n1,n3,"-"),edge(n3,n4,"-"),

    let (n5,n6) = ((2,0),(2,1)), 
    node(n5,$$),node(n6,$$),
    edge(n1,n5,"--"),edge(n5,n6,"-"),

    let (n7,n8) = ((3,0),(4,0)), 
    node(n7,$$),node(n8,$$),    
    edge(n5,n7,"--"),edge(n7,n8,"--"),
    
    let (n9,n10) = ((5,0),(5,1)), 
    node(n9,$$),node(n10,$$),
    edge(n8,n9,"--"),edge(n9,n10,"-"),

    let n11 = (6,0), 
    node(n11,$$),
    edge(n9,n11,"--"),

    let (n9,n10) = ((-1,0),(-1,1)), 
    node(n9,$$),node(n10,$$),
    edge(n1,n9,"--"),edge(n9,n10,"-"),
))

#pagebreak()

We end up with this: 

#align(center,    
    diagram(
        node-stroke: 1pt,
        let (n1,n2,n3,n4) = ((0,0),(0,1),(1,1),(1,2)),

        node(n1,$$),node(n2,$$),node(n3,$$),node(n4,$$),
        edge(n1,n2,"-"),edge(n1,n3,"-"),edge(n3,n4,"-"),

        let (n5,n6,n7,n8) = ((2,1),(2,2),(3,2),(3,3)),
        node(n5,$$),node(n6,$$),node(n7,$$),node(n8,$$),
        edge(n5,n6,"-"),edge(n5,n7,"-"),edge(n7,n8,"-"),
        edge(n1,n5),


        let (n9,n10,n11,n12) = ((4,0),(4,1),(5,1),(5,2)),

        node(n9,$$),node(n10,$$),node(n11,$$),node(n12,$$),
        edge(n9,n10,"-"),edge(n9,n11,"-"),edge(n11,n12,"-"), 


        let n13 = (6,0), 
        node(n13,$$),

        edge(n1,n9,"--"),edge(n9,n13,"--")
    ),
)

// Add transition schema

At the end of this clean up, all the tree have different rank. There is at most $log n$ tree, we can iterate overthem to find the new minimum. 

The cost of this clean up will define the cost of the remove minimum function. 

We go from $m$ to $log n$ tree. 

$
phi.alt eq.def "number of trees" = log n - m
$

$
tilde(T)("remove min") &= T + Delta phi.alt \
                         &= m + log n - m \
                         &= Omicron(log n) 
$

=== Decrease key

When the value of our node break the heap property: 

#align(center, diagram(
    node-stroke:1pt, 
    let (n0,n1,n2,n3,n4) = (
       (0,-1),(0,0),(0,1),(-1,1),(1,1),
    ), 
    node(n0,$$),node(n1,$X$),node(n2,$$),node(n3,$$),node(n4,$$),

    edge(n0,n1,$<=$,label-angle:-90deg),edge(n1,n2),edge(n1,n3),edge(n1,n4),

    edge((2,0),(4,0),"->",[decrease]), 

    let (n0,n1,n2,n3,n4) = (
       (0+6,-1),(0+6,0),(0+6,1),(-1+6,1),(1+6,1),
    ), 
    node(n0,$$),node(n1,$Y$),node(n2,$$),node(n3,$$),node(n4,$$),

    edge(n0,n1,$>$,label-angle:-90deg),edge(n1,n2),edge(n1,n3),edge(n1,n4),    
))

We have a problem, because the structure of the binomial tree is to rigid to achieve constant amortized time for the decrease key function. 

For now, our tree look like: 

#align(center, diagram(
    node-stroke:1pt, 
    node-shape: shapes.pill,
    let (n1,n2,n3,n4) = (
        (0,0),(0,1),(-1,1),(2,1),
    ), 
    node(n1,$K$),node(n2,$1$),node(n3,$0$),node(n4,$K-1$),
    node((1,1),$...$,stroke:0pt), 
    edge(n1,n2),edge(n1,n3),edge(n1,n4),

))

#pagebreak()

Lets change the tree structure to: 

#align(center, diagram(
    node-stroke:1pt, 
    node-shape: shapes.pill,
    let (n1,n2,n3,n4) = (
        (0,0),(0,1),(-1,1),(2,1),
    ), 
    node(n1,$K$),node(n2,$>=1$),node(n3,$>=0$),node(n4,$>= K-1$),
    node((1,1),$...$,stroke:0pt), 
    edge(n1,n2),edge(n1,n3),edge(n1,n4),

))

and

#align(center, diagram(
    node-stroke:1pt, 
    node-shape: shapes.pill,
    let (n1,n2,n3,n4) = (
        (0,0),(0,1),(-1,1),(2,1),
    ), 
    node(n1,$K^*$),node(n2,$>=1$),node(n3,$>=0$),node(n4,$>= K-2$),
    node((1,1),$...$,stroke:0pt), 
    edge(n1,n2),edge(n1,n3),edge(n1,n4),

))

$K^*$ is a tree of rank $K$ that have a child less. 

#align(center, diagram(
    node-stroke:1pt, 
    node-shape: shapes.pill,
    let (n1,n3,n4) = (
        (0,0),(-1,0.5),(1,0.5),
    ), 
    node(n1,$2$),node(n3,$>=0$),node(n4,$>=1$),

    edge(n1,n3),edge(n1,n4),

    let (n1,n3,n4) = (
        (0+4,0),(-1+4,0.5),(1+4,0.5),
    ), 
    node(n1,$3^*$),node(n3,$>=0$),node(n4,$>=1$),

    edge(n1,n3),edge(n1,n4),    
))

The difference between those two trees is that $3^*$ is of rank $3$ and not $2$. 

#align(center, diagram(
    node-stroke:1pt, 
    node-shape: shapes.pill,
    let (n1,n2,n3,n4) = (
        (0,0),(0,1),(-1,1),(2,1),
    ), 
    node(n1,$4$),node(n2,$>=1$),node(n3,$>=0$),node(n4,$>= 3$),
    node((1,1),$>=2$), edge(n1,(1,1)),
    edge(n1,n2),edge(n1,n3),edge(n1,n4),
    
    edge(n4,(3,1),"<-"), 
    node((3,1), text(fill:blue)[here we can \ put $3^*$ but \ not $2$], stroke:0pt)
))

This is a valid Fibonacci tree: 

#align(center, diagram(
    node-stroke:1pt, 
    node-shape: shapes.pill,
    let (n1,n2,n3,n4) = (
        (0,0),(0,1),(-1,1),(2,1),
    ), 
    node(n1,$4$),node(n2,$1^*$),node(n3,$0$),node(n4,$3^*$),
    node((1,1),$2$), edge(n1,(1,1)),
    edge(n1,n2),edge(n1,n3),edge(n1,n4),
    
    edge(n4,(3,1),"<-"), 
    node((3,1), text(fill:blue)[here we can \ put $3^*$ but \ not $2$], stroke:0pt),

    let (n5,n6,n7,n8,n9) = (
        (1,1.75),(0,1.75),(0,2.5),(0,3.25),(1,3.25),
    ), 
    node(n5,$1^*$),node(n6,$1$),node(n7,$2$),node(n8,$0$),node(n9,$1^*$),
    edge((1,1),n5),edge((1,1),n6),edge(n6,n7),edge(n7,n8),edge(n7,n9),

    let (n5,n6,n7) = (
        (2,1.75),(3,1.75),(3,2.5),
    ), 
    node(n5,$1^*$),node(n6,$1$),node(n7,$2$),
    edge(n4,n5),edge(n4,n6),edge(n6,n7),
))

The rank of this tree is less or equal than $c dot log n$. 
// do the proof

How do we decrease the key: 
- If our new element $X$ is less than is parent $A$, we put the tree of root $X$ at the root. We put a mark on $A$
- If $A$ was already marked, we cannot remove 1 more of its child. So we put the tree of root $X$ and the tree of root $A$ at the root. And we put the mark on the parent of $A$. 

We do that until the parent is not marked then we add a mark to it. 

For the marked tree we moved to the root, their rank goes from $K^*$ to $K-2$. 

$
tilde(T) = underbrace(T, = "number of moved marked tree" + 1 ("for" X) \ = H + 1) + Delta phi.alt \
$

Lets redefine $phi.alt$ for it to be enough for all our operations. 

$
phi.alt eq.def & underbrace("number of tree", #text(fill:blue)[from remove min]) + \ 
                 & 2 dot "number of marked tree"
$

$
tilde(T)("decrease key") &= (H+1) + (H + 1 - 2H + 2) \
                         &= (H + 1) + (3 - H) \
                         &= 4 \
                         &= Omicron(1) 
$

We decrease key in constant time. 

Thats it we have our Fibonacci heap with the desired complexity for each function. 
