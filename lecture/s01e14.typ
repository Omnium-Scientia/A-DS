#import "@preview/fletcher:0.5.5": *
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
    semester: "1", 
    chapter_number: "14", 
    video_link: "https://www.youtube.com/watch?v=QM_m5TfoQm4&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=14",
    title: "Hash tables"
)

= Hash tables

Hash tables are really important data structures. They are randomized and can cause problem in some situation. We will see when to use them and when not to. 

There are 2 major data structures that are based on hash tables: 
- `set`: as the name suggest, this is a set of objects. Its base operations are: 
    - `add(x)`
    - `remove(x)`
    - `contain(x)`
- `map`: these are object mapping a key to a value, we access value with the key. Its base operations are: 
    - `put(k,v)`
    - `get(k)`

Those are widely used primitive data structures. 

== Simple implementations 

=== Small range integers keys 

$
"key" in bracket.double.l 0,m-1 bracket.double.r \ m - "small"    
$

We use the key as an index of an array: 

```
def put(k,v)
    a[k] = v
```

```
def get(k)
    return a[k]
```

This is the most simple case to implement `maps`. 

=== Big range integers key

$
"key" in bracket.double.l 0,n-1 bracket.double.r \ n - "big"    
$

What wee can do is to make a function that take a big integer and return a small one. Then we use this result as a key in our array. 

$
h cases(
    delim: bar, 
    bracket.double.l 0\,n-1 bracket.double.r -> bracket.double.l 0\,m-1 bracket.double.r,
    k |-> k % m
)
$

What we can do now is: 

```
def put(k,v)
    a[h(k)] = v
```

```
def get(k)
    return a[h(k)]
```

#pagebreak()

Example: 

$
a: [ &" "& | &" "& | &" "& | &" "& | &" "& ] \ &0& &1& &2& &3& &4&
$

`put(37,3)` $->$ `h(37) = 2`

$
a: [ &" "& | &" "& | &3& | &" "& | &" "& ] \ &0& &1& &2& &3& &4&
$

`get(37)` $->$ `h(37) = 2` $->$ `3`

Since the function $h$ is the same for one hash table for both function $"put"$ and $"get"$, we end on the same index. This is the basic idea of hashing. 

But our current implementation suffer from one big problem: 
- Collision: when we have: $x,y in bracket.double.l 0\,n-1 bracket.double.r, x != y and h(x) = h(y)$

For example with our previous example we have: $37 != 52 and h(37) = h(52) = 2$

So we can get wrong result from collision. 

To patch that problem, instead of putting only the value in our array, we put the couple $("key","value")$. So that when we will have collision we can check for key equality. 

There is still one thing to do change, now we can ensure that we will not return a bad answer but we can store only 1 couple for a given index. To patch that, we store a list of couple instead so we can save multiple value a the same index. 

Example: 

$
a: [ &" "& | &" "& | (37,3)&;&(52,5) | &" "& | &" "& ] \ &0& &1& &2& &3& &4&
$

```
def put(k,v) 
    a[h(k)].add((k,v))
```

This function is fine if our $k$ is not already in the hash table. But it does not really work if it it the case, because we want to replace the value not ad it again. 

```
def get(k)
    for (x,y) : a[h(k)]
        if x = k
            return y 
    return null 
```

Both of our function have a worst case linear complexity. 

Since our function $h$ is really simple, the data is not really randomized and we can end in a situation where most of our value have the same index. 

If we want to avoid collision, we need to increase our array size. Indeed, we have $n$ elements so the number of pair is of the order of $n^2$. Each pair have the same probability to be putted in our hash table. Since our hash table array as a length of $m$, if we want the length of our collision list to be of $Omicron(1)$ length, we want the probability of choosing a cell to be the same as the one of a pair. The probability to chose a cell at random is $1/m$. Which mean that we need 

$
1/m = 1/(n^2)
$

So $m$ need to be at least of the order of $n^2$ to avoid collision. 

This is a problem because it forces us to make really big array to avoid collision for big value of $n$. So we cannot use this function is $n$ is not small. 

== Random hash function 

What we then want is to use a random function from all $h bar bracket.double.l 0,n-1 bracket.double.r -> bracket.double.l 0,m-1 bracket.double.r$. Which gives us $m^n$ possibilities. 

If we take a random function, what is the expected complexity for get?

$
EE(T("get")) &= EE(forall k, "number of" x != k: h(k) = h(x)) \ 
&= n/m because k != x => PP(h(k) = h(x)) = 1/m 
$

So if $m tilde.eq n -> T("get") = Omicron(1)$

But we need to chose one of $m^n$ function, this is too big of a number to be exploitable. So, in practice, you do not have a completely random hash function. What we do is take a set of good functions from our possible ones. And we pick one of this set. 

Our function set is the following, we call it $H$. 

$
H eq.def {
    h_(p,A) cases(
    delim: bar, 
    NN -> bracket.double.l 0\,m-1 bracket.double.r, 
    k |-> ((k dot A) % p) %m,
    ) : p "big random prime number", A in bracket.double.l 0,p-1 bracket.double.r
}
$

To get a function, we just generate $p$ and $A$. Lets find if our time complexity is still $Omicron(1)$ with $H$ as our function set.

In the previous proof, the property that was ensuring that $T("get") = Omicron(1)$ is: 

