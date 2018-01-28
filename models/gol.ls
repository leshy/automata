require! {
  leshdash: { random, sample, weighted, linlin, linexp, map, flatten, reduce }
  '../index.ls': { DiscreteTopology, CtxState, CtxNaiveCoords }
}

export On = (ctx) ->
#  console.log "ON COUNT", ctx.count(On)
  if ctx.count(On) in [ 2, 3 ]:
    ctx.t {}, (ctx) -> On
  else
    flatten map ctx.neighCoords(), (coords) ->
      ctx.t loc: (-> coords), visible: -1, (ctx) -> Check
      
export Check = (ctx) ->
  ctx.t { visible: 1 }, (ctx) ->
    console.log ctx.data.loc, ctx.count(On)
    if ctx.count(On) == 3
      return [
        On,
        map ctx.neighCoords(), (coords) ->
          if not ctx.look(coords) then ctx.t loc: (-> coords), visible: -1, (ctx) -> Check
      ]


setPoint = (topology, loc) ->
  ctx = new CtxNaiveCoords(visible: 1, loc: loc)
  topology = topology.set new CtxState(ctx, On)
  
  reduce do
    ctx.neighCoords()
    (topo, loc) ->
      if ctx.look(loc) then topo
      else
        topo.set new CtxState(new CtxNaiveCoords(visible: 0, loc: loc), Check)
      
    topology

  
topology = new DiscreteTopology()

# glider
# topology = setPoint(topology, [2, 1])
# topology = setPoint(topology, [1, 0])
# topology = setPoint(topology, [0, 0])
# topology = setPoint(topology, [0, 1])
# topology = setPoint(topology, [0, 2])

topology = setPoint(topology, [-1, 0])
topology = setPoint(topology, [0, 0])
topology = setPoint(topology, [1, 0])


export topology
