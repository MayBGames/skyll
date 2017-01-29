    Module = require './module'
    q      = require 'q'

    class Carver extends Module
      deps: [ 'config' ]
      pub: [ 'carve_path' ]

      row:   0
      col:   0
      steps: 0
      path:  [ ]

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

      initialize: (starting_row) =>
        deferred = q.defer()

        @path = [ ]
        @row  = starting_row
        @col  = 0

        @farthest_right     = row: @row, col: 0
        @previous_direction = undefined

        @steps          = 0
        @total_distance = 0

        super().then =>
          @config.grid[@row][@col] = true
          @path.push row: @row, col: @col

          deferred.resolve @

        deferred.promise

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

          @carve_path()
        else
          direction = @config.pathfinder neighbors

          switch @directions[direction]
            when @directions.RIGHT then @config.grid[@row][++@col] = true
            when @directions.LEFT  then @config.grid[@row][--@col] = true
            when @directions.UP    then @config.grid[--@row][@col] = true
            when @directions.DOWN  then @config.grid[++@row][@col] = true
            when undefined         then return @carve_path()

          @update_steps direction

          if @col > @farthest_right.col
            @farthest_right.col = @col
            @farthest_right.row = @row

          if @farthest_right.col < @config.grid[0].length - 1
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
