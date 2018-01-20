require! {
  './three/turtle.ls': turtle
  '../models/sierpinski.ls': { topology }
}

export draw = ->
  { render, renderEvo } = turtle.draw()
  renderEvo(topology, 5)
      
  
