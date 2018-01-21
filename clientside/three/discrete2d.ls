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
        material = new THREE.LineBasicMaterial color: new THREE.Color("rgb(#{ctx.data.cr}, #{ctx.data.cg}, #{ctx.data.cb})")

        scale = 1
        
        cube = new THREE.Mesh( new THREE.BoxGeometry(1,1,1), material );
        cube.position.x = ctx.data.loc[0]
        cube.position.y = ctx.data.loc[1]
        cube.position.z = z
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
