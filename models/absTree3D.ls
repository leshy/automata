require! {
  leshdash: { random, sample, map, weighted, times, zip }
  '../index.ls': { CtxState, CtxCanvas }
  '../topologies.ls': { NaiveTopology }
  '../contexts.ls': { CtxNaive }
  '../transforms.ls': { turtle }
}

mapper = (f, value) --> map value, f
brownian = (speed, value) --> value + random(-speed, speed, true)

#console.log turtle.loc([0,0,0],{ ctx: { dir: [1,0,0], speed: 2}})

export Branch = (ctx) ->
  ctx.t {
    dir: mapper(brownian(1)),
    speed: (*0.96)
  } <<< turtle, (ctx) ->
      weighted do
        [ 2 / ctx.ctx.size, Branch ]
        [ 1, [ Branch, Branch ] ]

export BranchStart = (ctx) ->
  ret = []
  times 20, -> ret.push Branch
  ret

export class Topo extends NaiveTopology
  Ctx: CtxNaive

export topology = new Topo().set new CtxState do
  {dir: [0,0,0], loc: [0,0,0], speed: 1, size: 1},
  Branch


