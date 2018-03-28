require! {
  assert
  livescript
  bluebird: p
  '../base.ls': { NaiveTopology, CtxState, Ctx }
}

describe 'Automata', ->
  
  specify 'basic', ->
    t = new NaiveTopology()

    testState = (ctx) -> return
      ctx.t x: 10, (ctx) -> testState
      ctx.t x: -11, (ctx) -> testState

    seed = new CtxState({x: 1}, testState)
    assert t.data.size is 0

    t = t.set seed
    assert.deepEqual t.toObject!, [
      [ { x: 1 }, 'testState' ]
    ]

    t = t.next!
    assert.deepEqual t.toObject!, [
      [ { x: 11 }, 'testState' ],
      [ { x: -10 }, 'testState' ]
    ]
    
    t = t.next!
    assert.deepEqual t.toObject!, [
      [ { x: 21 }, 'testState' ],
      [ { x: 0 }, 'testState' ],
      [ { x: 0 }, 'testState' ],
      [ { x: -21 }, 'testState' ]
    ]


  specify 'deep', ->
    t = new NaiveTopology()

    testState = (ctx) ->
      ctx.t x: 10, (ctx) -> return
          testState
          ctx.t x: -1, (ctx) -> testState

    seed = new CtxState({x: 3}, testState)
    assert t.data.size is 0

    t = t.set seed
    assert.deepEqual t.toObject!, [
      [ { x: 3 }, 'testState' ]
    ]

    t = t.next!
    assert.deepEqual t.toObject!, [
      [ { x: 13 }, 'testState' ],
      [ { x: 12 }, 'testState' ]
    ]

    t = t.next!
    assert.deepEqual t.toObject!, [
      [ { x: 23 }, 'testState' ],
      [ { x: 22 }, 'testState' ],
      [ { x: 22 }, 'testState' ],
      [ { x: 21 }, 'testState' ]
    ]

