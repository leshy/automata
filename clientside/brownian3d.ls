require! {
  './three/turtle3d.ls': turtle
  '../models/brownian3d.ls': { topology }
}


export draw = ->
  { render, renderEvo } = turtle.draw(50)
  renderEvo topology, 28, 0
