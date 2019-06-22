require! {
  './models/absTree3D.ls': { topology }
  leshdash: { abs, keys } 
  supercolliderjs: { msg, map }: sc
}

class Synth
  (@server, @name, @opts={}) ->
    @id = 1000 + Math.round((Math.random() * 1000))
    val = @server.send.msg msg.synthNew(@name, @id, msg.AddActions.TAIL, 0, { freq: 1})
      
  set: (opts={}) ->
    @server.send.msg msg.nodeSet @id, opts
    @opts <<< opts
    
  free: ->
    @server.send.msg msg.nodeFree @id

ServerPlus = require('supercolliderjs/lib/server/ServerPlus.js').default

new ServerPlus().connect()
.then (server) ->
#  x = new Synth server, 'ghosts', freq: 1, amp: 0.2
#  saw = new Synth server, 'sawSynth'
#
  synths = {}
  
  plop = -> 
    topology := topology.next()
    topology.data.map (branch) ->
      freq = Math.abs(100 + Math.floor(branch.ctx.loc[1] * 100))
      val1 = Math.abs(10 + Math.floor(branch.ctx.loc[0] * 100))
      val2 = Math.abs(10 + Math.floor(branch.ctx.loc[2] * 100))
      index = branch.ctx.index
      
      if freq < 1000
        if not synths[index]
          synths[index] = new Synth server, 'sawSynth2'
          
        synths[index].set freq: freq, amp: 1 / keys(synths).length#, lofreq = val1, hifreq = val1 + val2
        console.log index, freq: freq, amp: 1 / keys(synths).length
      else
        if synths[index]
          synths[index].free()
          delete synths[index]

  setInterval plop, 100

