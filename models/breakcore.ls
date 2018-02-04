require! {
  leshdash: { weighted, map, random }
  '../base.ls': { CtxState }
  '../topologies.ls': { NaiveTopology }
  '../contexts.ls': { CtxNaiveCoords }
}

      
cmod = 30


export Beat = (ctx) -> [ Beat ]

export TwoBeats = (ctx) -> return
  Beat
  ctx.t time: 0.1, (ctx) -> Beat

export RandomBeat = (ctx) ->
  ret = []
  ret.push Beat
  if random(0, 1, true) < 0.7 then ret.push(ctx.t time: 0.1, (ctx) -> RandomBeat)
  ret


export Tempo = (ctx) -> return
  weighted do
    [ 1, Beat ]
    [ 1, TwoBeats ]
    [ 1, RandomBeat ]
  ctx.t do
    time: 0.5
    -> Tempo

export class Topo extends NaiveTopology
  Ctx: CtxNaiveCoords

export topology = new Topo().set new CtxState(time: 0, Tempo)
