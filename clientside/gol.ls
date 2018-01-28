require! {
  './three/discrete2d.ls': discrete
  '../models/golsketch.ls': { topology }
}


export draw = ->
  { render, renderEvo } = discrete.draw(20)
  renderEvo topology, 15, 1
