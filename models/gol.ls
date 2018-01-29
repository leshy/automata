require! {
  leshdash: { random, sample, weighted, linlin, linexp, map, flatten, reduce, identity, filter }
  '../index.ls': { DiscreteTopology, CtxState }
  '../contexts.ls': { CtxNaiveCoords }
}

colormover = 10

rndc = (color) ->
  newColor = (color or 127) + random(-colormover, colormover)
  if newColor > 255 then newColor = 255
  if newColor < 0 then newColor = 0
  newColor

rndcBlock = do
  cr: rndc
  cg: rndc
  cb: rndc

placeChecks = (ctx) ->
  map ctx.neighCoords(), (coords) ->
    if not ctx.lookFuture(coords)
      ctx.t do
        { loc: coords } <<< rndcBlock
        (ctx) -> Check

export On = (ctx) ->
  if ctx.count(On) in [ 2, 3 ] then ctx.t rndcBlock, (ctx) -> [ On ]
  else placeChecks(ctx)
      
export Check = (ctx) ->
  if ctx.count(On) == 3 then [ On, ...placeChecks(ctx) ]

setPoint = (topology, loc) ->
  ctx = new CtxNaiveCoords({ loc: loc }, topology)
  reduce do
    ctx.neighCoords()
    (topo, loc) ->
      if ctx.look(loc, On) then topo
      else topo.set new CtxState(cr: 0, cb: 200, cg: 0, loc: ctx.coordinateTransform(loc), Check)
        
    topology.set new CtxState(ctx.ctx, On)

export class Topo extends DiscreteTopology
  Ctx: CtxNaiveCoords
  
topology = new Topo()

# http://wiki.secretgeek.net/starting-patterns-gol

# # glider
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
