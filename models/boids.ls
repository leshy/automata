require! {
  leshdash: { sample, map, weighted, times, zip }
  '../index.ls': { CtxState, CtxCanvas }
  '../topologies.ls': { DistanceToplogy }
  '../contexts.ls': { CtxNaive }
  '../transforms.ls': { randomTurtle }
}

export class Topo extends DistanceToplogy
  Ctx: CtxNaive


export topology = new Topo().set new CtxState do
  {dir: [0,0,0], loc: [0,0,0], speed: 1, size: 1},
  Boid


