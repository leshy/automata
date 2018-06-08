require! {
  leshdash: { weighted, map, random, sample }
  '../base.ls': { CtxState }
  '../topologies.ls': { NaiveTopology }
  '../contexts.ls': { CtxNaiveCoords }
}

      
cmod = 30

export Note = (ctx) -> [ Note ]
export Beat = (ctx) -> [ Note ]

export TwoBeats = (ctx) -> return
  Beat
  ctx.t note: -5, time: 1, sustain: 0.3, (ctx) -> Beat

export RandomBeat = (ctx) ->
  ret = []
  ret.push Beat
  if random(0, 1, true) < 0.7 then ret.push(ctx.t note: sample([3, -3]), time: 2, (ctx) -> RandomBeat)
  ret


export Tempo = (ctx) -> return
  weighted do
    [ 1, Note ]
    [ 1, RandomBeat ]
  ctx.t do
    time: 4
    -> Tempo

export Tempo2 = (ctx) -> return
  weighted do
     [ 1, Note ]
     [ 1, RandomBeat ]
  ctx.t do
    time: 2
    -> Tempo2

export class Topo extends NaiveTopology
  Ctx: CtxNaiveCoords

export getTopo = (ctx={}) ->
  x = new Topo()
  
  x.set do
    new CtxState({time: 0, note: 60, channel: 0, velocity: 10, sustain: 0.1 } <<< ctx, Tempo)
    new CtxState({time: 0, note: 65, channel: 0, velocity: 7, sustain: 0.1 } <<< ctx, Tempo2)
#    new CtxState({time: 0.6, note: 40, channel: 0, velocity: 10, sustain: 0.1 } <<< ctx, Tempo3)
  

