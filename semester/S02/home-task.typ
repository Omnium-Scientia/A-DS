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
  subtitle: [Home-task solution]
)

#include "../../home_task/s02ht01.typ"

#pagebreak()

#include "../../home_task/s02ht02.typ"

#pagebreak()

#include "../../home_task/s02ht03.typ"

#pagebreak()

#include "../../home_task/s02ht05.typ"

#pagebreak()

#include "../../home_task/s02ht06.typ"

#pagebreak()

#include "../../home_task/s02ht07.typ"

#pagebreak()

#include "../../home_task/s02ht09.typ"

#pagebreak()

#include "../../home_task/s02ht11.typ"
