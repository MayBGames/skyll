    Module = require '../../module'
    q      = require 'q'

    class PngRenderer extends Module
      deps: [ 'fs', 'canvas' ]
      pub:  [ 'render' ]

      draw_to: undefined

      dimensions:  undefined
      cell_width:  undefined
      cell_height: undefined

      initialize: (params) =>
        deferred = q.defer()

        super()
          .then =>
            @draw_to     = new @canvas params.width, params.height
            @cell_width  = params.cell.width
            @cell_height = params.cell.height

            deferred.resolve @

        deferred.promise

      render: (level, path) =>
        @ctx = @draw_to.getContext '2d'

        @do_render path

        stream = @fs.createWriteStream level

        stream.on 'finish', => @done 'Persisted', location: level, steps: path.length

        @draw_to.createPNGStream().pipe stream

    module.exports = PngRenderer
