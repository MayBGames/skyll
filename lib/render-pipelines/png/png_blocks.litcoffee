    PngRenderer = require './png_renderer'

    class PngBlocks extends PngRenderer

      block_fill_color: 'white'
      block_border_width: 1
      block_border_color: 'black'

      do_render: (path) =>
        ctx    = PngRenderer.ctx
        width  = PngRenderer.cell_width
        height = PngRenderer.cell_height

        for step in path
          ctx.lineWidth = @block_border_width
          ctx.fillStyle = @block_fill_color

          ctx.beginPath()
          ctx.rect width * step.col, height * step.row, width, height
          ctx.fill()

    module.exports = PngBlocks
