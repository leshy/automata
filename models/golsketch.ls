require! {
  leshdash: { random, sample, weighted, linlin, linexp, map, flatten, reduce, identity, filter }
  '../index.ls': { DiscreteTopology, CtxState }
  '../contexts.ls': { CtxNaiveCoords }
}

placeChecks = (ctx) ->
  map ctx.neighCoords(), (coords) ->
    if not ctx.lookFuture(coords)
      ctx.t loc: coords, (ctx) ->
        Check

export On = (ctx) ->
#  if ctx.ctx.loc[0] is 0 and ctx.ctx.loc[1] is 0
#  console.log " ** * **  LOOK RES", ctx.ctx.loc, ctx.count(On, true)
  if ctx.count(On) in [ 2, 3 ] then [ On ]
  else placeChecks(ctx)
      
export Check = (ctx) ->
  if ctx.count(On) == 3 then [ On, ...placeChecks(ctx) ]
#  if ctx.count(On) == 3 then [ On  ]

setPoint = (topology, loc) ->
  ctx = new CtxNaiveCoords({ loc: loc }, topology)
  reduce do
    ctx.neighCoords()
    (topo, loc) ->
      if ctx.look(loc, On) then topo
      else topo.set new CtxState(loc: ctx.coordinateTransform(loc), Check)
        
    topology.set new CtxState(ctx.ctx, On)

export class Topo extends DiscreteTopology
  Ctx: CtxNaiveCoords
  
topology = new Topo()

# http://wiki.secretgeek.net/starting-patterns-gol

# glider
# topology = setPoint(topology, [2, 1])
# topology = setPoint(topology, [1, 0])
# topology = setPoint(topology, [0, 0])
# topology = setPoint(topology, [0, 1])
# topology = setPoint(topology, [0, 2])


# R-Pentomino
topology = setPoint(topology, [0, -1])
topology = setPoint(topology, [0, 0])
topology = setPoint(topology, [-1, 0])
topology = setPoint(topology, [0, 1])
topology = setPoint(topology, [1, 1])

export topology
