    JsonRenderer = require './json_renderer'

    class JsonPlatforms extends JsonRenderer

      init_gap: =>
        start:     undefined
        length:    undefined
        bottom_y:  undefined
        thickness: undefined

      open_gap: (j, ground, next, diff) =>
        init_thickness = Math.ceil Math.random() * diff

        bottom_y = (@config.wall.segments - ground.thickness) - @config.ground.max_height_diff
        bottom_y += init_thickness

        start:          j + 2
        length:         0
        bottom_y:       bottom_y
        max_thickness:  diff
        init_thickness: init_thickness
        thickness:      next.thickness

      do_render: (ctx, path) =>

        for block, i in ctx
          gap = @init_gap()

          opening_gap = false

          block.platforms = [ ]

          blk = ctx[i - 1]

          if blk?
            for k in blk.platforms
              if k.length > 0 && block.y == blk.y && blk.x == block.x - 1
                opening_gap = k.last() if k.last().x == @config.ground.segments - 2

          for ground, j in block.ground
            if blk? && opening_gap != false && j == 0
              next = blk.ground[@config.ground.segments - 2]

              gap =
                start:          @config.ground.segments - 2
                length:         2
                bottom_y:       opening_gap.y
                max_thickness:  @config.ground.max_height_diff
                init_thickness: opening_gap.thickness
                thickness:      next.thickness

              platform = @config.platformer gap

              blk.platforms.last().push.apply blk.platforms.last(), platform if platform?

              gap.length = 0
              gap.start  = 0
            else
              opening_gap = false

            if gap.length >= 0 && ground.thickness <= @config.wall.segments - gap.bottom_y - @config.ground.max_height_diff
              if j < block.ground.length - 1
                gap.length += 1
              else
                gap.length -= 1

                platform = @config.platformer gap, ground, j

                block.platforms.push platform if platform?

                gap = @init_gap()
            else if gap.length > 2
              gap.length -= 2

              platform = @config.platformer gap, ground, j

              block.platforms.push platform if platform?

              gap = @init_gap()
            # else if gap.length != undefined
            #   gap = @init_gap()
            else
              if j < block.ground.length - 1
                next = block.ground[j + 1]

                if ground.thickness? && next.thickness?
                  diff = ground.thickness - next.thickness
                  max_thickness = 1

                  if diff > 0
                    if diff < @config.ground.max_height_diff
                      max_thickness = Math.ceil Math.random() * diff
                    else
                      max_thickness = Math.ceil Math.random() * @config.ground.max_height_diff

                  gap = @open_gap j, ground, next, max_thickness

    module.exports = JsonPlatforms
