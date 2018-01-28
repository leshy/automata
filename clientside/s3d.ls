require! {
  './three/turtle.ls': turtle
  '../models/sierpinski.ls': { topology }
}

export draw = ->
  { render, renderEvo } = turtle.draw(10)
  renderEvo(topology, 8, 10)
  
