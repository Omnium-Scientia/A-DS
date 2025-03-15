#import "@preview/fletcher:0.5.5": *
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *


= Binary search 

== Version 1: naive version 

This is the basic technique to search an element in a list of elements. 

=== Common example 

We are given a sorted array $a$ and a target $x$.

We need to find some $i$ in the array such as $x = a[i]$. 

To achieve that, we are going to use 2 pointers: 
- l = beginning at the leftmost index 
- r = beginning at the rightmost index 

We are ensuring the property: $x in a[l..r]$

#align(center, diagram(
  node((0,0), $a$),
  node((1,0), $2$),
  node((1.5,0), $5$), 
  node((2,0), $8$),
  node((2.5,0), $dot.triple$), 
  node((3,0), $15$),
  node((3.5,0), $18$),
  node((4,0), $21$),

  node((1,0.75), text(red, $l$)), 
  node((4,0.75), text(red, $r$)),

  edge((1,0.75), (1,0), "->", stroke: red), 
  edge((4,0.75), (4,0), "->", stroke: red),
))

We pick $m$ at the middle of this segment: 

$
m = floor((l + r) / 2)
$

Actually, this technique may lead to an overflow in the computing of $l + r$ depending of our language and used type. A better way to pick $m$ is: 

$
m = l + floor((r - l) / 2)
$


- if a[m] < x
  - since the array is sorted, all the elements to the left of $a[m]$ are also less than $x$
  - we want to look at the right of $m$
  - l = m + 1

- else if a[m] > x 
  - then it is the opposite case, all the elements to the right of $a[m]$ are also greater than $x$
  - we want to look at the left of $m$
  - r = m - 1

- else a[m] = x
  - we return $m$

We have our algorithm. 

#pagebreak()

```
def bin_search(a, x)
    l = 0, r = n - 1
    while r - l + 1 > 1 
        if a[m] = x 
            return m 
        else if a[m] < x 
            l = m + 1
        else 
            r = m - 1
```

If we have a more complex problem, this is not the more suitable version of binary search. 

== Version 2: Lower and upper bound 

=== Greater or equal

We are again given a sorted array $a$ and a target $x$. 

But this time we need to find $min(i)$ such as $x <= a[i]$

We are using the same two pointer as before. 

But this time, we want to ensure those properties: 
- $a[l] < x$
- $a[r] >= x$

The objective here is to find the leftmost position that the pointer $r$ can reach. 

We need to be careful to where we put $l$ and $r$: 
- Indeed, if all the elements are $>= x$, $l$ cannot be placed at index 0. 
- The same goes for $r$, if all elements are $< x$, $r$ cannot be placed at index $n - 1$. 
to satisfy the properties. 

To get around, we "add" $2$ more elements in the array: 
- $- infinity$ for the leftmost position and starting point of $l$. 
- $+ infinity$ for the rightmost position and starting point of $r$.

#align(center, diagram(
  node((0,0), $a$),
  node((1,0), $- infinity$),
  node((1.5,0), $5$), 
  node((2,0), $8$),
  node((2.5,0), $dot.triple$), 
  node((3,0), $15$),
  node((3.5,0), $18$),
  node((4,0), $+ infinity$),

  node((1,0.75), text(red, $l$)), 
  node((4,0.75), text(red, $r$)),

  edge((1,0.75), (1,0), "->", stroke: red), 
  edge((4,0.75), (4,0), "->", stroke: red),
))

This is a common work around when we try to find element with properties. 

Note that we do not actually put the elements in the array, but imagine $l$ and $r$ to have this value. (In some case we can put the elements, but not in here). It does not matter since we will never access these values.

#pagebreak()

```
def bin_search(a, x)
    l = -1, r = n
    while r > l + 1
        m = l + (r - l) / 2 
        if a[m] >= x 
            r = m 
        else 
            l = m 
    return r // if r = n all elt >= x
```

=== Less or equal 

With the same idea, we can find $max(i)$ such as $a[i] <= x$

This time the properties we need to satisfy are: 
- $a[l] <= x$
- $a[r] > x$

