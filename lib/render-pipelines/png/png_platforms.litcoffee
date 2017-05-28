    PngRenderer = require './png_renderer'

    class PngPlatforms extends PngRenderer

      do_render: (ctx, path) =>
        cell_width  = @config.width
        cell_height = @config.height

        ground_segments = @config.ground.segments
        wall_segments   = @config.wall.segments

        segment_width  = 1 / ground_segments
        segment_height = 1 / wall_segments

        ground_width = cell_width  * segment_width
        wall_height  = cell_height * segment_height

        fill_segment = (block, platform, color) =>
          for p in platform
            height =  p.thickness * wall_height
            left   = (cell_width  * block.x) + (p.x * ground_width)
            top    = (cell_height * block.y) + (p.y * wall_height) - height

            ctx.fillStyle = color

            ctx.beginPath()
            ctx.rect left, top, ground_width, height
            ctx.fill()

        for block, i in path
          for p in block.platforms
            fill_segment block, p, 'blue'

    module.exports = PngPlatforms
