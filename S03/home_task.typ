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
  subtitle: [Home task solution]
)

#include "../source/course_note/s03ht01-2.typ"

#pagebreak()

#include "../source/course_note/s03ht03-4.typ"

#pagebreak()

#include "../source/course_note/s03ht05-6.typ"

#pagebreak()

#include "../source/course_note/s03ht07-8.typ"

#pagebreak()

#include "../source/course_note/s03ht09_10-2.typ"
