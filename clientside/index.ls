lweb = require 'lweb3/transports/client/engineio'
queryProtocol = require 'lweb3/protocols/query'
channelProtocol = require 'lweb3/protocols/channel'

env = global.env = {}

env.lweb = lweb = new lweb.engineIoClient( host: "ws://" + window.location.host, verbose: false )

lweb.addProtocol new queryProtocol.client( verbose: false )
lweb.addProtocol new queryProtocol.server( verbose: false )
lweb.addProtocol new channelProtocol.client( verbose: false )

lweb.onQuery { sping: true }, (msg,reply,realm) -> reply.end { spong: msg.sping }
lweb.channel("broadcast").join -> console.log "broadcast received", it

global.draw = require('./breakcore.ls').draw
  