```
def bin_search(a, x)
    l = -1, r = n
    while r > l + 1
        m = l + (r - l) / 2
        if a[m] > x 
            r = m
        else 
            l = m
    return m
```

== Version 3: 2 Integer problem

Common problems for binary search are: 
- you take $ZZ$
- In this set, some number are good the other are not

If $x$ is good, $forall y in ZZ, y > x => y$ is good. Find the minimum of the set of good numbers. 

These problems can be tricky. 

=== Example 

We have $n$ rectangle of size $h times w$. 

$x$ is a good number id we can put all the rectangles in a square of size $x times x$. 
We want to find $min(x)$. 

Let's define a function $"good"$ such that the function tells us if a number is good or not. 

```
def good(x) -> bool 
    return (x / w) * (x / h) >= n
```

This function is the trickiest part of those problems. 

#linebreak()

How we can use binary search here? 
- $l$ will be the pointer on the bad number. 
- $r$ will be the pointer on the good number. 

We know then that our property to satisfy for $l$ and $r$ is: 
- $"good"(l) = 0$
- $"good"(r) = 1$

We now need to find to what values initialize our two pointers. 

Here we can chose $l = 0$ and $r = max(h, w) * n$. 

But if $h$ and $w$ are big, we may face integers overflows. There is no short answer to solve this problem. 
- the most common work around is to check what could be the biggest possible number is for $r$. 
- another one could be to use floating point number instead of integers to avoid overflow. But other problems would arise, for example accuracy of such number. 
- The best idea is generally to find a good number small enough. To achieve that we can use another function. 

In our case: 

```
def find_small_good()
    r = 1 
    while !good(r) 
        r = r * 2
    return r
```

This is the safer way. 

Now we can work our binary search algorithm. 

```
def bin_search()
    r = find_small_good()
    l = r / 2 // work because of find_small_good definition
    while r > l + 1 
        m = l + (r - l) / 2
        if good(m) 
            r = m
        else 
            l = m
    return r
```

== Version 4: Double problem

Let's consider the following problem, we have a line and $n$ people are living on this line at $x_i$. 

For each person we know: 
- is coordinate $x_i$
- is maximum speed $v_i$ 

Each person can move left or right. Our task is to find the minimum time we need to gather them at 1 point. 

The number $t$ is considered good when all the people can gather in $t$ seconds.

It is our good property as in version 3. We now need to define our $"good"$ function. 

How to check if we can get to the same point in $t$ seconds. 

At $t$ seconds we need to check the interval where a person can be. This interval is: 

$
[l_i, r_i] = [ x_i - t dot v_i, x_i + t dot v_i]
$

Our goal is to find a point which is in the interval for every person: 

$
forall i cases(
  delim: "|", 
  x >= l_i, 
  x <= r_i
) => cases(
  delim: "|", 
  x >= max(l_i), 
  x <= min(r_i)
)
$

```
def good(t) -> bool 
    return max(x_i - t * v_i) <= min(x_i + t * v_i)
```

The next thing we need to consider is that in this example, $t$ can not be an integer. 

The basic idea stay the same: 
- 1 pointer for the good values
- 1 pointer for the bad values 

The first way to implement our binary search considering that our target is not an integer is to do the same as before but our loop will be:

#align(center)[`while r - l > EPS` , with EPS a small value.]

```
def bin_search()
    EPS = 10**(-9)
    l = 0, r = 10**10
    while r - l > EPS
        m = l + (r - l) / 2
        if good(m) 
            r = m
        else 
            l = m
    return r 
```

This way is not a good idea. Let's say that our answer $t tilde.eq 10^9$ we then have in our loop: 

$
l = 3.1415 ... 356 \ r = 3.1415 ... 357 
$

With approximately 16 digits for double. in this case $r - l tilde.eq 10^(-7)$. 

We will never be able to reach our $epsilon$ with double numbers, because in this example $l$ and $r$ are the closest they can be. 

_It is the same as having two following integer but here we have two following double._

How to fix this? 
- first option: check if $m = l "or" r$
  - if it is the case then we are in the previous situation so we can break 
