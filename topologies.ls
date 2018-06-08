require! {
  immutable: { Map, Seq, List, Set }: i
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignInWith, flatten, map, keys, clone,
    { typeCast }: w
  }: _
  colors    
  './base.ls': { Topology, CtxState }
}

# stores states in a list
# write only, states can't interact
export class NaiveTopology extends Topology
  (data) ->
    if data then @ <<< data
    if not @data then @data = new List()
      
  inspect: ->
    colors.yellow(@constructor.name + "(") + @data.map((.inspect?!)).join(', ') + colors.yellow(")")
  
  reduce: (cb) -> @data.reduce cb, new @constructor()
  
  rawReduce: (seed, cb) -> @data.reduce cb, seed
  
  _set: (ctxState) -> new @constructor data: @data.push ctxState

# naive storage of discrete multidimensional contexts
# can read states by specific coordinates
export class DiscreteTopology extends Topology
  (data) ->
    if data then @ <<< data
    if not @data then @data = new Map()
      
  rawReduce: (seed, cb) -> @data.reduce cb, seed
  
  inspect: ->
    @data
    .map (.inspect!)
    .join('\n')

  reduce: (cb) -> @data.reduce cb, new @constructor()

  get: (coords) ->
    @data.get coords.join('-')
    
  _set: (ctxState) -> new @constructor data: @data.set ctxState.ctx.loc.join('-'), ctxState

