    PngRenderer = require './png_renderer'

    class PngStepCount extends PngRenderer

      do_render: (path) =>
        ctx    = PngRenderer.ctx
        width  = @config.width
        height = @config.height

        for step, i in path
          ctx.font      = "#{Math.floor height * 0.25}pt Arial"
          ctx.textAlign = @config.step_count.text_align
          ctx.fillStyle = @config.step_count.text_color

          x = (width  * 0.5) + (width  * step.col)
          y = (height * 0.5) + (height * step.row)

          ctx.beginPath()
          ctx.fillText i, x, y

    module.exports = PngStepCount
