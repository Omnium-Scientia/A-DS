// This is the template for a complete semester pdf // 

#let semester(
  title: none, 
  subtitle: none, 
  body
) = {
  
  set page(
    paper: "a4", 
    margin: 2cm, 
  )

  set text(
    font: "New Computer Modern",
    size: 12pt, 
  )

  set par(
    justify: true, 
    leading: 0.60em,
    spacing: 1.2em,
    first-line-indent: 20pt,
  ) 

  set heading(
    depth: 4,
    numbering: "1.1"
  )
  
  align(center, text(24pt, title))
  align(center, text(20pt, subtitle))

  outline(
    title: [Summary],
    depth: 2
  )
  
  pagebreak()

  counter(page).update(1)
  
  set page(
    numbering: "1 / 1", 
    number-align: center+bottom,
  )
  
  body
}
