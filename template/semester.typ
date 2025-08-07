#let semester(
    title: none, 
    subtitle: none, 
    abstract: none, 
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
        first-line-indent: 0pt,
    ) 

    set heading(
        depth: 4,
        numbering: "1.1 -"
    )

    line(length: 100%)
    
    align(center, text(24pt)[#title: #subtitle])

    line(length: 100%)

    align(center+top, text()[#abstract])
    
    line(length: 100%)  
    line(length: 100%)  
    
    outline(
        title: [Summary],
        depth: 2
    )
    
    pagebreak()

    counter(page).update(1)

    body
}