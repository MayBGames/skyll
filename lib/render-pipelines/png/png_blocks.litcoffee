    PngRenderer = require './png_renderer'

    class PngBlocks extends PngRenderer

      block_fill_color: 'white'
      block_border_width: 1
      block_border_color: 'black'

      do_render: (path) =>
        @ctx.lineWidth = @block_border_width
        @ctx.fillStyle = @block_fill_color

        for step in path
          @ctx.beginPath()
          @ctx.rect @cell_width * step.col, @cell_height * step.row, @cell_width, @cell_height
          @ctx.fill()

    module.exports = PngBlocks
