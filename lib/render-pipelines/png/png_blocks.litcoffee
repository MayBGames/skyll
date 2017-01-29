    PngRenderer = require './png_renderer'

    class PngBlocks extends PngRenderer

      do_render: (path) =>
        ctx    = PngRenderer.ctx
        width  = @config.width
        height = @config.height

        for step in path
          ctx.lineWidth = @config.block.border_width
          ctx.fillStyle = @config.block.fill_color

          ctx.beginPath()
          ctx.rect width * step.col, height * step.row, width, height
          ctx.fill()

    module.exports = PngBlocks
