#import "@preview/fletcher:0.5.5": *
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../template/lesson.typ": lesson

#show: lesson.with(
  semester: "1", 
  chapter_number: "7", 
  video_link: "https://www.youtube.com/watch?v=16MvK6W1GwU&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=7",
  title: "Linked List, Pointer Machine"
)


= Linked List, Pointer Machine

Until now, we have only used our RAM model. 

In this lecture, we introduce a new computational model: Pointer Machine 

== Pointer Machine 

In this model, all our data is stored in some nodes. 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1.5), (1.5,0), (1.5,1.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,0), (3,1.5), (4.5,0), (4.5,1.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  node((0.75,0.75), [$a = 5$ \ $b = 7$ \ $p = Y$]), 
  node((3.75,0.75), [$a = 9$ \ $b = 12$ \ $p$]),

  node((0.2,-0.2), [X]),
  node((3.2,-0.2), [Y]),

  edge((1.5,1), (2.25,0.75), (2.25,0.5), (3,0.25), "->"),
))

The pointer $p$ can point to nothing, itself... 

Main differences between pointer machine and RAM model: 
- In the PTR Machine model, we do not have arrays. 
- We only have node and each node have a constant number of PTR. 

With those limitations, one may ask why would we use this model? This will be discussed later in detail but sometimes a simpler model is better, for now we want to make a structure that allow us to not use any array. 

== Linked List 

=== Singly linked list 

==== Definition 

