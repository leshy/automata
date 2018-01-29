require! {
  leshdash: { times }: _
  three: THREE
  './index.ls': { getscene }
}


export draw = (distance) -> getscene distance, ({scene, camera, controls, renderer}) ->

  renderer.shadowMapEnabled = false;
  renderer.shadowMapSoft = true;
  renderer.shadowMapType = THREE.PCFShadowMap;
  light = new THREE.AmbientLight( 0xaaaaaa );
  scene.add( light );
  
  directionalLight = window.directionalLight = new THREE.DirectionalLight( 0xffffff, 1 );
  directionalLight.position.set( 100, 100, 100 );
  directionalLight.castShadow = true
  scene.add( directionalLight );


    
  
  ret = do
    render: (topo, z=0) ->
      topo.map (ctxState) ->
        { ctx, state } = ctxState
        
        if state.name == "Check"
          return

        scale = 1
        
        material = new THREE.LineBasicMaterial do
          color: new THREE.Color("rgb(#{ctx.cr or 100}, #{ctx.cg or 100}, #{ctx.cb or 100})")
          
        # material.transparent = true
        # material.opacity = 0.8

        # material = new THREE.MeshPhongMaterial do
        #   color: new THREE.Color("rgb(#{ctx.cr or 100}, #{ctx.cg or 100}, #{ctx.cb or 100})")

        if state.name == "Check"
          material.transparent = true;
          material.opacity = 0.2;

        cube = new THREE.Mesh( new THREE.BoxGeometry(0.05, 0.05, 0.05), material );
        cube.receiveShadow = true;
        
        cube.position.x = ctx.loc[0] / 10
        cube.position.y = ctx.loc[1] / 10
        cube.position.z = z / 10
        scene.add( cube )
        
    renderEvo: (topo, n=9, distance=10) ->
      _.times n, (z) ->
#        console.log "---------------------------------------------"
        ret.render(topo, z * distance)
        topo := topo.next!
      
    renderSlowEvo: (topo, n=9, distance=10) -> 
      if not n then return
      topo = topo.next!
      ret.render(topo, n * distance)
      setTimeout((-> ret.renderSlowEvo(topo, n-1,distance)), 20)

  # camera.matrix.fromArray(JSON.parse("[0.9227011283338787,2.7755575615628914e-17,-0.3855160538439185,0,0.28421051939831177,0.6756517153840521,0.6802346214078856,0,0.2604745830877341,-0.7372209706041926,0.6234246001455855,0,1.6767722721522267,-6.296830734514615,24.380864892154904,1]"))
    
  return ret
