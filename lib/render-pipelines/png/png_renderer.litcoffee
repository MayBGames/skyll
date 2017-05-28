    q      = require 'q'
    Madul = require 'madul'

    class PngRenderer extends Madul
      deps: [ 'fs', 'canvas', 'path', 'config' ]
      pub:  [ 'render', 'flush' ]

      @draw_to: undefined
      @ctx:     undefined

      initialize: (params) =>
        deferred = q.defer()

        super()
          .then =>
            @initialize_drawing_context()

            deferred.resolve @

        deferred.promise

      initialize_drawing_context: =>
        width  = @config.width  * @config.grid[0].length
        height = @config.height * @config.grid.length

        PngRenderer.draw_to = new @canvas width, height
        PngRenderer.ctx     = PngRenderer.draw_to.getContext '2d'

      render: (path, level_name) =>
        location = @path.join __dirname, '..', '..', '..', 'output', "#{level_name}.json"
        @fs.readFile location, 'utf8', (err, data) =>
          @done @do_render PngRenderer.ctx, JSON.parse data

      flush: (level_name) =>
        stream = @fs.createWriteStream @path.join __dirname, '..', '..', '..', 'output', "#{level_name}.png"

        stream.on 'finish', =>
          @initialize_drawing_context()
          @done 'Persisted', location: level_name

        PngRenderer.draw_to.createPNGStream().pipe stream

    module.exports = PngRenderer
