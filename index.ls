# Abstract cellular automata simulator (arbitrary dimensions and cell shapes)

require! {
  immutable: { Map, Seq }: i
  leshdash: { reduce, each, times, zip, defaults, mapFilter, { typeCast }: w }: _  
}


export class SpaceSpecification
  get: typeCast Location, (loc) -> throw Error "not implemented"
  set: typeCast Location, (loc, state) -> throw Error "not implemented"
  states: ->* throw Error "not implemented"
  next: ->
    @states!
    .reduce do
      (total, state, location) -> total.set location, ...state.next()
      new @constructor!

  toJSON: ->
    @states!
    .reduce do
      (total, state, location) -> total <<< { "#{location}": state.inspect() }
      {}


export class Space extends SpaceSpecification
  (data) ->
    if data then @ <<< data
    if not @data then @data = new Map()

  get: (loc) ->
    @data.get loc.join('-')
        
  set: (loc, ...states) ->
    loc = switch loc@@
      | String => loc
      | Array => loc.join('-')
      | _ => throw new Error loc + " is not a loc"

    newData = reduce states, ((data, state) -> data.set loc, state), @data
    new @@ data: newData

  neighbourLocs: typeCast Location, (loc, depth=1) ->
    throw Error "not implemented"
  
  states: ->
    @data.toKeyedSeq()

  inspect: -> "Sim(" + @data.reduce(((total, val, key) ->  total + " " + key + ":" + val.inspect?!), "") + " )"

export class Location
  (@coords, @field) -> void
  
  set: (state) -> @field.set @coords, state

  neighbourLocs: (depth) -> @field.neighbourLocs @coords, depth
    
  neighbours: ->
    each @neighbourCoords!, (loc) ->
      if (state = loc.state)? then state else void


export class State
  neighbours: ->
    each @loc.neighbourCoords!, (loc) ->
      if (state = loc.state)? then state else void

  inspect: -> "State"
  
  next: (location) ->
    return [ new State() ]


export class LAbsState 
  checkState: -> 
    nlen = @neighbours!length
    if nlen in [ 2, 3 ] then return State
    if nlen < 2 then return void
    if nlen > 3 then return void
      
  setChecks: -> each @neighbourCoords, (loc) -> @field.set loc, LCheckState


export class Lstate extends LAbsState
  next: ->
    if not state = @checkState then @setChecks!
    return state


export class LCheckState extends LAbsState
  next: ->
    if state = @checkState! then @setChecks!
    return state

  
export class Life extends Space
  next: (state, loc) ->
    nn = mapFilter loc.neighbours(), (.state)
    return switch state
      | 2 => void
      | 1 => void
      | void => void

    
