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

export draw = -> getscene ({scene, camera, controls}) ->
  material = new THREE.LineBasicMaterial color: 0xffffff

  ret = do
    render: (topo, z=0) ->
      topo.states().map (ctxState) ->
        { ctx, state } = ctxState

        geometry = new THREE.Geometry()
        point = new THREE.Vector3()
        direction = new THREE.Vector3()

        scale = 1

        geometry.vertices.push( new THREE.Vector3((ctx.data.x) * scale, (ctx.data.y) * scale, z))
        { x, y } = move({x: (ctx.data.x), y: (ctx.data.y)}, { x: -ctx.data.s, y: 0 }, ctx.data.r, 1)
        geometry.vertices.push( new THREE.Vector3(x * scale, y * scale, z))

        object = new THREE.Line( geometry, material )
        scene.add( object )

        
    renderEvo: (topo, n=9) ->   
      _.times n, (z) ->
        ret.render(topo, z * 10)
        topo := topo.next!

    
  return ret