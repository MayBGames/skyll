    randomIn = (r) => Math.random() * (r.max - r.min) + r.min

    roundedRandomIn = (r) => Math.round randomIn r

    render_cube = ({ x, y, width, height }) ->
      left   = [ ]
      top    = [ ]
      right  = [ ]
      bottom = [ ]
      front  = [ ]
      back   = [ ]

      left.push [ x, y,          0 ]
      left.push [ x, y + height, 0 ]
      left.push [ x, y + height, 1 ]
      left.push [ x, y + height, 1 ]
      left.push [ x, y,          1 ]
      left.push [ x, y,          0 ]

      top.push [ x,         y + height, 0 ]
      top.push [ x + width, y + height, 0 ]
      top.push [ x + width, y + height, 1 ]
      top.push [ x + width, y + height, 1 ]
      top.push [ x,         y + height, 1 ]
      top.push [ x,         y + height, 0 ]

      right.push [ x + width, y + height, 0 ]
      right.push [ x + width, y,          0 ]
      right.push [ x + width, y,          1 ]
      right.push [ x + width, y,          1 ]
      right.push [ x + width, y + height, 1 ]
      right.push [ x + width, y + height, 0 ]

      bottom.push [ x + width, y, 0 ]
      bottom.push [ x,         y, 0 ]
      bottom.push [ x,         y, 1 ]
      bottom.push [ x,         y, 1 ]
      bottom.push [ x + width, y, 1 ]
      bottom.push [ x + width, y, 0 ]

      front.push [ x,         y,          1 ]
      front.push [ x,         y + height, 1 ]
      front.push [ x + width, y + height, 1 ]
      front.push [ x + width, y + height, 1 ]
      front.push [ x + width, y,          1 ]
      front.push [ x,         y,          1 ]

      back.push [ x,         y,          0 ]
      back.push [ x + width, y,          0 ]
      back.push [ x + width, y + height, 0 ]
      back.push [ x + width, y + height, 0 ]
      back.push [ x,         y + height, 0 ]
      back.push [ x,         y,          0 ]

      { left, top, right, bottom, front, back }

    render_pass = (i, x, y, wdth, step, faces) ->
      args =
        x:      x + ((i + 1) * wdth)
        y:      y
        width:  wdth
        height: step * (i + 1)

      cube = render_cube args
      keys = Object.keys faces

      for k in keys
        for f in cube[k]
          faces[k].push f

    delegates =
      ground:    ({ x, y, width, height }) -> render_cube { x, y, width, height }
      stairs_up: ({ x, y, width, height }) ->
        faces =
          left:   [ ]
          top:    [ ]
          right:  [ ]
          bottom: [ ]
          front:  [ ]
          back:   [ ]

        max = Math.ceil width / height
        min = Math.ceil max   / 2

        wdth      = Math.ceil width / max
        step      = roundedRandomIn { min, max }
        remainder = width % wdth

        iterations = Math.floor width / wdth
        i          = 0

        while i < iterations
          render_pass i, x, y, wdth, step, faces
          ++i

        if remainder > 0
          render_pass i, x, y, remainder, step, faces

        faces

    module.exports = delegates
