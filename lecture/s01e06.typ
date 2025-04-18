#import "@preview/fletcher:0.5.5": *
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
  semester: "1", 
  chapter_number: "6", 
  video_link: "https://www.youtube.com/watch?v=EU09CpPUrZc&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=7",
  title: "Stacks, Queues, Amortized costs"
)


= Stacks, Queues, Amortized costs 

== Stack

=== Definition 

#align(center, grid(
  columns: 2, 
  column-gutter: 30pt,
  diagram(
    let (c1, c2, c3, c4) = (
      (0,0), (1,0), (0,4), (1,4)
    ),
  
    edge(c1, c3), edge(c3, c4), edge(c2, c4), 
  
    edge((-0.3,0), (0.3,0), "->", bend: 90deg, label: "push"),
    edge((1.3,0), (0.6,0), "<-", bend: -90deg, label: "pop"),
  
    let (a, b, c, d, e) = (
      (0.5,3.5),(0.5,2.5),(0.5,1.5),(0,0),(0,0), 
    ),
  
    node(a, "A", stroke: 1pt, shape: rect), node(b, "B", stroke: 1pt, shape: rect), node(c, "C", stroke: 1pt, shape: rect),
  
    edge((0.25,2), (0.75,1), stroke: red)
  ), 
  align(horizon, grid(
    row-gutter: 25pt,
    [$"push(A)"$],
    [$"push(B)"$],
    [$"push(C)"$],
    [$"pop()" #text(fill: red)[$-> C$]$],
  ))
))

=== Usages

Stack is a very simple data structure but it is widely used in computer science. Even if you never implemented it you used stack before. 

Any recursion implementation is a stack.  

The computer create a stack frame in order to remember the values of var for each call:
- When we call a new $f$, it pushes a new block on the stack frame. 
- When a $f$ return, it comes back to the previous function call by popping the block. 
- In each block we save a pointer which is used as a return address for the next function call. 

_Note: This is not only for recursive calls but for any call to a function from a function._

=== Implementation

With an infinite sized array: 

#align(center,
  diagram(
    let (c1, c2, c3, c4) = (
      (0,0), (0,1), (4,0), (4,1)
    ),
  
    edge(c1, c3), edge(c2, c4), edge(c1, c2), 
  
    let (a, b, c, d, e) = (
      (0.5,0.5),(1.5,0.5),(2.5,0.5),(3.5,0.5),(0,0), 
    ),
  
    node(a, "A"), node(b, "B"), node(c, "C"), node(d, $dot.triple$),
  
    let (n0, n1) = (
      (0.5,-0.25),(2.5,-0.25),
    ),

    node(n0, $0$), node(n1, $n - 1$)
  ), 
)

```
def push(x)
    stack[n++] = x
```

```
def pop()
    return stack[n--]
```

In C++, vectors are stacks. 

== Queue

=== Definition 

#align(center, grid(
  columns: 2, 
  column-gutter: 50pt,
  align(center+horizon, diagram(
    let (c1, c2, c3, c4) = (
      (0,0), (0,1), (5,0), (5,1)
    ),
  
    edge(c1, c3), edge(c2, c4),

    edge((0,0.5), (-1,1), "->", bend: -45deg, label: "remove"),
    edge((5,0.5), (6,0), "<-", bend: -45deg, label: "add"),
    
    let (a, b, c, d, e) = (
      (0,0),(1.5,0.5),(2.5,0.5),(3.5,0.5),(0,0), 
    ),
  
    node(b, "A"), node(c, "B"), node(d, "C"),

    let (n0, n1) = (
      (1.5,1.25),(3.5,1.25),
    ),

    node(n0, text(fill: blue)[head]), node(n1, text(fill: blue)[tail])
  )), 
  align(horizon, grid(
    row-gutter: 25pt,
    [$"add(A)"$],
    [$"add(B)"$],
    [$"add(C)"$],
    [$"remove()" #text(fill: red)[$-> A$]$],
  ))
))

=== Usages

Queue is used when queue is needed. 

