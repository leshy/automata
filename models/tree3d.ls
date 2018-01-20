require! {
  leshdash: { random, sample }
  '../index.ls': { BlindTopology, CtxState, CtxNaive, Sierpinski }
}

rndc = (color) ->
  newColor = (color or 255) + random(-20, 20)
  if newColor > 255 then newColor = 127
  newColor

mover = (pos, ctx) -> pos + (random(-1-ctx.data.size, ctx.data.size + 1, true))
  
            
cmod = 30
move = 0.75
export Branch = (ctx) ->  
  ctx.t do
    cr: rndc
    cg: rndc
    cb: rndc
    
    size: (*0.9)
    
    x: mover
    y: mover
    z: mover

    ->
      sample [
        [ Branch, Branch ],
        Branch,
        Branch,
        Branch,
      ]

export topology = new BlindTopology().set new CtxState(new CtxNaive(x: 0, y: 0, z:0, size: 1), Branch)

