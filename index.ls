require! {
  immutable: { Map, Seq, List, Set }: i
  colors
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
  transform: (modifier, cb) ->
    states = cb newctx = @applyTransform(modifier)
    
    if states@@ isnt Array then states = [states]
    
    ret = map flatten(states), (state) ~>
      switch state@@
        | Function => new CtxState(newctx, state)
        | CtxState => state
        
    ret

# tuple holding a state within a context
export class CtxState
  inspect: -> colors.green("CtxState(") + JSON.stringify(@ctx) + ", " + @state.name + colors.green(")")
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
              | _ => throw "wat"
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
    
    x2 = ((Math.cos(r) * x) - (Math.sin(r) * y))
    y2 = ((Math.sin(r) * x) + (Math.cos(r) * y))
    
    res = { x: v1.x + x2, y: v1.y + y2 }
#    console.log "APPLYVECTOR",v1, v2, r, res
    res

  applyTransform: (mod) ->
    ctx = clone @data
    
    cvector = ctx{x, y}
    mvector = mod{x, y}
    
    normalizeRotation = (angle) -> r: angle % 360
    
    standardJoin = (target, mod, ctx) ->
      if not target? then return mod
      if not mod? then return target
      if mod@@ is Function then return mod target, ctx
      mod + target
    
    assignInWith(ctx, mod, standardJoin)
      <<< normalizeRotation(ctx.r)
      <<< @_applyVector(cvector, mvector, ctx.r, ctx.s)
      
#    console.log colors.red("transform"), @data, colors.green('->'), mod, colors.green('->'), ctx

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

SierpinskiA = (ctx) ->
  ctx.transform x: -1, (ctx) -> return
    ctx.transform r: 60, x: 1, s: (/2), (ctx) -> return
      SierpinskiB
      ctx.transform r: -60, x: 1, (ctx) -> return
        SierpinskiA
        ctx.transform r: -60, x: 1, (ctx) -> return
          SierpinskiB

SierpinskiB = (ctx) ->
  ctx.transform x: -1, (ctx) -> return
    ctx.transform r: -60, x: 1, s: (/2), (ctx) -> return
      SierpinskiA
      ctx.transform r: 60, x: 1, (ctx) -> return
        SierpinskiB
        ctx.transform r: 60, x: 1, (ctx) -> return
          SierpinskiA

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
  .set new CtxState(new CtxCanvas(x: 0, y: 0, s: 10, r: 0), SierpinskiB)

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
  applyVector = (v1, v2, angle, size=1) ->
    r = radians angle
    
    x = (v2.x or 0) * size
    y = (v2.y or 0) * size
    
    x2 = ((Math.cos(r) * x) - (Math.sin(r) * y))
    y2 = ((Math.sin(r) * x) + (Math.cos(r) * y))
    
    { x: v1.x + x2, y: v1.y + y2 }

  render = (rendering) -> 
    rendering.states().map (ctxState) ->
      { ctx, state } = ctxState

      scale = 60
      add = 11
      
      # c.beginPath();
      # c.arc((ctx.data.x + add) * scale, (ctx.data.y + add) * scale, ctx.data.s * 3, 0, 2*Math.PI);
      # c.stroke();

      c.beginPath();
      
      c.moveTo((ctx.data.x + add) * scale, (ctx.data.y + add) * scale);
      
      { x, y } = applyVector({x: 0, y: 0}, { x: -ctx.data.s, y: 0 }, ctx.data.r, 1)
      
      c.lineTo((ctx.data.x + x + add) * scale, (ctx.data.y + y + add) * scale);
      
      c.stroke();

      # c.beginPath();
      # c.arc(ctx.x * 10,ctx.y * 10, 5,0,2*Math.PI);
      # c.stroke();
  
  render(rendering = topo.next!.next!.next!.next!.next!.next!)
#  render(rendering = topo)
#  console.log rendering
#  render(rendering = rendering.next!)
  # console.log rendering
  # render(rendering = rendering.next!)
  # console.log rendering
  # render(rendering = rendering.next!)
  # console.log rendering
  
  # render(rendering = rendering.next!)
  # render(rendering = rendering.next!)
  # render(rendering = rendering.next!)
