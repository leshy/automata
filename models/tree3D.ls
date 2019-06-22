require! {
  leshdash: { random, sample, map, weighted, times, zip }
  '../index.ls': { CtxState, CtxCanvas }
  '../topologies.ls': { NaiveTopology }
  '../contexts.ls': { CtxNaiveCoords }
  '../transforms.ls': { turtle, randomTurtle, mapper, brownian }
}

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
  if ctx.ctx.size < 0.001 then return []
  ctx.t turtle <<< { dir: mapper(brownian(5)), size: (*0.98), counter: counter, color: rndc } <<< colorBlock, (ctx) ->
    weighted do
      [ 1 / ctx.ctx.size, Branch ]
      [ 1, [ Branch, Branch ] ]

export BranchStart = (ctx) ->
  ret = []
  times 20, -> ret.push Branch
  ret

export class Topo extends NaiveTopology
  Ctx: CtxNaiveCoords

export topology = new Topo().set new CtxState({pos: [0,0,0], dir: [0,0,0], color: 0, speed: 1, size: 0.1, counter: 0}, Branch)


