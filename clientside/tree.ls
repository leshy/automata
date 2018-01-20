require! {
  './three/turtle.ls': turtle
  '../models/tree.ls': { topology }
}

export draw = ->
  { render, renderEvo } = turtle.draw()
  renderEvo(topology, 10, 0)
