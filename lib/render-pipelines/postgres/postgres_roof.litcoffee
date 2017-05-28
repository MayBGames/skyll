    # PngRenderer = require './png_renderer'
    #
    # class PngRoof extends PngRenderer
    #
    #   do_render: (ctx, path) =>
    #     cell_width  = @config.width
    #     cell_height = @config.height
    #
    #     ground_segments = @config.ground.segments
    #     segment_width   = 1 / ground_segments
    #     ground_width    = cell_width * segment_width
    #
    #     fill_segment = (block, segment, height, color) =>
    #       right  = segment * (cell_width * segment_width)
    #       left   = (cell_width * block.x) + right
    #       top    = (cell_height * block.y)
    #
    #       ctx.fillStyle = color
    #
    #       ctx.beginPath()
    #       ctx.rect left, top, ground_width, height
    #       ctx.fill()
    #
    #     for step in path
    #       if step.roof?
    #         for f, i in step.roof
    #           fill_segment step, i, f.thickness, 'red' if f?
    #
    # module.exports = PngRoof
