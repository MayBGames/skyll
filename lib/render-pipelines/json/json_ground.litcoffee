    JsonRenderer = require './json_renderer'

    class JsonGround extends JsonRenderer

      do_render: (ctx, path) =>
        ground_segments = @config.ground.segments

        for step, i in path
          ctx[i].ground = [ ]

          for g in [0...ground_segments]
            height = @config.grounder step, i, path, g

            if height == -1
              ctx[i - 1].ground[g].height = null

              height = @config.grounder direction: 'FAKE', i, path, g

            ctx[i].ground.push height: height

    module.exports = JsonGround
