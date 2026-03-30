-- export.dhall

{-
    This file hold the logic to generate the configuration for all the book files of our courses.
-}
let C = ./courses.dhall in C.adsCourses