We have a number of node, each node contain 1 element of the list and a pointer to the next element of the list. 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let t = 0.5, 

  node((t,t), [#text(fill: red)[data] \ next]), 
  node((t+2,t), [#text(fill: red)[data] \ next]),
  node((t+4,t), [#text(fill: red)[data] \ next]),
  
  node((-0.8,1.5), [first]), 
  edge((-0.8,1.5), (0,0.35), bend: 40deg, "->"),
  edge((1,0.65), (1.5,0.65), (1.5,0.35), (2,0.35), "->"),
  edge((3,0.65), (3.5,0.65), (3.5,0.35), (4,0.35), "->"),
  edge((5,0.65), (5.5,0.65), "->"), 
  node((5.8, 0.65), [null]),
))

==== Iterate over the list 

```
def print(first) 
    x = first
    while x != null 
        print(x)
        x = x.next
```

Complexity: #text(red)[$Omicron(n)$] $->$ #text(blue)[same as array].  

==== Get the $i^"th"$ element

```
def get(i)
    x = first
    j = 0 
    while j < i and x != null 
        x = x.next
    if j == i 
        return x
```

Complexity: #text(red)[$Omicron(n)$] $->$ #text(blue)[slower than array].  

==== Insert element 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,2), (3,3), (4,2), (4,3), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  
  let t = 0.5, 

  node((t,t), [#text(fill: red)[data] \ next]), 
  node((t+2,t), [#text(fill: red)[data] \ next]),
  node((t+4,t), [#text(fill: red)[data] \ next]),
  node((t+3,t+2), [#text(fill: red)[data] \ next]),
  
  node((-0.8,1.5), [first]), 
  edge((-0.8,1.5), (0,0.35), bend: 40deg, "->"),
  edge((1,0.65), (1.5,0.65), (1.5,0.35), (2,0.35), "->"),
  edge((3,0.65), (3.5,0.65), (3.5,0.35), (4,0.35), "->"),
  edge((5,0.65), (5.5,0.65), "->"), 
  node((5.8, 0.65), [null]),

  edge((3.25,0.35),(3.75,0.65), stroke: red), 
  node((2.2,-0.2), text(red)[X]),
  node((4.2,-0.2), text(red)[Y]),
  node((3.2,1.8), text(red)[Z]),
  edge((2.5,1),(3,2.65), corner: left, "->", stroke: red), 
  edge((4.5,1),(4,2.65), corner: right, "<-", stroke: red), 
))

```
def insert_after(x,z)
    y = x.next
    z.next = y
    x.next = z
```

Complexity: #text(red)[$Omicron(1)$] $->$ #text(blue)[faster than array]. 

The only difficulty here is that we need a pointer to $x$. 

==== Remove an element 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (6,0), (6,1), (7,0), (7,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let t = 0.5, 

  node((t,t), [#text(fill: red)[data] \ next]), 
  node((t+2,t), [#text(fill: red)[data] \ next]),
  node((t+4,t), [#text(fill: red)[data] \ next]),
  node((t+6,t), [#text(fill: red)[data] \ next]),
  
  node((-0.8,1.5), [first]), 
  edge((-0.8,1.5), (0,0.35), bend: 40deg, "->"),
  edge((1,0.65), (1.5,0.65), (1.5,0.35), (2,0.35), "->"),
  edge((3,0.65), (3.5,0.65), (3.5,0.35), (4,0.35), "->"),
  edge((5,0.65), (5.5,0.65), (5.5,0.35), (6,0.35), "->"),
  edge((7,0.65), (7.5,0.65), "->"), 
  node((7.8, 0.65), [null]),

  edge((3.25,0.35),(3.75,0.65), stroke: red), 
  edge((5.25,0.35),(5.75,0.65), stroke: red), 
  edge((3.8,-0),(5.2,1), stroke: red), 
  node((4.2,-0.2), text(red)[X]),

  edge((2.5,1),(6.5,1), bend: -20deg, "->", stroke: red)
))

To remove X, we need to have a pointer to the previous element. To ensure that property, we use doubly linked list. 

== Doubly Linked List

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let t = 0.5, 

  node((t,t), [#text(fill: red)[data] \ next \ #text(fill: blue)[prev]]), 
  node((t+2,t), [#text(fill: red)[data] \ next \ #text(fill: blue)[prev]]),
  node((t+4,t), [#text(fill: red)[data] \ next \ #text(fill: blue)[prev]]),
  
  node((-0.8, 0.5), [first]), 
  edge((-0.8,0.5), (0,0.5), "->"),
  node((-0.8, 0.75), text(blue)[null]), 
  edge((-0.8,0.75), (0,0.75), "<-", stroke: blue),
  edge((1,0.5), (2,0.5), "->"),
  edge((3,0.5), (4,0.5), "->"),
  edge((1,0.75), (2,0.75), "<-", stroke: blue),
  edge((3,0.75), (4,0.75), "<-", stroke: blue),
  edge((5,0.5), (5.5,0.5), "->"), 
  node((5.8, 0.5), [null]),
))

We add a second pointer in each node that point to the previous element. 

==== Insert after 

```
def insert_after(x, z) 
    y = x.next
    z.next = y 
    z.prev = x
    x.next = z 
    if y != null 
        y.prev = z
```

Complexity: #text(red)[$Omicron(1)$] $->$ #text(blue)[faster than array].

==== Remove 

```
def remove()
    y = x.prev 
    z = x.next 

    if z != null 
        z.prev = y
    if y != null 
        y.next = z
    if x = first 
        first = z 
```

We can see that even for a simple operation, we have many if-statements. Which is a problem because we need to test all of our if-statements. 

==== Simplify the structure

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (6,0), (6,1), (7,0), (7,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (0,2), (0,3), (1,2), (1,3), 
  ), 
  edge(c1,c2, stroke: blue), edge(c2,c4, stroke: blue), edge(c4,c3, stroke: blue), edge(c3,c1, stroke: blue),

  let (c1,c2,c3,c4) = (
    (6,2), (6,3), (7,2), (7,3), 
  ), 
  edge(c1,c2, stroke: blue), edge(c2,c4, stroke: blue), edge(c4,c3, stroke: blue), edge(c3,c1, stroke: blue),
  
  node((2.5,2.5), [first]), 
  edge((1,2.5), (2.5,2.5), "<-"),
  edge((1,0.33), (2,0.33), "->"),
  edge((3,0.33), (4,0.33), "->"),
  edge((5,0.33), (6,0.33), "->"),
  edge((0.33,1), (0.33,2), "->"),
  edge((6.33,1), (6.33,2), "->"),
  edge((1,0.66), (2,0.66), "<-"),
  edge((3,0.66), (4,0.66), "<-"),
  edge((5,0.66), (6,0.66), "<-"),
  edge((0.66,1), (0.66,2), "<-"),
  edge((6.66,1), (6.66,2), "<-"),
  edge((4.5,2.5), (6,2.5), "->"), 
  node((4.5,2.5), [last]), 
))

We add two elements to the linked list. Which allow us to get rid of our $"ifs"$ because we do not change the added the $"element"^#text(blue)[\*]$ only the ones in the $"middle"^*$. And as we see for the middle elements, the previous and the next pointer are $eq.not$ of null. 

We can simplify the data structure a little more: 
- Instead of adding two elements, we add only one and linked both end to it. 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (6,0), (6,1), (7,0), (7,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,2), (3,3), (4,2), (4,3), 
  ), 
  edge(c1,c2, stroke: blue), edge(c2,c4, stroke: blue), edge(c4,c3, stroke: blue), edge(c3,c1, stroke: blue),
  
  edge((1,0.33), (2,0.33), "->"),
  edge((3,0.33), (4,0.33), "->"),
  edge((5,0.33), (6,0.33), "->"),
  edge((4,2.5), (6.5,1), "<->", bend: -30deg, `prev`),
  edge((1,0.66), (2,0.66), "<-"),
  edge((3,0.66), (4,0.66), "<-"),
  edge((5,0.66), (6,0.66), "<-"),
  edge((0.5,1), (3,2.5), "<->", bend: -30deg, `next`),

  edge((3.5,3.5), (3.5,3), "->"),
  node((3.5,3.5), [list]),
))

==== Concatenate 2 linked list 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,0.5), (0.5,0), (0.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (1,0), (1,0.5), (1.5,0), (1.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,0.5), (2.5,0), (2.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,0), (3,0.5), (3.5,0), (3.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (1.5,1), (1.5,1.5), (2,1), (2,1.5), 
  ), 
  edge(c1,c2, stroke: blue), edge(c2,c4, stroke: blue), edge(c4,c3, stroke: blue), edge(c3,c1, stroke: blue),
  
  edge((0.5,0.17), (1,0.17), "->"),
  edge((1.5,0.17), (2,0.17), "->"),
  edge((2.5,0.17), (3,0.17), "->"),
  edge((2,1.25), (3.25,0.5), "<->", bend: -30deg),
  edge((0.5,0.33), (1,0.33), "<-"),
  edge((1.5,0.33), (2,0.33), "<-"),
  edge((2.5,0.33), (3,0.33), "<-"),
  edge((0.25,0.5), (1.5,1.25), "<->", bend: -30deg),

  edge((1.75,2), (1.75,1.5), "->"),
  node((1.75, 2), [list 1]),



  let (c1,c2,c3,c4) = (
    (4,0), (4,0.5), (4.5,0), (4.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (5,0), (5,0.5), (5.5,0), (5.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (6,0), (6,0.5), (6.5,0), (6.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (7,0), (7,0.5), (7.5,0), (7.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (5.5,1), (5.5,1.5), (6,1), (6,1.5), 
  ), 
  edge(c1,c2, stroke: blue), edge(c2,c4, stroke: blue), edge(c4,c3, stroke: blue), edge(c3,c1, stroke: blue),
  
  edge((4.5,0.17), (5,0.17), "->"),
  edge((5.5,0.17), (6,0.17), "->"),
  edge((6.5,0.17), (7,0.17), "->"),
  edge((6,1.25), (7.25,0.5), "<->", bend: -30deg),
  edge((4.5,0.33), (5,0.33), "<-"),
  edge((5.5,0.33), (6,0.33), "<-"),
  edge((6.5,0.33), (7,0.33), "<-"),
  edge((4.25,0.5), (5.5,1.25), "<->", bend: -30deg),

  edge((5.75,2), (5.75,1.5), "->"),
  node((5.75, 2), [list 2]),

  

  edge((3.5,0.17), (4,0.17), "->", stroke: red),
  edge((3.5,0.33), (4,0.33), "<-", stroke: red),
  edge((2,1.25), (7.25,0.5), "->", bend: -70deg, stroke: red),
  edge((2.5,1), (2.75,1.25), "-", stroke: red),
  edge((6.5,1), (6.75,1.25), "-", stroke: red),
  edge((5,1), (4.75,1.25), "-", stroke: red),
  edge((5.4,0.9), (6.12,1.6), "-", stroke: red),
))

```
def concat(l1, l2)
    l2.next.prev = l1.prev
    l1.prev.next = l2.next
    l1.prev = l2.prev
    l1.prev.next = l1
```

The same goes for the splitting... 

```
def split(l1, x)
    l2 = new Node()
    l2.next = x.next
    l2.prev = l1.prev
    l1.prev = x

    x.next = l1
    l2.next.prev = l2
    l2.prev.next = l2
    
    reutrn l2
```

== Stack 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (6,0), (6,1), (7,0), (7,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  edge((1,0.5), (2,0.5), "<-"),
  edge((3,0.5), (4,0.5), "<-"),
  edge((5,0.5), (6,0.5), "<-"),

  edge((7,0.5), (8,0.5), "<-"),
  node((8,0.5), [top]),
))

A singly linked list is sufficient to implement a stack because the only thing we need is to go from top to the bottom. 

=== Lets implement the stack operation. 

==== Push 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (6,0), (6,1), (7,0), (7,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (8,0), (8,1), (9,0), (9,1), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),

  edge((1,0.5), (2,0.5), "<-"),
  edge((3,0.5), (4,0.5), "<-"),
  edge((5,0.5), (6,0.5), "<-"),
  edge((7,0.5), (8,0.5), "<-", stroke: red),

  edge((6.5,0), (8.5,-1), "<-"),
  edge((8.5,0), (8.5,-1), "<-", stroke:red),
  node((8.5,-1), [top]),
  node((8.2,-0.2), text(red)[X]),
  edge((7.5,-0.2), (7.5,-0.7), "-",stroke:red),
  edge((7,-0.46), (8,-0.46), "-",stroke:red),
))

```
def psuh(x)
    x.nrxt = top 
    top = x
```

==== Pop 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (6,0), (6,1), (7,0), (7,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (8,0), (8,1), (9,0), (9,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  edge((1,0.5), (2,0.5), "<-"),
  edge((3,0.5), (4,0.5), "<-"),
  edge((5,0.5), (6,0.5), "<-"),
  edge((7,0.5), (8,0.5), "<-"),

  edge((6.5,0), (8.5,-1), "<-", stroke:red),
  edge((8.5,0), (8.5,-1), "<-"),
  node((8.5,-1), [top]),
  edge((8.25,-0.5), (8.75,-0.25), "-",stroke:red),
  edge((8.25,-0.25), (8.75,-0.50), "-",stroke:red),
  edge((7.25,0.25), (7.75,0.75), "-",stroke:red),
  edge((8,-0.1), (9,1.1), "-",stroke:red),
))

```
def pop()
    ans = top 
    top = top.next 
    return ans
```

== Queue

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (6,0), (6,1), (7,0), (7,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  edge((1,0.5), (2,0.5), "->"),
  edge((3,0.5), (4,0.5), "->"),
  edge((5,0.5), (6,0.5), "->"),

  edge((7,0.5), (8,0.5), "<-"),
  node((8,0.5), [tail]),
  edge((-1,0.5), (0,0.5), "->"),
  node((-1,0.5), [head]),
))

Again, singly linked list are sufficient here. Since I just need to be able to go from head to tail. The tricky thing here is handling an empty queue. 

Handling empty queue, 2 way to do it: 
- When the queue is empty, both of our pointer are null. 
- we use our the trick from the linked list simplification and add an extra node that serve the purpose of handling the empty queue. 

From we are going to go with the null pointer option. 

=== Add function

==== Empty case 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),

  edge((1,0.5), (2,0.5), "<-",stroke:red),
  node((2,0.5), [tail]),
  edge((-1,0.5), (0,0.5), "->",stroke:red),
  node((-1,0.5), [head]),
))

==== Non-empty case

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (6,0), (6,1), (7,0), (7,1), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),

  edge((1,0.5), (2,0.5), "->"),
  edge((3,0.5), (4,0.5), "->"),
  edge((5,0.5), (6,0.5), "->",stroke:red),

  edge((4.5,0), (6.5,-1), "<-"),
  edge((6.5,0), (6.5,-1), "<-",stroke:red),
  node((6.5,-1), [tail]),
  edge((-1,0.5), (0,0.5), "->"),
  node((-1,0.5), [head]),

  node((6.2,-0.2), text(red)[X]),
  edge((5.5,-0.2), (5.5,-0.7), "-",stroke:red),
  edge((5,-0.46), (6,-0.46), "-",stroke:red),
))

```
def add(x) 
    if head == null 
        head = tail = x
    else 
        tail.next = x
        tail = x
```

=== Remove 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (6,0), (6,1), (7,0), (7,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (-2,0), (-2,1), (-1,0), (-1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  edge((1,0.5), (2,0.5), "->"),
  edge((3,0.5), (4,0.5), "->"),
  edge((5,0.5), (6,0.5), "->"),
  edge((-1,0.5), (0,0.5), "->"),

  edge((7,0.5), (8,0.5), "<-"),
  node((8,0.5), [tail]),
  edge((-1.5,2), (-1.5,1), "->"),
  edge((-1.5,2), (0.5,1), "->",stroke:red),
  node((-1.5,2), [head]),
  edge((-1.25,1.5), (-1.75,1.25), "-",stroke:red),
  edge((-1.25,1.25), (-1.75,1.50), "-",stroke:red),
  edge((-0.75,0.25), (-0.25,0.75), "-",stroke:red),
  edge((-2,-0.1), (-1,1.1), "-",stroke:red),
))

```
def remove()
    ans = tail 
    if head == tail 
        head = tail = null 
    else 
        head = head.next
    return ans 
```

== Why pointer machine? 

Sometime when we use simpler computational model, it is simpler to analyze it. 

It is easier to check what part of the data structure is affected by the algorithm. 

=== Example 

In RAM model, if you access our array, you can change it only by giving indexes. In pointer machine, you are obliged to have a pointer to the node to actually change it. Which make easier to check what element have access to our node. 

For a node, you just need to have a list that contain all the pointer to this node and know at each instant which element has access to it. 

This can reveal to be an important feature, in garbage collection for example. When you create an object with a program, it is linked with other objects. By keeping a list of who is linked to who, you can detect if an object is not accessible anymore (i.e. it is linked to no one) and delete it safely. 

This can also be useful in a case of multiple threads, making concurrent call to the same object and want to be sure that only 1 thread at a time can modify your data.

== Persistent data structures

You have a data structure (any data structure). This data structure as a state, you make an operation on that data structure which changes its state. 

Commonly, you forget the base state and keep track only of the new one. 

In persistent data structure, you want to maintain all the state an be able to access the previous state. 

Why? In some algorithm it can be useful to keep the previous state in mind and have a persistent data structure (we will talk about persistent trees in semester 2). 

To simply fathom this idea, you can think of it as a version control system such as git. 

Almost all data structures that can be done in the pointer machine model can be made persistent without any additional asymptotic costs. 

=== Persistent stack 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,0.5), (0.5,0), (0.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (1,0), (1,0.5), (1.5,0), (1.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,0.5), (2.5,0), (2.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,0), (3,0.5), (3.5,0), (3.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  
  edge((0.5,0.25), (1,0.25), "<-"),
  edge((1.5,0.25), (2,0.25), "<-"),
  edge((2.5,0.25), (3,0.25), "<-"),
  edge((3.25,0), (4.25,-0.5), "<-"),
  node((4.25,-0.5), [top]), 

  let (n1,n2,n3,n4) = (
    (0.25,0.25),(1.25,0.25),(2.25,0.25),(3.25,0.25),
  ),

  node(n1, [A]),node(n2, [B]),node(n3, [C]),node(n4, [D]),
))

#linebreak()

#align(center, diagram(
  node-stroke: 1pt,
  node-shape: shapes.ellipse,
  
  let (v1, v2) = (
    (0,0),(2,0),
  ),

  node(v1, "v.1"), node(v2, "v.2"),
  edge(v1,v2, "->", [push(E)]),
))

#linebreak()

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,0.5), (0.5,0), (0.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (1,0), (1,0.5), (1.5,0), (1.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,0.5), (2.5,0), (2.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,0), (3,0.5), (3.5,0), (3.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,0.5), (4.5,0), (4.5,0.5), 
  ), 
  edge(c1,c2, stroke: red), edge(c2,c4, stroke: red), edge(c4,c3, stroke: red), edge(c3,c1, stroke: red),

  
  edge((0.5,0.25), (1,0.25), "<-"),
  edge((1.5,0.25), (2,0.25), "<-"),
  edge((2.5,0.25), (3,0.25), "<-"),
  edge((3.5,0.25), (4,0.25), "<-", stroke: red),
  edge((3.25,0), (4.25,-0.5), "<-"),
  node((4.25,-0.5), [top 1]),
  edge((4.25,0), (5.25,-0.5), "<-", stroke: red),
  node((5.25,-0.5), text(fill: red)[top 2]),
  
  let (n1,n2,n3,n4,n5) = (
    (0.25,0.25),(1.25,0.25),(2.25,0.25),(3.25,0.25),(4.25,0.25),
  ),

  node(n1, [A]),node(n2, [B]),node(n3, [C]),node(n4, [D]),node(n5, text(fill:red)[E]),
))

#linebreak()

#align(center, diagram(
  node-stroke: 1pt,
  node-shape: shapes.ellipse,
  
  let (v1, v2, v3) = (
    (0,0),(2,0),(4,0),
  ),

  node(v1, "v.1"), node(v2, "v.2"), node(v3, "v.3"),
  edge(v1,v2, "->", [push(E)]), edge(v2,v3, "->", [pop()]),
))

