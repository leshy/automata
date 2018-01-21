require! {
  './three/discrete2d.ls': discrete
  '../models/gol.ls': { topology }
}


export draw = ->
  { render, renderEvo } = discrete.draw(20)
  renderEvo topology, 2, 0
