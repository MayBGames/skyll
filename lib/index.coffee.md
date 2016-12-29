    fs     = require 'fs'
    path   = require 'path'
    Canvas = require 'canvas'

    cell       = width: 8 * 2, height: 7 * 2
    board      = cols: 500, rows: 50
    dimensions = width: cell.width * board.cols, height: cell.height * board.rows
    canvas     = new Canvas dimensions.width, dimensions.height
    ctx        = canvas.getContext '2d'

    pathfinders = [ ]
    to_delete = [ ]

    grid = ((false for j in [0..board.cols]) for i in [0..board.rows])

    directions =
      LEFT:  0
      RIGHT: 1
      UP:    2
      DOWN:  3

    current  = row: Math.floor(board.rows / 2), col: 0, direction: directions.RIGHT
    previous =
      row:       current.row
      col:       current.col
      direction: current.direction

    farthest_right = current.col

    direct_me = (options) ->
      chance = Math.random()

      for o in options
        return Object.keys(o)[0] if o[Object.keys(o)[0]] > chance

    neighoring_cell = (x = 0, y = 0) ->
      grid[pathfinder.current.row + x][pathfinder.current.col + y]

    walk = (pathfinder, index) ->
      neighbors = [ ]
      direction = undefined

      if pathfinder.current.row > 0 && neighoring_cell(-1, 0) == false
        neighbors.push 'UP'

      if pathfinder.current.row < board.rows - 1 && neighoring_cell(1, 0) == false
        neighbors.push 'DOWN'

      if pathfinder.current.col > 0 && neighoring_cell(0, -1) == false
        neighbors.push 'LEFT'

      if pathfinder.current.col < board.cols && neighoring_cell(0, 1) == false
        neighbors.push 'RIGHT'

      if neighbors.length > 0
        options = [ ]

        for n in [1..(neighbors.length / 1)]
          multiplier = 1 / neighbors.length
          if neighbors[n - 1] == 'RIGHT'
            options.push "#{neighbors[n - 1]}": ((multiplier * n) * ((2 / multiplier) * 0.5)) * multiplier
          else
            options.push "#{neighbors[n - 1]}": ((multiplier * n) * (0.5 / multiplier)) * multiplier

        direction = direct_me options
      else
        if direction != 'RIGHT'
          direction = 'RIGHT'
        else
          direction == undefined

      switch directions[direction]
        when directions.RIGHT
          grid[pathfinder.current.row][++pathfinder.current.col] = true
          farthest_right = pathfinder.current.col if pathfinder.current.col > farthest_right
          if pathfinder.previous.direction == directions.RIGHT
            ++pathfinder.steps
          else
            pathfinder.steps = 0
        when directions.LEFT
          grid[pathfinder.current.row][--pathfinder.current.col] = true
          if pathfinder.previous.direction == directions.LEFT
            ++pathfinder.steps
          else
            pathfinder.steps = 0
        when directions.UP
          grid[--pathfinder.current.row][pathfinder.current.col] = true
          pathfinders.push
            current: pathfinder.current
            previous:
              row:       pathfinder.current.row
              col:       pathfinder.current.col
              direction: pathfinder.current.direction
            steps: 0
          if Math.random() < 0.5 && pathfinders.length > 1
            to_delete.push index
          else
            if pathfinder.previous.direction == directions.UP
              ++pathfinder.steps
            else
              pathfinder.steps = 0
        when directions.DOWN
          grid[++pathfinder.current.row][pathfinder.current.col] = true
          pathfinders.push
            current: pathfinder.current
            previous:
              row:       pathfinder.current.row
              col:       pathfinder.current.col
              direction: pathfinder.current.direction
            steps: 0
          if Math.random() < 0.5 && pathfinders.length > 1
            to_delete.push index
          else
            if pathfinder.previous.direction == directions.DOWN
              ++pathfinder.steps
            else
              pathfinder.steps = 0

      pathfinder.previous =
        row:       pathfinder.current.row
        col:       pathfinder.current.col
        direction: pathfinder.current.direction

    pathfinders.push current: current, previous: previous, steps: 0

    grid[current.row][current.col] = true

    while pathfinders.length > 0 && farthest_right < board.cols
      for pathfinder, i in pathfinders
        if pathfinder?.current?.col < board.cols
          walk pathfinder, i

      to_delete
        .sort()
        .reverse()
        .forEach (d) -> to_delete.splice d, 1

      to_delete = [ ]

    for row, r in grid
      for col, c in row
        if col == false
          ctx.beginPath()
          ctx.rect cell.width * c, cell.height * r, cell.width, cell.height
          ctx.fillStyle = 'black'
          ctx.fill()
          ctx.lineWidth = 1
          ctx.strokeStyle = 'black'
          ctx.stroke()

    canvas
      .createPNGStream()
      .pipe fs.createWriteStream path.join __dirname, 'test.png'

    module.exports = {}