#linebreak()

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,0.5), (0.5,0), (0.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (1,0), (1,0.5), (1.5,0), (1.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,0.5), (2.5,0), (2.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,0), (3,0.5), (3.5,0), (3.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,0.5), (4.5,0), (4.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  
  edge((0.5,0.25), (1,0.25), "<-"),
  edge((1.5,0.25), (2,0.25), "<-"),
  edge((2.5,0.25), (3,0.25), "<-"),
  edge((3.5,0.25), (4,0.25), "<-"),
  edge((3.25,0), (4.25,-0.5), "<-"),
  node((4.25,-0.5), [top 1]),
  edge((4.25,0), (5.25,-0.5), "<-"),
  node((5.25,-0.5), text()[top 2]),
  edge((3.25,0.5), (4.25,1), "<-", stroke: red),
  node((4.25,1), text(fill:red)[top 3]),
  
  let (n1,n2,n3,n4,n5) = (
    (0.25,0.25),(1.25,0.25),(2.25,0.25),(3.25,0.25),(4.25,0.25),
  ),

  node(n1, [A]),node(n2, [B]),node(n3, [C]),node(n4, [D]),node(n5, [E]),
))

We can push $F$ after $v.2$:

#linebreak()

#align(center, diagram(
  node-stroke: 1pt,
  node-shape: shapes.ellipse,
  
  let (v1, v2, v3,v4) = (
    (0,0),(2,0),(4,-0.5),(4,0.5),
  ),

  node(v1, "v.1"), node(v2, "v.2"), node(v3, "v.3"), node(v4, "v.4"),
  edge(v1,v2, "->", [push(E)]), edge(v2,v3, "->", [pop()]), edge(v2,v4, "->", [push(F)], label-side: right),
))

