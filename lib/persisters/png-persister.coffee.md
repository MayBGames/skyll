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

        for step in path
          ctx.beginPath()
          ctx.rect @cell_width * step.col, @cell_height * step.row, @cell_width, @cell_height
          ctx.fillStyle = @block_fill_color
          ctx.fill()
          ctx.lineWidth   = @block_border_width
          ctx.strokeStyle = @block_border_color
          ctx.stroke()

        @draw_to.createPNGStream().pipe @fs.createWriteStream name

        @debug 'Persisted', location: name, steps: path.length

        @done()

    module.exports = PngPersister
