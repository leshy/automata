require! {
  './three/turtle3d.ls': turtle
  '../models/brownian3d.ls': { topology }
}

export draw = ->
  { render, renderEvo } = turtle.draw(10)
  renderEvo topology, 20, 0
