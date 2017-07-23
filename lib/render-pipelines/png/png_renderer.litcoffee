    Madul = require 'madul'

    class PngRenderer extends Madul
      deps:  [ 'fs', 'canvas', 'path' ]

      draw_to: undefined
      ctx:     undefined

      $init_canvas: (done) ->
        width  = @config.width  * @config.grid[0].length
        height = @config.height * @config.grid.length

        @draw_to = new @canvas width, height
        @ctx     = @draw_to.getContext '2d'

        done()

      flush: (grid, level, done) ->
        location = @path.join __dirname, '..', '..', '..', 'output', "#{grid}.png"
        stream   = @fs.createWriteStream location

        stream.on 'finish', done

        @draw_to.createPNGStream().pipe stream

    module.exports = PngRenderer
