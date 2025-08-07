#import "@preview/fletcher:0.5.5": *
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
    semester: "1", 
    chapter_number: "12", 
    video_link: "https://www.youtube.com/watch?v=5C7JT8cVHDU&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=12",
    title: "Knapsack"
)

= Knapsack

Knapsack problem is a fundamental problem in computer science. You can encounter it in many situation and real life problem. 

It is then an important thing to know how to recognize those problems and know what are the options to solve it. 

== Problem statement

You have: - $n$ items 

Each items has a weight and a cost: $forall i in bracket.double.l 0,n-1 bracket.double.r | I_i -> (w_i, c_i)$

You also have a knapsack of capacity $S$. 

Your objective is to put items in the knapsack in order to maximize its cost while not exciding its capacity: 

$
sum_i w_i <= S \ sum_i c_i "is maximized"
$

This problem is NP-complete (we will discuss and defined NP-complete more in the last lecture of semester 2) for now, lets just say that we do not know if a solution exist for this problem. 

If there is no additional constrain, there is a good chance that this problem is not solvable. 

But, with additional constrain it is possible. 

== No cost 

$
forall i, c_i = w_i
$

Then we want: 

$
sum_i w_i <= S \ sum_i w_i "is maximized"
$

This is still NP-complete. 

But what we can do is: 

$
D[i,j] eq.def "it is possible to have subset of" I[0..i-1] "with" sum w = j
$

+ set contain $i-1$:
    $D[i,j] = D[i-1,j-w_(i-1)]$
+ set does not contain $i-1$: 
    $D[i,j] = D[i-1,j]$

At the end: 
$
D[i,j] = D[i-1,j-w_(i-1)] or D[i-1,j]
$

Example: 

$
w : 5,3,2,3 \ S = 9
$

#align(
    center,
    table(
        columns: (1.5em,1.5em,1.5em,1.5em,1.5em,1.5em,1.5em,1.5em,1.5em,1.5em,1.5em), 
        rows: (1.5em,1.5em,1.5em,1.5em,1.5em,1.5em),
        [D],[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],
        [0],[+],[-],[-],[-],[-],[-],[-],[-],[-],[-],
        [1],[+],[-],[-],[-],[-],[+],[-],[-],[-],[-],
        [2],[+],[-],[-],[+],[-],[+],[-],[-],[+],[-],
        [3],[+],[-],[+],[+],[-],[+],[-],[+],[+],[-],
        [4],[+],[-],[+],[+],[-],[+],[+],[+],[+],[-],
    )
)

$
+ = "true" \/ - = "false"
$

To maximize the weight, we take the rightmost element in the last row. 

To get what we put in our maximized set, we retrace our steps. 

== Cost, all integers

$
forall i, w_i in NN, S in NN, S lt.tilde 10^6 
$

To solve this problem, we use the same technique as for the previous element. But, instead of true or false, we put our cost in the cell. 

$
D[i,j] eq.def max sum_i c_i "for subset of" [0..i-1] "with" sum_i w_i <= j 
$

We use the same approach: 
+ set contain $i-1$
    $
    D[i-1,j-w_(i-1)] + c_(i-1)
    $
+ set does not contain $i-1$ 
    $
    D[i-1,j]
    $

$
D[i,j] = max(D[i-1,j-w_(i-1)] + c_(i-1),D[i-1,j])
$

Example: 

$
w : 5,3,2,3 \ c : 3,2,5,3 \ S = 9
$

#align(
    center,
    table(
        columns: (1.5em,1.5em,1.5em,1.5em,1.5em,1.5em,1.5em,1.5em,1.5em,1.5em,1.5em), 
        rows: (1.5em,1.5em,1.5em,1.5em,1.5em,1.5em),
        [D],[0],[1],[2],[3],[4],[5],[6],[7],[8],[9],
        [0],[0],text(8pt)[$- infinity$],text(8pt)[$- infinity$],text(8pt)[$- infinity$],text(8pt)[$- infinity$],text(8pt)[$- infinity$],text(8pt)[$- infinity$],text(8pt)[$- infinity$],text(8pt)[$- infinity$],text(8pt)[$- infinity$],
        [1],[0],text(8pt)[$- infinity$],text(8pt)[$- infinity$],text(8pt)[$- infinity$],text(8pt)[$- infinity$],[3],text(8pt)[$- infinity$],text(8pt)[$- infinity$],text(8pt)[$- infinity$],text(8pt)[$- infinity$],
        [2],[0],text(8pt)[$- infinity$],text(8pt)[$- infinity$],[2],text(8pt)[$- infinity$],[3],text(8pt)[$- infinity$],text(8pt)[$- infinity$],[5],text(8pt)[$- infinity$],
        [3],[0],text(8pt)[$- infinity$],[5],[2],text(8pt)[$- infinity$],[7],text(8pt)[$- infinity$],[8],[5],text(8pt)[$- infinity$],
        [4],[0],text(8pt)[$- infinity$],[5],[3],text(8pt)[$- infinity$],[8],[5],[8],[10],text(8pt)[$- infinity$],
    )
)

