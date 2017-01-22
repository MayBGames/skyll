    Module = require '../module'
    q      = require 'q'

    class PngPersister extends Module
      deps: [ 'fs', 'canvas' ]
      pub: [ 'persist' ]

      draw_to: undefined

      dimensions:  undefined
      cell_width:  undefined
      cell_height: undefined

      block_fill_color: 'white'
      block_border_width: 1
      block_border_color: 'black'

      initialize: (params) =>
        deferred = q.defer()

        super()
          .then =>
            @[key] = val for key, val of params

            @draw_to = new @canvas @dimensions.width, @dimensions.height

            deferred.resolve @

        deferred.promise

      persist: (name, path) =>
        ctx = @draw_to.getContext '2d'

        ctx.font        = "#{Math.floor @cell_height * 0.25}pt Arial"
        ctx.textAlign   = 'center'
        ctx.lineWidth   = @block_border_width
        ctx.strokeStyle = 'red'

        for step, i in path
          ctx.beginPath()
          ctx.rect @cell_width * step.col, @cell_height * step.row, @cell_width, @cell_height
          ctx.fillStyle = @block_fill_color
          ctx.fill()

          x = (@cell_width  * 0.5)  + (@cell_width  * step.col)
          y = (@cell_height * 0.75) + (@cell_height * step.row)

          ctx.fillStyle = @block_border_color
          ctx.fillText i, x, y

          if i > 0
            previous = path[i - 1]
            top      =  @cell_height * previous.row  + 1
            bottom   = (@cell_height * previous.row) + (@cell_height - 1)
            left     = (@cell_width  * previous.col) + 1
            right    = (@cell_width  * previous.col) + (@cell_width - 1)

            switch step.direction
              when 'RIGHT', 'LEFT'
                if previous.direction != 'DOWN'
                  ctx.beginPath()
                  ctx.moveTo left,  top
                  ctx.lineTo right, top
                  ctx.stroke()
                else if step.direction == 'RIGHT'
                  ctx.beginPath()
                  ctx.moveTo left, top
                  ctx.lineTo left, bottom
                  ctx.stroke()
                else if step.direction == 'LEFT'
                  ctx.beginPath()
                  ctx.moveTo right, top
                  ctx.lineTo right, bottom
                  ctx.stroke()

                if previous.direction != 'UP'
                  ctx.beginPath()
                  ctx.moveTo left,  bottom
                  ctx.lineTo right, bottom
                  ctx.stroke()
                else if step.direction == 'RIGHT'
                  ctx.beginPath()
                  ctx.moveTo left, top
                  ctx.lineTo left, bottom
                  ctx.stroke()
                else if step.direction == 'LEFT'
                  ctx.beginPath()
                  ctx.moveTo right, top
                  ctx.lineTo right, bottom
                  ctx.stroke()

                if previous.direction == undefined
                  if step.direction == 'RIGHT'
                    ctx.beginPath()
                    ctx.moveTo left, top
                    ctx.lineTo left, bottom
                    ctx.stroke()
                  else if step.direction == 'LEFT'
                    ctx.beginPath()
                    ctx.moveTo right, top
                    ctx.lineTo right, bottom
                    ctx.stroke()

              when 'UP', 'DOWN'
                if previous.direction != 'LEFT'
                  ctx.beginPath()
                  ctx.moveTo right, top
                  ctx.lineTo right, bottom
                  ctx.stroke()
                else if step.direction == 'DOWN'
                  ctx.beginPath()
                  ctx.moveTo left,  top
                  ctx.lineTo right, top
                  ctx.stroke()
                else if step.direction == 'UP'
                  ctx.beginPath()
                  ctx.moveTo left,  bottom
                  ctx.lineTo right, bottom
                  ctx.stroke()

                if previous.direction != 'RIGHT'
                  ctx.beginPath()
                  ctx.moveTo left, top
                  ctx.lineTo left, bottom
                  ctx.stroke()
                else if step.direction == 'DOWN'
                  ctx.beginPath()
                  ctx.moveTo left,  top
                  ctx.lineTo right, top
                  ctx.stroke()
                else if step.direction == 'UP'
                  ctx.beginPath()
                  ctx.moveTo left,  bottom
                  ctx.lineTo right, bottom
                  ctx.stroke()

                if previous.direction == undefined
                  if step.direction == 'DOWN'
                    ctx.beginPath()
                    ctx.moveTo left,  top
                    ctx.lineTo right, top
                    ctx.stroke()
                  else if step.direction == 'UP'
                    ctx.beginPath()
                    ctx.moveTo left,  bottom
                    ctx.lineTo right, bottom
                    ctx.stroke()

          if i == path.length - 1
            previous = path[i - 1]
            top      =  @cell_height * step.row  + 1
            bottom   = (@cell_height * step.row) + (@cell_height - 1)
            left     = (@cell_width  * step.col) + 1
            right    = (@cell_width  * step.col) + (@cell_width - 1)

            switch step.direction
              when 'RIGHT', 'LEFT'
                ctx.beginPath()
                ctx.moveTo left,  top
                ctx.lineTo right, top
                ctx.stroke()

                ctx.beginPath()
                ctx.moveTo left,  bottom
                ctx.lineTo right, bottom
                ctx.stroke()

                if step.direction == 'RIGHT'
                  ctx.beginPath()
                  ctx.moveTo right, top
                  ctx.lineTo right, bottom
                  ctx.stroke()

                if step.direction == 'LEFT'
                  ctx.beginPath()
                  ctx.moveTo left, top
                  ctx.lineTo left, bottom
                  ctx.stroke()

              when 'UP', 'DOWN'
                ctx.beginPath()
                ctx.moveTo right, top
                ctx.lineTo right, bottom
                ctx.stroke()

                ctx.beginPath()
                ctx.moveTo left, top
                ctx.lineTo left, bottom
                ctx.stroke()

                if step.direction == 'UP'
                  ctx.beginPath()
                  ctx.moveTo left,  top
                  ctx.lineTo right, top
                  ctx.stroke()

                if step.direction == 'DOWN'
                  ctx.beginPath()
                  ctx.moveTo left,  bottom
                  ctx.lineTo right, bottom
                  ctx.stroke()

        stream = @fs.createWriteStream name

        stream.on 'finish', => @done 'Persisted', location: name, steps: path.length

        @draw_to.createPNGStream().pipe stream

    module.exports = PngPersister
