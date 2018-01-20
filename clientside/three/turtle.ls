require! {
  leshdash: { times }: _
  three: THREE
  './index.ls': { getscene }
}
require! {
  '../../models/sierpinski.ls': { topology }
}

applyVector = (v1, v2, angle, size=1) ->

  radianConstant = Math.PI / 180
  radians = (d) -> d * radianConstant

  r = radians angle

  x = (v2.x or 0) * size
  y = (v2.y or 0) * size

  x2 = (Math.cos(r) * x) - (Math.sin(r) * y)
  y2 = (Math.sin(r) * x) + (Math.cos(r) * y)

  { x: v1.x + x2, y: v1.y + y2 }

export draw = -> getscene ({scene, camera, controls}) ->
  material = new THREE.MeshBasicMaterial( { color: 0xffffff } );

  floor = new THREE.Mesh( new THREE.BoxGeometry( 1,1,1 ), material );
  floor.position.x = 0
  floor.position.y = 0
  floor.position.z = 0
#  scene.add floor

  renderTurtle = (topo, z=0) ->

    material = new THREE.LineBasicMaterial color: 0xffffff
    
    topo.states().map (ctxState) ->
      { ctx, state } = ctxState

      geometry = new THREE.Geometry()
      point = new THREE.Vector3()
      direction = new THREE.Vector3()

      scale = 1
      
      
      geometry.vertices.push( new THREE.Vector3((ctx.data.x) * scale, (ctx.data.y) * scale, z))
      
      { x, y } = applyVector({x: (ctx.data.x), y: (ctx.data.y)}, { x: -ctx.data.s, y: 0 }, ctx.data.r, 1)
      
      geometry.vertices.push( new THREE.Vector3(x * scale, y * scale, z))
      
      
      object = new THREE.Line( geometry, material )
      scene.add( object )

  
  _.times 9, (z) ->
    renderTurtle(topology, z * 10)
    topology := topology.next!
  
  line = ->
    geometry = new THREE.Geometry()
    point = new THREE.Vector3()
    direction = new THREE.Vector3()

    _.times 20, -> 
      direction.x += Math.random() - 0.5;
      direction.y += Math.random() - 0.5;
      direction.z += Math.random() - 0.5;

      direction.normalize().multiplyScalar( 1 );
      point.add( direction );
      geometry.vertices.push( point.clone() );

    object = new THREE.Line( geometry )

    object.position.x = Math.random() * 40 - 20;
    object.position.y = Math.random() * 40 - 20;
    object.position.z = Math.random() * 40 - 20;

    object.rotation.x = Math.random() * 2 * Math.PI;
    object.rotation.y = Math.random() * 2 * Math.PI;
    object.rotation.z = Math.random() * 2 * Math.PI;

    object.scale.x = Math.random() + 0.5;
    object.scale.y = Math.random() + 0.5;
    object.scale.z = Math.random() + 0.5;
    scene.add( object );

