require! {
  immutable: { Map, Seq, List, Set }: i
  util: { inspect }
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignInWith, flatten, map, keys, clone,
    { typeCast }: w
  }: _
}




# state = (ctx) --> [ ctxState, ...ctxState ]
# ctxState = () --> [ ctxState, ...ctxState ]
  

export class Ctx
  (@data) -> true
  inspect: -> "Ctx(" + JSON.stringify(@data) + ")"
  
  transform: (transform, cb) ->
    standardJoin = (target, mod, ctx) ->
      
      if not target? then return mod
      if not mod? then return target
      if mod@@ is Function then return mod target, ctx
      mod + target
    
    ret = cb new @constructor(assignInWith @data, transform, standardJoin)

    return map flatten(ret), (state) ~> new CtxState @, state

# tuple holding a state within a context
export class CtxState
  inspect: -> "CtxState(" + JSON.stringify(@ctx) + ", " + @state.name + ")"
  
  (@ctx, @state) ->
    if @state@@ isnt Function then throw Error "wrong state type"
  next: ->
    return @state(@ctx)

SA = (ctx) ->
  ctx.transform r: 90, (ctx) -> 
    SA

  
console.log SA(new Ctx(r: 20))
