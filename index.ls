# abstract automata simulator
#
# arbitrary machines running on arbitrary topologies.
#
# so spaces can be continuous or discrete, have arbitrary number of dimensions, be graph structures, hexagonal grids, etc
# machines can be stohastic or deterministic, implemented as RAM-machines, generative grammars, blind or with perception, etc
#  
# should be able to simulate transformation rule based generation like L-systems, brownian motion etc..
# or stuff that perceves, like CA, boids, etc.
#
# spaces are immutable objects, machines are functions returning other machines potentially with their location transformed
#
# views, storage and controllers as plugins
#

require! {
  immutable: { Map, Seq }: i
  util: { inspect }
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignInWith, flatten, map, keys,
    { typeCast }: w
  }: _
}

export class State
  -> ...
  

export class Ctx
  applyTransform: (transformations={}) -> ...
  inspect: -> "Ctx(" + JSON.stringify({} <<< @) + ")"
  transform: (modifier) ->
    (...states) ~>  
      map flatten(states), (state) ~>
        new CtxState ...switch state@@
          | Function => [ @applyTransform(modifier), state ]
          | CtxState => [ state.ctx.applyTransform(modifier), state.state ]
          
export class CtxState
  inspect: -> "CtxState(" + JSON.stringify(@ctx) + ", " + @state.name + ")"
  (@ctx, @state) -> true        
          
export class Space
  contextClass: Ctx
  
  get: (ctx) -> ...
  
  set: (ctxState) -> ...
  
  states: -> ...
  
  next: ->
    @states!reduce do
      (space, state, ctx) ~>
        
        newStates = state ctx
        if newStates@@ isnt Array then newStates = Array newStates
        
        reduce do
          newStates
          (space, newState) ~>
            space.set switch newState@@
              | Function => new CtxState ctx, newState
              | CtxState => newState
              | _ => throw "xxwat"
          space
            
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


export class CanvasSpace
#  contextClass: CanvasContext
  (data) ->
    if data then @ <<< data
    if not @data then @data = new Map()

  get: (ctx) ->
    @data.get switch ctx?@@
      | @contextClass => @data.get ctx.key()
      | String => @data.get ctx
      |_ => throw new Error "not a context"
        
  set: (ctx, ...states) ->
    ctx = switch ctx?@@
      | @contextClass => ctx.key()
      | String => ctx
      |_ => throw new Error "not a context"
    
    new @constructor do
      data: reduce states, ((data, state) -> data.set loc, state), @data


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

