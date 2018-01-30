require! {
  './three/discrete2d.ls': discrete
  '../models/gol.ls': { topology }
}


export draw = ->
  { render, renderEvo, renderSlowSlice } = discrete.draw(3)
  renderEvo topology, 300, 1

