require! {
  leshdash: { random, sample, weighted, linlin, linexp, map, flatten, reduce, identity, filter }
  '../index.ls': { DiscreteTopology, CtxState, CtxNaiveCoords }
}

placeChecks = (ctx) -> 
  map ctx.neighCoords(), (coords) -> ctx.t loc: coords, (ctx) -> Check

export On = (ctx) ->
  if ctx.data.loc[0] is 0 and ctx.data.loc[1] is 0
      console.log " ** * **  LOOK RES", ctx.data.loc, ctx.count(On, true)

  if ctx.count(On) in [ 2, 3 ] then [ On ]
#  else placeChecks(ctx)
      
export Check = (ctx) ->
#  if ctx.count(On) == 3 then [ On, placeChecks(ctx) ]
  if ctx.count(On) == 3 then [ On  ]

setPoint = (topology, loc) ->
  ctx = new CtxNaiveCoords(loc: loc)
  reduce do
    ctx.neighCoords()
    (topo, loc) ->
      if ctx.look(loc, On) then topo else topo
#      else topo.set new CtxState(new CtxNaiveCoords(loc: ctx.coordinateTransform(loc)), Check)
      
    topology.set new CtxState(ctx, On)
  
topology = new DiscreteTopology()
topology = setPoint(topology, [2, 1])
topology = setPoint(topology, [1, 0])
topology = setPoint(topology, [0, 0])
topology = setPoint(topology, [0, 1])
topology = setPoint(topology, [0, 2])

export topology
