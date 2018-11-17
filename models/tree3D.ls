require! {
  leshdash: { random, sample, map, weighted, times }
  '../index.ls': { CtxState, CtxCanvas }
  '../topologies.ls': { NaiveTopology }
  '../contexts.ls': { CtxNaiveCoords }
}

modder = 1
mover = (pos, ctx) -> map pos, (c) -> c + random(-modder, modder, true)

colormover = 20

rndc = (color) ->
  newColor = (color or 200) + random(-colormover, colormover)
  if newColor > 255 then newColor = 255
  if newColor < 0 then newColor = 0
  newColor

colorBlock = do
  cb: rndc
  cr: rndc
  cg: rndc

counter = (n) ->
  if n < 2 then n + random(0, 0.4, true) else 0

export Branch = (ctx) ->
  ctx.t { dir: mover, size: (*0.96), counter: counter, color: rndc } <<< colorBlock, (ctx) ->
    weighted do
      [ 2 / ctx.ctx.size, Branch ]
      [ 1, [ Branch, Branch ] ]

export BranchStart = (ctx) ->
  ret = []
  times 20, -> ret.push Branch
  ret

export class Topo extends NaiveTopology
  Ctx: CtxNaiveCoords

export topology = new Topo().set new CtxState({dir: [0,0,0], color: 0, speed: 1, size: 0.1, counter: 0}, Branch)

