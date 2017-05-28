    JsonRenderer = require './json_renderer'

    class JsonWalls extends JsonRenderer

      draw_roof: =>
        idx = @ctx.indexOf(@my) + 1

        if @ctx[idx]?
          next = @ctx[idx]
          prev = @ctx[idx - 2]

          @my.roof = [ ]

          for segment, i in @my.ground
            tile = thickness: @config.roofer()

            if @my.y > prev?.y
              @my.roof[i] = tile if prev?.ground[i].thickness > 0

            else if (@my.y == prev?.y && @my.y < next.y) ||
                     next.ground[i].thickness > 0        ||
                     next.y == @my.y
              @my.roof[i] = tile
        else
          @my.roof = for segment in @my.ground
            thickness: @config.roofer()

      draw_left_wall: =>
        @my.left_wall = for i in [0...@config.wall.segments]
          thickness: @config.waller()

      draw_right_wall: =>
        @my.right_wall = for i in [0...@config.wall.segments]
          thickness: @config.waller()

      draw_walls: =>
        @draw_left_wall()
        @draw_right_wall()

      do_render: (drawing_context, path) =>
        @ctx = drawing_context

        for step, i in path
          dir = step.direction

          if i > 0
            @my  = @ctx[i - 1]
            prev = path[i - 1].direction

            @draw_roof()

            switch dir
              when 'RIGHT', 'LEFT'
                @draw_left_wall()  if dir == 'RIGHT' && (prev == undefined || prev == 'UP' || prev == 'DOWN')
                @draw_right_wall() if dir == 'LEFT'  && (prev == 'UP' || prev == 'DOWN')
              when 'UP', 'DOWN'
                if prev == undefined || prev == 'UP' || prev == 'DOWN'
                  @draw_walls()
                else
                  @draw_left_wall()  if prev == 'LEFT'
                  @draw_right_wall() if prev == 'RIGHT'

          if i == path.length - 1
            @my = @ctx[i]

            @draw_roof()

            switch dir
              when 'RIGHT', 'LEFT'
                @draw_right_wall() if dir == 'RIGHT'
                @draw_left_wall()  if dir == 'LEFT'

              when 'UP', 'DOWN'
                @draw_walls()

    module.exports = JsonWalls
