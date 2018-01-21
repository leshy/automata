require! {
  immutable: { Map, Seq, List, Set }: i
  colors
  util: { inspect }
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignInWith, flatten, map, keys, clone,
    { typeCast }: w
  }: _
}


require! {
  './base.ls': { Topology, CtxState }
}

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
