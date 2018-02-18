require! {
  leshdash: { weighted, map, random }
  '../base.ls': { CtxState }
  '../topologies.ls': { NaiveTopology }
  '../contexts.ls': { CtxNaiveCoords }
}

      
cmod = 30

export Note = (ctx) -> [ Note ]
export Beat = (ctx) -> [ Note ]

export TwoBeats = (ctx) -> return
  Beat
  ctx.t note: -5, time: 0.1, sustain: 0.3, (ctx) -> Beat

export RandomBeat = (ctx) ->
  ret = []
  ret.push Beat
  if random(0, 1, true) < 0.7 then ret.push(ctx.t note: 5, time: 0.1, (ctx) -> RandomBeat)
  ret


export Tempo = (ctx) -> return
  weighted do
    [ 1, Beat ]
    [ 1, RandomBeat ]
  ctx.t do
    time: 0.3
    -> Tempo

export class Topo extends NaiveTopology
  Ctx: CtxNaiveCoords

export getTopo = (ctx={}) ->
  new Topo().set new CtxState({time: 0, note: 70, channel: 0, velocity: 1, sustain: 0.2 } <<< ctx, Tempo)

