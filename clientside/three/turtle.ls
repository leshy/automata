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
      topo.data.map (ctxState) ->
        { ctx, state } = ctxState
        material = new THREE.LineBasicMaterial color: new THREE.Color("rgb(#{ctx.cr or 255}, #{ctx.cg or 255}, #{ctx.cb or 255})")

        geometry = new THREE.Geometry()
        point = new THREE.Vector3()
        direction = new THREE.Vector3()

        scale = 1
        { x, y } = move({x: (ctx.x), y: (ctx.y)}, { x: -ctx.s, y: 0 }, ctx.r, 1)
#        console.log (ctx.x) * scale, (ctx.y) * scale, z, x * scale, y * scale, z
        geometry.vertices.push( new THREE.Vector3(x * scale, y * scale, z))

        object = new THREE.Line( geometry, material )
        scene.add( object )

        
    renderEvo: (topo, n=9, distance=10) ->   
      _.times n, (z) ->
        ret.render(topo, z * distance)
        topo := topo.next!

    
  return ret
