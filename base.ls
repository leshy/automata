require! {
  immutable: { Map, Seq, List, Set }: i
  colors
  util: { inspect }
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignWith, flatten, map, keys, clone,
    { typeCast }: w
  }: _
}


# Context
# 
# defines some context (location) for a state within some topology
# implements a transform function that takes either a plain state or a state within some context (CtxState)
# and returns a state within a new context (CtxState)
export class Ctx
  (data={}) ->
    if not @data then @data = data

  standardJoin: (target, mod) ->
    assignWith clone(target), mod, (target, mod, bla, blu) ~>
      if not mod? then return target
      if mod@@ is Function then return mod target, @
      if not target? then return mod
      mod + target
  
  applyTransform: (mod) ->
    new @constructor @standardJoin(@data, mod)
    
  inspect: -> "Ctx(" + JSON.stringify(@data) + ")"  
  t: (modifier, cb) ->
    states = cb newctx = @applyTransform(modifier) <<< { topo: @topo }
    console.log "STATES", states
    if states@@ isnt Array then states = [states]
    ret = map flatten(states), (state) ~>
      switch state@@
        | Function => new CtxState(newctx, state)
        | CtxState => state
    ret


# tuple holding a state within a context
export class CtxState
  inspect: -> colors.green("CtxState(") + JSON.stringify(@ctx) + ", " + @state.name + colors.green(")")
  (@ctx, @state, @topology) ->
    if @state@@ isnt Function then throw Error "wrong state type"
  next: ->
    return @state(@ctx)
        

# Topology holding CtxStates
#
# knows how to iterate, immutable next()
# 
# should potentially implement perception for states,
# store states and contexts within an efficient data structure depending on perceptions implemented
export class Topology
  get: (ctx) -> ...
  
  set: (ctxState) ->
    if not ctxState.ctx.topo then ctxState.ctx.topo = @
    @_set ctxState
    
  _set: (ctxState) -> ...
  
  reduce: (cb) -> @data.reduce cb, new @constructor!
  
  map: (cb) -> @data.map cb
  
  next: ->
    console.log "TOPO NEXT", @
    ret = @reduce (topology, ctxState) ~>
      newStates = ctxState.next(@)

      if newStates@@ isnt Array then newStates = Array newStates
      
      reduce do
        newStates
        (topology, newState) ~>
          topology.set switch newState@@
            | Function => new CtxState ctx, newState
            | CtxState => newState
            | _ => throw "state returned an invalid object"
        topology
        
    console.log "NEXT", ret

    ret
      

  toObject: ->
    @reduce do
      (total, state, ctx) -> total <<< {"#{ctx}": state.inspect!}
      {}


