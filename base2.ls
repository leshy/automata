require! {
  immutable: { Map, Seq, List, Set }: i
  colors
  util: { inspect }
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignWith, flattenDeep, map, keys, clone, filter, identity, push,
    { typeCast }: w
  }: _
}

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
  
  applyTransform: (mod) -> @standardJoin @ctx, mod
    
  inspect: -> colors.red("Ctx(") + JSON.stringify(@ctx) + colors.red(")")
  
  t: (modifier, cb) ->
    
    newView = new @constructor(transformed = @applyTransform(modifier), @topo, @newTopo)

#    console.log @ctx, "via", modifier, 'becomes', transformed
 
    newStates = cb newView
    if not newStates then return []
    if newStates@@ isnt Array then newStates = [newStates]

    map newStates, (newState) ~>
      switch newState@@
        | Function => new CtxState(newView.ctx, newState)
        |_ => newState


# tuple holding a state within a context, knows how to .next(), returns array of ctxStates
export class CtxState
  (@ctx, @state) -> true
  inspect: -> colors.green("CtxState(") + JSON.stringify(@ctx) + ", " + @state.name + colors.green(")")
  next: (topology, newTopology) ->
    flattenDeep @state new topology.CtxView @ctx, topology, newTopology
    
  toObject: ->
    [ @ctx, @state.name ]
    

# Topology holding CtxStates
#
# knows how to iterate, immutable next()
# 
# should potentially implement perception for states,
# store states and contexts within an efficient data structure depending on perceptions implemented
export class Topology
  CtxView: CtxView
  
  get: (ctx) -> ...
  
  set: (...ctxStates) ->
    reduce do
      ctxStates
      (topology, ctxState) ~> topology._set ctxState
      @

  _set: (ctxState) -> ...
  
  
  map: (cb) -> @data.map cb
  
  next: ->
    @reduce (newTopology, ctxState) ~>
      nextStates = ctxState.next @, newTopology
#      console.log ctxState.inspect! +  " -->", nextStates
      newTopology.set ...nextStates
      
  toObject: ->
    @rawReduce [], (total, ctxState) -> push total, ctxState.toObject()



export class NaiveTopology extends Topology
  (data) ->
    if data then @ <<< data
    if not @data then @data = new List()
      
  inspect: ->
    colors.yellow(@constructor.name + "(") + @data.map((.inspect?!)).join(', ') + colors.yellow(")")
  
  reduce: (cb) -> @data.reduce cb, new @constructor()
  
  rawReduce: (seed, cb) -> @data.reduce cb, seed
  
  _set: (ctxState) -> new @constructor data: @data.push ctxState
