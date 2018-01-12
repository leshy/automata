require! {
  immutable: { Map, Seq }: i
  util: { inspect }
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignInWith, flatten, map, keys,
    { typeCast }: w
  }: _
}

# Context
# 
# defines some context (location) for a state within some topology
# implements a transform function that takes wither a plain state or a state within some context (CtxState)
# and returns a state within a new context (CtxState)
export class Ctx
  applyTransform: (transformations={}) -> ...
  inspect: -> "Ctx(" + JSON.stringify({} <<< @) + ")"
  transform: (modifier) ->
    (...states) ~>  
      map flatten(states), (state) ~>
        new CtxState ...switch state@@
          | Function => [ @applyTransform(modifier), state ]
          | CtxState => [ state.ctx.applyTransform(modifier), state.state ]
          
# tuple holding a state within a context
export class CtxState
  inspect: -> "CtxState(" + JSON.stringify(@ctx) + ", " + @state.name + ")"
  (@ctx, @state) ->
    

# Topology holding states within contexts
#
# knows how to iterate, immutable next()
# 
# should potentially implement perception for states,
# and store states and contexts within an efficient data structure depending on perceptions implemented
export class Topology
  get: (ctx) -> ...
  
  set: (ctxState) -> ...
  
  states: -> ...
  
  next: ->
    @states!reduce do
      (topology, state, ctx) ~>
        
        newStates = state ctx
        if newStates@@ isnt Array then newStates = Array newStates
        
        reduce do
          newStates
          (topology, newState) ~>
            topology.set switch newState@@
              | Function => new CtxState ctx, newState
              | CtxState => newState
              | _ => throw "xxwat"
          topology
            
      new @constructor!

  toObject: ->
    @states!reduce do
      (total, state, ctx) -> total <<< {"#{ctx}": state.inspect!}
      {}



radianConstant = Math.PI / 180
radians = (d) -> d * radianConstant

export class CanvasCtx extends Ctx
  (data={}) -> @ <<< { s: 1 } <<< data
  
  _applyVector: (v1, v2, angle, size=1) ->
    x = (v2.x or 0) * size
    y = (v2.y or 0) * size
    r = radians angle
    x2 = (Math.cos(r) * x) - (Math.sin(r) * y)
    y2 = (Math.sin(r) * x) + (Math.cos(r) * y)

    { x: v1.x + x2, y: v1.y + y2 }

  applyTransform: (mod) ->
    ctx = new @constructor @
    
    cvector = ctx{x, y}
    mvector = mod{x, y}
    
    normalizeRotation = (angle) -> r: angle % 360
    
    standardJoin = (target, mod, ctx) ->
      if not target? then return mod
      if not mod? then return target
      if mod@@ is Function then return mod target, ctx
      mod + target

    assignInWith(ctx, mod, standardJoin)
      <<< @_applyVector(cvector, mvector, ctx.r, ctx.s)
      <<< normalizeRotation(ctx.r)

    if ctx.s > 0.9 then ctx else void



CheckLife = (ctx) ->
  if neighbours(ctx).length in [ 2, 3 ] then Life
  
Life = (ctx) ->
  if ctx.neighbours().length in [ 2, 3 ] then Life
  else map ctx.neighbourLocs(), (location) -> ctx.transform location, CheckLife
  
Spiral = (ctx) -> return do
  ctx.set 'circle'
  ctx.transform r: 46, x: 1, s: (* 1.01), Spiral


# 2D context
SierpinskiA = (ctx) ->
  ctx.transform(r:60) do
    SierpinskiB
    ctx.transform(r:60) do
      SierpinskiA
      ctx.transform(r:60) SierpinskiB

SierpinskiB = (ctx) ->
  ctx.transform(r:-60) do
    SierpinskiA
    ctx.transform(r:-60) do
      SierpinskiB
      ctx.transform(r:-60) SierpinskiA

ctx = new CanvasCtx s: 10, r: 0, x: 0, y:0
console.log SierpinskiA ctx



