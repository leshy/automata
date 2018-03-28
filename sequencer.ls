require! {
  midi
  leshdash: { times, wait, each }
  'backbone4000/extras': Backbone
}

Note = Backbone.Model.extend4000 do
  initialize: -> @ <<< it
  inspect: -> "Note(#{@note}, #{@velocity}, #{@sustain})"
  play: (player, channel=0) ->
    player.midiOut [ 144 + channel, @note, @velocity or 127 ]
    setTimeout do
      (~> player.midiOut [ 128 + channel, @note, 0 ])
      (@sustain or 1) * 1000
    
Seq = Backbone.Model.extend4000 do

  tempo: void
  
  inspect: ->
    "seq(#{@channel})"

  show: ->
    each @notes, ->
      console.log it
    
  initialize: ({ topo, channel=0 }) ->
    @channel = channel
    @index = 0
    
    makeNote = ({ ctx, state }) ~> 
      if state.name isnt "Note" then false
      else [ ctx.time, new Note(ctx{sustain, note, velocity}) ]
    
    @notes = topo.rawReduce [], (total, ctxState) ->
      if not newNote = makeNote(ctxState) then total
      else [ ...total, newNote ]

  play: (player) ->
    if @notes.length - 1 is @index then
      @index = 0
      @lastTime = 0
    else
      @index += 1
    @lastTime = @lastTime or 0

    [ time, note ] = @notes[@index]
    console.log "TIME", time, "NOTE", note
    
    setTimeout do
      (~>
        @play player
        note.play player, @channel)
      ((time - @lastTime) * 1000)

    @lastTime = time

                                
Sequencer = Backbone.MotherShip('seq').extend4000 do
  seqClass: Backbone.Model


Looper = Backbone.MotherShip('seq').extend4000 do
  seqClass: Seq
  initialize: ->
    @input = new midi.input()
    @output = new midi.output()
    
    @input.on 'message', (deltaTime, message) ~>
      console.log('m:' + message + ' d:' + deltaTime)
      @output.sendMessage message

    @input.openVirtualPort("Looper IN")
    @output.openVirtualPort("Looper OUT")


Player = Backbone.Model.extend4000 do
  initialize: -> 
    @output = new midi.output()
#    @output.openVirtualPort("Automata OUT")
    @output.openPort(0)
    
  midiOut: (msg) ->
    console.log "MIDIOUT", msg
    @output.sendMessage msg

require! { './models/breakcore.ls': { getTopo } }

looper = new Looper()

# topo = getTopo()
# times 50, -> topo := topo.next!
# seq1 = new Seq(channel: 0, topo: topo)

#seq1.show()

# topo = getTopo(note: 30, sustain: 0.5)
# times 50, -> topo := topo.next!

# seq2 = new Seq(topo: topo)

#player = new Player()
#seq1.play player
#seq2.play player
