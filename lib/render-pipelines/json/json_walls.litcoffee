    JsonRenderer = require './json_renderer'

    class JsonWalls extends JsonRenderer

      args:      [ 'ground', 'wall', 'multiplier' ]
      delegates: [ 'roofer', 'waller' ]

      _draw_roof: =>
        idx = @ctx.indexOf(@my) + 1

        if @ctx[idx]?
          next = @ctx[idx]
          prev = @ctx[idx - 2]

          @my.roof = [ ]

          for segment, i in @my.ground
            tile = thickness: @roofer @ground, @multiplier

            if @my.y > prev?.y
              @my.roof[i] = tile if prev?.ground[i].thickness > 0

            else if (@my.y == prev?.y && @my.y < next.y) ||
                     next.ground[i].thickness > 0        ||
                     next.y == @my.y
              @my.roof[i] = tile
        else
          @my.roof = for segment in @my.ground
            thickness: @roofer @ground, @multiplier

      _draw_left_wall: =>
        @my.left_wall = for i in [0...@wall.segments]
          thickness: @waller @ground

      _draw_right_wall: =>
        @my.right_wall = for i in [0...@wall.segments]
          thickness: @waller @ground

      _draw_walls: =>
        @_draw_left_wall()
        @_draw_right_wall()

      render: (drawing_context, path, level_name, done) ->
        @ctx = drawing_context

        for step, i in path
          dir = step.direction

          if i > 0
            @my  = @ctx[i - 1]
            prev = path[i - 1].direction

            @_draw_roof()

            switch dir
              when 'RIGHT', 'LEFT'
                @_draw_left_wall()  if dir == 'RIGHT' && (prev == undefined || prev == 'UP' || prev == 'DOWN')
                @_draw_right_wall() if dir == 'LEFT'  && (prev == 'UP' || prev == 'DOWN')
              when 'UP', 'DOWN'
                if prev == undefined || prev == 'UP' || prev == 'DOWN'
                  @_draw_walls()
                else
                  @_draw_left_wall()  if prev == 'LEFT'
                  @_draw_right_wall() if prev == 'RIGHT'

          if i == path.length - 1
            @my = @ctx[i]

            @_draw_roof()

            switch dir
              when 'RIGHT', 'LEFT'
                @_draw_right_wall() if dir == 'RIGHT'
                @_draw_left_wall()  if dir == 'LEFT'

              when 'UP', 'DOWN'
                @_draw_walls()

        done()

    module.exports = JsonWalls
