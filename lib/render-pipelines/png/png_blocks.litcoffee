    PngRenderer = require './png_renderer'

    class PngBlocks extends PngRenderer

      render_async: (path, grid, level_name, done, fail) ->
        location = @path.join __dirname, '..', '..', '..', 'output', "#{grid}.json"

        @fs.readFile location, 'utf8', (e, d) =>
          if e?
            fail e
          else
            done @_do_render @ctx, JSON.parse d

      _do_render: (ctx, path) =>
        width  = @config.width
        height = @config.height

        for step in path
          ctx.fillStyle = @config.block.fill_color

          ctx.beginPath()
          ctx.rect width * step.x, height * step.y, width, height
          ctx.fill()

    module.exports = PngBlocks
