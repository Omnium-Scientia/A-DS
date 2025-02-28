#import "@preview/fletcher:0.5.5": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *


= Quick-sort, order statistics

== Randomized algorithms

#linebreak()

#align(center, diagram(

  node((0,0), $"Input data"$, name: <I>),
  node((+1,0), $"Algorithm"$, name: <A>),
  node((1,0.75), $"Random In"$, name: <R>), 
  node((+2,0), $"Output data"$, name: <O>),

  edge(<I>, "->", <A>), 
  edge(<A>, "->", <O>), 
  edge(<R>, "->", <A>), 
))

We add a bit of random data to our input. And that random data can help us to solve the problem more efficiently. 

== Quick-sort

=== Algorithm

We have an array $a$ that we want to sort: 

#align(center, diagram(
  let (a, e, c, l, r) = (
    (0,0), (0.3, 0), (7.2, 0), (0.5, 0.25), (7, 0.25)  
  ),
  
  node(a, $a$),  
  node(c, $$), 
  node(e, $$),
  node(r, $r$),
  node(l, $l$),
 
  edge(c, e, "|==|", ),
))

#linebreak()

We chose $x$ as: 

$
x = a["random"(n -1)]
$

Then we split the array at $x$, before $x$ all the number $< x$ after all number $>= x$. 

#align(center, diagram(
  let (e, c, l, r) = (
    (0.3, 0), (7.2, 0), (3.6, 0), (4,0)  
  ),
    
  node(c, $$), 
  node(e, $$),
  node(r, $$),
  node(l, $$),

  node((1.95, 0.25), $< x$),
  node((5.4, 0.25), $>= x$),

  edge(e, r, "|==|", ),
  edge(c, l, "|==|", ),
))

#linebreak()

Then we recurse on each part until our array is completely sorted. 

We do not need to make a new array at each recursion, every thing can be done in the array $a$. 

Let's write the algorithm for this sort: 

```
def sort(l, r)
    if r - l <= 1
        retrun 
    x = a[random(l, r-1)]
    m = l
    for i = l..r-1
        if a[i] < x 
            swap(a[i], a[m])
            m += 1 
    
    sort(l, m)
    sort(m, r)
```

This algorithm actually has a flaw. If we have multiple element that are equal to our chosen $x$ we may enter in am infinite recursion. 

One of the most simple way to solve this problem id to split the array in three instead of two. One part for the number $< x$, one part for the number $= x$ and one part for the number $> x$. 

#align(center, diagram(
  let (e, c, l, m, r, v) = (
    (0.3, 0), (7.2, 0), (3.4, 0), (3.1,0), (5,0), (5.1,0)  
  ),
    
  node(c, $$), 
  node(e, $$),
  node(r, $$),
  node(l, $$),
  node(m, $$),

  node((1.95, 0.25), $< x$),
  node((6, -0.4), $2$, stroke: 1pt, shape: shapes.circle),
  node((1.95, -0.4), $1$, stroke: 1pt, shape: shapes.circle),
  node((6, 0.25), $> x$),
  node((4.2, 0.25), $= x$),
  
  edge(e, l, "|==|", ),
  edge(c, r, "|==|", ),
  edge(m, v, "|==|", ),
))

#linebreak()

We then make the recursion on the part 1 and 2

=== Time complexity 

Since our algorithm is randomized, we will compute our complexity differently. We take the expected value of our time complexity. 

$
EE(T(n)) = sum_X X dot PP(T(n) = X)
$

Why it is important ? 

Because if we do not do that, for example, in the worst case (when each time the random $x$ that we chose is the current minimum) in our quick sort, the complexity is $Omicron(n^2)$ and we are going to prove that our expected value is $Omicron(n log n)$. 

