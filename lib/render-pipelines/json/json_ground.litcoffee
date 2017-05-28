    JsonRenderer = require './json_renderer'

    class JsonGround extends JsonRenderer

      do_render: (ctx, path) =>
        ground_segments = @config.ground.segments

        for step, i in path
          ctx[i].ground = [ ]

          s = 0

          while s < ground_segments
            segment = @config.grounder step, i, path, s, ctx[i].ground

            if segment.thickness == -1

              j = 0

              while j < segment.width
                ctx[i - 1].ground[s + j++].thickness = 0

              seg = @config.grounder direction: 'FAKE', i, path, s, ctx[i].ground

              segment.thickness = seg.thickness

            k = 0

            while k < segment.width
              if ctx[i].ground.length < @config.ground.segments
                ctx[i].ground.push thickness: segment.thickness

              ++k
              ++s

    module.exports = JsonGround