#linebreak()

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,0.5), (0.5,0), (0.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (1,0), (1,0.5), (1.5,0), (1.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,0.5), (2.5,0), (2.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,0), (3,0.5), (3.5,0), (3.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,0.5), (4.5,0), (4.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (5,0), (5,0.5), (5.5,0), (5.5,0.5), 
  ), 
  edge(c1,c2, stroke: red), edge(c2,c4, stroke: red), edge(c4,c3, stroke: red), edge(c3,c1, stroke: red),
  
  edge((0.5,0.25), (1,0.25), "<-"),
  edge((1.5,0.25), (2,0.25), "<-"),
  edge((2.5,0.25), (3,0.25), "<-"),
  edge((3.5,0.25), (4,0.25), "<-"),
  edge((4.5,0.25), (5,0.25), "<-", stroke: red),
  edge((3.25,0), (4.25,-0.5), "<-"),
  node((4.25,-0.5), [top 1]),
  edge((4.25,0), (5.25,-0.5), "<-"),
  node((5.25,-0.5), text()[top 2]),
  edge((3.25,0.5), (4.25,1), "<-"),
  node((4.25,1), text()[top 3]),
  edge((5.25,0.5), (6.25,1), "<-", stroke: red),
  node((6.25,1), text(fill:red)[top 4]),
  
  let (n1,n2,n3,n4,n5,n6) = (
    (0.25,0.25),(1.25,0.25),(2.25,0.25),(3.25,0.25),(4.25,0.25),(5.25,0.25),
  ),

  node(n1, [A]), node(n2, [B]), node(n3, [C]), node(n4, [D]), node(n5, [E]),node(n6, text(fill: red)[F]),
))

