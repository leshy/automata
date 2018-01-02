require! {
  assert
  livescript
  bluebird: p
  '../index.ls': { Field }
}

describe 'automata', -> 
  specify 'field init', -> 
    x = new Field()
    assert x.get([1,2,3]) is void
    y = x.set([1,2,3], 'bla')
    assert y.get([1,2,3]) is 'bla'