$
limits(PP(h(x) = h(k)))_(x!=k) = 1/m
$

If we prove that getting a function from $H$ maintain this property we will have proved that $T("get") = Omicron(1)$. 

$
     & h(x) = h(y) \
=> & ((x dot A)%p)%m = ((y dot A)%p)%m \ 
=> & (((x - y) dot A)%p)%m = 0 \ 
=> & (((x - y) dot A)%p)%m = k dot m \ 
$

Where $k in bracket.double.l 0,p-1 bracket.double.r$, we then have $tilde.eq p/m$ possibilities for $k dot m$.

Since $p$ is prime and $x != y$: 
$
forall k in bracket.double.l 0,p-1 bracket.double.r, exists ! A in bracket.double.l 0,p-1 bracket.double.r, (x - y) dot A eq.triple k dot m [p]
$

The probability that we have picked such $A$ is the same as $limits(PP(h(x) = h(k)))_(x!=k) = 1/m$. 

And the probability that we have picked such $A$ is also: 

$
underbrace(p/m,#text()[number \ of $k dot m$]) dot underbrace(1/p,#text()[number \ of $!= A$]) = 1/m
$

So, we have proved that $limits(PP(h(x) = h(k)))_(x!=k) = 1/m$. 

Then we still have $T("get") = Omicron(1)$ with our new function set. 

Attention, working with hash function is a dangerous thing, indeed in our case we only have one property to satisfy to have $T("get") = Omicron(1)$. But be careful when working with other data structures, because the property to satisfy could be different, more complex and multiple. 

== Open addressing 

Open addressing is a different solution to the collision problem. 

The idea is the following, instead of treating the collision by making a list of couple at the same index: 

$
a: [ &" "& | &" "& | (37,3)&;&(52,5) | &" "& | &" "& ] \ &0& &1& &2& &3& &4&
$

We put the collision element into the first empty cell to the right of the collided one: 

$
a: [ &" "& | &" "& | (37&,&3) | (52&,&5) | &" "& ] \ &0& &1& &2& &3& &4&
$

```
def put(k,v)
    i = h(k)
    while a[i] != null 
        i = (i+1) % m 
    a[i] = (k,v)
```

To get a key, we have two possibilities: 
- The key is in the table
- We find an empty cell before our searched key which that our key is not in the table 

```
def get(k)
    i = h(k)
    while a[i] != null 
        if a[i].first = k 
            return a[i].second
    return null 
```

Array size and complexity: 
- $n "elements" - "array of size" m=n$

    This does not work because at the end we will not have any empty space so the get function will not work. 
- lets try with $n "elements" - "array of size" m=2n$

    Approximately half of our array is empty so $PP(a[i]="null") = 1/2$. 

    So, the probability of making $i$ step before finding (or not) our key is: 

    $
    PP("number of steps" = i) = 1/2^i
    $

    So: 

    $
    EE("number of steps") = sum_i 1/2^i = 1
    $

    This is actually not totally true because our probability are not independent. This is because of clustering: 

    $
    a: [ &" "& | &" "& | &" "&    | &crossmark& | &crossmark& | &crossmark& | &crossmark& | &crossmark& | &" "& | &" "& | &" "&] \ 
         &0& &1& &2& &3& &4& &5& &6& &7& &8& &9& &10&
    $

    In this case, the probability of putting our next value in the cluster increase because of how the previous value are disposed in the array. Therefore probability are dependent of each other. But we will talk after of avoiding cluster. So we can still say that: 

    $
    T("get") = EE("number of steps") = Omicron(1)
    $

How to avoid clustering? 
- When we iterate over the right, we change the size of the steps. The change need to follow a function, what is important is to use the same jump function for put and get function. 

    The function can be: 
        - Incremental: ($1^"st"$ jump -> 1 cell,$2^"nd"$ jump -> 2 cells,$3^"rd"$ jump -> 3 cells,...)
        - Polynomial: ($1^"st"$ jump -> 1 cell,$2^"nd"$ jump -> 4 cells,$3^"rd"$ jump -> 9 cells,...)
        - Or, what we can do is to select a second hash function $h_2$ created at the same time as the first one. In this case length of jump $= h_2(k)$

    But if this function make us make big jump, our function will be less efficient. 

    It is a tradeoff. 

Why use open addressing when the previous technique seems to work just fine? 
- Memory efficiency: 
    - No other lists 
    - No other pointers 
- Useful for caching because we iterate on a continuous block of memory 

In practice this technique can be more efficient than the first one. 

#pagebreak()

== Hash tables poisoning 

The only random point that ensure the working of our algorithms is the moment we chose a hash function randomly from our set.

If someone was able to find what function we use, he would be able to create key that are all colliding in order to make our hash table algorithms inefficient. 

To detect such thing, we check the size of our list in each of the hash map cell. If one of the list is too big, there is a problem because we proved that those size are expected to be constant. 

If we detect such big list, what we can do is to pick another hash function and recreate the hash table with a new function. 

== Dynamic hash table

In practice, we rarely know how many element we are going to put in our hash table. 

To make it grow, we use the same idea we use to deal against poisoning. when we detect that our table is to little (one list of cell has become too big), we pick a function & recreate the hash map bigger. 

Just like the array, our worst case complexity will become $Omicron(n)$ but the amortized one will stay $Omicron(1)$. 
