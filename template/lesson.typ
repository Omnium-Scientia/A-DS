#let lesson(
  semester: none, 
  title: none, 
  chapter_number: none, 
  video_link: "", 
  body 
) = {
  let date = datetime.today().display()

  show link: underline
  
  set page(
    header: grid(
      columns: (90%, 10%), 
      row-gutter: 5pt,
      align(left, text()[Semester #semester, Lecture #chapter_number: #title]),
      align(right, date),
      line(length: 100%),
      line(length: 100%),
    ), 
    footer: context [ #grid(
      columns: (90%, 10%), 
      row-gutter: 5pt,
      line(length: 100%),
      line(length: 100%),
      align(left, link(video_link)[Lecture #chapter_number\: video]),
      align(right, counter(page).display(
        "1 -- 1",
        both: true,
      ))
    )],
  )

  body 
}
