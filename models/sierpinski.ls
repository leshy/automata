require! {
  '../index.ls': { BlindTopology, CtxState, CtxCanvas, Sierpinski }
}

#   /\
#  /__\
# / \/ \
# ------

export Sierpinski = (ctx) ->
  
  A = (ctx) -> ctx.t x: -2, s: (/2),(ctx) ->
      ctx.t r: -60 , x: 1, (ctx) -> return
        B
        ctx.t r: 60, x: 1, (ctx) -> return
          A
          ctx.t r: 60, x: 1, (ctx) -> return
            B

  B = (ctx) -> ctx.t x: -2, s: (/2), (ctx) ->
      ctx.t r: 60, x: 1, (ctx) -> return
        A
        ctx.t r: -60, x: 1, (ctx) -> return
          B
          ctx.t r: -60, x: 1, (ctx) -> return
            A
            
  A ctx


export topology = new BlindTopology().set new CtxState(new CtxCanvas(x: 0, y: 3.25, s: 10, r: 0), Sierpinski)
