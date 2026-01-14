#import "@preview/fletcher:0.5.5": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
    semester: "1", 
    chapter_number: "4", 
    video_link: "https://www.youtube.com/watch?v=lJB_kwONQKY&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=4", 
    title: "Lower bound for sorting, Radix sort, Sorting networks"
)


= Lower bound for sorting, Radix sort, Sorting networks

#linebreak()

#set math.cases(reverse: true)
$ 
cases(
"Merge sort",
"Heap sort",
"Quick sort" 
) -> Omicron(n log n) 
$

== Can we go faster the $Omicron(n log n)$ ?

The only operations needed in those sort are the comparisons between two elements.    

Let's prove that if we only have the comparison operations the lower bound for sorting is $Omicron(n log n)$. 

Let's say we have an array of three elements $[x;y;z]$. Let's compute all the different output that the sort function can gives for this array. 

#align(center, diagram(
    let (N, H,I, Q,R,S,T, L,M,U,V) = (
        (-1.5,0), 
        (-2.75,1),(-0.25, 1), 
        (-3.25, 2),(-2.25, 2),(-0.75, 2),(0.25, 2), 
        (-3.75, 3),(-2.75, 3),(-1.25, 3),(-0.25, 3)
    ),

    node(N, $x < y$),
    
    node(H, $x < z$), node(I, $y < z$), 
    
    node(Q, $y < z$), node(R, $[z;x;y]$), node(S, $x < z$), node(T, $[z;y;x]$),

    node(L, $[x;y;z]$), node(M, $[x;z;y]$), node(U, $[y;x;z]$), node(V, $[y;z;x]$),

    edge(N, H, "-"), edge(N, I, "-"),

    edge(H, Q, "-"), edge(H, R, "-"),
    edge(I, S, "-"), edge(I, T, "-"),

    edge(Q, L, "-"), edge(Q, M, "-"),
    edge(S, U, "-"), edge(S, V, "-"),

    edge((1.5, 0), (1.5, 3), "<->", stroke: red, label-side: left, text(red,$T(n)$))
))

We can build those kind of tree for every sorting algorithm. 

If we look at the tree, we see that the height of the tree is the number of comparison needed to find our result. 

The height is then therefore the complexity of our algorithm. 

The number of possible output is $n!$:

$
T(n) &>= log_2 n! \
     &>= sum_i^n log i \    
     &=    Omega(n log n)
$

We have proved that in our comparison model, the lower bound for sorting is $Omicron(n log n)$. 

#pagebreak()

== Counting sort 

=== Version 1 

We have an array $a$ with:

$
a[i] in bracket.stroked 0..m-1 bracket.stroked.r "where" m "is small"
$

Let's take for example $m = 3$ and $a[1;0;1;2;2;0;1;1;2;0]$. 

We count the number in $a$: 

$
"cnt"[&3;&&4;&&&3] \ &0 &&1 &&&2
$

The complexity of this operation is $Omicron(n + m)$ where $n =$ the number of elements in $a$ and $m = $ number of elements in $"cnt"$. 

After that, we create $a'$ and put the number of elements of $"cnt"$ in $a'$. 

$
a'[0;0;0;1;1;1;1;2;2;2]
$

The cost of this operation is also $Omicron(n + m)$. 

Overall we just made an algorithm that sort in $Omicron(n + m)$. 

Usually this sort is used in situation where we know that $n tilde.eq m$. 

=== Version 2 

In reality, we generally don't want to sort integers but key of data structures. 

```
struct Item {
    int Key // 0..m-1
    Data data 
}
```

$
a[(1,A);(0,B);(1,C);(2,D);(2,E);(0,F);(1,G);(1,H);(2,I);(0,J)]
$

#set math.cases(reverse: false)
$ 
f(x, y) := cases(
    0 " "[B;F;J],
    1 " "[A;C;G;H],
    2 " "[D;E;I],
) 
$

$
a'[underbrace(B" "F" "J,0)" "underbrace(A" "C" "G" "H, 1)" "underbrace(D" "E" "I, 2)]
$

Instead of creating $m$ vectors, we can count like in the first version, create a big array and report the object in the array after that. 

$
a[(1,A);(0,B);(1,C);(2,D);(2,E);(0,F);(1,G);(1,H);(2,I);(0,J)]
$

$
"cnt"[&3;&&4;&&&3] \ &0 &&1 &&&2
$