Now we push $G$ after $v.3$:

#linebreak()

#align(center, diagram(
  node-stroke: 1pt,
  node-shape: shapes.ellipse,
  
  let (v1, v2, v3, v4, v5) = (
    (0,0),(2,0),(4,-0.5),(4,0.5),(6,-0.5),
  ),

  node(v1, "v.1"), node(v2, "v.2"), node(v3, "v.3"), node(v4, "v.4"), node(v5, "v.5"),
  edge(v1,v2, "->", [push(E)]), edge(v2,v3, "->", [pop()]), edge(v2,v4, "->", [push(F)], label-side: right), edge(v3,v5, "->", [push(G)]),
))

#linebreak()

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,0.5), (0.5,0), (0.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (1,0), (1,0.5), (1.5,0), (1.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,0.5), (2.5,0), (2.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,0), (3,0.5), (3.5,0), (3.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,-0.5), (4,0), (4.5,-0.5), (4.5,0), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (5,-0.5), (5,0), (5.5,-0.5), (5.5,0), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0.5), (4,1), (4.5,0.5), (4.5,1), 
  ),
  edge(c1,c2, stroke: red), edge(c2,c4, stroke: red), edge(c4,c3, stroke: red), edge(c3,c1, stroke: red),
  
  edge((0.5,0.25), (1,0.25), "<-"),
  edge((1.5,0.25), (2,0.25), "<-"),
  edge((2.5,0.25), (3,0.25), "<-"),
  edge((3.5,0.2), (4,-0.25), "<-"),
  edge((4.5,-0.25), (5,-0.25), "<-"),
  edge((3.5,0.3), (4,0.75), "<-", stroke: red),
  edge((3.25,0), (3.25,-1), "<-"),
  node((3.25,-1), [top 1 \ top 3]),
  edge((4.25,-0.5), (5.25,-1), "<-"),
  node((5.25,-1), text()[top 2]),
  edge((5.25,-0.5), (6.25,-1), "<-"),
  node((6.25,-1), [top 4]),
  edge((4.5,0.75), (5.25,0.75), "<-", stroke: red),
  node((5.25,0.75), text(fill:red)[top 5]),
  
  let (n1,n2,n3,n4,n5,n6,n7) = (
    (0.25,0.25),(1.25,0.25),(2.25,0.25),(3.25,0.25),(4.25,-0.25),(5.25,-0.25),(4.25,0.75),
  ),

  node(n1, [A]), node(n2, [B]), node(n3, [C]), node(n4, [D]), node(n5, [E]), node(n6, text()[F]), node(n7, text(fill: red)[G]),
))

To use a version, you need to have the pointer to $"top" v.i$.  You can for example save those pointer in a list.

_Note: You only need to keep track of the version you need not necessarily all of them._

=== Persistent queue

Let's try the idea of the stack for the queue, at first sight, there is not much of a difference. 

But actually, there is a difference. Let's try to use the same technique and see what goes wrong: 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,0.5), (0.5,0), (0.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (1,0), (1,0.5), (1.5,0), (1.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,0.5), (2.5,0), (2.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,0), (3,0.5), (3.5,0), (3.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  
  edge((0.5,0.25), (1,0.25), "->"),
  edge((1.5,0.25), (2,0.25), "->"),
  edge((2.5,0.25), (3,0.25), "->"),
  edge((3.25,0), (4.25,-0.5), "<-"),
  node((4.25,-0.5), [tail]), 
  edge((0.25,0.5), (-0.75,1), "<-"),
  node((-0.75,1), [head]), 

  let (n1,n2,n3,n4) = (
    (0.25,0.25),(1.25,0.25),(2.25,0.25),(3.25,0.25),
  ),

  node(n1, [A]),node(n2, [B]),node(n3, [C]),node(n4, [D]),
))

#linebreak()

#align(center, diagram(
  node-stroke: 1pt,
  node-shape: shapes.ellipse,
  
  let (v1, v2) = (
    (0,0),(2,0),
  ),

  node(v1, "v.1"), node(v2, "v.2"),
  edge(v1,v2, "->", [add(E)]),
))

