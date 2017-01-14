    Module = require './module'

    class Carver extends Module
      pub: [ 'carve_path' ]

      grid:  undefined
      board: undefined
      row:   0
      col:   0
      steps: 0
      path:  [ ]

      previous_direction: undefined
      farthest_right:     0
      total_distance:     0

      directions:
        LEFT:  0
        RIGHT: 1
        UP:    2
        DOWN:  3

      direct_me: (options) =>
        chance = Math.random()

        for option in options
          neighbor = Object.keys(option)[0]

          return neighbor if option[neighbor] > chance

      update_steps: (dir) =>
        if @previous_direction?
          if @previous_direction == @directions[dir]
            ++@steps
          else
            @steps = 0
        else
          @previous_direction = @directions[dir]
          @steps = 0

      neighbor: (x = 0, y = 0) => @grid[@row + x][@col + y]

      carve_path: =>
        neighbors = [ ]
        direction = undefined

        neighbors.push 'UP'    if @row > 0               && @neighbor(-1,  0) == false
        neighbors.push 'DOWN'  if @row < @board.rows - 2 && @neighbor( 1,  0) == false
        neighbors.push 'LEFT'  if @col > 0               && @neighbor( 0, -1) == false
        neighbors.push 'RIGHT' if @col < @board.cols     && @neighbor( 0,  1) == false

        if neighbors.length > 0
          o = [ ]

          for n in [1..(neighbors.length / 1)]
            c = 1 / neighbors.length

            if neighbors[n - 1] == 'RIGHT'
              o.push "#{neighbors[n - 1]}": ((c * n) * ((2 / c) * 0.5)) * c
            else
              o.push "#{neighbors[n - 1]}": ((c * n) * (0.5 / c)) * c

          direction = @direct_me o
        else
          direction = 'RIGHT' if direction != 'RIGHT'

        switch @directions[direction]
          when @directions.RIGHT then @grid[@row][++@col] = true
          when @directions.LEFT  then @grid[@row][--@col] = true
          when @directions.UP    then @grid[--@row][@col] = true
          when @directions.DOWN  then @grid[++@row][@col] = true
          when undefined         then @debug 'Nowhere to go', row: @row, col: @col

        @update_steps direction
        @farthest_right = @col if @col > @farthest_right

        if @farthest_right < @board.cols
          @path.push row: @row, col: @col

          stats =
            position:
              row: @row
              col: @col
            steps: @steps
            direction: direction
            distance: ++@total_distance

          @update stats

          @carve_path()
        else
          @done @path

    module.exports = Carver
