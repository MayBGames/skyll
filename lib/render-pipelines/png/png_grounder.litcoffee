    PngRenderer = require './png_renderer'

    class PngGrounder extends PngRenderer

      do_render: (path) =>
        ctx = PngRenderer.ctx

        cell_width  = @config.width
        cell_height = @config.height

        ground_segments = @config.ground.segments
        segment_width   = 1 / ground_segments
        ground_width    = cell_width * segment_width

        for step, i in path
          ctx.fillStyle = @config.ground.fill_color

          step.ground = [ ]

          for g in [0...ground_segments]
            height = @config.grounder step, i, path
            right  = g * (cell_width * segment_width)
            left   = (cell_width * step.col) + right
            top    = (cell_height * (step.row + 1)) - height

            ctx.beginPath()
            ctx.rect left, top, ground_width, height
            ctx.fill()

            step.ground.push height: height

    module.exports = PngGrounder
