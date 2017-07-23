    Madul = require 'madul'

    DIRECTIONS =
      LEFT:  0
      RIGHT: 1
      UP:    2
      DOWN:  3

    class Carver extends Madul

      carve_path: (pathfinder, height, width, done) ->
        grid = ((false for j in [0..width]) for i in [0..height])

        starting_row   = Math.floor grid.length / 2
        row            = starting_row
        col            = 0
        farthest_right = { row, col }
        more_to_carve  = true
        path           = [ farthest_right ]

        grid[row][col] = true

        while more_to_carve
          neighbors = [ ]
          width     = grid[0].length
          height    = grid.length

          neighbors.push 'UP'    if row > 0          && grid[row - 1][col] == false
          neighbors.push 'DOWN'  if row < height - 2 && grid[row + 1][col] == false
          neighbors.push 'LEFT'  if col > 0          && grid[row][col - 1] == false
          neighbors.push 'RIGHT' if col < width      && grid[row][col + 1] == false

          if neighbors.length == 0
            col = farthest_right.col
            row = farthest_right.row

            continue
          else
            direction = pathfinder neighbors

            switch DIRECTIONS[direction]
              when DIRECTIONS.RIGHT then grid[row][++col] = true
              when DIRECTIONS.LEFT  then grid[row][--col] = true
              when DIRECTIONS.UP    then grid[--row][col] = true
              when DIRECTIONS.DOWN  then grid[++row][col] = true
              when undefined        then continue

            if col > farthest_right.col
              farthest_right.col = col
              farthest_right.row = row

            if farthest_right.col < grid[0].length - 1
              path.push { row, col, direction }

              continue
            else
              more_to_carve = false

        done path

    module.exports = Carver