#linebreak()

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,0.5), (0.5,0), (0.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (1,0), (1,0.5), (1.5,0), (1.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,0.5), (2.5,0), (2.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,0), (3,0.5), (3.5,0), (3.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,0.5), (4.5,0), (4.5,0.5), 
  ), 
  edge(c1,c2, stroke: red), edge(c2,c4, stroke: red), edge(c4,c3, stroke: red), edge(c3,c1, stroke: red),

  
  edge((0.5,0.25), (1,0.25), "->"),
  edge((1.5,0.25), (2,0.25), "->"),
  edge((2.5,0.25), (3,0.25), "->"),
  edge((3.5,0.25), (4,0.25), "->", stroke: red),
  edge((3.25,0), (4.25,-0.5), "<-"),
  node((4.25,-0.5), [tail 1]),
  edge((4.25,0), (5.25,-0.5), "<-", stroke: red),
  node((5.25,-0.5), text(fill: red)[tail 2]),
  edge((0.25,0.5), (-0.75,1), "<-"),
  node((-0.75,-0.5), text(fill: red)[head 2]), 
  edge((0.25,0), (-0.75,-0.5), "<-", stroke: red),
  node((-0.75,1), [head 1]),

  let (n1,n2,n3,n4,n5) = (
    (0.25,0.25),(1.25,0.25),(2.25,0.25),(3.25,0.25),(4.25,0.25),
  ),

  node(n1, [A]),node(n2, [B]),node(n3, [C]),node(n4, [D]),node(n5, text(fill:red)[E]),
))

Until now, everything works the same, let's try to add another element after $v.1$: 

#linebreak()

#align(center, diagram(
  node-stroke: 1pt,
  node-shape: shapes.ellipse,
  
  let (v1, v2, v3) = (
    (0,0),(2,-0.5),(2,0.5)
  ),

  node(v1, "v.1"), node(v2, "v.2"), node(v3, "v.3"),
  edge(v1,v2, "->", [add(E)]), edge(v1,v3, "->", [add(F)], label-side: right),
))

#linebreak()

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,0.5), (0.5,0), (0.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (1,0), (1,0.5), (1.5,0), (1.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,0.5), (2.5,0), (2.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,0), (3,0.5), (3.5,0), (3.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,-0.5), (4,0), (4.5,-0.5), (4.5,0), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0.5), (4,1), (4.5,0.5), (4.5,1), 
  ),
  edge(c1,c2, stroke: red), edge(c2,c4, stroke: red), edge(c4,c3, stroke: red), edge(c3,c1, stroke: red),
  
  edge((0.5,0.25), (1,0.25), "->"),
  edge((1.5,0.25), (2,0.25), "->"),
  edge((2.5,0.25), (3,0.25), "->"),
  edge((3.5,0.2), (4,-0.25), "->"),
  edge((3.5,0.3), (4,0.75), "->", stroke: red),
  edge((3.25,0), (3.25,-1), "<-"),
  node((3.25,-1), [tail 1]),
  edge((4.5,-0.25), (5.25,-0.25), "<-"),
  node((5.25,-0.25), text()[tail 2]),
  edge((4.5,0.75), (5.25,0.75), "<-", stroke: red),
  node((5.25,0.75), text(fill:red)[tail 3]),
  edge((0.25,0.5), (-0.75,1), "<-"),
  node((-0.75,-0.5), [head 2]), 
  edge((0.25,0), (-0.75,-0.5), "<-"),
  node((-0.75,1), [head 1]),
  edge((0,0.25), (-0.75,0.25), "<-", stroke: red),
  node((-0.75,0.25), text(fill: red)[head 3]),
  
  let (n1,n2,n3,n4,n5,n6) = (
    (0.25,0.25),(1.25,0.25),(2.25,0.25),(3.25,0.25),(4.25,-0.25),(4.25,0.75),
  ),

  node(n1, [A]), node(n2, [B]), node(n3, [C]), node(n4, [D]), node(n5, [E]), node(n6, text(fill: red)[F]),
))

And from mow we have a problem, which is that we cannot have multiple value for $D."next"$. This is why we cannot use the same technique to create our persistent queue structure than for our persistent stack. 

There are various way to solve this problem: 
- One of the easiest is to build queue on top of stacks. In the previous lecture, we talk about making queue out of 2 stacks @2-stack. 

  Let's use that: 
  - You can take 2 persistent stack and it will solve the problem.

  But it will be slow because our queue made of 2 stacks as a constant amortized time complexity only and when you have a constant amortized time complexity, you cannot just make a persistent data structure of constant amortized time complexity.

  Indeed, for example if you are at a version $v.i$ and you want to make an operation: 

  #linebreak()
  
  #align(center, diagram(
    node-stroke: 1pt,
    node-shape: shapes.pill,
    
    let (v0, v1, v2) = (
      (-1,0),(0,0),(3,0),
    ),
  
    node(v1, [$v.i$]), node(v2, [$v.(i+1)$]),
    edge(v0,v1, "->"), edge(v1,v2, "->", [long operation]),
  ))
  
  #linebreak()

  Normally our long operation is compensated by a decrease of $phi.alt$. But in persistent data structure, you can go back to $v.i$ and do as many long operations as we want. 

  #linebreak()
  
  #align(center, diagram(
    node-stroke: 1pt,
    node-shape: shapes.pill,
    
    let (v0, v1, v2, v3) = (
      (-1,0),(0,0),(3,-0.5),(3,0.5)
    ),
  
    node(v1, [$v.i$]), node(v2, [$v.(i+1)$]), node(v3, [$v.(i+k)$]),
    edge(v0,v1, "->"), edge(v1,v2, "->", [long operation]), edge(v1,v3, "->", [long operation], label-side: right),
    node((3,0), $colon.tri.op$, stroke: 0pt)
  ))
  
  #linebreak()

  Hence the amortized time cannot be compensated by $phi.alt$. 

  The way to solve this problem is to make queue out of stacks with a real constant complexity. // Add link to 6 stacks queue when done. 

=== Partially persistent data structure

A data structure is said to be partially persistent when you can access to all the older states but make operations only on the last version. We have a linear ordering of our versions.

==== Partially persistent linked lists

The authorized operations are: 
- $"add_after"(x,y)$
- $"remove"(x)$
- $"iterate"()$

