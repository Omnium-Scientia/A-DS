#import "@preview/fletcher:0.5.5": *
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
  semester: "1", 
  chapter_number: "11", 
  video_link: "https://www.youtube.com/watch?v=kBtTT3fTSc8&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=11",
  title: "Dynamic Programming - PART II"
)

= Dynamic Programming - PART II

== Levenshtein distance 

We have two text: 

#grid(
  columns: (50%,50%), 
  column-gutter: 10pt,
  ```py
  s = 0 
  for i in range(n): 
      s+= a[i]
  print(s)
  ```,
  ```py
  s = float('-inf') 
  for i in range(n): 
      if a[i] > s:
          s = a[i]
  print(s)
  ```
)

The changes between those texts are: 
- line 1: $s = 0 -> s = "float"('-inf')$
- line 3: add the line `if a[i] > s:`
- line 4: change `+=` $->$ `=`

We want to be able to look at two files and create the list of operation that we should do to the file $A$ to obtain the file $B$ as an output. 

This is not trivial since we do not have any information other than the two raw files. 

There are multiple list of changes that produce $B$ from $A$. The simplest being erase all the file $A$ and put $B$ at its place. 

The difficulty here is to get the minimal possible list of changes that produces $B$ from $A$. 

=== Levenshtein distance between 2 words 

You want to fo from one word to another using the minimal number of operation. 

Our authorized operations are: 
- change letter
- add letter 
- remove letter 

Lets look at an example: 

$
  A = "APPLE" \ B = "ALPINE"
  $

#align(center,grid(
  columns: (30%,30%,30%), 
  $
  A &cancel(P) P L E \ &#text(fill:blue)[L]
  $,
  $
  A L P &cancel(L) E \ &#text(fill:blue)[I]
  $,
  $
  A L P I #text(fill:blue)[N] E
  $
))

// MAke the example 

#align(
  center,
  diagram(
    let y = 0, 
  )
)

We need 4 operations to get from $A$ to $B$. This is what we call the Levenshtein distance (or the edit distance). 

The set of operation is not necessarly immutable from one problem to an other. We just need to set it when we define it. 

We now want to make an algorithm that compute that edit distance. 

We have two words:

$
A : underbracket("                   ") x "  " B : underbracket("                   ") y
$

+ If the last character bewtween $A$ and $B$ is the same $(x = y)$, we can let it here and repeat the same problem on $A'$ and $B'$ where $A' = A[:-1]$ and $B' = B[:-1]$. 

  $
  A &: underbracket("                   ") \ B &: underbracket("                   ")
  $

  We do the same as in the first dynamic programming lecture: repeat the same problem on a reduced input. 

+ If $(x eq.not y)$: 
  - change $(x,y)$ so that both leter are the same and then we are in $1.$ situation. 

  $
  A &: underbracket("                   ") y \ B &: underbracket("                   ") y
  $

  - remove $x$, then we repeat our problem between $A'$ and $B$. 

  $
  A &: underbracket("                   ") \ B &: underbracket("                   ") y
  $

  - add $y$ at the end of $A$ then repeat our problem between $A$ and $B'$. 

  $
  A &: underbracket("                   ") x y \ B &: underbracket("                   ") y
  $

  Those are the option we have if the end letter are not the same. Each time, we reduce our problem to a smaller one of the same type, and each time the smaller problems input are prefix of $A$ and $B$. 

Lets define our dynamic programming state: 

$
D[i,j] eq.def "min munber of operation to produce" B[0..j-1] "from" A[0..j-1]
$

Lets define our transition value for each transition define before: 
- same ending   
$
D[i,j] = D[i-1,j-1]
$
- change $x$ to $y$
$
D[i,j] = 1 + D[i-1,j-1]
$
- remove $x$
$
D[i,j] = 1 + D[i-1,j]
$
- add $y$ 
$
D[i,j] = 1 + D[i,j-1]
$

To get $D[i,j]$, if $x = y$ then we take this solution, else we take the minimum between every other possibilities. 

#pagebreak()

```
def levenshtein_dist(A,B)
    for i = 0..|A|
        for j = 0..|B|
            if i = 0 or j = 0
                D[i,j] = i+j
                continue
            if A[i-1] = B[j-1]
                D[i,j] = D[i-1,j-1]
            else 
                D[i,j] = 1 + min(D[i-1,j-1], D[i-1,j], D[i,j-1])
    return D[|A|,|B|]
```

Lets try to run this algorithm on our previous example: 
$
A = "APPLE" \ B = "ALPINE"
$

