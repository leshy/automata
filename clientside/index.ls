require! {
  bluebird: p
  './three/turtle.ls': painter
  mqtt
}

env = global.env = {}

wait_document = -> new p (resolve,reject) ~>
  console.log 'waitdoc'
  env.draw_promise = resolve

connect = -> new p (resolve,reject) ~>
  env.client = mqtt.connect('ws://localhost:8080')
  env.client.on 'connect', ->
    console.log 'connect'
    resolve()
    
  env.client.on 'error', console.log
  

p.all [ connect() ]
.then (data) ->
  { render, time, reset } = painter.draw(20)

  env.client.subscribe 'turtle3d', (err) ->
    console.log 'subscribe', err
  
  env.client.on 'message', (topic, message) ->
    parsed = JSON.parse(message.toString())
    # console.log parsed.cmd
    switch parsed.cmd
     | 'data' => render parsed.data, (parsed.z or 0)
     | 'reset' => reset()
    
      

