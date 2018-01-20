require! {
  './three/turtle3d.ls': turtle
  '../models/brownian3d.ls': { topology }
}

export draw = ->
  { render, renderEvo } = turtle.draw()
  renderEvo(topology, 15, 0)
