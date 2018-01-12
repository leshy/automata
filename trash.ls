
export class CanvasSpace
#  contextClass: CanvasContext
  (data) ->
    if data then @ <<< data
    if not @data then @data = new Map()

  get: (ctx) ->
    @data.get switch ctx?@@
      | @contextClass => @data.get ctx.key()
      | String => @data.get ctx
      |_ => throw new Error "not a context"
        
  set: (ctx, ...states) ->
    ctx = switch ctx?@@
      | @contextClass => ctx.key()
      | String => ctx
      |_ => throw new Error "not a context"
    
    new @constructor do
      data: reduce states, ((data, state) -> data.set loc, state), @data
