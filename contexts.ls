require! {
  immutable: { Map, Seq, List, Set }: i
  colors
  util: { inspect }
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignInWith, flatten, map, keys, clone,
    { typeCast }: w
  }: _
}

require! {
  './base.ls': { Ctx }
}

export class CtxNaive extends Ctx

  applyTransform: (mod) ->
    standardJoin = (target, mod, ctx) ~> 
      if not mod? then return target
      if mod@@ is Function then return mod target, @
      if not target? then return mod
      mod + target
    ctx = clone(@data)
    assignInWith(ctx, mod, standardJoin)
    new @constructor ctx

  checkLoc: (loc) ->    
    true


export class Ctx2D extends Ctx
  
  _move: (v1, v2, rotation, scale=1) ->
    radians = (d) -> d * Math.PI / 180

    r = radians rotation
    
    x = (v2.x or 0) * scale
    y = (v2.y or 0) * scale
    
    x2 = (Math.cos(r) * x) - (Math.sin(r) * y)
    y2 = (Math.sin(r) * x) + (Math.cos(r) * y)
    
    { x: v1.x + x2, y: v1.y + y2 }

  applyTransform: (mod) ->
    ctx = clone @data
    
    cvector = ctx{x, y}
    mvector = mod{x, y}
    
    normalizeRotation = (angle) -> r: angle % 360
    
    standardJoin = (target, mod, ctx) ->
      if not mod? then return target
      if mod@@ is Function then return mod target, ctx
      if not target? then return mod
      mod + target
    
    assignInWith(ctx, mod, standardJoin)
      <<< normalizeRotation(ctx.r)
      <<< @_move(cvector, mvector, ctx.r, ctx.s)

    new @constructor ctx

export class CtxCanvas extends Ctx2D
  line: ->
    true

