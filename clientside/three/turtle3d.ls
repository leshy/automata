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
        [ ctx, state ] = ctxState
        color = ctx.color
#        if ctx.counter > 1 then color = 255 - color
          
        material = new THREE.MeshBasicMaterial do
#          color: new THREE.Color("rgb(#{ctx.cr or 255}, #{ctx.cg or 255}, #{ctx.cb or 255})")
          color: new THREE.Color("rgb(#{color},#{color},#{color})")

        scale = 1
        cube = new THREE.Mesh( new THREE.SphereGeometry( ctx.size ), material );
        cube.position.x = ctx.pos?[0] or 0
        cube.position.y = - ctx.pos?[1] or 0
        cube.position.z = ctx.pos?[2] or 0
        scene.add( cube )

    reset: ->
      while scene.children.length > 0
        scene.remove(scene.children[0])
      
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
