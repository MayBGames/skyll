    Madul = require 'madul'
    q     = require 'q'

    class JsonRenderer extends Madul
      deps: [ 'fs', 'path', 'config' ]
      pub:  [ 'flush' ]

      @ctx: undefined

      post_initialize: =>
        JsonRenderer.ctx = [ ]
        @done()

      render: (path) => @do_render JsonRenderer.ctx, path

      flush: (level) =>
        location = @path.join __dirname, '..', '..', '..', 'output', "#{level}.json"

        @fs.writeFile location, JSON.stringify(JsonRenderer.ctx), 'utf8', (err) =>
          if err?
            @fail err
          else
            @done 'Persisted', location: location

    module.exports = JsonRenderer
