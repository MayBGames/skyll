    PngRenderer = require './png_renderer'

    class PngStepCount extends PngRenderer

      text_color: 'black'

      do_render: (path) =>
        ctx    = PngRenderer.ctx
        width  = @config.width
        height = @config.height

        for step, i in path
          ctx.font      = "#{Math.floor height * 0.25}pt Arial"
          ctx.textAlign = 'center'
          ctx.fillStyle = @text_color

          x = (width  * 0.5) + (width  * step.col)
          y = (height * 0.5) + (height * step.row)

          ctx.beginPath()
          ctx.fillText i, x, y

    module.exports = PngStepCount
