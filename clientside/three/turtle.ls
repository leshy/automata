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

  window.scene = scene

  window.gcode = ->
    scene.children.map (line) ->
      x1 = line.geometry.vertices[ 0 ].x
      y1 = line.geometry.vertices[ 0 ].y
      x2 = line.geometry.vertices[ 1 ].x
      y2 = line.geometry.vertices[ 1 ].y
      [ [ x1, y1  ], [ x2, y2 ] ]

  window.project = ->
    scene.children.map (child) ->
      child.geometry.vertices.map (v) ->

        const { x, y, z } = v.project(camera)
        geometry = new THREE.PlaneGeometry(0.1,0.1)
        material = new THREE.MeshBasicMaterial( {color: 0xffff00, side: THREE.DoubleSide} )
        plane = new THREE.Mesh( geometry, material )
        plane.position.x = x
        plane.position.y = y
        plane.position.z = 0
        console.log(x,y,z)
        
        scene.add(plane)
        
    gridHelper(scene)

            
  gridHelper = (scene) ->
    grid = new THREE.GridHelper 2, 2, new THREE.Color(0xff0000) 
    grid.geometry.rotateX( Math.PI / 2 )
    scene.add( grid )


  # gridHelper(scene)

  
  ret = do
    reset: ->
      while scene.children.length > 0
        scene.remove(scene.children[0])
      # gridHelper(scene)
    render: (topo, z=0) ->
      # material = new THREE.LineBasicMaterial color: new THREE.Color("rgb(255 ,255 , 255)")
      # material.transparent = true;
      # material.opacity = 0.3;
      # cube = new THREE.Mesh(new THREE.BoxGeometry( 1, 1, 1 ), material);
      
      
      # cube.position.z = z
      # cube.position.x = 0
      # cube.position.y = 0
      # scene.add( cube )
      # while scene.children.length > 0
      #   scene.remove(scene.children[0])
      console.log(z)
      topo.map (ctxState) ->
          
        [ ctx, state ] = ctxState
        material = new THREE.LineBasicMaterial color: new THREE.Color("rgb(#{ctx.cr or 255}, #{ctx.cg or 255}, #{ctx.cb or 255})")

        geometry = new THREE.Geometry()
        point = new THREE.Vector3()
        direction = new THREE.Vector3()

        scale = 1
                        
        geometry.vertices.push( new THREE.Vector3(ctx.x, ctx.y, z))
        { x, y } = move({x: (ctx.x), y: (ctx.y)}, { x: -ctx.s, y: 0 }, ctx.r, 1)
        geometry.vertices.push( new THREE.Vector3(x * scale, y * scale, z))
        
        object = new THREE.Line( geometry, material )

#        console.log (ctx.x) * scale, (ctx.y) * scale, z, x * scale, y * scale, z

        
        scene.add( object )

        
    renderEvo: (topo, n=9, distance=10) ->   
      _.times n, (z) ->
        ret.render(topo, z * distance)
        topo := topo.next!
        # console.log topo

    
  return ret

