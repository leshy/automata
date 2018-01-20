require! {
  immutable: { Map, Seq, List, Set }: i
  colors
  util: { inspect }
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignInWith, flatten, map, keys, clone,
    { typeCast }: w
  }: _
}


# Context
# 
# defines some context (location) for a state within some topology
# implements a transform function that takes either a plain state or a state within some context (CtxState)
# and returns a state within a new context (CtxState)
export class Ctx
  applyTransform: (transformations={}) -> ...
  inspect: -> "Ctx(" + JSON.stringify(@data) + ")"  
  t: (modifier, cb) ->
    states = cb newctx = @applyTransform(modifier)
    if states@@ isnt Array then states = [states]
    ret = map flatten(states), (state) ~>
      switch state@@
        | Function => new CtxState(newctx, state)
        | CtxState => state
    ret


# tuple holding a state within a context
export class CtxState
  inspect: -> colors.green("CtxState(") + JSON.stringify(@ctx) + ", " + @state.name + colors.green(")")
  (@ctx, @state) ->
    if @state@@ isnt Function then throw Error "wrong state type"
  next: ->
    return @state(@ctx)
        

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
      (topology, ctxState) ~>
        newStates = ctxState.next!
        
        if newStates@@ isnt Array then newStates = Array newStates

        reduce do
          newStates
          (topology, newState) ~>
            topology.set switch newState@@
              | Function => new CtxState ctx, newState
              | CtxState => newState
              | _ => throw "state returned an invalid object"
          topology
      new @constructor!

  toObject: ->
    @states!reduce do
      (total, state, ctx) -> total <<< {"#{ctx}": state.inspect!}
      {}

export class Ctx2D extends Ctx
  (data={}) -> @data = {s: 1, r: 0, x: 0, y: 0} <<< data
  
  _applyVector: (v1, v2, angle, size=1) ->
    
    radianConstant = Math.PI / 180
    radians = (d) -> d * radianConstant

    r = radians angle
    
    x = (v2.x or 0) * size
    y = (v2.y or 0) * size
    
    x2 = (Math.cos(r) * x) - (Math.sin(r) * y)
    y2 = (Math.sin(r) * x) + (Math.cos(r) * y)
    
    { x: v1.x + x2, y: v1.y + y2 }

  applyTransform: (mod) ->
    ctx = clone @data
    
    cvector = ctx{x, y}
    mvector = mod{x, y}
    
    normalizeRotation = (angle) -> r: angle % 360
    
    standardJoin = (target, mod, ctx) ->
      if not target? then return mod
      if not mod? then return target
      if mod@@ is Function then return mod target, ctx
      mod + target
    
    assignInWith(ctx, mod, standardJoin)
      <<< normalizeRotation(ctx.r)
      <<< @_applyVector(cvector, mvector, ctx.r, ctx.s)

    new @constructor ctx

export class BlindTopology extends Topology
  (data) ->
    if data then @ <<< data
    if not @data then @data = new List()
      
  inspect: ->
    @states()
    .map (.inspect!)
    .join('\n')
  
  states: -> @data
  
  set: (ctxState) ->
    new @constructor data: @data.push ctxState

export class CtxCanvas extends Ctx2D
  line: ->
    true

