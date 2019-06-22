require! {
  './models/absTree3D.ls': { topology }
  leshdash: { abs } 
  supercolliderjs: { msg, map }: sc
}

class Synth
  (@server, @name, @opts) ->
    console.log 'init synth', @name
    @server.send.msg msg.synthNew do
      @name
      @id = server.state.nextNodeID() + 1000 + Math.round(Math.random() * 100)
      @server.send.msg msg.nodeFree @id
      msg.AddActions.TAIL
      0
      @opts
      
  set: (opts) -> 
    @server.send.msg msg.nodeSet @id, opts
    @opts <<< opts
    
  free: ->
    @server.send.msg msg.nodeFree @id

ServerPlus = require('supercolliderjs/lib/server/ServerPlus.js').default

new ServerPlus().connect()
.then (server) ->
  x = new Synth server, 'ghosts', freq: 1, amp: 0.2
  y = new Synth server, 'ghosts', freq: 1, amp: 0.2
  z = new Synth server, 'overkill', freq: 1, amp: 0.2
  saw = new Synth server, 'sawSynth'
  plop = -> 
    topology := topology.next()
    freq = Math.abs(1 + Math.floor(topology.data.get(0).ctx.loc[0] * 100))
    x.set freq: freq
    console.log freq
    freq = Math.abs(1 + Math.floor(topology.data.get(0).ctx.loc[1] * 100))
    y.set freq: freq
    console.log freq
    freq = Math.abs(1 + Math.floor(topology.data.get(0).ctx.loc[2] * 10))
    z.set freq: freq
    console.log freq, ''

  setInterval plop, 100

