require! {
  './models/absTree3D.ls': { topology }
  leshdash
}

swankjs = require("swank-js/client/node").setupNodeJSClient({})
global.i = require('util').inspect
global.t = topology
global.l = leshdash