$
a'[underbrace(B" "F" "J, 0)" "underbrace(A" "C" "G" "H, 1)" "underbrace(D" "E" "I, 2)] 
$

Complexity is still $Omicron(n + m)$. 

== Radix sort 

Let's do counting sort with bigger int. We still have our array $a$ but this time: 

$
a[i] in bracket.stroked 0..m^2-1 bracket.stroked.r "where" m "is small"
$

For $x$ an element of $a$ we have: 

$
x in bracket.stroked 0..m^2-1 bracket.stroked.r \
x = y dot m + z " such that " y,z in bracket.stroked 0..m-1 bracket.stroked.r
$

We make two array for $x "and" y$ and we have: 

$
a[i] = b[i] dot m + c[i]
$

Compare $a[i] "and" a[j]$ is then the same as comparing $(b[i],c[i]) "and" (b[j],c[j])$. 

$
a[6;2;4;1;7;2;3;4;6]\ = a[(2,0);(0,2);(1,1);(0,1);(2,1);(0,2);(1,0);(1,1);(2,0)]
$

In order to sort this array we do the counting sort 2 times. 

We need to begin by sorting the second element: 

$
"cnt"[3;4;2]
$

$
a'[(2,0);(1,0);(2,0);(1,1);(0,1);(2,1);(1,1);(0,2);(0,2)]
$

Now we do the counting sort on the first element: 

$
"cnt"[3;3;3]
$

$
a''[(0,1);(0,2);(0,2);(1,0);(1,1);(1,1);(2,0);(2,0);(2,1)]
$

Then we can reconstruct the number of the original $a$

$
a''[1;2;2;3;4;4;6;6;7]
$

Here, we have sorted our array because we started by sorting the second element of the pair and then the first element, since counting sort is stable the combinations of these two sort have sorted our whole array. 

Since the complexity of the counting is $Omicron(n + m)$ and we do it two times our complexity is also $Omicron(n + m)$ here. 

Now instead of being limited to $m^2$ let's do it for integers up to $m^k - 1$.

The reasoning is the same but here we need to do $k$ iterations of our counting sort. 

Our total complexity will be: $Omicron(k dot    (n + m))$. 

And this is the radix sort. 

Note that in practice algorithm with worse asymptotic can be better than the algorithms with better ones. 

This algorithm is usually not the best for sorting an array if $n, m$ are not that big. You'll need to check for your case if it is worth the shot. This algorithm is also a very important sort because in some algorithms that we will discuss about in the later lessons it is at the base of the algorithm. 

== Sorting networks 

=== Concurrent calls 

We want to sort an array and the only allowed operations in our model is: 

```
def cmp(i, j) 
    if a[i] > a[j]
        swap(a[i], a[j])
```

$
"Example for" n = 3 "we do: " cases(
    "cmp"(0,1), 
    "cmp"(1,2), 
    "cmp"(0,1), 
)
$

Let's schematize those call over the time: 

#linebreak()

#align(center, diagram(
    let (a0, a1, a2) = (
        (-1, 0), (-1, 0.5), (-1,1), 
    ),
    let (t0, tinf) = (
        (0,1.5), (4,1.5),
    ),
    let (l0b, l0e, l1b, l1e, l2b, l2e) = (
        (0,0), (4,0),
        (0,0.5), (4,0.5),
        (0,1), (4,1),
    ),
    let (c0b, c1b, c2b) = (
        (1,0), (2,0.5), (3,0), 
    ), 
    let (c0e, c1e, c2e) = (
        (1,0.5), (2,1), (3,0.5), 
    ),

    node(a0, $a[0]$), node(a1, $a[1]$), node(a2, $a[2]$),

    edge(l0b, l0e, "-",), 
    edge(l1b, l1e, "-",), 
    edge(l2b, l2e, "-",), 

    edge(c0b,c0e, "O->"),edge(c1b,c1e, "O->"),edge(c2b,c2e, "O->"),

    edge(t0, tinf, "->", text(black,$"Time"$), label-side: right), 
))

Let's do it now with an array of 5 elements: 

#linebreak()

