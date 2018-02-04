require! {
  './three/general.ls': painter
  bluebird: p
  'lweb3/transports/client/engineio': lweb
  'lweb3/protocols/query': queryProtocol
  'lweb3/protocols/channel': channelProtocol
}

env = global.env = {}

global.draw = ->
  env.draw_promise()
  delete env.draw_promise

wait_document = -> new p (resolve,reject) ~>
  console.log 'waitdoc'
  env.draw_promise = resolve

connect = -> new p (resolve,reject) ~>
  console.log 'connect'
  env.lweb = new lweb.engineIoClient( host: "ws://" + window.location.host, verbose: false )
  env.lweb.addProtocol new queryProtocol.client( verbose: false )
  env.lweb.addProtocol new queryProtocol.server( verbose: false )
  env.lweb.addProtocol new channelProtocol.client( verbose: false )
  env.lweb.on 'connect', resolve

subscribe = -> new p (resolve,reject) ~>
  console.log 'subscribe'
  env.lweb.channel("broadcast").join()
  console.log "JOIN"
  resolve true

createApi = -> new p (resolve,reject) ~>
  console.log 'create api'
  
  { render, time } = painter.draw(20)
  
  env.lweb.channel("time").join (msg) ->
    time(msg.time)

  # env.lweb.onQuery { time: Number }, (msg, reply, realm) ->
  #   console.log "TIME", msg.time

  env.lweb.onQuery { render: true }, (msg, reply, realm) ->
    console.log 'render req', msg.render
    render msg.render
    reply.end { render: true }
  resolve true

broadcastReady = -> new p (resolve,reject) ~>
  console.log 'broadcast ready'
  env.lweb.query ready: true, (msg, reply) -> resolve!

p.all [ wait_document(), connect() ]
.then subscribe
.then createApi
.then broadcastReady
.then -> console.log 'done'
  