$
T(n) &= 1/n sum_(k=0)^(n-1) (n + T(k) + T(n - k)) \
     &<= underbrace(1/3 (T(n/3) + T((2n)/3)), #text($"good split " \ x tilde.eq "middle"$)) + underbrace(2/3 T(n), "bad split") + n \ 

1/3 T(n) &<= 1/3 (T(n/3) + T((2n)/3)) + n \ \

T(n) & <= 3n + T(n/3) + T((2n)/3)
$

Now let's prove that $T(n) <= c dot n log n$

$
T(n) &<= 3n + c dot n /3 log n/3 + c dot (2n)/3 log (2n)/3 \
     &<= 3n + c dot n/3 (log n - log 3) + c dot (2n)/3 (log n - log 3/2) \ 
     &<= n (1/3c dot log n + 2/3log n + underbrace(3 - 1/3c dot log 3 - 2/3 c dot log 3/2, #text($Omicron(n)$))) \ 
     &= Omicron(n log n)
$

=== Improvement ? 

We cannot improve asymptotically our algorithm but we can improve it by making our constant factor decrease. #strong()[Because constant factor are also important is performance are seeken.]

To make it decrease, we need to raise the possibility of choosing a $x$ that is good. 

One idea is, instead of picking 1 random element, we pick 3 (or 5...) random element and choose the middle one for $x$. 

_We can understand as said in the beginning of the time complexity part that in the case of a random algorithm, our worst case come from the random data that we inject and not from out input._

== Order statistics 

Objective: find the $k^"th"$ element of am array. 

=== Naive option 

Sort the array and pick the $k^"th"$ element. #text(red, $Omicron(n log n)$)

Can be done with a heap #text(red, $Omicron(n log k)$)

=== Linear solution 

Sometimes randomized algorithm are faster than non-randomized ones. But sometimes they are not.

Here we are going to present two technique that work in linear time for this problem. The objective here is not to compare the asymptotic difference but the difference in the complexity of the algorithm. 

Because this is another reason to chose randomized algorithm, they can be as fast as the other ones but simpler. 

==== Randomized: using quick-sort

Basically the idea is to do a quick-sort but instead of make all the recursion, we do it only on the part that contain k until we find it. 

```
def find(l, r, k) 
    if r - l = 1 
        return a[k] 
    x = a[random(l, r-1)]
    m = l
    for i = l..r-1
        if a[i] < x 
            swap(a[i], a[m])
            m += 1 
    if k < m: 
        return find(l, m, k)
    else: 
        return find(m, r, k)
```

Here we are able to achieve a better complexity than $Omicron(n log n)$ because we make only one recursive call instead of two like in the basic quick-sort algorithm. 

We have $Omicron(n)$: 

$
& tilde.eq (n + 2/3 n + 4/9 n + dots.h.c) \
& tilde.eq 3n 
$

When we make a good split. 

==== Deterministic: Blum-Floyd-Pratt-Rivestt-Tasjar

Here we are going to do the same algorithm than previously with the modified quick-sort, but instead of finding $x$ randomly, we are going to find it deterministically. 

We separate our array $a$ in block of five elements. 

#align(center, diagram(
  let (a, e, c, l, r) = (
    (0,0), (0.3, 0), (7.3, 0), (0.5, 0.25), (7.1, 0.25)  
  ),
  
  node(a, $a$),  
  node(c, $$), 
  node(e, $$),
  node(r, $r$),
  node(l, $l$),
 
  edge(c, e, "|==|", ),

  edge((1.3, 0.15), (1.3, -0.15)), 
  edge((2.3, 0.15), (2.3, -0.15)), 
  edge((3.3, 0.15), (3.3, -0.15)),
  edge((4.3, 0.15), (4.3, -0.15)),
  edge((5.3, 0.15), (5.3, -0.15)), 
  edge((6.3, 0.15), (6.3, -0.15)), 

  node((0.8, -0.3), $5$),
  node((1.8, -0.3), $5$),
  node((2.8, -0.3), $5$),
  node((3.8, -0.3), $5$),
  node((4.8, -0.3), $5$),
  node((5.8, -0.3), $5$),
  node((6.8 , -0.3), $5$),
))

$
"     "n/5 "blocks"
$

We take the median of each block. After that, we take the median of those median. This is our $x$.

#align(center, diagram(
  let (a, bl, br, ul, ur) = (
    (0,0), (0.3,1), (7.3,1), (0.3,-1), (7.3,-1) 
  ),
  let (b1, b2, b3, b4, b5, b6, u1, u2, u3, u4, u5, u6) = (
    (1.3,1),(2.3,1),(3.3,1),(4.3,1),(5.3,1),(6.3,1),
    (1.3,-1),(2.3,-1),(3.3,-1),(4.3,-1),(5.3,-1),(6.3,-1),
  ),
  let x = (3.8,-0.025), 
  let (lbn, lun, rbn,run) = (
    (0.3,0.1), (0.3,-0.1), (7.3,0.1), (7.3,-0.1)
  ),
  let (mb1, mb2, mb3, mb4, mb5, mb6, mu1, mu2, mu3, mu4, mu5, mu6) = (
    (1.3,0.1),(2.3,0.1),(3.3,0.1),(4.3,0.1),(5.3,0.1),(6.3,0.1),
    (1.3,-0.1),(2.3,-0.1),(3.3,-0.1),(4.3,-0.1),(5.3,-0.1),(6.3,-0.1),
  ),
  
  node(a, $a$), 
  node(x, $x$),
  
  node((8.3, -0.6), text(red, $"Less than" x$)),
  node((8.3, 0.6), text(blue, $"Could be" \ "less than" x$)),

  edge(bl, br), edge(ul,ur), edge(bl,ul), edge(br,ur), 
  edge(b1,u1),edge(b2,u2),edge(b3,u3),edge(b4,u4),edge(b5,u5),edge(b6,u6),
  edge(lbn, rbn), edge(lun, run), 

  edge(lbn, u1, stroke: red), edge(mb1, u2, stroke: red), edge(mb2, u3, stroke: red), edge(mu3, u4, stroke: red), edge(ul, mb1, stroke: red), edge(mb2, u1, stroke: red), edge(mb3, u2, stroke: red), edge(mu4, u3, stroke: red),

  edge(mu4, u5, stroke: blue), edge(mu5, u6, stroke: blue), edge(mu6, ur, stroke: blue), edge(mu5, u4, stroke: blue), edge(mu6, u5, stroke: blue), edge(run, u6, stroke: blue),

  edge(lbn, b1, stroke: blue), edge(mb1, b2, stroke: blue), edge(mb2, b3, stroke: blue), edge(mb1, bl, stroke: blue), edge(mb2, b1, stroke: blue), edge(mb3, b2, stroke: blue),
))

To find the median of all the median, we call recursively the algorithm that make the block in the array & take their median. 

$
T(n) = underbrace(n, "Make\ngroups") + underbrace(T(n/5), #text(green, "Find\nmedian")) + underbrace(T((7n)/10), "Recursion\ncalls")^(#text(blue, $*$)#text(red, $*$)) \ 
     
$

Let's show that $T(n) <= c dot n$:

$
T(n) &<= n + c n/5 + c (7n)/10
     &=  n (1 + 9/10 c)
     &= Omicron(n)
$

The algorithm is indeed working as fast as the randomized one but is far more complex put in motion.
