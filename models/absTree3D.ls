require! {
  leshdash: { random, sample, map, weighted, times, zip }
  '../index.ls': { CtxState, CtxCanvas }
  '../topologies.ls': { NaiveTopology }
  '../contexts.ls': { CtxNaiveCoords }
}

modder = 1

mapper = (f, value) --> map value, f
brownian = (speed, value) --> value + random(-speed, speed, true)

# # brownian = (pos, ctx) -> map pos, (c) -> c + random(-modder, modder, true)
# mover = (pos, ctx) ->
#   pos

export Branch = (ctx) ->
  ctx.t {
    dir: mapper(brownian(1)),
    pos: (pos, ctx) -> map zip(pos, ctx.get('dir')), (+)
    size: (*0.96)
    }, (ctx) ->
      weighted do
        [ 2 / ctx.ctx.size, Branch ]
        [ 1, [ Branch, Branch ] ]

export BranchStart = (ctx) ->
  ret = []
  times 20, -> ret.push Branch
  ret

export class Topo extends NaiveTopology
  Ctx: CtxNaiveCoords

export topology = new Topo().set new CtxState({dir: [0,0,0], pos: [0,0,0], speed: 1, size: 1}, Branch)

