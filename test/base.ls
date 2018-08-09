require! {
  assert
  util: { inspect }
  lodash: { map, random }
  '../index.ls': { NaiveTopology, CtxState, Ctx3DTurtle }
  '../transforms.ls': { turtle }
}


describe 'base', ->
  specify 'turtle tree 2D', ->
    Branch = (ctx) ->
      ctx.t { dir: (map _, (val, index) -> val + index )} <<< turtle,
      -> Branch
    
    topo = new NaiveTopology().set new CtxState({loc: [0,0], dir: [0,0], speed: 1, size: 1}, Branch)
    topo = topo.iterate 3

    assert.deepEqual do
      topo.serialize!
      [ [ { loc: [ 0, 2 ], dir: [ 0, 3 ], speed: 1, size: 1 }, 'Branch' ] ]
      
  specify 'turtle tree 3D', ->
    Branch = (ctx) ->
      ctx.t { dir: (map _, (val, index) -> val + index )} <<< turtle,
      -> Branch
    
    topo = new NaiveTopology().set new CtxState({loc: [0,0,0], dir: [0,0,0], speed: 1, size: 1}, Branch)
    topo = topo.iterate 3

    assert.deepEqual do
      topo.serialize!
      [ [ { loc: [ 0, 0.8944271909999159, 1.7888543819998317 ], dir: [ 0, 3, 6 ], speed: 1, size: 1 }, 'Branch' ] ]

  specify 'wolfram', ->

    require! { '../models/wolfram1D.ls': { getRule } }
    topology = getRule(30)
#    console.log topology
    console.log topology.iterate(10)
    
