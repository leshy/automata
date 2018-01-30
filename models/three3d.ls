require! {
  leshdash: { random, sample, map, weighted, times }
  '../index.ls': { CtxState, CtxCanvas, Sierpinski }
  '../topologies.ls': { NaiveTopology }
  '../contexts.ls': { Ctx3DTurtle }
}

modder = 1
mover = (pos, ctx) -> map pos, (c) -> c + random(-modder, modder, true)

colormover = 10
rndc = (color) ->
  newColor = (color or 127) + random(-colormover, colormover)
  if newColor > 255 then newColor = 255
  if newColor < 0 then newColor = 0
  newColor

rndcBlock = do
  cr: rndc
  cg: rndc
  cb: 255

export Branch = (ctx) ->  
  ctx.t { dir: mover, size: (*0.96) } <<< rndcBlock, (ctx) ->
    weighted do
      [ 2 / ctx.ctx.size, Branch ]
      [ 1, [ Branch, Branch ] ]

export BranchStart = (ctx) ->
  ret = []
  times 20, -> ret.push Branch
  ret

export class Topo extends NaiveTopology
  Ctx: Ctx3DTurtle

export topology = new Topo().set new CtxState({loc: [0,0,0], dir: [0,0,0], speed: 1, size: 0.1}, BranchStart)

