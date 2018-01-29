require! {
  leshdash: { times, each }: _
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

export draw = (distance) -> getscene distance, ({scene, camera, controls, renderer}) ->

  # renderer.shadowMap.enabled = false;
  # renderer.shadowMap.soft = true;
  # renderer.shadowMap.type = THREE.PCFShadowMap;
  # light = new THREE.AmbientLight( 0xaaaaaa );
  # scene.add( light );
  
  # directionalLight = window.directionalLight = new THREE.DirectionalLight( 0xffffff, 0.3 );
  # directionalLight.position.set( 100, 100, 100 );
  # directionalLight.castShadow = true
  # scene.add( directionalLight );
  ret = do
    render: (topo, z=0) ->
      ret = []
      topo.map (ctxState) ->
        { ctx, state } = ctxState
        
        if state.name == "Check"
          return

        scale = 1
        
          
        # material = new THREE.LineBasicMaterial do
        #   color: new THREE.Color("rgb(#{ctx.cr or 100}, #{ctx.cg or 100}, #{ctx.cb or 100})")
        # material.transparent = true
        # material.opacity = 0.8

        # material = new THREE.MeshPhongMaterial do
        #   color: new THREE.Color("rgb(#{ctx.cr or 100}, #{ctx.cg or 100}, #{ctx.cb or 100})")

        if state.name == "Check"
          material.transparent = true;
          material.opacity = 0.2;

        geometry = new THREE.BoxGeometry(0.1, 0.1, 0.1)
        
        material = new THREE.LineBasicMaterial do
          color: new THREE.Color("rgb(#{ctx.cr or 100}, #{ctx.cg or 100}, #{ctx.cb or 100})")
          linewidth: 1
          
        # geometry = new THREE.EdgesGeometry geometry
        # object = new THREE.LineSegments geometry, material
  
        object = new THREE.Mesh geometry, material
        object.position.x = ctx.loc[0] / 10
        object.position.z = ctx.loc[1] / 10
        object.position.y = z / 10

        # object = new THREE.Mesh geometry, material
        # object.position.x = ctx.loc[0] / 10
        # object.position.z = ctx.loc[1] / 10
        # object.position.y = z / 10

        scene.add object
        ret.push object
      ret
          
    renderEvo: (topo, n=9, distance=10) ->
      _.times n, (z) ->
        ret.render(topo, z * distance)
        topo := topo.next!
        
    renderSlowSlice: (topo, n=9, distance=10, prevObjects=[]) -> 
      if not n then return
      topo = topo.next!
      
      # while(scene.children.length > 0)
      #   scene.remove(scene.children[0])
        
      # renderer.renderLists.dispose()

      each prevObjects, -> scene.remove it
      
      prevObjects = ret.render(topo, 1)

      setTimeout((-> ret.renderSlowSlice(topo, n-1,distance, prevObjects)), 1)
      
    renderSlowEvo: (topo, n=9, distance=10) -> 
      if not n then return
      topo = topo.next!
      ret.render(topo, - n * distance)
      
      
      setTimeout((-> ret.renderSlowEvo(topo, n-1,distance)), 20)

  # camera.matrix.fromArray(JSON.parse("[0.9227011283338787,2.7755575615628914e-17,-0.3855160538439185,0,0.28421051939831177,0.6756517153840521,0.6802346214078856,0,0.2604745830877341,-0.7372209706041926,0.6234246001455855,0,1.6767722721522267,-6.296830734514615,24.380864892154904,1]"))
    
  return ret
