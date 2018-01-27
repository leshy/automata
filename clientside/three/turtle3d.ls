require! {
  leshdash: { times }: _
  three: THREE
  './index.ls': { getscene }
}

move = (v1, v2, rotation, size=1) ->
  radians = (d) -> d * Math.PI / 180
  r = radians rotation
  x = (v2.x or 0) * size
  y = (v2.y or 0) * size
  x2 = (Math.cos(r) * x) - (Math.sin(r) * y)
  y2 = (Math.sin(r) * x) + (Math.cos(r) * y)
  { x: v1.x + x2, y: v1.y + y2 }

export draw = (distance) -> getscene distance, ({scene, camera, controls}) ->
  
  ret = do
    render: (topo, z=0) ->
      topo.map (ctxState) ->
        { ctx, state } = ctxState
        material = new THREE.LineBasicMaterial color: new THREE.Color("rgb(#{ctx.cr or 255}, #{ctx.cg or 255}, #{ctx.cb or 255})")

        scale = 1
        cube = new THREE.Mesh( new THREE.BoxGeometry( ctx.size, ctx.size, ctx.size ), material );
#        console.log ctx
#        console.log "DRAW", ctx.x, ctx.y, ctx.z, ctx.size
        cube.position.x = ctx.x
        cube.position.y = ctx.y
        cube.position.z = ctx.z
        scene.add( cube )
        
    renderEvo: (topo, n=9, distance=10) ->
      _.times n, (z) ->
        ret.render(topo, z * distance)
        topo := topo.next!
      
    renderSlowEvo: (topo, n=9, distance=10) -> 
      if not n then return
      topo = topo.next!
      ret.render(topo, n * distance)
      setTimeout((-> ret.renderSlowEvo(topo, n-1,distance)), 20)

    
  return ret
