require! {
  './models/absTree3D.ls': { topology }
  leshdash: { abs } 
  supercolliderjs: { msg, map }: sc
}
ServerPlus = require('supercolliderjs/lib/server/ServerPlus.js').default


swankjs = require("swank-js/client/node").setupNodeJSClient({})
global.i = require('util').inspect
global.t = topology
