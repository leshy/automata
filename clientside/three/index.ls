require! {
  leshdash: { times }: _
  three: THREE
}

OrbitControls = require('three-orbit-controls')(THREE)
EffectComposer = require('three-effectcomposer')(THREE)

export getscene = (distance, cb) ->
  if not cb
    cb = distance
    distance = 20
    
  renderer = new THREE.WebGLRenderer( antialias: true );
  renderer.setClearColor( 0x202020 );
  renderer.setSize( window.innerWidth, window.innerHeight );
  document.body.appendChild( renderer.domElement );

  scene = new THREE.Scene();
#  scene.fog = new THREE.Fog( 0x59472b, 1000, 3000 );
#  scene.add new THREE.GridHelper( 100, 10 );
  
  light = new THREE.AmbientLight( 0xaaaaaa );
  scene.add( light );
  

  camera  = window.camera = new THREE.OrthographicCamera( -70, 4, 1, 100)
#  camera  = window.camera = new THREE.PerspectiveCamera( 70, window.innerWidth / window.innerHeight, 1, 100 );
  camera.position.set( 0, 0, distance );
#  camera.lookAt(new THREE.Vector3( 0, 0, -1 ))

  controls = new OrbitControls( camera, renderer.domElement );
  controls.enableDamping = false
  controls.dampingFactor = 0.25;
  controls.enableZoom = true;
  controls.enableRotate = true;
  controls.target = new THREE.Vector3( 0, 0, 0 )

  composer = false

  ret = cb({ scene, camera, controls, renderer })

  shaders = -> 
    DotScreenShader = require('./shaders/DotScreenShader')
    RGBShiftShader = require('./shaders/RGBShiftShader')

    composer := new EffectComposer( renderer );
    composer.addPass( new EffectComposer.RenderPass( scene, camera ) );

    effect = new EffectComposer.ShaderPass( DotScreenShader );
    effect.uniforms.scale.value = 4;
    composer.addPass( effect );

    effect = new EffectComposer.ShaderPass( RGBShiftShader );
    effect.uniforms.amount.value = 0.0015;
    effect.renderToScreen = true;
    composer.addPass( effect );

#  shaders!

  render = ->
    requestAnimationFrame render
    controls.update()
    renderer.render scene, camera
    if composer then composer.render();

  render!
  return ret


