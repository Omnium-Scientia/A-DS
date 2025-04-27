#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *
#show: codly-init.with()

#codly(languages: codly-languages,
        zebra-fill: luma(250), 
        number-format: none, 
      )

#import "../../template/semester.typ": semester

#show: semester.with(
  title: [Semester 1],
  subtitle: [Lecture notes],
  abstract: [
      This semester is about core concept of algorithms:
    \ You will learn about simple data structures, algorithms and also techniques to analyze them.
    \ The concepts of this semester will be used multiple times across the next ones.
  ],
)

#include "../../lecture/s01e01.typ"

#pagebreak()

#include "../../lecture/s01e02.typ"

#pagebreak()

#include "../../lecture/s01e03.typ"

#pagebreak()

#include "../../lecture/s01e04.typ"

#pagebreak()

#include "../../lecture/s01e05.typ"

#pagebreak()

#include "../../lecture/s01e06.typ"

#pagebreak()

#include "../../lecture/s01e07.typ"

#pagebreak()

#include "../../lecture/s01e08.typ"

#pagebreak()

#include "../../lecture/s01e09.typ"

#pagebreak()

#include "../../lecture/s01e10.typ"

#pagebreak()

#include "../../lecture/s01e11.typ"

#pagebreak()

#include "../../lecture/s01e12.typ"

#pagebreak()

#include "../../lecture/s01e13.typ"

#pagebreak()

#include "../../lecture/s01e14.typ"

#pagebreak()

#include "../../lecture/s01e15.typ"