#align(center, diagram(
    let (a0, a1, a2, a3, a4) = (
        (-1, 0), (-1, 0.5), (-1,1), (-1,1.5), (-1,2), 
    ),
    let (t0, tinf) = (
        (0,2.5), (11,2.5),
    ),
    let (l0b, l0e, l1b, l1e, l2b, l2e, l3b, l3e, l4b, l4e) = (
        (0,0), (11,0),
        (0,0.5), (11,0.5),
        (0,1), (11,1),
        (0,1.5), (11,1.5),
        (0,2), (11 ,2),
    ),
    let (c0b, c1b, c2b, c3b, c4b, c5b, c6b, c7b, c8b, c9b) = (
        (1,0), (2,0.5), (3,0), 
        (4,1), (5,0.5), (6,0), 
        (7,1.5), (8,1), (9,0.5), (10,0), 
    ), 
    let (c0e, c1e, c2e, c3e, c4e, c5e, c6e, c7e, c8e, c9e) = (
        (1,0.5), (2,1), (3,0.5),
        (4,1.5), (5,1), (6,0.5),
        (7,2), (8,1.5), (9,1), (10,0.5), 
    ),

    node(a0, $a[0]$), node(a1, $a[1]$), node(a2, $a[2]$), node(a3, $a[3]$), node(a4, $a[4]$),

    edge(l0b, l0e, "-",), 
    edge(l1b, l1e, "-",), 
    edge(l2b, l2e, "-",),
    edge(l3b, l3e, "-",),
    edge(l4b, l4e, "-",),

    edge(c0b,c0e, "O->"),edge(c1b,c1e, "O->"),edge(c2b,c2e, "O->"),
    edge(c3b,c3e, "O->"),edge(c4b,c4e, "O->"),edge(c5b,c5e, "O->"),
    edge(c6b,c6e, "O->"),edge(c7b,c7e, "O->"),edge(c8b,c8e, "O->"),edge(c9b,c9e, "O->"),

    edge(t0, tinf, "->", text(black,$"Time"$), label-side: right), 
))

Here we make #text(red,$Omicron(n^2)$) concurrent call.    

#pagebreak()

We want to optimize 2 parameters here: 
- The number of comparator 
- The length of the network 

We are allowed to call simultaneously the unrelated comparators. 

If we do that the previous example become: 

#align(center, diagram(
    let (a0, a1, a2, a3, a4) = (
        (-1, 0), (-1, 0.5), (-1,1), (-1,1.5), (-1,2), 
    ),
    let (t0, tinf) = (
        (0,2.5), (11,2.5),
    ),
    let (l0b, l0e, l1b, l1e, l2b, l2e, l3b, l3e, l4b, l4e) = (
        (0,0), (11,0),
        (0,0.5), (11,0.5),
        (0,1), (11,1),
        (0,1.5), (11,1.5),
        (0,2), (11 ,2),
    ),
    let (c0b, c1b, c2b, c3b, c4b, c5b, c6b, c7b, c8b, c9b) = (
        (1,0), (2,0.5), (3,0), 
        (3,1), (4,0.5), (5,0), 
        (4,1.5), (5,1), (6,0.5), (7,0), 
    ), 
    let (c0e, c1e, c2e, c3e, c4e, c5e, c6e, c7e, c8e, c9e) = (
        (1,0.5), (2,1), (3,0.5),
        (3,1.5), (4,1), (5,0.5),
        (4,2), (5,1.5), (6,1), (7,0.5), 
    ),

    node(a0, $a[0]$), node(a1, $a[1]$), node(a2, $a[2]$), node(a3, $a[3]$), node(a4, $a[4]$),

    edge(l0b, l0e, "-",), 
    edge(l1b, l1e, "-",), 
    edge(l2b, l2e, "-",),
    edge(l3b, l3e, "-",),
    edge(l4b, l4e, "-",),

    edge(c0b,c0e, "O->"),edge(c1b,c1e, "O->"),edge(c2b,c2e, "O->"),
    edge(c3b,c3e, "O->"),edge(c4b,c4e, "O->"),edge(c5b,c5e, "O->"),
    edge(c6b,c6e, "O->"),edge(c7b,c7e, "O->"),edge(c8b,c8e, "O->"),edge(c9b,c9e, "O->"),

    edge(t0, tinf, "->", text(black,$"Time"$), label-side: right), 
))

We now make only #text(red,$Omicron(n)$) concurrent call.    

It is even possible to take an algorithm with #text(red,$Omicron(n log n)$) comparators and reduce it to #text(red,$Omicron(log n)$) (very hard and the constant is to big, not for practical use). 

=== Theorem 

If a network sort any array of $0 "and" 1$ it can sort any array. 

