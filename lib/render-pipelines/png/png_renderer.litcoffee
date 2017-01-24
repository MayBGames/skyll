    Module = require '../../module'
    q      = require 'q'

    class PngRenderer extends Module
      deps: [ 'fs', 'canvas' ]
      pub:  [ 'render' ]

      @draw_to: undefined
      @ctx:     undefined

      @board_width:  undefined
      @board_height: undefined

      @cell_width:  undefined
      @cell_height: undefined

      initialize: (params) =>
        deferred = q.defer()

        super()
          .then =>
            unless PngRenderer.draw_to?
              PngRenderer.cell_width  = params.cell.width
              PngRenderer.cell_height = params.cell.height

              PngRenderer.board_width  = params.width
              PngRenderer.board_height = params.height

              PngRenderer.draw_to = new @canvas params.width, params.height
              PngRenderer.ctx     = PngRenderer.draw_to.getContext '2d'

            deferred.resolve @

        deferred.promise

      render: (level, path) =>
        @ctx = @draw_to.getContext '2d'

        @do_render path

        stream = @fs.createWriteStream level

        stream.on 'finish', => @done 'Persisted', location: level, steps: path.length

        @draw_to.createPNGStream().pipe stream

    module.exports = PngRenderer
