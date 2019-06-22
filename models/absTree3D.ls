require! {
  leshdash: { sample, map, weighted, times, zip }
  '../index.ls': { CtxState, CtxCanvas }
  '../topologies.ls': { NaiveTopology }
  '../contexts.ls': { CtxNaive }
  '../transforms.ls': { randomTurtle }
}

newId = -> Math.floor(Math.random() * 1000)

export Branch = (ctx) ->
  ctx.t {
    speed: (*0.98)
  } <<< randomTurtle, (ctx) ->
      weighted do
        [ 40 / ctx.ctx.size, Branch ]
        [ 1, [
          Branch
          ctx.t { index: newId }, (ctx) -> Branch
        ]]

export SimpleBranch = (ctx) ->
  ctx.t {
    speed: (*0.96)
  } <<< randomTurtle, (ctx) -> [ SimpleBranch ]

export BranchStart = (ctx) ->
  ret = []
  times 20, -> ret.push Branch
  ret

export class Topo extends NaiveTopology
  Ctx: CtxNaive

export topology = new Topo().set new CtxState do
  {dir: [0,0,0], loc: [0,0,0], speed: 1, size: 1, index: 1001},
  Branch

# topo = topology
# times 10, ->
#   console.log topo
#   topo := topo.next()
