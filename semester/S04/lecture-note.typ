#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *
#show: codly-init.with()

#codly(languages: codly-languages,
        zebra-fill: luma(250), 
        number-format: none, 
      )

#import "../../template/semester.typ": semester

#show: semester.with(
  title: [Semester 4],
  subtitle: [Lecture notes]
)

#include "../../lecture/s04e01.typ"

#pagebreak()

#include "../../lecture/s04e02.typ"

#pagebreak()

#include "../../lecture/s04e03.typ"

#pagebreak()

#include "../../lecture/s04e04.typ"

#pagebreak()

#include "../../lecture/s04e05.typ"

#pagebreak()

#include "../../lecture/s04e06.typ"

#pagebreak()

#include "../../lecture/s04e07.typ"

#pagebreak()

#include "../../lecture/s04e08.typ"

#pagebreak()

#include "../../lecture/s04e09.typ"

#pagebreak()

#include "../../lecture/s04e10.typ"

#pagebreak()

#include "../../lecture/s04e11.typ"

#pagebreak()

#include "../../lecture/s04e12.typ"

#pagebreak()

#include "../../lecture/s04e13.typ"

#pagebreak()

#include "../../lecture/s04e14.typ"
