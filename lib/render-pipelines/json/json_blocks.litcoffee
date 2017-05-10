    JsonRenderer = require './json_renderer'

    class JsonBlocks extends JsonRenderer

      do_render: (ctx, path) =>
        width  = @config.width
        height = @config.height

        for step in path
          ctx.push
            x: step.col
            y: step.row

    module.exports = JsonBlocks