Example: 
- You have workers and tasks 
- The workers are going to take the tasks from the queue and another part of the program will add tasks in the queue.

=== Implementation

We take an array of infinite size. We also need two pointer, 1 at the head and 1 at the tail. 

```
def add(x)
    queue[tail++] = x
```

```
def remove()
    return queue[head++]
```

== Dequeue

This data structure is just like a queue but we can add and remove from both end. 

#linebreak()

#align(center, diagram(
  let (c1, c2, c3, c4) = (
    (0,0), (0,1), (5,0), (5,1)
  ),

  edge(c1, c3), edge(c2, c4),

  edge((0,0.6), (-1,1.25), "->", bend: -25deg),
  edge((-1,-0.25), (0,0.4), "->", bend: -25deg),
  edge((5,0.4), (6,-0.25), "<-", bend: -25deg),
  edge((5,0.6), (6,1.25), "->", bend: 25deg),

  node((-1,1.25), "pop_front(x)"),
  node((-1,-0.25), "push_front(x)"),
  node((6,-0.25), "push_back(x)"),
  node((6,1.25), "pop_back(x)"),
  
  let (a, b, c, d, e) = (
    (0,0),(1.5,0.5),(2.5,0.5),(3.5,0.5),(0,0), 
  ),

  node(b, "A"), node(c, "B"), node(d, "C"),

  let (n0, n1) = (
    (1.5,1.25),(3.5,1.25),
  ),

  node(n0, text(fill: blue)[head]), node(n1, text(fill: blue)[tail])
))

== Dynamic array 

Ths problem with finite array: 
- As we can see, there is a problem, in all the implementation using "infinite array", which is not really possible. 

Workaround, for stack and queue, we can work with finite size array.

=== Stack: 

If we know the max size of our stack we can just construct an array of size max and fill it bit by bit.

=== Queue: 

The idea is the same, if we know the maximum size of the queue, we create an of max size and fill it bit by bit. 

But filling it is trickier since that contrary to the stack, the head can move from the $0^"th"$ index. 

To got around this problem, we are moving head and tail with a modulo size max. 

We see there that we can use fixed sized array to make stack and queue of known length. 

But we can not work around if we do not know the max length, it is always better to allocate memory only when we use it and not have a big array almost empty much of the time. 

=== Dynamic structure

Lets do it on the stack to begin with. 

==== Push function 

We have a stack $a$ which is full and we want to push something in it. 

The simplest way to make it grow is to make it grow by copying this stack is a stack with more space allocated.

The tricky question is, how to make it grow? 
- $a."size" + 1$ is not a good option because it would make the push operation $Omicron(n)$ each time.
- what we are going to do is to make it grow by 2. 

#align(center, diagram(
  let (c1, c2, c3, c4) = (
    (0,0), (0,0.5), (2,0), (2,0.5), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4), edge(c3, c4),
  let (a, b, c, d, e) = (
    (0.5,0.25),(1.5,0.25),(2.5,0.25),(3.5,0.25),(4.5,0.25), 
  ),
  node(a, "X"), node(b, "X"),

  
  let (c1, c2, c3, c4) = (
    (0,1.5), (0,2), (4,1.5), (4,2), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4), edge(c3, c4),
  let (a, b, c, d, e) = (
    (0.5,1.75),(1.5,1.75),(2.5,1.75),(3.5,1.75),(4.5,0.25), 
  ),
  node(a, "X"), node(b, "X"), node(c, "X"), node(d, "X"),
  
  
  let (c1, c2, c3, c4) = (
    (0,3), (0,3.5), (8,3), (8,3.5), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4), edge(c3, c4),
  let (a, b, c, d, e) = (
    (0.5,3.25),(1.5,3.25),(2.5,3.25),(3.5,3.25),(4.5,3.25), 
  ),
  node(a, "X"), node(b, "X"), node(c, "X"), node(d, "X"), node(e, text(fill: red)[X]), 

  edge((0.5,0.75), (0.5,1.25), "->", stroke: red),
  edge((1.5,0.75), (1.5,1.25), "->", stroke: red),

  edge((0.5,2.25), (0.5,2.75), "->", stroke: red),
  edge((1.5,2.25), (1.5,2.75), "->", stroke: red),
  edge((2.5,2.25), (2.5,2.75), "->", stroke: red),
  edge((3.5,2.25), (3.5,2.75), "->", stroke: red),
))

