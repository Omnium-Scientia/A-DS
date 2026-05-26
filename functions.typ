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

// From https://colorbrewer2.org/#type=diverging&scheme=RdYlBu&n=4
#let c_red = rgb(215,25,28)
#let c_orange = rgb(253,174,97)
#let c_lblue = rgb(171,217,233)
#let c_blue = rgb(44,123,182)
