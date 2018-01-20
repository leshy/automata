require! {
  leshdash: { random, sample }
  '../index.ls': { BlindTopology, CtxState, CtxCanvas, Sierpinski }
}

rndc = (color) ->
  newColor = (color or 255) + random(-40, 40)
  if newColor > 255 then newColor = 255
  newColor
    
cmod = 30
export Branch = (ctx) ->  
  ctx.t do
  
    cr: rndc
    cg: rndc
    cb: rndc
    
    r: random(-60, 60)
    s: (*0.9)
    x: 1,

    ->
      sample [
        [ Branch, Branch ],
        Branch,
      ]

export topology = new BlindTopology().set new CtxState(new CtxCanvas(x: 0, y: 0, s: 1, r: 90), Branch)

