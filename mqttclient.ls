require! {
  mqtt,
  './models/tree3D.ls': { topology }
}

client  = mqtt.connect 'mqtt://localhost'
 
client.on 'connect', -> 
  client.subscribe 'turtle3d'
  
  topo = topology
  client.publish 'turtle3d', JSON.stringify(cmd: 'reset')

  ping = -> 
    topo := topo.next!
    serialized = topo.serialize!
    if not serialized.length then
      clearInterval bla
    else
      client.publish 'turtle3d', JSON.stringify(cmd: 'data', data: serialized)

  bla = setInterval ping, 100


