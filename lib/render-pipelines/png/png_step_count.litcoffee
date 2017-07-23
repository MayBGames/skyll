    PngRenderer = require './png_renderer'

    class PngStepCount extends PngRenderer

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

        for step, i in path
          ctx.font      = '12pt Arial'
          ctx.textAlign = @config.step_count.text.align
          ctx.fillStyle = @config.step_count.text.color

          x = (width  * 0.5) + (width  * step.x)
          y = (height * 0.5) + (height * step.y)

          ctx.beginPath()
          ctx.fillText i, x, y

    module.exports = PngStepCount
