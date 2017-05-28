    Madul = require 'madul'

    class Carver extends Madul
      deps: [ 'config' ]

      starting_row: 0

      row:   0
      col:   0
      steps: 0

      previous_direction: undefined
      total_distance:     0
      farthest_right:
        row: 0
        col: 0

      directions:
        LEFT:  0
        RIGHT: 1
        UP:    2
        DOWN:  3

      clear_state: =>
        @row  = @starting_row
        @col  = 0

        @farthest_right     = row: @row, col: 0
        @previous_direction = undefined

        @steps          = 0
        @total_distance = 0

        for row, r in @config.grid
          for cell, c in @config.grid[r]
            @config.grid[r][c] = false

        @config.grid[@row][@col] = true

      update_steps: (dir) =>
        if @previous_direction?
          if @previous_direction == @directions[dir]
            ++@steps
          else
            @steps = 0
        else
          @previous_direction = @directions[dir]
          @steps = 0

      neighbor: (x = 0, y = 0) => @config.grid[@row + x][@col + y]

      carve_path: =>
        more_to_carve = true
        path          = [{ row: @row, col: @col }]

        while more_to_carve
          neighbors = [ ]
          width     = @config.grid[0].length
          height    = @config.grid.length

          neighbors.push 'UP'    if @row > 0          && @neighbor(-1,  0) == false
          neighbors.push 'DOWN'  if @row < height - 2 && @neighbor( 1,  0) == false
          neighbors.push 'LEFT'  if @col > 0          && @neighbor( 0, -1) == false
          neighbors.push 'RIGHT' if @col < width      && @neighbor( 0,  1) == false

          if neighbors.length == 0
            @col = @farthest_right.col
            @row = @farthest_right.row

            continue
          else
            direction = @config.pathfinder neighbors

            switch @directions[direction]
              when @directions.RIGHT then @config.grid[@row][++@col] = true
              when @directions.LEFT  then @config.grid[@row][--@col] = true
              when @directions.UP    then @config.grid[--@row][@col] = true
              when @directions.DOWN  then @config.grid[++@row][@col] = true
              when undefined         then continue

            @update_steps direction

            if @col > @farthest_right.col
              @farthest_right.col = @col
              @farthest_right.row = @row

            if @farthest_right.col < @config.grid[0].length - 1
              path.push row: @row, col: @col, direction: direction

              continue
            else
              more_to_carve = false

        path

    module.exports = Carver
