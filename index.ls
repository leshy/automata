#
# abstract automata simulator
#
# arbitrary machines running on arbitrary topologies,
# (stuff like stohastic or deterministic machines in continuous or discrete spaces)
#
# machines implemented as RAM-machines, generative grammars, blind or with perception, etc
# so should be able to simulate L-systems, CA, brownian motion, boids, etc
# should be able to run in spaces with arbitrary numbers of dimensions, on graph structures, hexagonal grids, etc
# 
# spaces as immutable objects, machines as functions
#
# views, storage and controllers as plugins
#

require! {
  immutable: { Map, Seq }: i
  leshdash: { reduce, each, times, zip, defaults, mapFilter, { typeCast }: w }: _
}


export class SpaceSpec
  get: typeCast LocSpec, (ctx) -> ...
  set: typeCast LocSpec, (ctx, state) -> ...
  
  states: ->* ...
  
  next: ->
    @states!reduce do
      (total, state, ctx) -> total.set ctx, state(ctx)
      new @constructor!

  toObject: ->
    @states!reduce do
      (total, state, location) -> total <<< {"#{location}": state.inspect!}
      {}


export class LocSpec
  transform: (transformations={}, state) -> ...

export class StateSpec
  -> ...


export class BlockSpace extends SpaceSpec
  (data) ->
    if data then @ <<< data
    if not @data then @data = new Map()

  get: (loc) ->
    @data.get loc.join '-'
        
  set: (loc, ...states) ->
    loc = switch loc@@
      | String => loc
      | Array => loc.join('-')
      | _ => throw new Error loc + " is not a loc"

    newData = reduce states, ((data, state) -> data.set loc, state), @data
    new @@ data: newData

  neighbourLocs: typeCast Location, (loc, depth=1) ->
    throw Error "not implemented"
  
  states: -> @data.toKeyedSeq()

  inspect: -> "Sim(" + @data.reduce(((total, val, key) ->  total + " " + key + ":" + val.inspect?!), "") + " )"


export class Context2D
  (@coords, @field) -> void

  neighbourLocs: (depth) -> @field.neighbourLocs @coords, depth
    
  neighbours: ->
    each @neighbourCoords!, (loc) ->
      if (state = loc.state)? then state else void


CheckLife = (ctx) ->
  if neighbours(ctx).length in [ 2, 3 ] then Life
  
Life = (ctx) ->
  if ctx.neighbours().length in [ 2, 3 ] then Life
  else map ctx.neighbourLocs(), (location) -> ctx.transform location, CheckLife
  
Spiral = (ctx) -> return do
  ctx.set 'circle'
  ctx.transform r: 46, x: 1, s: (* 1.01), Spiral


SierpinskiA = (ctx) -> return do
  SierpinsskiB
  ctx.transform r: 60, do
    SierpinsskiA
    ctx.transform r: 60, do
      SierpinsskiB

SierpinsskiB = (ctx) -> return do
  SierpinsskiA
  ctx.transform r: -60, do
    SierpinsskiB
    ctx.transform r: -60, do
      SierpinsskiA


SierpinsskiA = (ctx) -> return do
  SierpinsskiA
  SierpinsskiR
  SierpinsskiB
  SierpinsskiR
  SierpinsskiA

SierpinsskiB = (ctx) -> return do
  SierpinsskiB
  SierpinsskiL
  SierpinsskiA
  SierpinsskiL
  SierpinsskiB



  
