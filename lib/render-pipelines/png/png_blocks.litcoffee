    PngRenderer = require './png_renderer'

    class PngBlocks extends PngRenderer

      do_render: (ctx, path) =>
        width  = @config.width
        height = @config.height

        for step in path
          ctx.fillStyle = @config.block.fill_color

          ctx.beginPath()
          ctx.rect width * step.x, height * step.y, width, height
          ctx.fill()

    module.exports = PngBlocks
