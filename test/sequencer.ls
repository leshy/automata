require! {
  lodash: { map }
  assert
  livescript
  bluebird: p
  '../sequencer.ls': { Sequencer, Sequence, Event, Note }
}

describe 'Sequencer', ->
  
  specify 'Event', ->
    try
      A = new Event(22)
    catch
      B = new Event bla: 22
      assert.equal B.bla, 22
    
  specify 'Note', ->
    A = new Note(22)
    assert.equal A.note, 22
    
    B = new Note note: 75, velocity: 123, sustain: 1
    assert.equal B.note, 75
    assert.equal B.velocity, 123
    assert.equal B.sustain, 1


  specify 'Sequence', ->
    notes = map [ 1, 2, 3, 4 ], -> new Note(it)
    seq = new Sequence(notes)

  specify 'Sequencer', -> new p (resolve,reject) ~> 
    notes = map [ 1, 2, 3, 4 ], -> new Note(it)
    seq = new Sequence(notes)

    console.log 'iterating seq'
    for el in [...seq]
      console.log el
    # s = new Sequencer(seq)
    # s.play()
    
