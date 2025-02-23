#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *
#show: codly-init.with()

#codly(languages: codly-languages,
        zebra-fill: luma(250), 
        number-format: none, 
      )

#import "../source/template/semester.typ": semester

#show: semester.with(
  title: [Semester 1], 
  subtitle: [Course notes]
)

#include "../source/course_note/s01e01.typ"

#pagebreak()

#include "../source/course_note/s01e02.typ"

#pagebreak()

#include "../source/course_note/s01e03.typ"

#pagebreak()

#include "../source/course_note/s01e04.typ"

#pagebreak()

#include "../source/course_note/s01e05.typ"

#pagebreak()

#include "../source/course_note/s01e06.typ"

#pagebreak()

#include "../source/course_note/s01e07.typ"

#pagebreak()

#include "../source/course_note/s01e08.typ"

#pagebreak()

#include "../source/course_note/s01e09.typ"

#pagebreak()

#include "../source/course_note/s01e10.typ"

#pagebreak()

#include "../source/course_note/s01e11.typ"

#pagebreak()

#include "../source/course_note/s01e12.typ"

#pagebreak()

#include "../source/course_note/s01e13.typ"

#pagebreak()

#include "../source/course_note/s01e14.typ"

#pagebreak()

#include "../source/course_note/s01e15.typ"