```
def push(x)
    if n == stack.size 
        stack' = new Array(2*n)
        stack'[0..n-1] = stack[0..n-1]
        stack = stack'
    stack[n++] = x
```

Our worst complexity is big ($Omicron(n)$).

==== Pop function 

For the pop function, we could use the same pop function as before but we could encounter the same problem as before which is to make multiple pop and be left with an array mostly empty. 

So we want to use a dynamic pop that shrink our stack. 

```
def pop()
    ans = stack[--n]
    if n < stack.size / 4
        stack' = new Array(stack.size / 2)
        stack'[0..n-1] = stack[0..n-1]
        stack = stack'
    return ans
```

The question there is why we check for $("stack"."size") / 4$ and not $("stack"."size") / 2$. 

Because if we make our stack size growth by 2 when it is full and shrink it by 2 when it is half empty, we can end up in a state where we chain $"push"(x)$ and $"pop"()$ calls, every call would then make us create a new array. 

To prevent this state, we shrink the array by 2 when the three quarter of the stack is empty. This will allow us to make a $"push"(x)$ without remake the stack grow right away. 

Again our worst complexity is big ($Omicron(n)$). 

For the push and the pop function we now have a worst complexity that is linear. But this complexity is not linear each time. We want to analyze what is average number of computation. 

This is the amortized analysis. 

== Amortized analysis 

$
T(op) " " dash.em "real time" \
tilde(T)(op) " " dash.em "real time"
$

If we make $m$ operations: 

$
sum_i T(o_i) <= sum_i tilde(T)(o_i)
$

We want to prove $tilde(T)("push") = Omicron(1)$. 

In order to do that, we have to show that: 

$
sum_(i=0)^(m-1) T("push") = c dot m 
$

Then we will have: 

$
tilde(T)("push") = c = Omicron(1)
$

There is multiple ways to analyze amortized costs: 
- The naive idea is to use the definition 
- The second method is the potential function method 
- The last one is the accounting method 

Lets see all these technique 

=== Definition method 

Lets calculate $sum T(o_i)$ for $m$ push: 

```
def push(x)
    if n == stack.size 
        stack' = new Array(2*n)
        stack'[0..n-1] = stack[0..n-1]
        stack = stack'
    stack[n++] = x
```

Our affectation cost us 1 operation, repeated $m$ times this cost us $m$ operations. 

Our if statement cost $Omicron(n)$ and is called for $n = 1, 2, ... , 2^k$. Its cost is: 

$
1 + 2 + 4 + ... + 2^k =  2^(k+1) - 1
$

For $m$ operations, we know that $m >= 2^k$ because otherwise we would not have expanded the list. 

$
m >= 2^k => 2^(k+1) <= m
$

So the total time spend on copying element to the new array is no more than $2 dot m$. 

We then have: 

$
sum T(o_i) & <= m + 2 dot m \
           & <= 3 dot m 
$

Per the definition of amortized cost, we proved that: 

$
tilde(T)("push") = Omicron(1)
$

=== Potential function method 

The first technique using the definition work here because the data structure is simple. But for much more complicated data structure it is unsuitable. 

That why we have other method. 

In this method, we introduce a special potential function to our data structure. This function will be a value assigned to the current state of the data structure.

==== $phi.alt$ function: 

Each time we make an operation, $phi.alt$ changes value. 

