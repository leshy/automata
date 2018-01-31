require! {
  './three/general.ls': painter
  '../models/breakcore.ls': { topology }
  leshdash: { times }
}

export draw = ->
  { render } = painter.draw(20)
  topo = topology
  times 50, -> topo := topo.next!
  render(topo)