Our answer is $limits(max)_j D[n,j]$

To get all our chosen elements, we retrace our steps. 

Our algorithm complexity is $Omicron(n dot S)$. 

In those case, we can use the fact that since $sum w <= S$ and $S$ is small, $sum w$ is also small. And since we only have integers there are not to many case to handle. This allow us to have array of the size. The fact that $S$ is small is really important have since $S$ is part of our complexity. 

== Small integers costs 

$
sum_i c_i -> "small" \ c_i - "integers" 
$

This is part of the question of the home tasks. The idea is basically the same but instead of having the weight as the state of our dynamic programming we have the costs. 

== $n$ is very small 

$
2^n - "small enough" \ n tilde.eq 25 
$

The idea here is since $n$ is small, the solution will be the naive one. We iterate over all the possible subsets. 

To achieve that, we want to enumerate all the subsets. 

We want to make a bijection between: 

$
"subset of" [0..n-1] <-> bracket.double.l 0..2^n -1 bracket.double.r    
$

We are going to use the bit in our number to enumerate our subsets. 

$
x = {1,2,4} <-> x = 0010110_2 = 22_10
$

Lets try to make all the common subsets operations with this integers. 

=== Singleton 

$
x = {i} <-> x = 1<<i = 2^i 
$ 

=== Union 

The $i^"th"$ bit of    our number should be equal to one $i$ at least one of the $i^"th"$ bit of our two sets we want to make the vision of is set at once. 

This is the bitwise or: 
$
x union y <-> x bar.v y 
$

=== Intersection 

$
x inter y <-> x \& y 
$

Elements that in $x$ and $y$. The $i^"th"$    bit of our resulting set is set to $1$ if both $i^"th"$ bit are set to $1$ for $x$ and $y$. This is the bitwise and. 

=== Difference 

We want all the elements of $x$ that are not in $y$. 

In the general case: $x \\ y <-> x \& (tilde y)$

If $forall y subset x$: $x \\ y <-> x - y "or" x hat y$

=== Appartenance of an element to the subset 

$
i in x <-> x \& (1<<i) > 0 "or" (x>>i) \& 1 > 0 
$

From now, we iterate over all subsets is just iterate from $0$ to $n-1$. 

```
def knapsack(w,c,S)
    ans = 0 
    for x = 0..2**n - 1
        sw = 0 
        sc = 0 
        for i = 0..n-1 
            if x & (1<<i) > 0
                sc += c[i] 
                sw += w[i]
            if sw <= S 
                ans = max(sc,ans)
    return ans 
```

Our complexity here is $Omicron(2^n dot n)$. We want to optimize that complexity (the $2^n$ part especially). 

=== Meet in the middle optimization 