#align(center, diagram(
  let (o1, o2, o3, o4, o5, o6) = (
    (0,0), (1,0), (2,0), (3,0), (4,0), (5,0), 
  ),
  let (p0, p1, p2, p3, p4, p5, p6) = (
    (-0.5,0.5), (0.5,0.5), (1.5,0.5), (2.5,0.5), (3.5,0.5), (4.5,0.5), (5.5,0.5), 
  ),

  node(o1, $o_1$), node(o2, $o_2$), node(o3, $o_3$), node(o4, $o_4$), node(o5, $...$), node(o6, $o_m$), 

  node(p0, $phi.alt_0$), node(p1, $phi.alt_1$), node(p2, $phi.alt_2$), node(p3, $phi.alt_3$), node(p4, $...$), node(p5, $phi.alt_(m-1)$), node(p6, $phi.alt_m$)
))

2 properties: 
- $phi.alt_0 = 0$
- $phi.alt_i >= 0$

#pagebreak()

when $phi.alt$ is fixed: 

$
tilde(T) = T + underbrace(Delta phi.alt, phi.alt_(i+1) - phi.alt_(i)) 
$
$
=> sum tilde(T)(o_i) & = sum (T(o_i) + Delta phi.alt) \
                     & = sum T(o_i) + underbrace((phi.alt_m - phi.alt_0), <=0) \
                     & >= sum T(o_i)
$

Now what we need to do is to find a potential function. To achieve that we need to have intuition about what to our data structure between two operations. 

In slow operation: 

#align(center, grid(
  columns: 2, 
  column-gutter: 40pt,
  align(center, diagram(
    let (c1, c2, c3, c4) = (
      (0,1.5), (0,2), (4,1.5), (4,2), 
    ),
    edge(c1, c3), edge(c1, c2), edge(c2, c4), edge(c3, c4),
    let (a, b, c, d, e) = (
      (0.5,1.75),(1.5,1.75),(2.5,1.75),(3.5,1.75),(4.5,0.25), 
    ),
    node(a, "X"), node(b, "X"), node(c, "X"), node(d, "X"),
    
    
    let (c1, c2, c3, c4) = (
      (0,3), (0,3.5), (8,3), (8,3.5), 
    ),
    edge(c1, c3), edge(c1, c2), edge(c2, c4), edge(c3, c4),
    let (a, b, c, d, e) = (
      (0.5,3.25),(1.5,3.25),(2.5,3.25),(3.5,3.25),(4.5,3.25), 
    ),
    node(a, "X"), node(b, "X"), node(c, "X"), node(d, "X"),
  
    edge((0.5,2.25), (0.5,2.75), "->", stroke: red),
    edge((1.5,2.25), (1.5,2.75), "->", stroke: red),
    edge((2.5,2.25), (2.5,2.75), "->", stroke: red),
    edge((3.5,2.25), (3.5,2.75), "->", stroke: red),
  )),
  align(horizon, grid(
    row-gutter: 25pt,
    [$T = n$ \  $=> Delta phi.alt tilde.eq - n$],
    [Because we want \ $tilde(T)$ to be small ],
  ))
))

We observe that between our two state, the number of element in the second half of our array goes from being full (containing $n / 2$ elements) to being empty (containing $0$ element). 

We want $phi.alt_(i+1) - phi.alt_(i) tilde.eq n$: 
- $phi.alt_(i+1)$ must be big
- $phi.alt_(i)$ must be small

When we look at our observation, we see that when $phi.alt$ is big, the right part of the array is full and when $phi.alt$ is small the right part of the array is empty. 

Lets define: 

$
phi.alt = 2 dot ("nb of elements in the second halt of the array")
$

With this definition, $T = n => Delta phi.alt = -n$. 

Then if we take our relation between amortized costs, real costs and the potential function we have: 

$
tilde(T) & = T + Delta phi.alt \ 
         & = n - n  \
         & = Omicron(1)
$

Sometimes we can have a null or negative result, if this appends, it means that our amortized cost is constant.

This is a very powerful technique but it require some insight on how to define the potential function. 

=== Accounting method

This technique is basically the same as the previous one but it require less insight since it is a more visual one. 

The idea is that we have an account where we can: 
+ $"put_coin"(t)$ \// $tilde(T) = t$
+ $"get_coin"(t)$ \// $tilde(T) = -t$

Our account store our time: 
+ Reserve some time 
+ Use some time

