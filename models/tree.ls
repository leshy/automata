require! {
  leshdash: { random, sample }
  '../index.ls': { BlindTopology, CtxState, CtxCanvas, Sierpinski }
}

rndc = (color) ->
  newColor = color + random(-10, 10)
  if newColor > 255 then newColor = 255
    
cmod = 30
export Branch = (ctx) ->  
  ctx.t cr: random(-cmod,cmod), cg: random(-cmod,cmod), cb: random(-cmod,cmod), r: random(-60, 60), s: (*0.9), x: 1, ->
    sample [
      [ Branch, Branch ],
      Branch,
    ]

export topology = new BlindTopology().set new CtxState(new CtxCanvas(cr: 255, cg: 255, cb: 255, x: 0, y: 0, s: 1, r: 90), Branch)

