require! {
  leshdash: { map, random }
  three: { Vector3, Vector2 }
}

# single value
export mapper = (f, value) --> map value, f

export brownian = (maxDelta, value) --> value + random(-maxDelta, maxDelta, true)

# context aware
export turtle = do
  pos: (pos, { ctx: { dir, size }  }) ->
    Vector = switch pos.length
      | 2 => Vector2
      | 3 => Vector3
      |_ _ => throw new Error "pos has #{pos.length} dimensions, can't build vector"

    (new Vector(...pos)).addScaledVector do
      (new Vector(...dir)).normalize(),
      size
    .toArray()

export randomTurtle = { dir: mapper(brownian(1)) } <<< turtle

