# Abstract cellular automata simulator
# we support arbitrary dimensions as well as cell shapes

require! {
  immutable: { Map }: i
  leshdash: { each, times, zip, defaults, mapFilter }: _
}


export class Field
  (data) ->
    if data then @ <<< data
    if not @data then @data = new Map()

  get: (loc) ->
    @data.get(loc.join('-'))
        
  set: (loc, state) ->
    new Field data: @data.set(loc.join('-'), state)

  neighbourCoords: (coords) ->
    throw Error "not implemented"
    

export class Loc
  (@coords, @field) -> void
  set: (state) -> @field.set @coords, state

  neighbourCoords: -> @field.neighbourCoords @coords
    
  neighbours: ->
    each @neighbourCoords!, (loc) ->
      if (state = loc.state)? then state else void


export class State
  neighbours: ->
    each @loc.neighbourCoords!, (loc) ->
      if (state = loc.state)? then state else void

  next: ->
    throw Error "not implemented"


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




  
export class Life extends Field
  next: (state, loc) ->
    nn = mapFilter loc.neighbours(), (.state)
    return switch state
      | 2 => void
      | 1 => void
      | void => void

    



