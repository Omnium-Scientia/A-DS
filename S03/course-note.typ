#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *
#show: codly-init.with()

#codly(languages: codly-languages,
        zebra-fill: luma(250), 
        number-format: none, 
      )

#import "../source/template/semester.typ": semester

#show: semester.with(
  title: [Semester 3], 
  subtitle: [Course notes]
)

#include "../source/course_note/s03e01.typ"

#pagebreak()

#include "../source/course_note/s03e02.typ"

#pagebreak()

#include "../source/course_note/s03e03.typ"

#pagebreak()

#include "../source/course_note/s03e04.typ"

#pagebreak()

#include "../source/course_note/s03e05.typ"

#pagebreak()

#include "../source/course_note/s03e06.typ"

#pagebreak()

#include "../source/course_note/s03e07.typ"

#pagebreak()

#include "../source/course_note/s03e08.typ"

#pagebreak()

#include "../source/course_note/s03e09.typ"

#pagebreak()

#include "../source/course_note/s03e10.typ"

#pagebreak()

#include "../source/course_note/s03e11.typ"

#pagebreak()

#include "../source/course_note/s03e12.typ"

#pagebreak()

#include "../source/course_note/s03e13.typ"

#pagebreak()

#include "../source/course_note/s03e14.typ"

#pagebreak()

#include "../source/course_note/s03e15.typ"
