require! {
  './index.ls': { BlindTopology, CtxState, CtxCanvas, Sierpinski }
}

topo = new BlindTopology().set new CtxState(new CtxCanvas(x: 0, y: 3.25, s: 10, r: 0), Sierpinski)

global.draw = ->
  global.c = c = document.getElementById('canvas').getContext('2d')
  c.canvas.width  = window.innerWidth;
  c.canvas.height = window.innerHeight;
  
  c.strokeStyle = 'white';
  applyVector = (v1, v2, angle, size=1) ->

    radianConstant = Math.PI / 180
    radians = (d) -> d * radianConstant
    r = radians angle
    
    x = (v2.x or 0) * size
    y = (v2.y or 0) * size
    
    x2 = ((Math.cos(r) * x) - (Math.sin(r) * y))
    y2 = ((Math.sin(r) * x) + (Math.cos(r) * y))
    
    { x: v1.x + x2, y: v1.y + y2 }

  clear = ->
    c.clearRect(0, 0, c.canvas.width, c.canvas.height)

  render = (rendering) ->
    
    #c.clearRect(0, 0, c.canvas.width, c.canvas.height)
    rendering.states().map (ctxState) ->
      { ctx, state } = ctxState

      scale = 60
      addx = 11
      addy = 9
            
      # c.beginPath();
      # c.arc((ctx.data.x + add) * scale, (ctx.data.y + add) * scale, ctx.data.s * 3, 0, 2*Math.PI);
      # c.stroke();

      c.beginPath();
      c.moveTo((ctx.data.x + addx) * scale, (ctx.data.y + addy) * scale);
      { x, y } = applyVector({x: 0, y: 0}, { x: -ctx.data.s, y: 0 }, ctx.data.r, 1)
      c.lineTo((ctx.data.x + x + addx) * scale, (ctx.data.y + y + addy) * scale);
      c.stroke();


  rerender = (topo, cnt=1, delay=500) ->
    if not cnt then return
    else setTimeout((-> rerender(topo.next!, cnt-1, delay)), delay)
    clear()
    render(topo)

  rerender(topo, 8, 100)

  
