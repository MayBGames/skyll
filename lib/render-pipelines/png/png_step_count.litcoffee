    PngRenderer = require './png_renderer'

    class PngStepCount extends PngRenderer

      text_color: 'black'

      do_render: (path) =>
        @ctx.font      = "#{Math.floor @cell_height * 0.25}pt Arial"
        @ctx.textAlign = 'center'
        @ctx.fillStyle = @text_color

        for step, i in path
          x = (@cell_width  * 0.5) + (@cell_width  * step.col)
          y = (@cell_height * 0.5) + (@cell_height * step.row)

          @ctx.beginPath()
          @ctx.fillText i, x, y

    module.exports = PngStepCount
