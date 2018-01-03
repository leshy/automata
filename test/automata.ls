require! {
  assert
  livescript
  bluebird: p
  '../index.ls': { Space, State }
}

describe 'automata', -> 
  specify 'space init', -> 
    x = new Space()
    assert x.get([1,2,3]) is void
    
    y = x.set([1,2,3], 'bla')
    assert y.get([1,2,3]) is 'bla'

  specify 'space fill and iterate', -> 
    space = new Space()
    space = space.set([1,2,3], 'bla1')
    space = space.set([1,1,1], 'bla2')
    space = space.set([1,0,1], 'bla3')

    assert.deepEqual do
      Array.from(space.states())
      [ [ '1-2-3', 'bla1' ], [ '1-1-1', 'bla2' ], [ '1-0-1', 'bla3' ] ]

  specify 'space next', -> 
    space = new Space()
    space = space.set([1,2,3], new State('bla1'))
    space = space.set([1,1,1], new State('bla2'))
    space = space.set([1,0,1], new State('bla3'))
    space = space.next()
    
    assert.deepEqual do
      space.toJSON(),
      { '1-2-3': "State", '1-1-1': "State", '1-0-1': "State" }



