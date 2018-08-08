require! {
  fs
  leshdash: { times }
  ribcage
  'backbone4000/extras': Backbone
  './index.ls': { Topology }
}
  
require! { './models/tree.ls': { topology } }

settings = do
  verboseInit: true
  module:
    express4:
      port: 9966
      static: 'static'
      views: 'ejs'

env = { settings: settings }

ribcage.init env, (err, env) ->
  console.log String fs.readFileSync "motd"
  
  lweb = require 'lweb3/transports/server/engineio'
  queryProtocol = require 'lweb3/protocols/query'
  channelProtocol = require 'lweb3/protocols/channel'

  env.app.get '/', (req,res) ->
    res.render 'index', { }

  env.lweb = new lweb.engineIoServer do
    name: 'eio'
    http: env.http
    logger: env.logger.child()
    verbose: false

  env.lweb.addProtocol new queryProtocol.serverServer verbose: false, logger: false
  env.lweb.addProtocol new channelProtocol.serverServer verbose: false, logger: false
  
  env.lweb.on 'connect', (channel) ->
    channel.addProtocol new queryProtocol.client( verbose: true )


  # env.time = 0
  # env.last_time = new Date().getTime()
  
  # setInterval do
  #   ->
  #     now = new Date().getTime()
  #     diff = (now - env.last_time) / 1000
  #     env.last_time = now
  #     env.time += diff
  #     if env.time > 20 then env.time -= 20
  #     env.lweb.channel('time').broadcast time: env.time
  #   50
    

  # env.lweb.onQuery ready: true, (msg, reply, { client }) ->
  #   reply.end ok: true
  #   client.query { time: 0 }
  #   topo = topology
  #   times 50, ->
  #     console.log topo.serialize!
  #     client.query { render: topo.serialize!, z: it }, (msg) -> console.log "render", msg
  #     topo := topo.next!



