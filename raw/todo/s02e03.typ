#import "@preview/fletcher:0.5.5": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *

#import "../../template/lecture.typ": lesson

#show: lesson.with(
  semester: "2",
  chapter_number: "3",
  video_link: "https://www.youtube.com/watch?v=Ti_U3Q_G7yM&list=PLrS21S1jm43igE57Ye_edwds_iL7ZOAG4&index=20&pp=iAQB",
  title: "Fenwick tree, Sparse table",
)


= Fenwick tree, Sparse table

Given an array $a$, we want to answer two types of queries:
- The first one change change an element of the array.
- Second one is making an operation on a segment of the array.

For the first thinking, let's chose:
- `inc(i,v)` $eq.def a[i] += v$
- `sum(l,r)` $eq.def sum_(i=l)^(r-1) a[i]$
as our operations. Goal here is to make both those operations running in $Omicron(log n)$.

This might seems the same as the segment tree from the two previous lectures. So why we would have to make an other structure working the same? \
Fenwick tree are actually better in multiple ways:
- Complexity: same asymptotic behaviour but better constant factors.
- Better memory usage.

Those two reasons motive our learning of this data structure.

== Implementation 