===== Add after

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (4,0), (4,1), (5,0), (5,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (6,0), (6,1), (7,0), (7,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  
  edge((1,0.33), (2,0.33), "->"),
  edge((3,0.33), (4,0.33), "->"),
  edge((5,0.33), (6,0.33), "->"),
  edge((1,0.66), (2,0.66), "<-"),
  edge((3,0.66), (4,0.66), "<-"),
  edge((5,0.66), (6,0.66), "<-"),

  edge((7,0.33), (8,0.33), "--"),
  edge((7,0.66), (8,0.66), "<--"),
  edge((-1,0.33), (0,0.33), "-->"),
  edge((-1,0.66), (0,0.66), "--"),

  let (n1,n2) = (
    (2.25,0.25),(4.25,0.25),
  ),

  node(n1, $X$),node(n2, $Z$)
))

#linebreak()

#align(center, diagram(
  node-stroke: 1pt,
  node-shape: shapes.pill,
  
  let (v0, v1, v2) = (
    (-1,0),(0,0),(3,0),
  ),

  node(v1, $i$), node(v2, $(i+1)$),
  edge(v0,v1, "-->"), edge(v1,v2, "->", [$"add_after"(X,Y)$]),
))

#linebreak()

After the adding operation, we want to be able to access both version $i$ and $i+1$. In order to achieve that we are going to maintain 2 version of our nodes $X$ and $Y$. 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1), (1,0), (1,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (2,0), (2,1), (3,0), (3,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (5,0), (5,1), (6,0), (6,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (7,0), (7,1), (8,0), (8,1), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3.5,2), (3.5,3), (4.5,2), (4.5,3), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),

  let (c1,c2,c3,c4) = (
    (2,2), (2,3), (3,2), (3,3), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),

  let (c1,c2,c3,c4) = (
    (5,2), (5,3), (6,2), (6,3), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),
  
  edge((1,0.33), (2,0.33), "->"),
  edge((3,0.33), (5,0.33), "->"),
  edge((6,0.33), (7,0.33), "->"),
  edge((1,0.66), (2,0.66), "<-"),
  edge((3,0.66), (5,0.66), "<-"),
  edge((6,0.66), (7,0.66), "<-"),

  edge((8,0.33), (9,0.33), "--"),
  edge((8,0.66), (9,0.66), "<--"),
  edge((-1,0.33), (0,0.33), "-->"),
  edge((-1,0.66), (0,0.66), "--"),

  let (n1,n2,n3,n4,n5) = (
    (2.25,0.25),(5.25,0.25),(3.75,2.25),(2.25,2.25),(5.25,2.25)
  ),

  node(n1, $X$),node(n2, $Z$),node(n3, text(fill:red)[$Y$]),node(n4, text(fill:red)[$X'$]),node(n5, text(fill:red)[$Z'$]),

  let (c1,c2,c3,c4) = (
    (1.75,-0.25), (1.75,3.25), (3.25,-0.25), (3.25,3.25), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),
  
  let (c1,c2,c3,c4) = (
    (4.75,-0.25), (4.75,3.25), (6.25,-0.25), (6.25,3.25), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),

  edge((3,2.33), (3.5,2.33), "->",stroke:red),
  edge((3,2.66), (3.5,2.66), "<-",stroke:red),
  edge((4.5,2.33), (5,2.33), "->",stroke:red),
  edge((4.5,2.66), (5,2.66), "<-",stroke:red),
))

The idea is to go through $X,Z$ while iterating version $i$ and $X',Y,Z'$ while iterating version $i+1$. 

How to check what version of element $X$ is to use when we go along the list? 
- We maintain the limit number version (i.e. if version $>= 6$, we go through $X'$ else we go though $X$.)

We do this for all the node that have multiple version. 

How to apply this idea in a real pointer machine? 
- With a big $X$ node: 
  
#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,2.6), (1.5,0), (1.5,2.6), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  node((0.25,-0.25), $X$),

  node((0.75,0.5), [data 1 \ prev 1 \ next 1]),
  node((0.75,1.5), [data 2 \ prev 2 \ next 2]),
  node((0.75,2.25), [version]),
))

#pagebreak()

- With 2 $X$ nodes and a version node: 

#align(center, diagram(
  let (c1,c2,c3,c4) = (
    (0,0), (0,1.5), (1.5,0), (1.5,1.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,-1.5), (3,0), (4.5,-1.5), (4.5,0), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  let (c1,c2,c3,c4) = (
    (3,1.5), (3,3), (4.5,1.5), (4.5,3), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),

  node((0.75,0.75), [Version]),
  node((3.75,-0.75), $X$),
  node((3.75,2.25), $X'$),

  edge((1.5,0.5), (3,-0.75), "->"),
  edge((1.5,1), (3,2.25), "->"),
))

We can actually do that because we will never have more than 2 versions of a node. If so we would have a list of node version, but it would be impossible to find the good version in $Omicron(1)$ ($Omicron(log n)$ being the best with balanced binary tree). 

But if we add a new node between $Y$ and $Z$ in our example we will need a third version of $Z$. Therefore, to add a node $Y$ between $X$ and $Z$, we will do the following: 

- if $X$ have only 1 version, we create a second version for $X$
- else
  - we create a new node $X'$

We repeat this process until we reach a node that only have 1 version, and we do the same for node $Z$ but for the element after. 

If we reach an end, we add a version to each node. 

This gives us the following result: 