Let's prove that by taking an array $a[6;2;4;1;5]$ and associate $0 "and" 1$ to it. The minimum element is paired to a zero and the other are paired to ones. 

$
a[(6,1);(2,1);(4,1);(1,0);(5,1)]
$

#align(center, diagram(
    let (l0l, l0r, l1l, l1r, l2l, l2r, l3l, l3r, l4l, l4r) = (
        (0,0), (0.5,0),
        (0,0.5), (0.5,0.5),
        (0,1), (0.5,1),
        (0,1.5), (0.5,1.5),
        (0,2), (0.5,2),
    ),
    let (r0l, r0r, r1l, r1r, r2l, r2r, r3l, r3r, r4l, r4r) = (
        (1.5,0), (2,0),
        (1.5,0.5), (2,0.5),
        (1.5,1), (2,1),
        (1.5,1.5), (2,1.5),
        (1.5,2), (2,2),
    ),
    let (lu,lb,ru,rb) = (
        (0.5,-0.25), (0.5,2.25), (1.5,-0.25), (1.5,2.25), 
    ),
    let qm = (1,1), 

    let (l0, l1, l2, l3, l4, l5, l6, l7, l8, l9) = (
        (-1,0), (-0.5,0),
        (-1,0.5), (-0.5,0.5),
        (-1,1), (-0.5,1),
        (-1,1.5), (-0.5,1.5),
        (-1,2), (-0.5,2),
    ),
    let (r0, r1, r2, r3, r4, r5, r6, r7, r8, r9) = (
        (2.5,0), (3,0),
        (2.5,0.5), (3,0.5),
        (2.5,1), (3,1),
        (2.5,1.5), (3,1.5),
        (2.5,2), (3,2),
    ),

    node(qm, "?"), 

    edge(lu,lb),edge(lu,ru),edge(ru,rb),edge(rb,lb), 

    edge(l0l, l0r),edge(l1l, l1r),edge(l2l, l2r),edge(l3l, l3r),edge(l4l, l4r),
    edge(r0l, r0r),edge(r1l, r1r),edge(r2l, r2r),edge(r3l, r3r),edge(r4l, r4r),

    node(l0, $1$), node(l1, $6$),
    node(l2, $1$), node(l3, $2$),
    node(l4, $1$), node(l5, $4$),
    node(l6, $0$), node(l7, $1$),
    node(l8, $1$), node(l9, $5$),

    node(r0, $0$), node(r1, $1$), 
    node(r2, $1$), node(r3, $dot$), 
    node(r4, $1$), node(r5, $dot$), 
    node(r6, $1$), node(r7, $dot$), 
    node(r8, $1$), node(r9, $dot$), 
))

Since our network sort array of zeros and ones, if we sort this array with the second element of the pair, we know that the result will be: 

$
a[(1,0);(6,1);(2,1);(4,1);(5,1)]
$

In the next step, we add a zero. to the new minimum. We now have two elements paired with zeros and the other with ones. We know that our two elements paired with zeros are going to be in the 2 first positions. But since the first position is occupied by our 1 we have no choice but to put our 2 in second place because of the previous iteration. 

