require! {
  './three/turtle3d.ls': turtle
  '../models/tree3d.ls': { topology }
}

export draw = ->
  { render, renderEvo } = turtle.draw()
  renderEvo(topology, 35, 0)
