#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *
#show: codly-init.with()

#codly(languages: codly-languages,
        zebra-fill: luma(250), 
        number-format: none, 
      )

#import "../../template/semester.typ": semester

#show: semester.with(
  title: [Semester 2],
  subtitle: [Lecture notes]
)

#include "../../lecture/s02e01.typ"

#pagebreak()

#include "../../lecture/s02e02.typ"

#pagebreak()

#include "../../lecture/s02e03.typ"

#pagebreak()

#include "../../lecture/s02e04.typ"

#pagebreak()

#include "../../lecture/s02e05.typ"

#pagebreak()

#include "../../lecture/s02e06.typ"

#pagebreak()

#include "../../lecture/s02e07.typ"

#pagebreak()

#include "../../lecture/s02e08.typ"

#pagebreak()

#include "../../lecture/s02e09.typ"

#pagebreak()

#include "../../lecture/s02e10.typ"

#pagebreak()

#include "../../lecture/s02e11.typ"

#pagebreak()

#include "../../lecture/s02e12.typ"

#pagebreak()

#include "../../lecture/s02e13.typ"

#pagebreak()

#include "../../lecture/s02e14.typ"

#pagebreak()

#include "../../lecture/s02e15.typ"