#align(
  center, 
  grid(
    align: center+horizon,
    stroke:1pt,
    columns: (2em,2em,2em,2em,2em,2em,2em,2em,), 
    rows:    (1.5em,1.5em,1.5em,1.5em,1.5em,1.5em,1.5em,), 
    [D],  [0],[A:1],[L:2],[P:3],[I:4],[N:5],[E:6],
    [0],  text(fill:blue)[0],text(fill:blue)[1],text(fill:blue)[2],text(fill:blue)[3],text(fill:blue)[4],text(fill:blue)[5],text(fill:blue)[6],
    [A:1],text(fill:blue)[1],text(fill:blue)[0],text(fill:blue)[1],text(fill:blue)[2],text(fill:blue)[3],text(fill:blue)[4],text(fill:blue)[5],
    [P:2],text(fill:blue)[2],text(fill:blue)[1],text(fill:blue)[1],text(fill:blue)[1],text(fill:blue)[2],text(fill:blue)[3],text(fill:blue)[4],
    [P:3],text(fill:blue)[3],text(fill:blue)[2],text(fill:blue)[2],text(fill:blue)[1],text(fill:blue)[2],text(fill:blue)[3],text(fill:blue)[4],
    [L:4],text(fill:blue)[4],text(fill:blue)[3],text(fill:blue)[2],text(fill:blue)[2],text(fill:blue)[2],text(fill:blue)[3],text(fill:blue)[4],
    [E:5],text(fill:blue)[5],text(fill:blue)[4],text(fill:blue)[3],text(fill:blue)[3],text(fill:blue)[3],text(fill:blue)[3],text(fill:blue)[3],
  )
)

Now, we want to not just getthe minimum number of change but also get the changelog of what operation need to be done. 

The changelog can be interpreted as the path from the beginning to the end. We need to recover it. 

To do that when we make our if, we save what transition we used. 

_Note: we there made the algorithm going from $A$ to $B$ but the distance is symetrical._

=== Levenshtein distance between 2 files

Now we can go back to our base problem, 2 files instead of 2 words. 

This is the same thing: a letter become a line of our file. 

The algorihm we made as a complexity of $Omicron(bar.v\Abar.v dot bar.v\Bbar.v)$. It is sufficient for practical use: 
- if both of our file are not that long 

If each file is really big: $bar.v\Abar.v tilde.eq bar.v\Bbar.v tilde.eq 10^6$, our algorithm will not be good enough.

In a real world calculation, in git diff for example, we use additional heuristics to decrease complexity: 
- If we have 2 big files with not to many difference, we arrange just to build the table arround the optimal path and not the whole things. 
- Sometimes it will not give you real optimal solution, we made a trade of between optimality and complexity. 
- The algorithm  work "less" correctly if the files are really different. But usually, we use diff on file that have similarity. 

== Word alignment and text justification 

$
"Text": underbrace(l_0"       "l_(m-1), w_0) "  " underbrace(l_0"          "l_(m'-1), w_1) "  " underbrace(l_0"  "l_(m''-1), w_2) "  " ... "  "  underbrace(l_0"       "l_(m-1), w_(n-1))
$

We know the length of each words. We want to print them on a sheet of width $L$. 

#align(
  center,
  diagram(
    let (c0,c1,c2,c3,ll,lr) = (
      (0,0),(0,5),(3,0),(3,5),(0,4.5),(3,4.5) 
    ),

    edge((0.2,0.5),(0.8,0.5),"|-|",label:text(8pt)[$w_0$],label-side:right),edge((1.1,0.5),(2.1,0.5),"|-|",label:text(8pt)[$w_1$],label-side:right),edge((2.4,0.5),(2.6,0.5),"|-|",label:text(8pt)[$w_2$],label-side:right),

    edge((0.2,1.5),(1.2,1.5),"|-|",label:text(8pt)[$w_3$],label-side:right),edge((1.5,1.5),(2.4,1.5),"|-|",label:text(8pt)[$w_4$],label-side:right),

    edge((0.2,2.5),(1.2,2.5),"|-|",label:text(8pt)[$w_5$],label-side:right),edge((1.5,2.5),(2.7,2.5),"<->",stroke:red),

    edge((0.2,3.5),(2.2,3.5),"|-|",label:text(8pt)[$w_6$],label-side:right),edge((2.4,3.5),(2.6,3.5),"|-|",label:text(8pt)[$w_7$],label-side:right),

    edge(c0,c1),edge(c0,c2),edge(c2,c3),edge(ll,lr,"<->",label:$L$,label-side:right),
  )
)

We have a big gap after word 5. What we want is to justify the text to not have those kind of big gaps. 

#align(
  center,
  diagram(
    let (c0,c1,c2,c3,ll,lr) = (
      (0,0),(0,5),(3,0),(3,5),(0,4.5),(3,4.5) 
    ),

    edge((0.2,0.5),(0.8,0.5),"|-|",label:text(8pt)[$w_0$],label-side:right),edge((1.1,0.5),(2.1,0.5),"|-|",label:text(8pt)[$w_1$],label-side:right),edge((2.4,0.5),(2.8,0.5),"<->",stroke:red),

    edge((0.2,1.5),(0.6,1.5),"|-|",label:text(8pt)[$w_2$],label-side:right),edge((1.2,1.5),(2.2,1.5),"|-|",label:text(8pt)[$w_3$],label-side:right),edge((2.4,1.5),(2.8,1.5),"<->",stroke:red),
    
    edge((1.5-1.3,2.5),(2.4-1.3,2.5),"|-|",label:text(8pt)[$w_4$],label-side:right),edge((1.3,2.5),(2.3,2.5),"|-|",label:text(8pt)[$w_5$],label-side:right),edge((2.4,2.5),(2.8,2.5),"<->",stroke:red),

    edge((0.2,3.5),(2.2,3.5),"|-|",label:text(8pt)[$w_6$],label-side:right),edge((2.4,3.5),(2.6,3.5),"|-|",label:text(8pt)[$w_7$],label-side:right),

    edge(c0,c1),edge(c0,c2),edge(c2,c3),edge(ll,lr,"<->",label:$L$,label-side:right),
  )
)