#align(center, diagram(
    let (l0l, l0r, l1l, l1r, l2l, l2r, l3l, l3r, l4l, l4r) = (
        (0,0), (0.5,0),
        (0,0.5), (0.5,0.5),
        (0,1), (0.5,1),
        (0,1.5), (0.5,1.5),
        (0,2), (0.5,2),
    ),
    let (r0l, r0r, r1l, r1r, r2l, r2r, r3l, r3r, r4l, r4r) = (
        (1.5,0), (2,0),
        (1.5,0.5), (2,0.5),
        (1.5,1), (2,1),
        (1.5,1.5), (2,1.5),
        (1.5,2), (2,2),
    ),
    let (lu,lb,ru,rb) = (
        (0.5,-0.25), (0.5,2.25), (1.5,-0.25), (1.5,2.25), 
    ),
    let qm = (1,1), 

    let (l0, l1, l2, l3, l4, l5, l6, l7, l8, l9) = (
        (-1,0), (-0.5,0),
        (-1,0.5), (-0.5,0.5),
        (-1,1), (-0.5,1),
        (-1,1.5), (-0.5,1.5),
        (-1,2), (-0.5,2),
    ),
    let (r0, r1, r2, r3, r4, r5, r6, r7, r8, r9) = (
        (2.5,0), (3,0),
        (2.5,0.5), (3,0.5),
        (2.5,1), (3,1),
        (2.5,1.5), (3,1.5),
        (2.5,2), (3,2),
    ),

    node(qm, "?"), 

    edge(lu,lb),edge(lu,ru),edge(ru,rb),edge(rb,lb), 

    edge(l0l, l0r),edge(l1l, l1r),edge(l2l, l2r),edge(l3l, l3r),edge(l4l, l4r),
    edge(r0l, r0r),edge(r1l, r1r),edge(r2l, r2r),edge(r3l, r3r),edge(r4l, r4r),

    node(l0, $1$), node(l1, $6$),
    node(l2, text(blue, $0$)), node(l3, $2$),
    node(l4, $1$), node(l5, $4$),
    node(l6, $0$), node(l7, $1$),
    node(l8, $1$), node(l9, $5$),

    node(r0, $0$), node(r1, text(red,$1$)), 
    node(r2, $1$), node(r3, text(blue, $2$)), 
    node(r4, $1$), node(r5, $dot$), 
    node(r6, $1$), node(r7, $dot$), 
    node(r8, $1$), node(r9, $dot$), 
))

We iterate 3 more times for $4,5,6$ and we have sorted our array. 

=== Bitonic sort 

Bitonic sort is a bitonic sort that is made to sort bitonic sequence. 

==== Bitonic sequence 

A bitonic sequence is a sequence made of increasing and decreasing interval that can be splited in 2 parts, 1 increasing and 1 decreasing forming a cycle. 

Example: 

$
a[3;2;4;6;10;25;17;11;8;6]
$

$a$ is a bitonic sequence because if we move the $[3;2]$ at the end of the array we have: 

$
a[4;6;10;25;17;11;8;6;3;2]
$

which is composed of 1 increasing interval (index 0 to 3) and 1 decreasing (index 3 to 9). 

=== Sort 

Now let's build the sorting network that will sort the bitonic sequence. 

To achieve this, we only need to sort a bitonic sequence of zeros and ones ($a[0;0;0;0;1;1;1;0;0;0]$). Where the $1$ represent the increasing part and the $0$ represent the decreasing part of the sequence.

_Note: to achieve this with the RAM-model we just need to find the minimum and merge the 2 parts. Here the model is different and we cannot do that._

==== Sort a bitonic sequence: 

#align(center, diagram(
    let (l0b, l0e, l1b, l1e, l2b, l2e, l3b, l3e, l4b, l4e, l5b, l5e, l6b, l6e, l7b, l7e) = (
        (0,0), (2.5,0),
        (0,0.5), (2.5,0.5),
        (0,1), (2.5,1),
        (0,1.5), (2.5,1.5),
        (0,2), (2.5,2),
        (0,2.5), (2.5,2.5),
        (0,3), (2.5,3),
        (0,3.5), (2.5,3.5),
    ),
    let (c0b, c1b, c2b, c3b) = (
        (0.5,0), (1,0.5), (1.5,1), (2,1.5) 
    ), 
    let (c0e, c1e, c2e, c3e) = (
        (0.5,2), (1,2.5), (1.5,3), (2,3.5) 
    ),
    let (a0, a1, a2, a3, a4, a5) = (
        (-0.25,-0.1), (-0.25, 1.6),
        (-0.25,1.9), (-0.25, 3.6), 
        (-0.8,-0.1), (-0.8, 3.6), 
    ),
    let (n0, n1, n2) = (
        (-0.5,0.75),
        (-0.5,2.75),
        (-1,1.75),
    ),

    edge(l0b, l0e, "-",), 
    edge(l1b, l1e, "-",), 
    edge(l2b, l2e, "-",), 
    edge(l3b, l3e, "-",), 
    edge(l4b, l4e, "-",), 
    edge(l5b, l5e, "-",), 
    edge(l6b, l6e, "-",), 
    edge(l7b, l7e, "-",), 

    edge(c0b,c0e, "O->"),edge(c1b,c1e, "O->"),edge(c2b,c2e, "O->"),edge(c3b,c3e, "O->"),

    edge(a0, a1, bend: -30deg, stroke: red),
    edge(a2, a3, bend: -30deg, stroke: red),
    edge(a4, a5, bend: -20deg),

    node(n0, text(red,$2^(k-1) "     "$)), 
    node(n1, text(red,$2^(k-1) "     "$)), 
    node(n2, $2^(k) "     "$), 
))

