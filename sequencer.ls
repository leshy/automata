require! {
  midi
  leshdash: { times, wait, each, sortBy, find, intersection }
  'backbone4000/extras': Backbone
}

export Event = Backbone.Model.extend4000 do
  initialize: (data) ->
    @ <<< switch data?@@
      | Object => data
      | void => {}
      | _ => { "#{@mainproperty or throw 'mainproperty undefined for event class'}": data }

export Note = Event.extend4000 do
  mainproperty: 'note'
  velocity: 1
  sustain: 1
  inspect: (depth, opts) -> "N(#{@note}, #{@velocity}, #{@sustain})"

bla = 'lala'

# holds events in some order with some abstract distance between them
export Sequence = Backbone.Model.extend4000 do
  initialize: (@events) -> true
Sequence::[Symbol.iterator] = ->*
  yield from @events

export Midi = Backbone.Model.extend4000 do
  initialize: -> 
    @output = new midi.output()
#    @output.openVirtualPort("Automata OUT")
    @output.openPort(0)
    
  midiOut: (msg) ->
    @output.sendMessage msg

# plays sequences
export Sequencer = Backbone.Model.extend4000 do
  tempo: 1/8
  initialize: (...sequences) ->
    @sequences = sequences
    
  play: -> @start()

  start: (position=0) ->
    setInterval (~> @beat(position++)), @tempo * 1000

  beat: (n) ->
    console.log 'beat', n
    each @sequences, ->
      console.log it.get(n)
    

# StandardInterpreter = (state, defaultNote) ->
#   if not state.note or not state.time then return false
#   else return [ state.time, new Note(defaultNote <<< state{sustain, note, velocity}) ]

# # turn a topology into a sequence of notes
# InterpretTopology = (topology, interpreter=StandardInterpreter) ->
#   topo.rawReduce [], (total, state) ->
#     if not seqNote = interpreter(state) then return total
#     return [ ...total, seqNote ]

# Sequencer = Backbone.MotherShip('seq').extend4000 do
#   seqClass: Backbone.Model

# Looper = Backbone.MotherShip('seq').extend4000 do
#   seqClass: Sequence
#   initialize: ->
#     @input = new midi.input()
#     @output = new midi.output()
    
#     @input.on 'message', (deltaTime, message) ~>
#       console.log('m:' + message + ' d:' + deltaTime)
#       @output.sendMessage message

#     @input.openVirtualPort("Looper IN")
#     @output.openVirtualPort("Looper OUT")


# # require! { './models/breakcore.ls': { getTopo } }

# # looper = new Looper()
# # topo = getTopo()
# # times 150, -> topo := topo.next!
# # seq1 = new Seq(channel: 0, topo: topo)
# # seq1.show()

# # # topo = getTopo(note: 30, sustain: 0.5)
# # # times 50, -> topo := topo.next!

# # # seq2 = new Seq(topo: topo)

# # player = new Player()
# # seq1.play player

# # #seq2.play player

