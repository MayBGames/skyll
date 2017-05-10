    Module = require '../../module'
    q      = require 'q'

    class PngRenderer extends Module
      deps: [ 'fs', 'canvas', 'path', 'config' ]
      pub:  [ 'render', 'flush' ]

      @draw_to: undefined
      @ctx:     undefined

      initialize: (params) =>
        deferred = q.defer()

        super()
          .then =>
            @initialize_drawing_context() unless PngRenderer.draw_to?

            deferred.resolve @

        deferred.promise

      initialize_drawing_context: =>
        width  = @config.width  * @config.grid[0].length
        height = @config.height * @config.grid.length

        PngRenderer.draw_to = new @canvas width, height
        PngRenderer.ctx     = PngRenderer.draw_to.getContext '2d'

      render: (path) => @done @do_render path

      flush: (level) =>
        stream = @fs.createWriteStream @path.join __dirname, '..', '..', '..', 'output', "#{level}.png"

        for row, r in @config.grid
          for cell, c in @config.grid[r]
            @config.grid[r][c] = false

        stream.on 'finish', => @done 'Persisted', location: level

        PngRenderer.draw_to.createPNGStream().pipe stream

    module.exports = PngRenderer
