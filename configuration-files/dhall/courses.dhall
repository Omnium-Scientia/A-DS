-- lectures.dhall

{-
  This file hold all the lectures of this repository.

  If you are an author contributing to this project, add a new course the following way:
  ```
    let course-ref
        : T.Course
        = { title = "The course title"
          , subtitle = "The course subtitle"
          , abstract =
              ''
              The abstract of your course
              ''
          , content = [ L.s01l01 ] -- the list of the lectures inside your courses.
          }
  ```
  and add your course inside the `{}` after `in`:
  ```
    in { s01l01, course-ref }
  ```

  If you are not sure about how to fill this file for your lecture, ask for help in your PR.
-}
let T = ./types.dhall

let L = ./lectures.dhall

let a-ds-s1
    : T.Course
    = { title = "Algorithms and Data strcutures"
      , subtitle = "Lecture notes — Semester 1"
      , abstract =
          ''
          This semester is about core concepts of algorithms:
          You will learn about simple data structures, algorithms and also techniques to analyze them.
          The concepts you will learn this semester will be used multiple times across the next ones.
          ''
      , content = [ L.s01l01, L.s01l02 ]
      }

let a-ds-s2
    : T.Course
    = { title = "Algorithms and Data structures"
      , subtitle = "Lecture notes — Semester 2"
      , abstract =
          ''
          In this semester, we continue to explore core concepts:
          We will begin with trees, a lot of tree types to do many things,
          after that we will talk about when an algorithm needs external memory
          and finally a chapter on complexity classes.
          ''
      , content = [ L.s02l01 ]
      }

let adsCourses
    : List T.CourseMap
    = [ { mapKey = "a-ds-s1", mapValue = a-ds-s1 }
      , { mapKey = "a-ds-s2", mapValue = a-ds-s2 }
      ]

in  { adsCourses }
