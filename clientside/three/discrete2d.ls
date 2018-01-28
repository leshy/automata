require! {
  leshdash: { times }: _
  three: THREE
  './index.ls': { getscene }
}


export draw = (distance) -> getscene distance, ({scene, camera, controls}) ->
  
  ret = do
    render: (topo, z=0) ->
      topo.map (ctxState) ->
        { ctx, state } = ctxState
        
        if state.name == "Check"
          return

        scale = 1
        material = new THREE.LineBasicMaterial color: new THREE.Color("rgb(#{ctx.cr or 255}, #{ctx.cg or 255}, #{ctx.cb or 255})")
        if state.name == "Check"
          material.transparent = true;
          material.opacity = 0.2;

        cube = new THREE.Mesh( new THREE.BoxGeometry(1,1,1), material );
        
        cube.position.x = ctx.loc[0]
        cube.position.y = ctx.loc[1]
        cube.position.z = z
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

    
  return ret
