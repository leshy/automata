require! {
  leshdash: { random, sample }
  '../index.ls': { CtxState, Ctx2D, NaiveTopology }
}

rndc = (color) ->
  newColor = (color or 255) + random(-40, 40)
  if newColor > 255 then newColor = 255
  newColor
    
cmod = 30

export Branch = (ctx) -> 
  ctx.t do
  
    # cr: rndc
    # cg: rndc
    # cb: rndc
    x: 0.3
    y: 0.3
    r: random(-60, 60)
    s: (*0.9)

    ->
      sample [
        [ Branch, Branch ],
        Branch,
        Branch,
        Branch,
        Branch,
        Branch,
        Branch,
        Branch,
        Branch,
        Branch,
        Branch,
        Branch,
        Branch,
      ]

export class Topo extends NaiveTopology
  Ctx: Ctx2D
  
export topology = new Topo().set(new CtxState(x: 1, y: 1, s: 10, r: 90, Branch)).set(new CtxState(x: 1, y: 1, s: 10, r: 90, Branch)).set(new CtxState(x: 1, y: 1, s: 10, r: 90, Branch))

