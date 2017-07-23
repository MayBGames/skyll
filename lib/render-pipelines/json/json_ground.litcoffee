    JsonRenderer = require './json_renderer'

    class JsonGround extends JsonRenderer

      args:      [ 'ground', 'wall' ]
      delegates: [ 'grounder' ]

      render: (ctx, path, level_name, done) ->
        ground_segments = @ground.segments

        for step, i in path
          ctx[i].ground = [ ]

          s = 0

          while s < ground_segments
            segment = @grounder @ground, @wall, step, i, path, s, ctx[i].ground

            if segment.thickness == -1

              j = 0

              while j < segment.width
                ctx[i - 1]?.ground[s + j++]?.thickness = 0

              seg = @grounder @ground, @wall, direction: 'FAKE', i, path, s, ctx[i].ground

              segment.thickness = seg.thickness

            k = 0

            while k < segment.width
              if ctx[i].ground.length < @ground.segments
                ctx[i].ground.push thickness: segment.thickness

              ++k
              ++s

        done()

    module.exports = JsonGround