#align(center, diagram(
  spacing: 5em,
  
  let (c1,c2,c3,c4) = (
    (0,0), (0,0.5), (0.5,0), (0.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  let (c1,c2,c3,c4) = (
    (0,-1), (0,-0.5), (0.5,-1), (0.5,-0.5), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),
  let (c1,c2,c3,c4) = (
    (-0.125,-1.125), (-0.125,0.625), (0.625,-1.125), (0.625,0.625), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),

  
  let (c1,c2,c3,c4) = (
    (1,0), (1,0.5), (1.5,0), (1.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  let (c1,c2,c3,c4) = (
    (1,1), (1,1.5), (1.5,1), (1.5,1.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  let (c1,c2,c3,c4) = (
    (0.875,-0.125), (0.875,1.625), (1.625,-0.125), (1.625,1.625), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  
  
  let (c1,c2,c3,c4) = (
    (2,0), (2,0.5), (2.5,0), (2.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  let (c1,c2,c3,c4) = (
    (2,1), (2,1.5), (2.5,1), (2.5,1.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  let (c1,c2,c3,c4) = (
    (1.875,-0.125), (1.875,1.625), (2.625,-0.125), (2.625,1.625), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  
  
  edge((-0.5,0.17),(0,0.17), "->"),
  edge((0.5,0.17), (1,0.17), "-->"),
  edge((1.5,0.17), (2,0.17), "->"),

  edge((-0.5,0.33), (0,0.33), "<-"),
  edge((0.5,0.33), (1,0.33), "<--"),
  edge((1.5,0.33), (2,0.33), "<-"),

  node((2.25,0.25), text(7pt)[$X$]),




  let (c1,c2,c3,c4) = (
    (0+5.5,0), (0+5.5,0.5), (0.5+5.5,0), (0.5+5.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  let (c1,c2,c3,c4) = (
    (0+5.5,-1), (0+5.5,-0.5), (0.5+5.5,-1), (0.5+5.5,-0.5), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),
  let (c1,c2,c3,c4) = (
    (-0.125+5.5,-1.125), (-0.125+5.5,0.625), (0.625+5.5,-1.125), (0.625+5.5,0.625), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),

  
  let (c1,c2,c3,c4) = (
    (1+3.5,0), (1+3.5,0.5), (1.5+3.5,0), (1.5+3.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  let (c1,c2,c3,c4) = (
    (1+3.5,1), (1+3.5,1.5), (1.5+3.5,1), (1.5+3.5,1.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  let (c1,c2,c3,c4) = (
    (0.875+3.5,-0.125), (0.875+3.5,1.625), (1.625+3.5,-0.125), (1.625+3.5,1.625), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  
  
  let (c1,c2,c3,c4) = (
    (2+1.5,0), (2+1.5,0.5), (2.5+1.5,0), (2.5+1.5,0.5), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  let (c1,c2,c3,c4) = (
    (2+1.5,1), (2+1.5,1.5), (2.5+1.5,1), (2.5+1.5,1.5), 
  ),  
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  let (c1,c2,c3,c4) = (
    (1.875+1.5,-0.125), (1.875+1.5,1.625), (2.625+1.5,-0.125), (2.625+1.5,1.625), 
  ), 
  edge(c1,c2), edge(c2,c4), edge(c4,c3), edge(c3,c1),
  
  
  edge((-0.5+6.5,0.17),(0+6.5,0.17), "->"),
  edge((0.5+4.5,0.17), (1+4.5,0.17), "-->"),
  edge((1.5+2.5,0.17), (2+2.5,0.17), "->"),

  edge((-0.5+6.5,0.33), (0+6.5,0.33), "<-"),
  edge((0.5+4.5,0.33), (1+4.5,0.33), "<--"),
  edge((1.5+2.5,0.33), (2+2.5,0.33), "<-"),

  node((3.75,0.25), text(7pt)[$Z$]),




  edge((2.5,0.17), (3.5,0.17), "->"),
  edge((2.5,0.33), (3.5,0.33), "<-"),



  let (c1,c2,c3,c4) = (
    (1,0-2), (1,0.5-2), (1.5,0-2), (1.5,0.5-2), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),
  
  
  let (c1,c2,c3,c4) = (
    (2,0-2), (2,0.5-2), (2.5,0-2), (2.5,0.5-2), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),
  
  
  let (c1,c2,c3,c4) = (
    (1+3.5,0-2), (1+3.5,0.5-2), (1.5+3.5,0-2), (1.5+3.5,0.5-2), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),
  
  
  let (c1,c2,c3,c4) = (
    (2+1.5,0-2), (2+1.5,0.5-2), (2.5+1.5,0-2), (2.5+1.5,0.5-2), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),

  let (c1,c2,c3,c4) = (
    (2+0.75,0-2), (2+0.75,0.5-2), (2.5+0.75,0-2), (2.5+0.75,0.5-2), 
  ), 
  edge(c1,c2,stroke:red), edge(c2,c4,stroke:red), edge(c4,c3,stroke:red), edge(c3,c1,stroke:red),

  
  node((2.25,0.25-2), text(7pt, fill:red)[$X'$]),
  node((3,0.25-2), text(7pt, fill:red)[$Y$]),
  node((3.75,0.25-2), text(7pt, fill:red)[$Z'$]),


  edge((0.25,0.25-1.25), (1,0.25-2), "->", stroke:red),
  edge((1.5,0.17-2), (2,0.17-2), "->", stroke:red),

  edge((0.5,-0.75), (1.25,-1.5), "<-", stroke:red),
  edge((1.5,0.33-2), (2,0.33-2), "<-", stroke:red),


  edge((0.5+4.5,0.25-2), (1+4.75,0.25-1.25), "->", stroke:red),
  edge((1.5+2.5,0.17-2), (2+2.5,0.17-2), "->", stroke:red),

  edge((0.5+4.25,-1.5), (1+4.5,-0.75), "<-", stroke:red),
  edge((1.5+2.5,0.33-2), (2+2.5,0.33-2), "<-", stroke:red),


  edge((2.5,0.17-2), (2.75,0.17-2), "->", stroke:red),
  edge((3.25,0.33-2), (3.5,0.33-2), "<-", stroke:red),
  
  edge((3.25,0.17-2), (3.5,0.17-2), "->", stroke:red),
  edge((2.5,0.33-2), (2.75,0.33-2), "<-", stroke:red),
))

#pagebreak()

*Time complexity:*

Obviously, in a case where all our node have two version: $T("add_after") = Omicron(n)$. 

But lets prove that since our linked list is partially persistent: $tilde(T)("add_after") = Omicron(1)$. 

$phi.alt$ definition:
- Our long operation is making a new node when one has already 2 versions. 
- we need our $phi.alt$ to decrease when we are doing our long operation. 

$phi.alt = $ number of fat nodes (nodes with 2 versions)

If you are making $k$ copy: 
- $T = k, Delta phi.alt = -k + 2$ ($+2$ for the nodes on the left and the right). 

We then have: $ tilde(T) = 2 = Omicron(1) $
