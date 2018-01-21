require! {
  immutable: { Map, Seq, List, Set }: i
  colors
  util: { inspect }
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignWith, flatten, map, keys, clone,
    { typeCast }: w
  }: _
  
  './base.ls': { Ctx }
}

export class CtxNaive extends Ctx
  applyTransform: (mod) ->
    new @constructor @standardJoin(@data, mod)


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
    
    new @constructor @standardJoin(ctx, mod)    
      <<< normalizeRotation(ctx.r)
      <<< @_move(cvector, mvector, ctx.r, ctx.s)


export class CtxNaiveCoords
    (data) -> @ <<< { loc: [] } <<< (data or {})
    key: -> @data.loc.join('-')
    
    look: (mod) ->
      target = new @constructor @applyTransform { loc: mod }, { loc: @data.loc }
      @topo.get(target)
      
      

