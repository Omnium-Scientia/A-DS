#import "@preview/fletcher:0.5.5": *
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
  semester: "1", 
  chapter_number: "15", 
  video_link: "https://www.youtube.com/watch?v=YyqdxbwAIgA&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=15",
  title: "Perfect & Cuckoo hashing, Bloom filters"
)

= Perfect & Cuckoo hashing, Bloom filters

Last lecture, we saw 2 data structures: 
#align(center, grid(
  columns:(30%,30%),  
  [
  `set`: 
  - `insert(x)`
  - `contain(x)` 
  ], 
  [ 
  `map`:
  - `put(k,v)`
  - `get(k)`
  ]
))

All of these function were working in $Omicron(1)$ average when $-> limits(PP(h(x) = h(y)))_(x!=y) tilde.eq 1/m$. 

The goal of this lecture is to make a hash table that allow us to have `get` and `contain` function working in $Omicron(1)$ worst case instead of average. 

Why? Because it happens a lot that we make a hash table at the beginning at the program and then make many `get` operations. 

There is 2 techniques to do that, perfect hashing and cuckoo hashing. 

== Perfect hashing 

Last lecture we had: 

```
def get(k) 
    i = h(k)
    find k in a[i]
```

Since $a[i]$ was a list, our find operations had a worst case complexity of $Omicron(n)$. What we want to do is use another data structure that will allow us to have a find operation working in constant time. 

And what data structure allows us to find in constant time? Yes hash table. Instead of lists, we will have hash tables to store our collision. 

We will use small hash tables inside a big hash table. 

We need a different hash function between the big and small hash tables. If not, our optimization would be useless. And will use a different hash function for each small hash table. 

$
a[i] - "hash table with hash function " g_i
$

At this moment you might ask yourself: 
- But what is we have collision in $a[i]$, we also put smaller hash tables in it again? 
- At one point, we need to stop the hash tables Matryoshka. 

What are we going to do is to keep $a[i]$ collision free. We talked about the possibility of doing that in the previous lecture, we can have collision free table if the array is big enough compared to number of element inserted. 

We could not use that for our main table because the number of element is to big but there since our tables are small we can afford to do it. 

$
n_i = "number of elements in" a[i] \ "size"(a[i]) = n_i^2
$

If we do that, we have a high probability that we will not have any collision. If one occur anyway, we get a new hash function until we do not have any collision. 

Lets calculate the average number of collision. Since we have $n_i$ element: 

$
EE("collision") = (n(n-1)/2) dot 1/n^2 tilde.eq 1/2 \ PP("collision" >= 1) <= 1/2
$

So we will not have to try many times to find a good function $g_i$. 

Since our small hash table are collision free, our `find k in a[i]` work in $Omicron(1)$ worst case. 

Now that we have a working hash table, lets see what is its size: 

$
"size" = sum_i n_i^2 \ sum_i n_i^2 = "number of pair" (x,y), h(x) = i, h(y) = i
$

$
EE(sum_i n_i^2) &= EE("number of pairs" (x,y) : h(x) = h(y)) \ 
                &= underbrace(n,n "pairs" \ "where" x = y) + EE("number of pairs" (x,y) : x!=y, h(x) = h(y)) \ 
                &= n + (n(n-1)/2) dot 1/n \ 
                &= Omicron(n)
$

The size of our hash table stays linear. 

In theory, this is a good technique but in practice, the constant factor is much bigger than the classical way we saw in the previous lecture + it uses more memory. So, in practice, with the exception of special weird case, you do not want to use it (remember we made the same commentary on Fibonacci heap, great theory but mostly unusable).

== Cuckoo hashing 

We have 2 hash function ($h_1$ and $h_2$) and 2 array ($a_1$ and $a_2$) with $"size"(a_1) + "size"(a_2) > "number of elements"$. 

Each element have two possible placement, one in $a_1$ and one in $a_2$. 

```
def get(k)
    look in a1[h1(k)]
    look in a2[h2(k)]
```

