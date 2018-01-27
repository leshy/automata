
# Context View
# 
# defines some context (location) for a state within some topology
# implements a transform function that takes either a plain state or a state within some context (CtxState)
# and returns a state within a new context (CtxState)
export class CtxView
  (@ctx, @topo, @newTopo) -> true

  standardJoin: (target, mod) ->
    assignWith clone(target), mod, (target, mod) ~>
      if not mod? then return target
      if mod@@ is Function then return mod target, @
      if not target? then return mod
      mod + target
  
  applyTransform: (mod) ->
    new @constructor @standardJoin(@data, mod), @topo
    
  inspect: -> "Ctx(" + JSON.stringify(@data) + ")"
  
  t: (modifier, cb) ->
    states = cb newctx = @applyTransform(modifier)
    if not states then return []
    if states@@ isnt Array then states = [states]

    map states, (state) ~>
      switch state@@
        | Function => new CtxState(newctx, state)
        | CtxState => state


# tuple holding a state within a context, knows how to .next(), returns array of ctxStates
export class CtxState
  (@ctx, @state) ->
    if @state@@ isnt Function then throw Error "wrong state type"
      
  inspect: -> colors.green("CtxState(") + JSON.stringify(@ctx) + ", " + @state.name + colors.green(")")
  
  next: (topology, newTopology) ->
    @state new @topology.CtxView(@ctx, topology, newTopology)


# Topology holding CtxStates
#
# knows how to iterate, immutable next()
# 
# should potentially implement perception for states,
# store states and contexts within an efficient data structure depending on perceptions implemented
export class Topology
  CtxView = CtxView
  
  get: (ctx) -> ...
  
  set: (...ctxStates) ->
    reduce do
      ctxStates
      (topology, ctxState) ~> topology._set ctxState
      @

  _set: (ctxState) -> ...
  
  reduce: (cb) -> @data.reduce cb, new @constructor()
  
  map: (cb) -> @data.map cb
  
  next: ->
    @reduce (topology, ctxState) ~>
      @set newStates = ctxState.next @, topology
      
  toObject: ->
    @reduce do
      (total, state, ctx) -> total <<< {"#{ctx}": state.inspect!}
      {}


