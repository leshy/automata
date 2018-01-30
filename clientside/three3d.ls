require! {
  './three/turtle3d.ls': turtle
  '../models/three3d.ls': { topology }
}


export draw = ->
  { render, renderEvo, renderSlowEvo, renderSlowSlice } = turtle.draw(5)
  renderEvo topology, 125, 1