$
underbrace(underbracket(#text(fill:blue)[$0$] " " 0 " " #text(fill:blue)[$0$] " " #text(fill:blue)[$0$] " " .,n/2).underbracket(.    " " 0 " " #text(fill:red)[$0$] " " 0 " " #text(fill:red)[$0$], n/2),n) : #text(fill:blue)[$X$] ; #text(fill:red)[$Y$]
$

We want to iterate over $x$ and $y$ separately. 

$
(1) cases(
    sum_(i in x) w_i + sum_(i in y) w_i <= S, 
    sum_(i in x) c_i + sum_(i in y) c_i -> "maximized"
)
$

We do not want to iterate over all $x$ and $y$ or our optimization will be worth nothing. 

We want the optimal $y$ for each $x$. 

Lets see, if we fix the value of $x$, what constrain do we have on $y$ from $(1)$.    

$
(2) cases(
    sum_(i in y) w_i <= S - sum_(i in x) w_i, 
    sum_(i in y) c_i -> "maximized"
)
$

Our new objective is to solve $(2)$ for $y$ without going through every possible $y$. To achieve that, we make a sorted array of $y$, sorted by $sum_(i in y) w_i$. We can then separate this array into two part: 

$
[Y_0, ... , Y_i, Y_(i+1), ... , Y_(n-1)] -> forall j in bracket.double.l 0,i bracket.double.r, sum_(k in Y_j) w_k <= S - sum_(k in X) w_k
$

We can find this prefix using binary search. 

Then we take the max value of $sum_(i in y) c_i$ from this prefix. 

With this optimization, our complexity is now $Omicron(2^(n/2) dot n)$.

== Multi-knapsack

$
n - "items" \ "weights": w_i \ S
$

We want to minimize the number of knapsacks to all items. 

Example: 

#grid(
    align: center,
    columns: (50%,50%),
    $
    w = 2,5,3,1,4,8 \ S = 9
    $, 
    $
    K_1 = {5,2} \ 
    K_2 = {8,1} \ 
    K_3 = {3,4}     
    $
)

$
forall i, sum_(w in K_i) w <= S
$

For those kind of problem, even if integers are small, it is hard to solve because we want to remember all knapsack value not only 1. 

We define our algorithm state by: 

$
D[X] eq.def "min number ok knapsacks to put all elements in" X
$

$
D[X] = limits(min)_(Y subset X \ sum_(w in Y) w <= S)(1 + D[X \\ Y])
$

```
def multi_knapsack(w,S)
    D[0] = 0
    for X = 1..(2**n - 1)
        for Y = 1..(2**n - 1)
            if Y subset of X and sum(w) of Y <= S // can precompute the sum
                D[X] = min(D[X], D[X-Y]+1)
```

This algorithm runs in $Omicron(n^4)$. Which is bad. 

Lets optimize our algorithm by iterating only over the $Y$ that are a subset of $X$. 

```
def multi_knapsack(w,S)
    D[0] = 0 
    for X = 1..(2**n - 1)
        for Y subset of X 
            if    sum(w) of Y <= S
                D[X] = min(D[X], D[X-Y]+1)
```

Here we go through all couple $(X,Y) "such as" Y subset X$

We only have 3 possible cases: 
- the element is in neither $X$ or $Y$
- the element is in $X$ but not $Y$
- the element is in $X$ and $Y$
We then have only $Omicron(n^3)$ possibilities to go through. 

With this optimization, our complexity goes from $Omicron(n^4)$ to $Omicron(n^3)$. 

The idea to iterate over all the subset of $X$ is to begin with $X = Y$ and then by decreasing $Y$ from $X$ to $0$, we get all the its subset. 

$
X =    &1 0 0 1 0 1 1 0 \
Y -> &1 0 0 1 0 1 1 0 \
     &1 0 0 1 0 1 0 0 \
     &1 0 0 1 0 0 1 0 \
     &1 0 0 1 0 0 0 0 \
     &1 0 0 0 0 1 1 0 \
     & ... \
     &0 0 0 0 0 0 0 0
$

To go from one iteration of $Y$ to another: 

#let colorunderline(color: black, equation) = block(
    stroke: (bottom: 1pt + color), 
    outset: (bottom: 2pt), 
    $ equation $
)

$
X    &: underbracket(colorunderline(color:#red,"         ")colorunderline(color:#rgb(255,255,255),1)colorunderline(color:#blue,011010)) \
Y    &: underbracket(colorunderline(color:#red,"         ")1011010) \
Y' &: underbracket(colorunderline(color:#red,"         ")colorunderline(color:#rgb(255,255,255),#text(fill:blue)[0])colorunderline(color:#blue,011010)) 
$

$
Y' = (Y - 1) & X
$

Iterating with this formula for $Y$ will give all the subset of $X$. 

```
def multi_knapsack(w,S)
    D[0] = 0
    for X = 1..(2**n - 1)
        for (Y = X; Y > 0; Y = (Y - 1) & X)
            if sum(w) of Y <= S 
                D[X] =    min(D[X], D[X-Y]+1)
```

This is quite a universal technique when we want to split a set into subsets maintaining a property. 

But in this specific problem, we can do even better. Our number of state is $Omicron(n^2)$ but our overall complexity is $Omicron(n^3)$. This append because we have too many transition between our states. 

Instead of adding elements in group, we want to add them 1 by 1. 

We have $A$ knapsacks and only 1 of them is not full. We add element one by one in it, we keep track of its weight $B$. When this knapsack is full, we create a new empty one. 

Our state is: 

$
D[X] eq.def (A,B)
$

- Here, we want to optimize both $A$ and $B$. Usually this is not possible. It is here because we want to minimize the pair. We optimize $A$ and then $B$. 

    Compare $(A_1,B_1)$ and $(A_2,B_2)$: 
    - $A_1 <= A_2, B_1 <= B_2 => (A_1,B_1) <= (A_2,B_2)$
    - $A_1 < A_2, B_1 > B_2 => (A_1,B_1) <= (A_2,B_2)$
    - Because $(A_1,B_1) <= (A_1 + 1, 0) <= (A_2,B_2)$
    // Do the schema
    
    In short, we have two parameters to optimize but they do not have the same priority. 

In our transition we go from set $X \\ {i} -> X$: 
- If $(B + w_i) <= S$ 
    $
    D[X] = (A, B+w_i)
    $
- Else $(B + w_i) > S$ 
    $
    D[X] = (A+1, w_i)
    $

Our number of transition from one state to another is now $2$ instead of $2^n$. 

With this technique, we came to a complexity of $Omicron(2^n dot n)$. 
