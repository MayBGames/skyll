    PngRenderer = require './png_renderer'

    class PngStepCount extends PngRenderer

      do_render: (ctx, path) =>
        width  = @config.width
        height = @config.height

        for step, i in path
          ctx.font      = "#{Math.floor height * 0.25}pt Arial"
          ctx.textAlign = @config.step_count.text.align
          ctx.fillStyle = @config.step_count.text.color

          x = (width  * 0.5) + (width  * step.x)
          y = (height * 0.5) + (height * step.y)

          ctx.beginPath()
          ctx.fillText i, x, y

    module.exports = PngStepCount
