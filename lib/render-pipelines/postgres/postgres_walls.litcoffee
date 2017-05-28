    # PngRenderer = require './png_renderer'
    #
    # class PngWalls extends PngRenderer
    #
    #   do_render: (ctx, path) =>
    #     cell_width  = @config.width
    #     cell_height = @config.height
    #
    #     wall_segments  = @config.wall.segments
    #     segment_height = 1 / wall_segments
    #     wall_height    = cell_height * segment_height
    #
    #     fill_segment = (side, block, segment, width, color) =>
    #       top  = (cell_height * block.y) + (segment * (cell_height * segment_height))
    #       left = cell_width * block.x
    #
    #       left += cell_width - width if side == 'RIGHT'
    #
    #       ctx.fillStyle = color
    #
    #       ctx.beginPath()
    #       ctx.rect left, top, width, @config.multiplier
    #       ctx.fill()
    #
    #     for block in path
    #       for side in [ 'left', 'right' ]
    #         if block["#{side}_wall"]?
    #           for seg, i in block["#{side}_wall"]
    #             fill_segment side.toUpperCase(), block, i, seg.thickness, @config.wall.color
    #
    # module.exports = PngWalls
