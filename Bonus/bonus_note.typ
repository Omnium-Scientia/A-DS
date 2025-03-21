#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.7": *
#show: codly-init.with()

#codly(languages: codly-languages,
        zebra-fill: luma(250), 
        number-format: none, 
      )

#import "../source/template/semester.typ": semester

#show: semester.with(
  title: [Bonus], 
  subtitle: [Lecture notes]
)

#include "../source/course_note/b01.typ"

#pagebreak()

#include "../source/course_note/b02.typ"