- second option: The safest way 
  - instead of a while-loop we can use a for-loop and do a given amount of iterations.
    - i.e. `for i=0..100` instead of `while r - l > EPS` 
    since each time the difference between $l$ and $r$ is divided by 2, with this for-loop the distance will be divided by $2^100 tilde.eq 10^30$. This is more than enough, 100 even may be to big and time out. 

```
def bin_search()
    l = 0, r = 10**10
    for i=0..100
        m = l + (r - l) / 2
        if good(m) 
            r = m
        else 
            l = m
    return r 
```

== Version 5: Ternary search

=== Example 

Imagine you are given a function that you want to maximize. This function is of $x$. 

#align(center, diagram(
  render: (grid, nodes, edges, options) => {
    cetz.canvas({
      draw.set-style(
        axes: (
          y: (label: (anchor: "north-west", offset: -0.2), mark: (end: "stealth", fill: black)),
          x: (mark: (end: "stealth", fill: black)),
        ),
      )
      plot.plot(
        size: (10, 4),
        x-min: -1,
        x-max: 1,
        x-label: $x$,
        y-label: $f(x)$,
        y-tick-step: 1,
        x-tick-step: 2,
        x-grid: false,
        y-grid: false,
        legend: "inner-north-west",
        legend-style: (stroke: .5pt),
        axis-style: "school-book",
        {
          plot.add(
            style: (stroke: red + 1.5pt),
            domain: (-1, 1),
            samples: 100,
            x => -calc.pow(x+0.16, 2) + 0.5,
          )
        },
      )
    })
  }
))

On the interval where we want to maximize $f$, the function can be separated in 2 intervals, 1 where the function increase, the other one where the function decrease. 

If at each point we can check if the function is increasing or not, then this check become our good function and we use the previous binary search example. 

But if we can only compute the value of the given point: 
- we set two pointers $l$ and $r$ 
- we maintain following properties, 
  - in $l$ the function is increasing
  - in $r$ the function is decreasing 
- we pick 2 middle points $m_1$ and $m_2$

  - $m_1 = l + 1 / 3 (r - l)$

  - $m_1 = l + 2 / 3 (r - l)$
- now we compute $f(m_1)$ and $f(m_2)$
  - if $f(m_1) >= f(m_2)$
    - it means that the function is decreasing in $m_2$
    - $r = m_2$
  - else 
    - it means that the function is increasing in $m_1$
    - $l = m_1$

At each time, we decrease the length of the segment by $2/3$. 

The tricky part here is to chose $m_1$ and $m_2$. Because in a case where the difference between $m_1$ and $m_2$ is little, we can face accuracy problems. 

=== Make the algorithm faster

The most of the computation time here is the evaluation of $f$ in $m_1$ and $m_2$. 

To save time, the idea is to chose carefully our $m$ in order that only 1 of them change at each iterations i.e.:
- if $r = m_2$, $m_1$ become $m_2$ in the next iteration. Therefore the value of $f(m_2)$ is already known from the previous iteration s owe can save lots of time. 
- if $l = m_1$, $m_2$ become $m_1$ in the next iteration. In this case we already know the value of $f(m_1)$. 

In order to do that, we want to find $alpha$ such as: 

$
d_(l,m_1) = d_(m_2,r) = alpha dot (r - l) \ 
d_(m_1,m_2) = alpha dot (r - m_1)
$

Let's find $alpha$: 

$
d_(m_1,r) = &(1 - alpha) dot (r - l) \
d_(m_2,r) = &(1 - alpha) dot (r - m_1) \
            &(1 - alpha) dot d_(m_1, r) \
            &(1 - alpha)^2 dot (r - l)
$

$
alpha dot (r - l) = (1 - alpha)^2 dot (r - l) \
alpha = 1 - 2 alpha  + alpha ^2 \ 
alpha ^2 - 3 alpha + 1 = 0 
$

This way to chose $alpha$ will increase the speed by $tilde.eq 2$ because we will only have to compute one $f(m_i)$ each time and the computation of $f$ are costing way more than the other operation. 
