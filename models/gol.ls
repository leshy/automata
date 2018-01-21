require! {
  leshdash: { random, sample, weighted, linlin, linexp, map }
  '../index.ls': { DiscreteTopology, CtxState, CtxNaiveCoords }
}

export On = (ctx) ->
  if ctx.count() not in [ 2, 3 ]:
    map ctx.neighCoords(), (coords) ->
      ctx.t vector: coords, Check
      
export Check = (ctx) ->
  if ctx.count() is 3 then return
    On,
    map ctx.neighCoords(), (coords) ->
      ctx.t vector: coords, Check

export topology = new DiscreteTopology().set new CtxState(new CtxNaiveCoords(loc: [0, 0]), On)

