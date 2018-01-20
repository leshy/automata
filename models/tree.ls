require! {
  leshdash: { random, sample }
  '../index.ls': { BlindTopology, CtxState, CtxCanvas, Sierpinski }
}

export Branch = (ctx) ->  
  ctx.t r: random(-50, 50), s: (*0.9), x: 1, ->
    sample [
      [ Branch, Branch ],
      Branch,
    ]

export topology = new BlindTopology().set new CtxState(new CtxCanvas(x: 0, y: 0, s: 1, r: 90), Branch)