But how we put elements $x$ in our tables? 
- If one of the two positions: $a_1[h_1(x)]$ or $a_2[h_2(x)]$, we put $x$ in this empty position. 
- When we have an element in $a_1[h_1(x)]$ and in $a_2[h_2(x)]$ (respectively $A$ and $B$): 
  - Both of our possibility are taken 
  - We put $x$ at the place of $A$ 
  - We try to put $A$ in $a_2$ at $a_2[h_2(A)]$: 
    - If an element $C$ is in there then we put $A$ at the place of $C$ and try to put $C$ in $a_1$ 
    
  And so on until we reach an empty position. 

A problem here is that we can en in a cycle: 
#align(center)[
$X$ goes in $a_1[h_1(X)] = a_1[h_1(A)]$ \
$A$ goes from $a_1[h_1(A)] -> a_2[h_2(A)] = a_2[h_2(B)]$ \
$B$ goes from $a_2[h_2(B)] -> a_1[h_1(B)] = a_1[h_1(C)]$ \
$C$ goes from $a_1[h_1(C)] -> a_2[h_2(C)] = a_2[h_2(D)]$ \
$D$ goes from $a_2[h_2(D)] -> a_1[h_1(D)] = a_1[h_1(E)]$ \
$E$ goes from $a_1[h_1(E)] -> a_2[h_2(E)] = a_2[h_2(A)]$ \
$A$ goes from $a_2[h_2(A)] -> a_1[h_1(A)] = a_1[h_1(X)]$ \
$X$ goes from $a_1[h_1(X)] -> a_2[h_2(X)] = a_2[h_2(D)]$ 
]

We can see that here we have a full cycle from we cannot escape. And we cannot fully prevent those kind of cycle. 

So how to do deal with that? 
- Use a cycle detection algorithm 
- Keep the value of the number of changes. If we go this number become bigger than $tilde.eq 100$ it mean we probably have a cycle. 

When we detect a cycle, we recalculate a hash function and make our structures from the base. 

Now, to keep our complexity small, we want to ensure that the probability of cycle is small. 

The proof will be in the further reading because it is kinda black magic and use the property of k-universality of our function set. which roughly mean: 

$
forall (x_1, ... x_k),(y_1, ... y_k) in NN^k, PP(h(x_1) = h(y_1), ... h(x_k) = h(y_k)) = 1/m^k
$

In our case, if our set $H$ is $log(n)$-universal our probability will stay low enough. 

This is complex but what we need to grasp is that with a good hash function this works good. Just be careful in production and try to ensure that your possible function are sufficiently good. 

We can add that at the beginning we said that $"size"(a_1) + "size"(a_2) > "number of elements"$. 
We can say that we want to have $"size"(a_1) + "size"(a_2) > c dot "number of elements" "with" c >= 1$ 

The probability of our cycle will decrease with the growing of $c$ (our memory consumption grow with $c$ so it is a tradeoff). 

But anyway these cycle only affect our put speed. Our get will always works in $Omicron(1)$ worst case. 

== Bloom filters

We want to create a set data structure with classical operations (insert and contain). 

The objective is to use the less memory we can. Basically, the smallest amount is the memory used to remember all the elements of the set. We want to go lower than that. 

One might think it is impossible, and one would be right in general. But, we are going to introduce a property that make it possible. 

We are going to allow our structure to be wrong. Sometimes our structure will say $x$ is in the set but $x$ will not be in it. 

The error threshold for contains operation should not be more than $epsilon$. The size of our structure will be a tradeoff of our probability. 

$
epsilon arrow.tr "size" arrow.br \ epsilon arrow.br "size" arrow.tr
$

=== Set of 1 element 

You have one element $x$ and a function that tells you if a given $y$ is equal to $x$. 

```
def equal_x(y)
    return x == y
```

To optimize the memory, we do not store $x$ but $h_x$ which is the hash of $x$. 

```
def equal_x(y)
    hy = hash(y)
    return hx == hy
```

We can see that if $y$ and $x$ collide, we have a wrong answer. 

But, we saw that with a good function, 

$
"for memory" = k "bits" \ limits(PP(h(x) = h(y)))_(x!=y) = 1/2^k
$

