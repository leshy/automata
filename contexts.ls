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
    ctx = clone @ctx
    cvector = ctx{x, y}
    mvector = mod{x, y}
    
    normalizeRotation = (angle) -> { r: angle % 360 }
    
    ctx = @standardJoin(ctx, mod)

    ctx
      <<< normalizeRotation(ctx.r)
      <<< @_move(cvector, mvector, ctx.r, ctx.s)


export class CtxNaiveCoords extends Ctx
    key: -> @data.loc.join('-')
  
    applyTransform: (mod) ->
      data = @standardJoin omit(@data, [ 'loc' ]), mod
      <<< { loc: @coordinateTransform(mod.loc) }
        
      new @constructor data, @topo
      
    coordinateTransform: (mod) ->
      target = @data.loc
      if not mod then return target
      if mod@@ is Function then mod(target)
      else map zip(target, mod), ([t, m]) -> t + m
      
    look: (loc, state, verbose=false) ->
      if verbose
        console.log "CHECKING", @coordinateTransform(loc), @topo.get(@coordinateTransform(loc))?state?name
        
      lookState = @topo.get @coordinateTransform(loc)
      if not state then return lookState
      else lookState?state is state
    
    neighCoords: ->
      return [
        [ 1, 1 ]
        [ 1, 0 ]
        [ 1, -1 ]

        [ 0, 1 ]
        [ 0, -1 ]

        [ -1, 1 ]
        [ -1, 0 ]
        [ -1, -1 ] ]
      
    count: (state, verbose=false) ->
      reduce do
        @neighCoords()
        (total, coords) ~>
          if @look(coords, state, verbose) then total + 1 else total
        0

