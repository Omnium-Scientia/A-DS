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
  subtitle: [Home task solution]
)

#include "../source/course_note/s01ht01.typ"

#pagebreak()

#include "../source/course_note/s01ht02.typ"

#pagebreak()

#include "../source/course_note/s01ht03.typ"

#pagebreak()

#include "../source/course_note/s01ht04.typ"

#pagebreak()

#include "../source/course_note/s01ht05.typ"

#pagebreak()

#include "../source/course_note/s01ht06.typ"

#pagebreak()

#include "../source/course_note/s01ht07.typ"

#pagebreak()

#include "../source/course_note/s01ht08.typ"

#pagebreak()

#include "../source/course_note/s01ht09.typ"

#pagebreak()

#include "../source/course_note/s01ht10.typ"

#pagebreak()

#include "../source/course_note/s01ht11.typ"

#pagebreak()

#include "../source/course_note/s01ht12.typ"

#pagebreak()

#include "../source/course_note/s01ht13.typ"

#pagebreak()

#include "../source/course_note/s01ht14.typ"
