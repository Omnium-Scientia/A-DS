#import "@preview/lovelace:0.3.1": * 

#let pseudocode-alg(title: str, body) = {  
  figure(
    kind: "algorithm",
    supplement: smallcaps[Algorithm],
  
    {
      set text(font: "JuliaMono") 
      show math.equation: set text(font: "JuliaMono")
      pseudocode-list(indentation: 1em, hooks: 0.5em, booktabs: true, numbered-title:   smallcaps[#title], body)
    }
  )
}

#let pseudocode-alg-nt(title: str, body) = {  
  figure(
    kind: "algorithm",
    supplement: none,
  
    {
      set text(font: "JuliaMono") 
      show math.equation: set text(font: "JuliaMono")
      pseudocode-list(indentation: 1em, hooks: 0.5em, booktabs: true, title: smallcaps[#title], body)
    }
  )
}
