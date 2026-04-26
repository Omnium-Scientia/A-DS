#let blogpost(
  entry-key: str,
  body,
) = {
  let date = datetime.today().display()

  // Get parameters from yaml file
  let data = yaml("configuration-files/yaml/lectures.yml")
  let entry = data.at(entry-key)
  if entry == none { panic("Could not find entry " + entry-key + " in the YAML file.") }

  let title = entry.at("title", default: "Untitled")
  let subtitle = entry.at("subtitle", default: none)
  let authors = entry.at("authors", default: ())
  let abstract = entry.at("abstract", default: none)
  let chapter = entry.at("chapter", default: none)

  let lecture = "./raw/" + entry.at("file", default: none) + ".typ"

  // Set document
  set document(
    title: [#title, #subtitle],
    author: authors.map(author => author.name),
    description: [#abstract],
    date: datetime.today(),
  )

  // Set page layout and footer
  set page(
    width: 210mm,
    height: auto,
    margin: (left: 2cm, right: 2cm, top: 1cm, bottom: 3.5cm),
    footer: align(
      center,
      text(font: "Atkinson Hyperlegible Next", size: 9pt)[
        #line(length: 100%)
        #v(-0.2em)
        The source of this document is available freely at #link("https://github.com/Omnium-Scientia/A-DS") under the CC-BY-4.0 license. \
        An implementation of the presented theory is available freely at #link("https://github.com/Omnium-Scientia/A-DS-implementation") under the MIT license. \
        This text may contain errors or make you react, do not hesitate to contact me about it! \
        Thanks for reading (or listening)!
      ],
    ),
  )

  // Typography setup (paragprah, font)
  set par(
    justify: true,
    leading: 0.60em,
    spacing: 1.2em,
    first-line-indent: 0pt,
  )

  set text(font: "STIX Two Text", size: 11pt)
  show math.equation: set text(font: "STIX Two Math")
  show raw: set text(font: "JuliaMono", size: 10pt)

  // Links setup
  show link: it => underline(
    offset: 2.5pt,
    stroke: 1pt + rgb("#555555"),
    it,
  )

  // Headings setup (numbering and style)
  show heading: set text(font: "Atkinson Hyperlegible Next")
  show heading: set text(weight: "bold", fill: rgb("#111111"))
  set heading(
    depth: 4,
    numbering: "1.1",
  )
  show heading: it => {
    if it.numbering == none { return it }
    let levels = counter(heading).at(it.location())
    let num_text = numbering(it.numbering, ..levels)
    block(above: 1em, below: 1em)[
      #num_text --- #it.body
    ]
  }
  show heading.where(level: 1): it => {
    it
    v(0.3em, weak: true)
    line(length: 100%, stroke: 0.50pt + rgb("#18284f"))
    v(0.5em, weak: true)
  }

  // Show title
  align(
    center,
    text(font: "Atkinson Hyperlegible Next", weight: "bold", size: 25pt)[
      #title \ #text(size: 20pt)[#subtitle]],
  )
  v(2em, weak: true)

  // Show authors and date
  align(
    right,
    text(font: "Atkinson Hyperlegible Next", style: "italic", size: 9pt)[
      By #strong(authors.map(a => { if "link" in a { [#a.name] } else { a.name } }).join(", ", last: " and "))
      #h(1fr) Updated on: #date,
    ],
  )
  v(0.5em, weak: true)
  line(length: 100%)
  v(1.5em, weak: true)

  // Table of contents
  show outline.entry: it => {
    show underline: it => it.body
    let custom-inner = [
      #it.body()
      #box(width: 1fr, it.fill)
    ]
    link(it.element.location())[
      #it.indented(it.prefix(), custom-inner)
    ]
  }
  outline(
    title: "Table of Contents",
    depth: 2,
    indent: 1.6em,
  )
  v(2em, weak: true)

  // Content
  [= #title]

  include lecture

  body

  // Bibliography
  bibliography("bib.yml")
}


#let book(
  entry-key: str,
  body,
) = {
  let date = datetime.today().display()

  // Get parameters from yaml file
  let data = yaml("configuration-files/yaml/courses.yml")
  let entry = data.at(entry-key)
  if entry == none { panic("Could not find entry " + entry-key + " in the YAML file.") }

  let title = entry.at("title", default: "Untitled")
  let subtitle = entry.at("subtitle", default: none)
  let abstract = entry.at("abstract", default: none)

  // Set document
  let lectures = entry.at("content", default: none)
  let authors = lectures.map(lecture => lecture.authors).flatten().dedup()
  set document(
    title: [#title, #subtitle],
    author: authors.map(author => author.name),
    description: [#abstract],
    date: datetime.today(),
  )

  // Set page layout
  set page(
    paper: "a4",
    margin: (x: 1.5cm, y: 2cm),
  )

  // Typography setup
  set par(
    justify: true,
    leading: 0.60em,
    spacing: 1.2em,
    first-line-indent: 0pt,
  )

  set text(font: "STIX Two Text", size: 10pt)
  show math.equation: set text(font: "STIX Two Math")
  show raw: set text(font: "JuliaMono", size: 10pt)

  // Links setup
  show link: it => underline(
    offset: 2.5pt,
    stroke: 1pt + rgb("#555555"),
    it,
  )

  // Headings style
  show heading: set text(font: "Atkinson Hyperlegible Next")
  show heading: set text(weight: "bold", fill: rgb("#111111"))
  set heading(
    depth: 4,
    numbering: "1.1",
  )
  show heading: it => {
    if it.numbering == none { return it }
    let levels = counter(heading).at(it.location())
    let num_text = numbering(it.numbering, ..levels)
    let prefix = if it.level == 1 { "Lecture " } else { "" }

    block(above: 1.5em, below: 1em)[
      #prefix#num_text --- #it.body
    ]
  }
  show heading.where(level: 1): it => {
    it
    v(0.3em, weak: true)
    line(length: 100%, stroke: 0.50pt + rgb("#18284f"))
    v(0.5em, weak: true)
  }

  // Show title
  v(8em)
  line(length: 100%, stroke: 1pt + rgb("#111111"))
  v(1em)
  align(center, text(weight: "bold", size: 22pt, font: "Atkinson Hyperlegible Next")[#title \ #subtitle])
  v(1em)
  line(length: 100%, stroke: 1pt + rgb("#111111"))

  // Abstract
  v(1em)
  align(center, text(size: 12pt)[#abstract])
  v(1em)
  line(length: 100%, stroke: 1pt + rgb("#111111"))

  // Date
  align(center + bottom, text(size: 12pt, font: "Atkinson Hyperlegible Next")[
    #date
  ])
  line(length: 100%, stroke: 1pt + rgb("#111111"))


  set page(footer: none)

  // Show authors
  pagebreak()
  align(left, text(font: "Atkinson Hyperlegible Next", size: 12pt)[
    Authors and contributors:
  ])
  v(0.3em, weak: true)
  line(length: 100%, stroke: 1pt + rgb("#111111"))

  let author_block(authors) = {
    let num_cols = calc.min(authors.len(), 3)

    grid(
      columns: (1fr,) * num_cols,
      gutter: 1.5em,
      ..authors.map(author => {
        set align(center)
        block(width: 100%)[
          #text(font: "Atkinson Hyperlegible Next")[#author.name] \
          #if author.organisation != none [
            #text(size: 10pt, font: "Atkinson Hyperlegible Next")[#author.organisation] \
          ]
          #if author.contact != none [
            #text(size: 10pt, fill: rgb("#444444"), font: "Atkinson Hyperlegible Next")[#author.contact]
          ]
        ]
      })
    )
  }
  author_block(authors)
  pagebreak()

  // Infos
  align(left + horizon, text(font: "Atkinson Hyperlegible Next", size: 12pt)[
    This document is part of the *Omnium Scientia* project and its source code is available freely at #link("https://github.com/Omnium-Scientia/A-DS") under the *CC-BY-4.0 license*. \
    It is updated regularly with new information, corrections, and improvements; to find the latest version, please check the repository releases. \

    If you have a comment, an observation, or find an error, please reach out to us via the project GitHub or send a mail to \[contact at buzzybis.com\]. \
    As this project is open to contributions, you are encouraged to propose fixes for observed issues or suggest additional content relevant to a chapter. Contributions are encouraged but shall be justified using logical or mathematical arguments or by referring to existing literature.
  ])
  align(right, line(length: 60%, stroke: 1pt + rgb("#000000")))
  pagebreak()

  // Table of contents
  show outline.entry: it => {
    show underline: it => it.body
    let custom-inner = [
      #it.body()
      #box(width: 1fr, it.fill)
    ]
    link(it.element.location())[
      #it.indented(it.prefix(), custom-inner)
    ]
  }
  outline(
    title: "Table of Contents",
    depth: 2,
    indent: 1.6em,
  )
  pagebreak()

  // Content
  let chapters = (:)
  for lecture in lectures.sorted(key: l => l.chapter) {
    let key = str(lecture.chapter)
    let val = lecture
    let _ = val.remove("chapter", default: none)
    let _ = val.remove("authors", default: none)

    chapters.insert(key, val)
  }

  counter(page).update(1)

  for (chapter, info) in chapters [
    #set page(
      paper: "a4",
      margin: (x: 1.5cm, y: 1.5cm),
      header: [
        #align(left, text(
          font: "Atkinson Hyperlegible Next",
          size: 10pt,
        )[Lecture #chapter: #info.title])
        #v(0.5em, weak: true)
        #line(length: 100%)
      ],
      footer: context [
        #let current = counter(page).get().first()
        #let main_end = counter(page).at(<end-of-main>).first() - 1

        #line(length: 100%)
        #v(0.5em, weak: true)
        #align(left, text(size: 10pt, font: "Atkinson Hyperlegible Next")[#date #h(1fr) #current -- #main_end])
      ],
    )

    = #info.title

    #let inc = "raw/" + info.file + ".typ"
    #include inc
    #pagebreak()
  ]

  let main_content = body + [#metadata(none) <end-of-main>]
  main_content

  // Bibliography
  bibliography("bib.yml")
}
