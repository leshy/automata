require! {
  leshdash: { pad, map, reduce, times }
  '../index.ls': { CtxState, CtxNaive, CtxNaiveCoords }
  '../topologies.ls': { DiscreteTopology }
}

toBinaryRule = -> (map pad((it.toString(2)), 8).split(''), -> if it != '0' then true else false).reverse()

interpretRule = (binaryRule, states) -->
  reduce do
    states,
    (total, state) -> total + Number(state)
    ''
  |> parseInt(_, 2)
  |> -> binaryRule[it]

binaryRule = toBinaryRule(30)

export class Topo extends DiscreteTopology
  Ctx: CtxNaiveCoords

# can get any rule
export getRule = (ruleDec) ->
  rule = toBinaryRule ruleDec

  placeChecks = (ctx) ->
    map [[-1], [1]], (coords) ->
      future = ctx.lookFuture(coords)
      if not future
        ctx.t { loc: coords }, (ctx) -> Check
        
  checkCtx = (ctx, prevState) ->
    states = map [ -1, 0, 1 ], ->
      if ctx.look([it])?state is On then true else false

    if interpretRule(rule, states)
      if prevState is On then return [On]
      else return [ placeChecks(ctx), On ]
    else
      if prevState is Check then return []
      else return [ placeChecks(ctx), Check ]

  On = -> checkCtx it, On
  Check = -> checkCtx it, Check
  
  new Topo()
    .set new CtxState({loc: [0]}, On)
    .set new CtxState({loc: [-1]}, Check)
    .set new CtxState({loc: [1]}, Check)
