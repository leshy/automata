require! { three: { Vector3, Vector2 } }

export turtle = do
  loc: (loc, { ctx: { dir, speed } }) ->
    Vector = switch loc.length
      | 2 => Vector2
      | 3 => Vector3
      |_ _ => throw new Error "loc has #{loc.length} dimensions, can't build vector"

    (new Vector(...loc)).addScaledVector do
      (new Vector(...dir)).normalize(),
      speed
    .toArray()
