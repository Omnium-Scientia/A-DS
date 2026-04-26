-- types.dhall

{-
    This file hold the types for our configuration.
-}
let Author
    : Type
    = { name : Text, contact : Optional Text, organisation : Optional Text }

let Lecture
    : Type
    = { file : Text
      , authors : List Author
      , chapter : Natural
      , title : Text
      , subtitle : Optional Text
      , abstract : Optional Text
      }

let Course
    : Type
    = { title : Text, subtitle : Text, abstract : Text, content : List Lecture }

let BlogOutput
    : Type
    = { title : Text, subtitle : Text, abstract : Text, content : List Text }

let CourseMap
    : Type
    = { mapKey : Text, mapValue : Course }

let BlogMapOutput
    : Type
    = { mapKey : Text, mapValue : BlogOutput }

in  { Author, Lecture, Course, BlogOutput, CourseMap, BlogMapOutput }
