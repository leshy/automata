require! { ribcage }

settings = do
  verboseInit: true
  module:
    express4:
      port: 8181
      static: 'static'
      views: 'ejs'

env = { settings: settings }

ribcage.init env, (err, env) ->
  console.log "init done", err
  
  lweb = require 'lweb3/transports/server/engineio'
  queryProtocol = require 'lweb3/protocols/query'
  channelProtocol = require 'lweb3/protocols/channel'

  env.app.get '/', (req,res) ->
    res.render 'index', { }

  env.lweb = new lweb.engineIoServer do
    name: 'eio'
    http: env.http
    logger: env.logger.child()

  env.lweb.addProtocol new queryProtocol.serverServer verbose: false, logger: false
  env.lweb.addProtocol new channelProtocol.serverServer verbose: false, logger: false

  broadcast = env.lweb.channel('broadcast')
    
  env.lweb.on 'connect', (channel) ->
    channel.addProtocol new queryProtocol.client( verbose: true )
    channel.query sping: true, (msg, end) -> console.log "MSG", msg

  setInterval (-> broadcast.broadcast({t: new Date().getTime()})), 1000
