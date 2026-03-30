-- authors.dhall

{-
    This file hold the authors that have contributed to this repository.

    If you are an author contributing to this repository, please add yourself the follwing way:
    ```
    let nickname-ref
        : T.Author
        = { name = "Your name / pseudo"
          , contact = Some "the way to contact you" | None Text
          , organisation = Some "the organisation you are part of" | None Text
          }
    ```
    and add yourself inside the `{}` after `in`:
    ```
    in { buzzy, nickname-ref }
    ```

    If you are not sure about how to fill this file for yourself, ask for help in your PR.
-}
let T = ./types.dhall

let buzzy
    : T.Author
    = { name = "BuzzY_"
      , contact = Some "contact@buzzybis.com"
      , organisation = None Text
      }

in  { buzzy }
