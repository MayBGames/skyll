    PngRenderer = rqeuire './png_renderer'

    class PngWalls extends PngRenderer

      wall_width: 1
      wall_color: 'red'

      do_render: (path) =>
        @ctx.lineWidth   = @wall_width
        @ctx.strokeStyle = @wall_color

        for step, i in path
          if i > 0
            previous = path[i - 1]
            top      =  @cell_height * previous.row  + 1
            bottom   = (@cell_height * previous.row) + (@cell_height - 1)
            left     = (@cell_width  * previous.col) + 1
            right    = (@cell_width  * previous.col) + (@cell_width - 1)

            switch step.direction
              when 'RIGHT', 'LEFT'
                if previous.direction != 'DOWN'
                  @ctx.beginPath()
                  @ctx.moveTo left,  top
                  @ctx.lineTo right, top
                  @ctx.stroke()
                else if step.direction == 'RIGHT'
                  @ctx.beginPath()
                  @ctx.moveTo left, top
                  @ctx.lineTo left, bottom
                  @ctx.stroke()
                else if step.direction == 'LEFT'
                  @ctx.beginPath()
                  @ctx.moveTo right, top
                  @ctx.lineTo right, bottom
                  @ctx.stroke()

                if previous.direction != 'UP'
                  @ctx.beginPath()
                  @ctx.moveTo left,  bottom
                  @ctx.lineTo right, bottom
                  @ctx.stroke()
                else if step.direction == 'RIGHT'
                  @ctx.beginPath()
                  @ctx.moveTo left, top
                  @ctx.lineTo left, bottom
                  @ctx.stroke()
                else if step.direction == 'LEFT'
                  @ctx.beginPath()
                  @ctx.moveTo right, top
                  @ctx.lineTo right, bottom
                  @ctx.stroke()

                if previous.direction == undefined
                  if step.direction == 'RIGHT'
                    @ctx.beginPath()
                    @ctx.moveTo left, top
                    @ctx.lineTo left, bottom
                    @ctx.stroke()
                  else if step.direction == 'LEFT'
                    @ctx.beginPath()
                    @ctx.moveTo right, top
                    @ctx.lineTo right, bottom
                    @ctx.stroke()

              when 'UP', 'DOWN'
                if previous.direction != 'LEFT'
                  @ctx.beginPath()
                  @ctx.moveTo right, top
                  @ctx.lineTo right, bottom
                  @ctx.stroke()
                else if step.direction == 'DOWN'
                  @ctx.beginPath()
                  @ctx.moveTo left,  top
                  @ctx.lineTo right, top
                  @ctx.stroke()
                else if step.direction == 'UP'
                  @ctx.beginPath()
                  @ctx.moveTo left,  bottom
                  @ctx.lineTo right, bottom
                  @ctx.stroke()

                if previous.direction != 'RIGHT'
                  @ctx.beginPath()
                  @ctx.moveTo left, top
                  @ctx.lineTo left, bottom
                  @ctx.stroke()
                else if step.direction == 'DOWN'
                  @ctx.beginPath()
                  @ctx.moveTo left,  top
                  @ctx.lineTo right, top
                  @ctx.stroke()
                else if step.direction == 'UP'
                  @ctx.beginPath()
                  @ctx.moveTo left,  bottom
                  @ctx.lineTo right, bottom
                  @ctx.stroke()

                if previous.direction == undefined
                  if step.direction == 'DOWN'
                    @ctx.beginPath()
                    @ctx.moveTo left,  top
                    @ctx.lineTo right, top
                    @ctx.stroke()
                  else if step.direction == 'UP'
                    @ctx.beginPath()
                    @ctx.moveTo left,  bottom
                    @ctx.lineTo right, bottom
                    @ctx.stroke()

          if i == path.length - 1
            previous = path[i - 1]
            top      =  @cell_height * step.row  + 1
            bottom   = (@cell_height * step.row) + (@cell_height - 1)
            left     = (@cell_width  * step.col) + 1
            right    = (@cell_width  * step.col) + (@cell_width - 1)

            switch step.direction
              when 'RIGHT', 'LEFT'
                @ctx.beginPath()
                @ctx.moveTo left,  top
                @ctx.lineTo right, top
                @ctx.stroke()

                @ctx.beginPath()
                @ctx.moveTo left,  bottom
                @ctx.lineTo right, bottom
                @ctx.stroke()

                if step.direction == 'RIGHT'
                  @ctx.beginPath()
                  @ctx.moveTo right, top
                  @ctx.lineTo right, bottom
                  @ctx.stroke()

                if step.direction == 'LEFT'
                  @ctx.beginPath()
                  @ctx.moveTo left, top
                  @ctx.lineTo left, bottom
                  @ctx.stroke()

              when 'UP', 'DOWN'
                @ctx.beginPath()
                @ctx.moveTo right, top
                @ctx.lineTo right, bottom
                @ctx.stroke()

                @ctx.beginPath()
                @ctx.moveTo left, top
                @ctx.lineTo left, bottom
                @ctx.stroke()

                if step.direction == 'UP'
                  @ctx.beginPath()
                  @ctx.moveTo left,  top
                  @ctx.lineTo right, top
                  @ctx.stroke()

                if step.direction == 'DOWN'
                  @ctx.beginPath()
                  @ctx.moveTo left,  bottom
                  @ctx.lineTo right, bottom
                  @ctx.stroke()

    module.exports = PngWalls
