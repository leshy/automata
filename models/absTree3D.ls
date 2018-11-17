require! {
  leshdash: { sample, map, weighted, times, zip }
  '../index.ls': { CtxState, CtxCanvas }
  '../topologies.ls': { NaiveTopology }
  '../contexts.ls': { CtxNaive }
  '../transforms.ls': { randomTurtle }
}

export Branch = (ctx) ->
  ctx.t {
    speed: (*0.96)
  } <<< randomTurtle, (ctx) ->
      weighted do
        [ 2 / ctx.ctx.size, Branch ]
        [ 1, [ Branch, Branch ] ]


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
  {dir: [0,0,0], loc: [0,0,0], speed: 1, size: 1},
  SimpleBranch