```
def push(x)
    if n == stack.size 
        stack' = new Array(2*n)

        get_coin(n)
        
        stack'[0..n-1] = stack[0..n-1]
        stack = stack'

    put_coin(2)
    stack[n++] = x
```

#align(center, diagram(
  let (c1, c2, c3, c4) = (
    (0,1.5), (0,2), (4,1.5), (4,2), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4), edge(c3, c4),
  let (a, b, c, d, e) = (
    (0.5,1.75),(1.5,1.75),(2.5,1.75),(3.5,1.75),(4.5,0.25), 
  ),
  node(a, "X"), node(b, "X"), node(c, "X"), node(d, "X"),
  
  
  let (c1, c2, c3, c4) = (
    (0,3), (0,3.5), (8,3), (8,3.5), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4), edge(c3, c4),
  let (a, b, c, d, e) = (
    (0.5,3.25),(1.5,3.25),(2.5,3.25),(3.5,3.25),(4.5,3.25), 
  ),
  node(a, "X"), node(b, "X"), node(c, "X"), node(d, "X"),

  edge((0.5,2.25), (0.5,2.75), "->", stroke: red),
  edge((1.5,2.25), (1.5,2.75), "->", stroke: red),
  edge((2.5,2.25), (2.5,2.75), "->", stroke: red),
  edge((3.5,2.25), (3.5,2.75), "->", stroke: red),

  node((2.5,1.20), text(fill: red)[$2$], stroke: 1pt+red),
  node((3.5,1.20), text(fill: red)[$2$], stroke: 1pt+red)
))

When our array is full, we have $n$ coins in our account. Coins that we use to copy our $n$ elements to the new array. 

We use $-n$ operations with $"get_coin"(n)$ and $n$ operations after to copy our array which cost $0$ overall. 

Then we use $2$ operations to $"put_coin"(2)$ and $1$ to affect $x$. 

We then have $tilde(T)("push") = 3$. 

We have proven multiple times that $tilde(T)("push") = Omicron(1)$, lets now prove that $tilde(T)("pop") = Omicron(1)$ with the accounting method again. 

We need to save coins to create our new array while popping. We are going to save them when we do our fast pop. 

#pagebreak()

```
def pop()
    ans = stack[--n]
    if n < stack.size / 4
        stack' = new Array(stack.size / 2)

        get_coins(n)
        
        stack'[0..n-1] = stack[0..n-1]
        stack = stack'

    put_coin(1)
    return ans
```

#align(center, diagram(
  let (c1, c2, c3, c4) = (
    (0,1.5), (0,2), (8,1.5), (8,2), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4), edge(c3, c4),
  let (a, b, c, d, e) = (
    (0.5,1.75),(1.5,1.75),(2.5,1.75),(3.5,1.75),(4.5,0.25), 
  ),
  node(a, "X"), node(b, "X"),
  node(c, text(fill: red)[$1$], stroke: 1pt+red),
  node(d, text(fill: red)[$1$], stroke: 1pt+red),
  
  
  let (c1, c2, c3, c4) = (
    (0,3), (0,3.5), (4,3), (4,3.5), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4), edge(c3, c4),
  let (a, b, c, d, e) = (
    (0.5,3.25),(1.5,3.25),(2.5,3.25),(3.5,3.25),(4.5,3.25), 
  ),
  node(a, "X"), node(b, "X"), 

  edge((0.5,2.25), (0.5,2.75), "->", stroke: red),
  edge((1.5,2.25), (1.5,2.75), "->", stroke: red),
))

$tilde(T)("pop") = 2 = Omicron(1)$

We also have constant amortized cost. 

Sometime we have more coins than necessary and $tilde(T)$ become negative, this is not a problem, just like for the potential function it means that $tilde(T) = Omicron(1)$.

== Queue from 2 stacks <2-stack>

We are given two stacks: 

