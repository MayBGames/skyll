    JsonRenderer = require './json_renderer'

    class JsonBlocks extends JsonRenderer

      render: (ctx, path, level_name, done) ->
        for step in path
          ctx.push
            x: step.col
            y: step.row

        done()

    module.exports = JsonBlocks
