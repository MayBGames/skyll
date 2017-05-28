    Madul = require 'madul'

    class PngRenderer extends Madul
      deps: [ 'fs', 'canvas', 'path', 'config' ]
      pub:  [ 'render', 'flush' ]

      @draw_to: undefined
      @ctx:     undefined

      post_initialize: =>
        unless PngRenderer.draw_to
          width  = @config.width  * @config.grid[0].length
          height = @config.height * @config.grid.length

          PngRenderer.draw_to = new @canvas width, height
          PngRenderer.ctx     = PngRenderer.draw_to.getContext '2d'

        @done()

      render: (path, level_name) =>
        location = @path.join __dirname, '..', '..', '..', 'output', "#{level_name}.json"
        @fs.readFile location, 'utf8', (err, data) =>
          @done @do_render PngRenderer.ctx, JSON.parse data

      flush: (level_name) =>
        stream = @fs.createWriteStream @path.join __dirname, '..', '..', '..', 'output', "#{level_name}.png"

        stream.on 'finish', => @done 'Persisted', location: level_name

        PngRenderer.draw_to.createPNGStream().pipe stream

    module.exports = PngRenderer
