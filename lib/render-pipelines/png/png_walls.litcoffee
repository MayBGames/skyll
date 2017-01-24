    PngRenderer = require './png_renderer'

    class PngWalls extends PngRenderer

      wall_width: 1
      wall_color: 'red'

      do_render: (path) =>
        ctx    = PngRenderer.ctx
        width  = PngRenderer.cell_width
        height = PngRenderer.cell_height

        for step, i in path
          ctx.lineWidth   = @wall_width
          ctx.strokeStyle = @wall_color

          if i > 0
            previous = path[i - 1]
            top      =  height * previous.row  + 1
            bottom   = (height * previous.row) + (height - 1)
            left     = (width  * previous.col) + 1
            right    = (width  * previous.col) + (width - 1)

            switch step.direction
              when 'RIGHT', 'LEFT'
                if previous.direction != 'DOWN'
                  ctx.beginPath()
                  ctx.moveTo left,  top
                  ctx.lineTo right, top
                  ctx.stroke()
                else if step.direction == 'RIGHT'
                  ctx.beginPath()
                  ctx.moveTo left, top
                  ctx.lineTo left, bottom
                  ctx.stroke()
                else if step.direction == 'LEFT'
                  ctx.beginPath()
                  ctx.moveTo right, top
                  ctx.lineTo right, bottom
                  ctx.stroke()

                if previous.direction != 'UP'
                  ctx.beginPath()
                  ctx.moveTo left,  bottom
                  ctx.lineTo right, bottom
                  ctx.stroke()
                else if step.direction == 'RIGHT'
                  ctx.beginPath()
                  ctx.moveTo left, top
                  ctx.lineTo left, bottom
                  ctx.stroke()
                else if step.direction == 'LEFT'
                  ctx.beginPath()
                  ctx.moveTo right, top
                  ctx.lineTo right, bottom
                  ctx.stroke()

                if previous.direction == undefined
                  if step.direction == 'RIGHT'
                    ctx.beginPath()
                    ctx.moveTo left, top
                    ctx.lineTo left, bottom
                    ctx.stroke()
                  else if step.direction == 'LEFT'
                    ctx.beginPath()
                    ctx.moveTo right, top
                    ctx.lineTo right, bottom
                    ctx.stroke()

              when 'UP', 'DOWN'
                if previous.direction != 'LEFT'
                  ctx.beginPath()
                  ctx.moveTo right, top
                  ctx.lineTo right, bottom
                  ctx.stroke()
                else if step.direction == 'DOWN'
                  ctx.beginPath()
                  ctx.moveTo left,  top
                  ctx.lineTo right, top
                  ctx.stroke()
                else if step.direction == 'UP'
                  ctx.beginPath()
                  ctx.moveTo left,  bottom
                  ctx.lineTo right, bottom
                  ctx.stroke()

                if previous.direction != 'RIGHT'
                  ctx.beginPath()
                  ctx.moveTo left, top
                  ctx.lineTo left, bottom
                  ctx.stroke()
                else if step.direction == 'DOWN'
                  ctx.beginPath()
                  ctx.moveTo left,  top
                  ctx.lineTo right, top
                  ctx.stroke()
                else if step.direction == 'UP'
                  ctx.beginPath()
                  ctx.moveTo left,  bottom
                  ctx.lineTo right, bottom
                  ctx.stroke()

                if previous.direction == undefined
                  if step.direction == 'DOWN'
                    ctx.beginPath()
                    ctx.moveTo left,  top
                    ctx.lineTo right, top
                    ctx.stroke()
                  else if step.direction == 'UP'
                    ctx.beginPath()
                    ctx.moveTo left,  bottom
                    ctx.lineTo right, bottom
                    ctx.stroke()

          if i == path.length - 1
            previous = path[i - 1]
            top      =  height * step.row  + 1
            bottom   = (height * step.row) + (height - 1)
            left     = (width  * step.col) + 1
            right    = (width  * step.col) + (width - 1)

            switch step.direction
              when 'RIGHT', 'LEFT'
                ctx.beginPath()
                ctx.moveTo left,  top
                ctx.lineTo right, top
                ctx.stroke()

                ctx.beginPath()
                ctx.moveTo left,  bottom
                ctx.lineTo right, bottom
                ctx.stroke()

                if step.direction == 'RIGHT'
                  ctx.beginPath()
                  ctx.moveTo right, top
                  ctx.lineTo right, bottom
                  ctx.stroke()

                if step.direction == 'LEFT'
                  ctx.beginPath()
                  ctx.moveTo left, top
                  ctx.lineTo left, bottom
                  ctx.stroke()

              when 'UP', 'DOWN'
                ctx.beginPath()
                ctx.moveTo right, top
                ctx.lineTo right, bottom
                ctx.stroke()

                ctx.beginPath()
                ctx.moveTo left, top
                ctx.lineTo left, bottom
                ctx.stroke()

                if step.direction == 'UP'
                  ctx.beginPath()
                  ctx.moveTo left,  top
                  ctx.lineTo right, top
                  ctx.stroke()

                if step.direction == 'DOWN'
                  ctx.beginPath()
                  ctx.moveTo left,  bottom
                  ctx.lineTo right, bottom
                  ctx.stroke()

    module.exports = PngWalls