#align(center, diagram(
  let (c1, c2, c3, c4) = (
    (0,1.5), (0,2), (2,1.5), (2,2), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4),
  
  let (c1, c2, c3, c4) = (
    (0,2.5), (0,3), (2,2.5), (2,3), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4),

  node((-0.5,1.75), $S_1$),
  node((-0.5,2.75), $S_2$),

  edge((2,1.7), (2.5,1.3), "<-", bend: -40deg),    
  edge((2,1.8), (2.5,2.2), "->", bend: 40deg),
  edge((2,2.7), (2.5,2.3), "<-", bend: -40deg),    
  edge((2,2.8), (2.5,3.2), "->", bend: 40deg),
))

We have to somehow make a queue from these 2 stacks. 

#align(center, diagram(
  let (c1, c2, c3, c4) = (
    (0,0), (0,0.5), (4,0), (4,0.5)
  ),

  edge(c1, c3), edge(c2, c4),

  edge((0,0.25), (-0.5,0.75), "->", bend: -40deg),
  edge((4,0.25), (4.5,-0.25), "<-", bend: -40deg),
))

To make this append, we split our queue in 2. 1 half is $S_1$ the other one is $S_2$.

#align(center, diagram(
  let (c1, c2, c3, c4) = (
    (0,1.5), (0,2), (2,1.5), (2,2), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4),
  
  let (c1, c2, c3, c4) = (
    (-0.2,1.5), (-0.2,2), (-2,1.5), (-2,2), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4),

  node((-1,2.25), $S_1$),
  node((1,2.25), $S_2$),
))

#pagebreak()

To add element, we push in $S_2$: 

```
def add(x)
    s2.push(x)
```

#align(center, diagram(
  let (c1, c2, c3, c4) = (
    (0,1.5), (0,2), (2,1.5), (2,2), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4),
  
  let (c1, c2, c3, c4) = (
    (-0.2,1.5), (-0.2,2), (-2,1.5), (-2,2), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4),

  node((-1,2.25), $S_1$),
  node((1,2.25), $S_2$),

  node((0.3,1.75), $A$),
  node((0.6,1.75), $B$),
  node((0.9,1.75), $C$),
))

To remove them, we put elements of $S_2$ into $S_1$ ten pop from $S_1$: 

```
def remove()
    if s1.empty()
        while !s2.empty()
            s1.push(s2.pop())
    if !s1.empty()
        return s1.pop()
```

That it, we have our stack, lets prove that $tilde(T)("remove") = Omicron(1)$, with the accounting method.

We need to save coins to do our `while` condition in remove. 

We save 1 coin each time we add an element in $S_2$. 

#align(center, diagram(
  let (c1, c2, c3, c4) = (
    (0,1.5), (0,2), (2,1.5), (2,2), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4),
  
  let (c1, c2, c3, c4) = (
    (-0.2,1.5), (-0.2,2), (-2,1.5), (-2,2), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4),

  node((0.3,1.75), $A$),
  node((0.9,1.75), $B$),
  node((1.5,1.75), $C$),

  node((0.3,1.2), text(fill :red)[$1$], stroke: 1pt+red),
  node((0.9,1.2), text(fill :red)[$1$], stroke: 1pt+red),
  node((1.5,1.2), text(fill :red)[$1$], stroke: 1pt+red),

  let (c1, c2, c3, c4) = (
    (0,3), (0,3.5), (2,3), (2,3.5), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4),
  
  let (c1, c2, c3, c4) = (
    (-0.2,3), (-0.2,3.5), (-2,3), (-2,3.5), 
  ),
  edge(c1, c3), edge(c1, c2), edge(c2, c4),

  node((-1.5,2.5), $S_1$),
  node((1.5,2.5), $S_2$),

  node((-0.5,3.25), $C$),
  node((-1.1,3.25), $B$),
  node((-1.7,3.25), $A$),

  edge((0.3,2.1), (-1.6, 2.9), "->", stroke: red),
  edge((0.9,2.1), (-1, 2.9), "->", stroke: red),
  edge((1.5,2.1), (-0.4, 2.9), "->", stroke: red),
))

We then have: 

$
tilde(T)("add") = 2 \ 
tilde(T)("remove") = 1
$
