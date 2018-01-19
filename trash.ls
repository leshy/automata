
setInterval((->
  rendering = topo
  console.log Math.floor(global.vol / 10)
  _.times -Math.floor(global.vol / 10), ->
    rendering := rendering.next!
  render(rendering)
  ), 5)

global.vol = 60
getUserMedia = require('getusermedia')
hark = require 'hark'
getUserMedia (err, stream) ->
  console.log err, stream
  speech = hark stream, {}
  speech.on 'volume_change', ->
    global.vol = it



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
