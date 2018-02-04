require! {
  leshdash: { times }
  ribcage,
  fs
}
  
require! { './models/breakcore.ls': { topology } }

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

  broadcast = env.lweb.channel('broadcast')
  env.broadcast = broadcast

  
  env.lweb.on 'connect', (channel) ->
    channel.addProtocol new queryProtocol.client( verbose: true )
#    channel.query sping: true, (msg, end) -> console.log "MSG", msg

  env.lweb.onQuery ready: true, (msg, reply, { client }) ->
    reply.end ok: true
    
    topo = topology
    times 50, -> topo := topo.next!

    client.query { render: topo.serialize! }, (msg) -> console.log "render", msg
    client.query { time: 0 }



#  setInterval (-> broadcast.broadcast({t: new Date().getTime()})), 60000


  
