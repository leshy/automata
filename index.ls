require! {
  immutable: { Map, Seq, List, Set }: i
  util: { inspect }
  leshdash: {
    reduce, each, times, zip, defaults, mapFilter, assignInWith, flatten, map, keys, clone,
    { typeCast }: w
  }: _
}

# Context
# 
# defines some context (location) for a state within some topology
# implements a transform function that takes wither a plain state or a state within some context (CtxState)
# and returns a state within a new context (CtxState)
export class Ctx
  applyTransform: (transformations={}) -> ...
  inspect: -> "Ctx(" + JSON.stringify(@data) + ")"
  transform: (modifier) ->
    (...states) ~>  
      map flatten(states), (state) ~>
        new CtxState ...switch state@@
          | Function => [ @applyTransform(modifier), state ]
          | CtxState => [ state.ctx.applyTransform(modifier), state.state ]


# tuple holding a state within a context
export class CtxState
  inspect: -> "CtxState(" + JSON.stringify(@ctx) + ", " + @state.name + ")"
  (@ctx, @state) ->
    if @state@@ isnt Function then throw Error "wrong state type"
  next: ->
    return @state(@ctx)
        

# Topology holding states within contexts
#
# knows how to iterate, immutable next()
# 
# should potentially implement perception for states,
# and store states and contexts within an efficient data structure depending on perceptions implemented
export class Topology
  get: (ctx) -> ...
  
  set: (ctxState) -> ...
  
  states: -> ...
  
  next: ->
    @states!reduce do
      (topology, ctxState) ~>
        newStates = ctxState.next!
        
        if newStates@@ isnt Array then newStates = Array newStates

        reduce do
          newStates
          (topology, newState) ~>
            topology.set switch newState@@
              | Function => new CtxState ctx, newState
              | CtxState => newState
              | _ => throw "xxwat"
          topology
            
      new @constructor!

  toObject: ->
    @states!reduce do
      (total, state, ctx) -> total <<< {"#{ctx}": state.inspect!}
      {}

radianConstant = Math.PI / 180
radians = (d) -> d * radianConstant

export class Ctx2D extends Ctx
  (data={}) -> @data = {s: 1, r: 0, x: 0, y: 0} <<< data
  
  _applyVector: (v1, v2, angle, size=1) ->
    r = radians angle
    
    x = (v2.x or 0) * size
    y = (v2.y or 0) * size
    
    x2 = Math.round((Math.cos(r) * x) - (Math.sin(r) * y))
    y2 = Math.round((Math.sin(r) * x) + (Math.cos(r) * y))
    
    { x: v1.x + x2, y: v1.y + y2 }

  applyTransform: (mod) ->
    ctx = clone @data
    console.log "APPLYTRANSFORM", ctx, mod
    
    cvector = ctx{x, y}
    mvector = mod{x, y}
    
    normalizeRotation = (angle) -> r: angle % 360
    
    standardJoin = (target, mod, ctx) ->
      if not target? then return mod
      if not mod? then return target
      if mod@@ is Function then return mod target, ctx
      mod + target

    
    assignInWith(ctx, mod, standardJoin)
      <<< @_applyVector(cvector, mvector, ctx.r, ctx.s)
      <<< normalizeRotation(ctx.r)

    console.log "RES", ctx
    new @constructor ctx

export class CtxCanvas extends Ctx2D
  line: ->
    true
            
CheckLife = (ctx) ->
  if neighbours(ctx).length in [ 2, 3 ] then Life
  
Life = (ctx) ->
  if ctx.neighbours().length in [ 2, 3 ] then Life
  else map ctx.neighbourLocs(), (location) -> ctx.transform location, CheckLife
  
Spiral = (ctx) -> return do
  ctx.set 'circle'
  ctx.transform r: 46, x: 1, s: (* 1.01), Spiral

defineState = (def) ->
  def.state = true
  def

SierpinskiA = defineState (ctx) ->
  ctx.transform(r: 90, x: 1) (ctx) -> 
    SierpinskiA
    ctx.transform(r: 0, x: 1) (ctx) -> 
      SierpinskiB
      ctx.transform(x: 1) (ctx) -> 
        SierpinskiA

SierpinskiB = (ctx) -> true

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

topo = new BlindTopology!
  .set new CtxState(new CtxCanvas(x: 0, y: 0, s: 10, r: 0), SierpinskiA)
  
console.log topo.next!

  # .next!
  # .next!
  # .next!
  # .next!
  

global.draw = ->
  global.c = c = document.getElementById('canvas').getContext('2d')
  c.canvas.width  = window.innerWidth;
  c.canvas.height = window.innerHeight;
  
  #c.canvas.width  = document.body.clientWidth;
  #c.canvas.height = document.body.clientHeight;

  
  c.strokeStyle = 'white';

  render = (rendering) -> 
    rendering.states().map (ctxState) ->
      { ctx, state } = ctxState

      scale = 20
      add = 20
      
      c.beginPath();
      c.arc((ctx.data.x + add) * scale, (ctx.data.y + add) * scale, ctx.data.s * 3, 0, 2*Math.PI);
      c.stroke();

      # ctx.x = ctx.x
      # ctx.y = ctx.y
      # c.beginPath();
      
      # c.moveTo(ctx.x * scale, ctx.y * scale);
      
      # { x, y } = applyVector({ x: 0, y: 0}, { x: -ctx.s * 2, y: 0 }, ctx.r, 1)
      
      # c.lineTo((ctx.x + x) * scale, (ctx.y + y) * scale);
      # c.stroke();


      # c.beginPath();
      # c.arc(ctx.x * 10,ctx.y * 10, 5,0,2*Math.PI);
      # c.stroke();
  render(rendering = topo)
  console.log rendering
  render(rendering = rendering.next!)
  console.log rendering
#  render(rendering = rendering.next!)
#  console.log rendering
  # render(rendering = rendering.next!)
  # render(rendering = rendering.next!)
  # render(rendering = rendering.next!)
