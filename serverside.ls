require! {
  fs
  leshdash: { times, mapFilter, head }
  util: { inspect }
  ribcage
  'backbone4000/extras': Backbone
}
  

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
    logger: env.logger.child!
    verbose: false

  env.lweb.addProtocol new queryProtocol.serverServer verbose: false, logger: false
  env.lweb.addProtocol new channelProtocol.serverServer verbose: false, logger: false
  
  env.lweb.on 'connect', (channel) -> channel.addProtocol new queryProtocol.client verbose: true
    
  require! {
#    sclink: { OscServer }
#    './models/wolfram1D.ls': { getRule }
    './models/tree3D.ls': { topology }
  }

#  oscServer = new OscServer()
  
  env.lweb.onQuery ready: true, (msg, reply, { client }) ->
    console.log 'starting topology'
    reply.end ok: true
    
    topo = topology
    
    ping = -> 
      topo := topo.next!
      serialized = topo.serialize!
      if not serialized.length then
        clearInterval bla
      else
        client.query render: serialized

    bla = setInterval ping, 100
    
    client.on 'end', ->
      console.log "CLIENT END"
      clearInterval bla
    # times 300, ->
    #   console.log topo.serialize!
    #   client.query { render: topo.serialize!, z: it }, (msg) -> console.log "render", msg
    #   topo := topo.next!