We can now see the tradeoff between memory usage and the probability of error. 

=== Actual set 

We have an array of bits of length $m$ and $k$ hash functions ($h_1, ..., h_k$). 

Instead of computing and storing the hash of $x$, we do the following: 
- for insert function: 
  - for all $i$ in $bracket.double.l 1,k bracket.double.r$ compute $h_i(x)$. 
  - for all $i$ in $bracket.double.l 1,k bracket.double.r, a[h_i (x)] = 1$
- for contain function: 
  - for all $i$ in $bracket.double.l 1,k bracket.double.r$ we check that $a[h_i (x)] = 1$

```
def insert(x)
    for i = 1..k 
        a[h[i](x)] = 1
```

```
def contain(x)
    for i = 1..k 
        if a[h[i](x)] == 0
            return false 
    rewturn true
```

Again, we see from where our errors can come. We can insert element that collide with $x$ for a specific $h_i$. So if $forall i in bracket.double.l 1,k bracket.double.r ,exists y, h_i (x) = h_i (y)$ we have contain equal true for $x$  when $x$ is not actually here. 

Lets now fix our $k$ and $m$: 
- We want $m$ such as $PP(a[i] = 1) = 2$ (i.e. when we pick an element at random from $a$, we have the same chance to get $0$ or $1$). 

  Since for each element we add $k$ ones, we add $k dot n$ ones total. 

  If we want halfs the number of $1$ and $0$ in $a$, we need $m tilde.eq 2 dot k dot n$ (actually it is smaller ($m = 1.44 dot k dot n$) because some ones are colliding). 

Since $PP(a[i] = 1) = 1/2$, the probability of a false positive is $1/2$ for each iteration. 

We then have: $PP("false positive") tilde.eq 1/2^k$

And from definition we have: $PP("false positive") = epsilon$

- From that, we fix $k = log 1/epsilon$

Again, we clearly see the dependance between memory usage and number of error. 

Example: 

$
n = 10^6 ("big objects") \ epsilon tilde.eq 10^(-6) \ k tilde.eq 20, m tilde.eq 2.10^7 tilde.eq 2.5 "MB"
$

Which is very compact. 

== Cuckoo filter 

The idea is to combine both cuckoo hashing and bloom filter idea. 

The idea is the following: 
- for insert function: 
  - We compute $x'$, a $k$ bits fingerprint (hash) of $x$. 
  - we insert the element in the cuckoo table: 
    - we compute $h_1(x)$ and $h_2(x)$
    - but instead of putting $x$ as in the cuckoo hashing, we put $x'$ in one of the array
- for the check function: 
  we check if $a_1[h_1(x)]$ or $a_2[h_2(x)]$ contain $x'$

We have a problem here: 
- During the insertion, if both places are occupied, we move one of the present element (lets called it $A$)
- For cuckoo hashing, we were just putting $A$ in $a_2[h_2(A)]$
- Here, we cannot do that because we cannot compute $a_2[h_2(A)]$ since it is $A'$ in the array. 

To go around this problem we define: 

$
h_1(x) = "hash"(x) \ h_2(x) = h_1(x) plus.circle "hash"(x') 
$

#pagebreak()

With this: 
- If we go from $a_1 -> a_2$: 
  - we know the value of $h_1(x)$ because it is the value of the index of $A'$ in $a_1$. 
  - we can compute $"hash"(x')$ because we have $x'$

  So we can compute $h_2(x)$
- If we go from $a_2 -> a_1$: 

  We know $h_2(x)$ and can compute $"hash"(x')$, so we have: $h_1(x) = h_2(x) plus.circle "hash"(x')$ from xor property. 

Here, we define: 

$
k = log 1/epsilon + 1 \ "size" tilde.eq (k dot n)/"load factor"
$

_Note 1: It is really difficult to make a bloom or a cuckoo filter that allow to remove elements._

_Note 2: We have skipped some math in this lecture (especially in the cuckoo sections), this is because the mathematics behind this are pretty hardcore and require deep knowledge._
