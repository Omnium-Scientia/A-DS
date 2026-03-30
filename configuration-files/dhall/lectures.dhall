-- courses.dhall

{-
  This file hold all the lectures of this repository.

  If you are an author contributing to this project, add a new lecture the following way:
  ```
  let lecture-ref
      : T.Lecture
      = { file = "The name of the file containing your lecture, shall be the same as `lecture-ref`"
        , authors = [ A.buzzy ] -- the author list
        , chapter = 1 -- the chapter number
        , title = "Title of your lecture"
        , subtitle = "Subtitle of your lecture" | None Text
        , abstract = "Abstract for your lecture" | None Text
        }
  ```
  and add your lecture inside the `{}` after `in`:
  ```
    in { s01l01, lecture-ref }
  ```

  If you are not sure about how to fill this file for your lecture, ask for help in your PR.
-}
let T = ./types.dhall

let A = ./authors.dhall

let s01l01
    : T.Lecture
    = { file = "s01l01"
      , authors = [ A.buzzy ]
      , chapter = 1
      , title = "Algorithm, Time complexity, Merge sort"
      , subtitle = None Text
      , abstract = None Text
      }

let s02l01
    : T.Lecture
    = { file = "s02l01"
      , authors = [ A.buzzy ]
      , chapter = 1
      , title = "Segment tree"
      , subtitle = Some "Generality"
      , abstract = None Text
      }

in  { s01l01, s02l01 }