First we need to define a measurement to know if the text is good. For example, if we call our end gap $x$, we have: $"badness" = x^3$.

Our badness function does not change the code this function need to be found by experimenting. We want to minimize the total badness ($min(sum "badness")$) of our text. 

What we want is to take our word array and split it in segment representing our lines. 

$
underbrace(underbrace(l_0"       "l_(m-1), w_0) "  " underbrace(l_0"          "l_(m'-1), w_1), "line 1") "  " underbrace(underbrace(l_0"  "l_(m''-1), w_2) "  " ..., "line 2") "  " underbrace(... "  "  underbrace(l_0"       "l_(m-1), w_(n-1)), "line 3")
$

Lets define the function computing the badness of a segment. 

If we put words from index $l$ to $r-1$ in a segment then: 

$
"bad"(l,r) = (L - sum_(i=l)^(r-1) w_i)^3
$

If we want to put the gap not in the end of the line but to have all the gap the same between each words. 

We have: 

$
"bad"(l,r) = ((L - sum_(i=l)^(r-1) w_i) / (r-l-1))^3 dot (r - l - 1)
$

Lets solve our problem: 

$
"word array": [w_0,w_1,w_2,w_3,...,underbrace(w_(n-2)\,w_(n-1),"last line")]
$ 

We put those words in the last line and then, we have the same problem without the last segment. Which is a prefix of our words array. 

$
D[i] eq.def min sum "bad" "for" w[0..i-1]
$

```
def word_justification(w)
    D[0] = 0
    for i = 1..n 
        D[i] = +infinity 
        s = 0 
        for k = 1..i 
            s += w[i-k] 
            if s >= L 
                break 
            D[i] = min(D[i], D[i-k]+(L-s)**3)
    return D[n]
```

We have a complexity of #text(fill:red)[$Omicron(n^2)$]. 

Here we only compute the total badness. In an actuall problem, we want to have the actuall answer. The path. We do the same as everytime, go from the end and retrace our step back. 

== Run length encoding (RLE)

Basic RLE: $"AAAB" -> 3"AB"$

RLE we are going to solve: 

$
"AAABAAAB" -> 2(3"AB")
$

Given a string $S$, what is the minimum size of encoded $S$. 

=== Encoding the string $S$

Lets take a look at the first character of the string $S$:
+ either $c_1$ is a letter alone in our encoded string: 
$
S -> c_1(S[1..n-1])
$
+ it is part of a repeting group: 
$
S: underbrace(underline(l_0 ... l_(x-1)) "  "..."  "  underline(l_((K-1)\x) ... l_(K\x-1)), K "times the same group of length" x) "  "..."  " l_(n-1) -> K(S[0..x-1])(S[K\x..n-1])
$ 

In each case, we reduce our problem to a subset of the same problem: 
- In the first one we reduce to $S[1..n-1]$
- In the second one, we reduce to $S[0..x-1] "and" S[K\x..n-1]$

Our state is: 
$
D[l,r] eq.def "minimum emcodding for string" S[l..r-1]
$

Our transition value are: 
+ $1 + D[l+1,r]$
+ $"len"(K) + 2 + D[l,l+x] + D[l+K\x,r]$

We use the 2 previously calculated state to get the new one: 

#align(
  center,
  diagram(
    node-stroke:1pt,
    node-shape:shapes.pill,
    node((-1,-0.5),$l,l+x$), 
    node((-1,0.5),$l+k\x,r$), 
    node((0,0),$l,r$), 

    edge((-1,-0.5),(0,0),"->"),
    edge((-1,0.5),(0,0),"->"),
  )
)

We see there that on the contrary of our previous algorihms, we need to compute our array from the bottom to up. 

And we need to assess that the $K$ repetition of the group string are equal (use a string algorithm that we will see in the Semester 3). 

Again here we compute the minimum value, we need to take the path from the last element to get our encoded string. 