$
[0" "0" "0" "1" "1" "1" "0" "0] -> [underbrace(0" "0" "0" "0, a)" "underbrace(1" "1" "0" "1, b)]
$

Let's prove that each part $a$ and $b$ are bitonic sequence and all element of $a$ are less or equal to the element of $b$. 

we have three possibilities: 

- either there were only zeros in $a$ before the comparison:
    - in that case no element in the first half can be greater than the one of the second half, so, we do not have any swap then after the comparison no element of a have changed. 

    $
    [underbrace(0" "0" "0" "0, a)" "underbrace(0" "1" "1" "0, b)] -> [underbrace(0" "0" "0" "0, a)" "underbrace(0" "1" "1" "0, b)]
    $

- all the ones of the sequence were in $a$:
    - so after comparisons all the ones are in $b$ and only zeros are in $a$.

    $
    [underbrace(0" "1" "1" "0, a)" "underbrace(0" "0" "0" "0, b)] -> [underbrace(0" "0" "0" "0, a)" "underbrace(0" "1" "1" "0, b)]
    $

- there were in both $a$ and $b$:
    - either there were not enough ones in $b$ and all the ones are in $b$. 
    
    $
    [underbrace(0" "0" "1" "1, a)" "underbrace(1" "0" "0" "0, b)] -> [underbrace(0" "0" "0" "0, a)" "underbrace(1" "0" "1" "1, b)]
    $
    
    - there were to many ones so there is ones in $a$ and in all $b$. 

    $
    [underbrace(0" "1" "1" "1, a)" "underbrace(1" "1" "0" "0, b)] -> [underbrace(0" "1" "0" "0, a)" "underbrace(1" "1" "1" "1, b)]
    $

As we can see in all case $a$ and $b$ are bitonic sequence. 

So we can apply the same process as before but recursively: 

