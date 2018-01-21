require! {
  immutable: { Map, Seq, List, Set }: i
  colors
  util: { inspect }
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignWith, flatten, map, keys, clone, omit,
    { typeCast }: w
  }: _
  
  './base.ls': { Ctx }
}

export class CtxNaive extends Ctx

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


export class CtxNaiveCoords extends Ctx
    key: -> @data.loc.join('-')
  
    applyTransform: (mod) ->
      new @constructor do
        @standardJoin omit(@data, [ 'loc' ]), mod
        <<< { loc: @coordinateTransform(@data.loc, mod.loc) }
      
    coordinateTransform: (target, mod) ->
      if not mod then return target
      map zip(target, mod), ([t, m]) -> t + m
      
    look: (mod) ->
      @topo.get(@coordinateTransform @data.loc, mod)

    neighCoords: -> return
      [ 1, 1 ]
      [ 1, 0 ]
      [ 1, -1 ]
      
      [ 0, 1 ]
      [ 0, -1 ]
      
      [ -1, 1 ]
      [ -1, 0 ]
      [ -1, -1 ]
      
    count: ->
      console.log "CALLING COUNT", @
      reduce do
        @neighCoords()
        (total, coords) ~>
          console.log "LOOKING AT", total, coords
          if @look(coords) then total + 1 else total
        0
          

