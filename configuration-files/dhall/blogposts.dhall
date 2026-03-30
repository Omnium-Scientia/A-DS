-- blogposts.dhall

{-
    This file hold the logic to generate the configuration for all the blogposts files of our courses.
-}
let map = https://prelude.dhall-lang.org/List/map

let T = ./types.dhall

let C = ./courses.dhall

let createBlogpostFile
    : T.Lecture → Text
    = λ(l : T.Lecture) →
        ''
        #import "../templates.typ": blogpost

        #show: blogpost.with(
          entry-key: "${l.file}",
        )
        ''

let processCourse
    : T.Course → T.BlogOutput
    = λ(c : T.Course) →
        { title = c.title
        , subtitle = c.subtitle
        , abstract = c.abstract
        , content = map T.Lecture Text createBlogpostFile c.content
        }

let processCourses
    : T.CourseMap → T.BlogMapOutput
    = λ(m : T.CourseMap) →
        { mapKey = m.mapKey, mapValue = processCourse m.mapValue }

in  map T.CourseMap T.BlogMapOutput processCourses C.adsCourses