#align(center, diagram(
    let (l0b, l0e, l1b, l1e, l2b, l2e, l3b, l3e, l4b, l4e, l5b, l5e, l6b, l6e, l7b, l7e) = (
        (0,0), (5,0),
        (0,0.5), (5,0.5),
        (0,1), (5,1),
        (0,1.5), (5,1.5),
        (0,2), (5,2),
        (0,2.5), (5,2.5),
        (0,3), (5,3),
        (0,3.5), (5,3.5),
    ),
    let (c0b, c1b, c2b, c3b, c4b, c5b, c6b, c7b, c8b, c9b, c10b, c11b,) = (
        (0.5,0), (1,0.5), (1.5,1), (2,1.5),
        (3,0), (3.5,0.5), (3,2), (3.5,2.5),
        (4.5,0), (4.5,1), (4.5,2), (4.5,3),
    ), 
    let (c0e, c1e, c2e, c3e, c4e, c5e, c6e, c7e, c8e, c9e, c10e, c11e) = (
        (0.5,2), (1,2.5), (1.5,3), (2,3.5),
        (3,1), (3.5,1.5), (3,3), (3.5,3.5),
        (4.5,0.5), (4.5,1.5), (4.5,2.5), (4.5,3.5),
    ),
    let (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9 ,a10, a11, a12, a13) = (
        (-0.25,-0.1), (-0.25, 1.6), 
        (-0.25,1.9), (-0.25, 3.6), 
        (-0.8,-0.1), (-0.8, 3.6), 
        (2.5,-0.1), (2.5, 0.6), 
        (2.5,0.9), (2.5, 1.6), 
        (2.5,1.9), (2.5, 2.6), 
        (2.5,2.9), (2.5, 3.6), 
    ),
    let (n0, n1, n2) = ( 
        (-0.5,0.75),
        (-0.5,2.75),
        (-1,1.75),
    ),

    edge(l0b, l0e, "-",), 
    edge(l1b, l1e, "-",), 
    edge(l2b, l2e, "-",), 
    edge(l3b, l3e, "-",), 
    edge(l4b, l4e, "-",), 
    edge(l5b, l5e, "-",), 
    edge(l6b, l6e, "-",), 
    edge(l7b, l7e, "-",), 

    edge(c0b,c0e, "O->"),edge(c1b,c1e, "O->"),edge(c2b,c2e, "O->"),edge(c3b,c3e, "O->"),
    edge(c4b,c4e, "O->"),edge(c5b,c5e, "O->"),edge(c6b,c6e, "O->"),edge(c7b,c7e, "O->"),
    edge(c8b,c8e, "O->"),edge(c9b,c9e, "O->"),edge(c10b,c10e, "O->"),edge(c11b,c11e, "O->"),

    edge(a0, a1, bend: -30deg, stroke: red),
    edge(a2, a3, bend: -30deg, stroke: red),
    edge(a4, a5, bend: -20deg),
    edge(a6, a7, bend: -30deg, stroke: red),
    edge(a8, a9, bend: -30deg, stroke: red),
    edge(a10, a11, bend: -30deg, stroke: red),
    edge(a12, a13, bend: -30deg, stroke: red),
    node((4,0), text(red,$($)),
    node((4,0.5), text(red,$($)),
    node((4,1), text(red,$($)),
    node((4,1.5), text(red,$($)),
    node((4,2), text(red,$($)),
    node((4,2.5), text(red,$($)),
    node((4,3), text(red,$($)),
    node((4,3.5), text(red,$($)),

    node(n0, text(red,$2^(k-1) "     "$)), 
    node(n1, text(red,$2^(k-1) "     "$)), 
    node(n2, $2^(k) "     "$), 
))

Here , we have: 
- $Omicron(n log n)$ comparators
- $Omicron(log n)$ depth

==== Sort a non-bitonic sequence

Let's use bitonic sort to sort array of size 2 (because an array of size 2 in necessarily bitonic). 

#align(center, diagram(
    let (a,b,c,d,e,f,g,h) = (
        (0,0),(0.75,0),(1.5,0),(2.25,0),(3,0),(3.75,0),(4.5,0),(5.25,0),
    ),

    node(a, $circle.filled$), node(b, $circle.filled$), node(c, $circle.filled$), node(d, $circle.filled$), node(e, $circle.filled$), node(f, $circle.filled$), node(g, $circle.filled$), node(h, $circle.filled$), 
))

#linebreak()

#align(center, diagram(
    let (a,b,c,d,e,f,g,h) = (
        (0,0.5),(0.75,0),(1.5,0),(2.25,0.5),(3,0.5),(3.75,0),(4.5,0),(5.25,0.5),
    ),

    node(a, $circle.filled$), node(b, $circle.filled$), node(c, $circle.filled$), node(d, $circle.filled$), node(e, $circle.filled$), node(f, $circle.filled$), node(g, $circle.filled$), node(h, $circle.filled$), 

    edge(a,b),edge(c,d),edge(e,f),edge(g,h),

    edge((-0.2,0.8), (2.45,0.8), stroke: blue, text(blue,"bitonic sequence"), label-side: right),
    edge((2.8,0.8), (5.45,0.8), stroke: blue)
))

#linebreak()

#align(center, diagram(
    let (a,b,c,d,e,f,g,h) = (
        (0,1.5),(0.75,1),(1.5,0.5),(2.25,0),(3,0),(3.75,0.5),(4.5,1),(5.25,1.5),
    ),

    node(a, $circle.filled$), node(b, $circle.filled$), node(c, $circle.filled$), node(d, $circle.filled$), node(e, $circle.filled$), node(f, $circle.filled$), node(g, $circle.filled$), node(h, $circle.filled$), 

    edge(a,b),edge(b,c),edge(c,d),edge(e,f),edge(f,g),edge(g,h),

    edge((-0.2,1.8), (5.45,1.8), stroke: blue, text(blue,"bitonic sequence"), label-side: right),
))

#linebreak()

#align(center, diagram(
    let (a,b,c,d,e,f,g,h) = (
        (0,3.5),(0.75,3),(1.5,2.5),(2.25,2),(3,1.5),(3.75,1),(4.5,0.5),(5.25,0),
    ),

    node(a, $circle.filled$), node(b, $circle.filled$), node(c, $circle.filled$), node(d, $circle.filled$), node(e, $circle.filled$), node(f, $circle.filled$), node(g, $circle.filled$), node(h, $circle.filled$), 

    edge(a,b),edge(b,c),edge(c,d),edge(d,e),edge(e,f),edge(f,g),edge(g,h),

    edge((-0.2,3.8), (5.45,3.8), stroke: blue, text(blue,"sorted array"), label-side: right),
))

$
n log^2 n "comparators" \ 
log^2 n "depth"
$
