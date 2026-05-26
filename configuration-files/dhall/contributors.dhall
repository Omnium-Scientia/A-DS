-- contributors.dhall

{-
    This file hold the logic to generate the public contributors configuration without internal IDs.
-}
let T = ./types.dhall

let A = ./authors.dhall

in  { buzzy = A.buzzy.{ name, contact, organisation } }
