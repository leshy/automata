require! {
  immutable: { Map, Seq, List, Set }: i
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignInWith, flatten, map, keys, clone,
    { typeCast }: w
  }: _
    
  './base.ls': { Topology, CtxState }
}

export class NaiveTopology extends Topology
  (data) ->
    if data then @ <<< data
    if not @data then @data = new List()
      
  inspect: ->
    @states()
    .map (.inspect!)
    .join('\n')
  
  _set: (ctxState) ->
    new @constructor data: @data.push ctxState


export class DiscreteTopology extends Topology
  (data) ->
    if data then @ <<< data
    if not @data then @data = new Map()
      
  inspect: ->
    @states()
    .map (.inspect!)
    .join('\n')

  get: (coords) ->
    console.log @data, coords.join('-')
    @data.get coords.join('-')
    
  _set: (ctxState) ->
    console.log "SET", ctxState, ctxState.ctx.key(), ctxState.state.name

    new @constructor data: @data.set ctxState.ctx.key(), ctxState

