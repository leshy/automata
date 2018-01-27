require! {
  immutable: { Map, Seq, List, Set }: i
  colors
  util: { inspect }
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignWith, flattenDeep, map, keys, clone, filter, identity,
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

    ret = map states, (state) ~>
      switch state@@
        | Function => new CtxState(newctx, state)
        | CtxState => state
    ret


# tuple holding a state within a context
export class CtxState
  (@ctx, @state) ->
    if @state@@ isnt Function then throw Error "wrong state type"
      
  inspect: -> colors.green("CtxState(") + JSON.stringify(@ctx) + ", " + @state.name + colors.green(")")
  
  next: (topology, newTopology) ->
    nextStates = filter (flattenDeep @state(@ctx) or []), identity
    console.log "NextStates for", @ctx.data.loc, @state.name, "are", nextStates
    
    return map nextStates, (state) ~> 
      switch state@@
        | Function => new CtxState(@ctx, state)
        | CtxState => state
        

# Topology holding CtxStates
#
# knows how to iterate, immutable next()
# 
# should potentially implement perception for states,
# store states and contexts within an efficient data structure depending on perceptions implemented
export class Topology
  get: (ctx) -> ...
  
  set: (ctxState) ->
    @_set ctxState
    
  _set: (ctxState) -> ...
  
  reduce: (cb) -> @data.reduce cb, new @constructor()
  
  map: (cb) -> @data.map cb
  
  next: ->
    @reduce (topology, ctxState) ~>
      newStates = ctxState.next @, topology
      
      if newStates@@ isnt Array then newStates = Array newStates
      
      reduce do
        newStates
        (topology, newState) ~>
          if newState then topology.set(newState) else topology
        topology

  toObject: ->
    @reduce do
      (total, state, ctx) -> total <<< {"#{ctx}": state.inspect!}
      {}


