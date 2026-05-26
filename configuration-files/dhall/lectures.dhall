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

let s01l02
    : T.Lecture
    = { file = "s01l02"
      , authors = [ A.buzzy ]
      , chapter = 2
      , title = "Data structures, Binary heap, Heap sort"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l03
    : T.Lecture
    = { file = "s01l03"
      , authors = [ A.buzzy ]
      , chapter = 3
      , title = "Quick-sort, Order statistics"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l04
    : T.Lecture
    = { file = "s01l04"
      , authors = [ A.buzzy ]
      , chapter = 4
      , title = "Lower bound for sorting, Radix sort, Sorting networks"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l05
    : T.Lecture
    = { file = "s01l05"
      , authors = [ A.buzzy ]
      , chapter = 5
      , title = "Binary search"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l06
    : T.Lecture
    = { file = "s01l06"
      , authors = [ A.buzzy ]
      , chapter = 6
      , title = "Stacks, Queues, Amortized costs"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l07
    : T.Lecture
    = { file = "s01l07"
      , authors = [ A.buzzy ]
      , chapter = 7
      , title = "Linked list, Pointer machine"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l08
    : T.Lecture
    = { file = "s01l08"
      , authors = [ A.buzzy ]
      , chapter = 8
      , title = "Disjoint sets (Union-Find)"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l09
    : T.Lecture
    = { file = "s01l09"
      , authors = [ A.buzzy ]
      , chapter = 9
      , title = "Fibonacci heap"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l10
    : T.Lecture
    = { file = "s01l10"
      , authors = [ A.buzzy ]
      , chapter = 10
      , title = "Dynamic Programming — PART I"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l11
    : T.Lecture
    = { file = "s01l11"
      , authors = [ A.buzzy ]
      , chapter = 11
      , title = "Dynamic Programming — PART II"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l12
    : T.Lecture
    = { file = "s01l12"
      , authors = [ A.buzzy ]
      , chapter = 12
      , title = "Knapsack"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l13
    : T.Lecture
    = { file = "s01l13"
      , authors = [ A.buzzy ]
      , chapter = 13
      , title = "Dynamic programming on subsets, on profiles"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l14
    : T.Lecture
    = { file = "s01l14"
      , authors = [ A.buzzy ]
      , chapter = 14
      , title = "Hash tables"
      , subtitle = None Text
      , abstract = None Text
      }

let s01l15
    : T.Lecture
    = { file = "s01l15"
      , authors = [ A.buzzy ]
      , chapter = 15
      , title = "Perfect & Cuckoo hasing, Bloom filters"
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

in  { s01l01
    , s01l02
    , s01l03
    , s01l04
    , s01l05
    , s01l06
    , s01l07
    , s01l08
    , s01l09
    , s01l10
    , s01l11
    , s01l12
    , s01l13
    , s01l14
    , s01l15
    , s02l01
    }
