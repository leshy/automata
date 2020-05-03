require! {
  mqtt,
  # './models/tree3D.ls': { topology }
  # './models/tree.ls': { topology }
  './models/sierpinski.ls': { topology }
  # './models/brownian3d.ls': { topology }
  leshdash: { times }
  util: { inspect}
}

client  = mqtt.connect 'mqtt://localhost'
 
client.on 'connect', -> 
  # client.subscribe 'turtle3d'
  
  topo = topology
  client.publish 'turtle3d', JSON.stringify(cmd: 'reset')

  ping = -> 
    console.log 'TOPO', inspect(topo.serialize(), depth: 8)
    topo := topo.next!
    serialized = topo.serialize!
    if not serialized.length then
      clearInterval bla
    else
      client.publish 'turtle3d', JSON.stringify(cmd: 'data', data: serialized)

  startLoop = (speed=100, max=3) ->
    cnt = 0
    step = -> 
      cnt++
      if cnt > max
        return

      ping()
      setTimeout(step, speed)

    step()


  startLoop()
