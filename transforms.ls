require! {
  leshdash: { map, random }
  three: { Vector3, Vector2 }
}

# single value
export mapper = (f, value) --> map value, f
export randomWalk = (maxDelta, value) --> value + random(-maxDelta, maxDelta, true)

# context level
export turtle = do
  loc: (loc, { ctx: { dir, speed }  }) ->
    Vector = switch loc.length
      | 2 => Vector2
      | 3 => Vector3
      |_ _ => throw new Error "loc has #{loc.length} dimensions, can't build vector"

    (new Vector(...loc)).addScaledVector do
      (new Vector(...dir)).normalize(),
      speed
    .toArray()

export brownian = { dir: mapper(randomWalk(1)) } <<< turtle

