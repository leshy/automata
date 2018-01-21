require! {
  leshdash: { random, sample, weighted, linlin, linexp }
  '../index.ls': { NaiveTopology, CtxState, CtxNaive }
}

rndc = (color) ->
  newColor = (color or 127) + random(-20, 20)
  if newColor > 255 then newColor = 255
  if newColor < 0 then newColor = 0
  newColor

mapper = linexp(4 ,0, 1, 0, 7)
#mapper = linlin(0, 1, 0, 6)
mover = (pos, ctx) ->
  pos + (random(-mapper(1 - ctx.data.size), mapper(1 - ctx.data.size), true))

cmod = 30
move = 0.75

export Start = (ctx) ->
  ctx.t {}, (ctx) ->
    [ DeepBranch,DeepBranch, Branch, Branch ]
    
export Start = (ctx) ->
  ctx.t {}, (ctx) ->
    [ Branch, Branch ]

export DeepBranch = (ctx) ->  
  ctx.t do
  
    cr: 255
    cg: rndc
    cb: rndc
    
    size: (*0.98)
    
    x: mover
    y: mover
    z: mover

    -> weighted do
      [ 4, DeepBranch ]
      [ 1, [ DeepBranch, Branch ] ]

export Branch = (ctx) ->  
  ctx.t do
  
    cr: rndc
    cg: rndc
    cb: rndc
    
    size: (* 0.9)
    
    x: mover
    y: mover
    z: mover

    -> weighted do
      [ 1, [ Branch, Branch ] ]
      [ 4, Branch ]

export topology = new NaiveTopology().set new CtxState(new CtxNaive(x: 0, y: 0, z:0, size: 1), Start)

