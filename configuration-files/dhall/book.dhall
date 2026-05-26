-- export.dhall

{-
    This file hold the logic to generate the configuration for all the book files of our courses.
-}
let map = https://prelude.dhall-lang.org/List/map
let concat = https://prelude.dhall-lang.org/List/concat
let fold = https://prelude.dhall-lang.org/List/fold
let Natural/equal = https://prelude.dhall-lang.org/Natural/equal

let T = ./types.dhall

let contains
    : List T.Author → T.Author → Bool
    = λ(list : List T.Author) → λ(item : T.Author) →
        fold T.Author list Bool (λ(x : T.Author) → λ(acc : Bool) → acc || Natural/equal x.id item.id) False

let dedup
    : List T.Author → List T.Author
    = λ(list : List T.Author) →
        fold T.Author list (List T.Author) (λ(x : T.Author) → λ(acc : List T.Author) → if contains acc x then acc else acc # [ x ]) ([] : List T.Author)

let toBookCourse
    : T.Course → T.BookCourse
    = λ(c : T.Course) →
        let lectureAuthors = map T.Lecture (List T.Author) (λ(l : T.Lecture) → l.authors) c.content
        let allAuthors = concat T.Author lectureAuthors
        let uniqueAuthors = dedup allAuthors
        let bookLectures = map T.Lecture { file : Text, chapter : Natural, title : Text, subtitle : Optional Text, abstract : Optional Text } (λ(l : T.Lecture) → l.{ file, chapter, title, subtitle, abstract }) c.content
        in  { title = c.title
            , subtitle = c.subtitle
            , abstract = c.abstract
            , authors = uniqueAuthors
            , content = bookLectures
            }

let toBookCourseMap
    : T.CourseMap → T.BookCourseMap
    = λ(m : T.CourseMap) →
        { mapKey = m.mapKey, mapValue = toBookCourse m.mapValue }

let C = ./courses.dhall

in  map T.CourseMap T.BookCourseMap toBookCourseMap C.adsCourses
