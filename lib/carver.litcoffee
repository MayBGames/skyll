    Module = require './module'

    class Carver extends Module
      pub: [ 'carve_path' ]

      grid:  undefined
      row:   0
      col:   0
      steps: 0
      path:  [ ]

      previous_direction: undefined
      total_distance:     0
      director:           undefined
      farthest_right:
        row: 0
        col: 0

      directions:
        LEFT:  0
        RIGHT: 1
        UP:    2
        DOWN:  3

      initialize: (grid, starting_row, director) =>
        @grid  = grid
        @path  = [ ]
        @row   = starting_row
        @col   = 0

        @farthest_right     = row: @row, col: 0
        @previous_direction = undefined

        @steps          = 0
        @total_distance = 0

        @director = director

        @grid[@row][@col] = true
        @path.push row: @row, col: @col

        super()

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
        width     = @grid[0].length
        height    = @grid.length

        neighbors.push 'UP'    if @row > 0          && @neighbor(-1,  0) == false
        neighbors.push 'DOWN'  if @row < height - 2 && @neighbor( 1,  0) == false
        neighbors.push 'LEFT'  if @col > 0          && @neighbor( 0, -1) == false
        neighbors.push 'RIGHT' if @col < width      && @neighbor( 0,  1) == false

        if neighbors.length == 0
          @col = @farthest_right.col
          @row = @farthest_right.row

          @carve_path()
        else
          direction = @director neighbors

          switch @directions[direction]
            when @directions.RIGHT then @grid[@row][++@col] = true
            when @directions.LEFT  then @grid[@row][--@col] = true
            when @directions.UP    then @grid[--@row][@col] = true
            when @directions.DOWN  then @grid[++@row][@col] = true
            when undefined         then return @carve_path()

          @update_steps direction

          if @col > @farthest_right.col
            @farthest_right.col = @col
            @farthest_right.row = @row

          if @farthest_right.col < @grid[0].length - 1
            @path.push row: @row, col: @col, direction: direction

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
