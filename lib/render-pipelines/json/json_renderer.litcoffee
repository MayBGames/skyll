    Madul = require 'madul'
    q     = require 'q'

    class JsonRenderer extends Madul
      deps: [ 'fs', 'path', 'config' ]
      pub:  [ 'flush' ]

      @ctx: undefined

      initialize: (params) =>
        deferred = q.defer()

        super()
          .then =>
            @initialize_rendering_context()

            deferred.resolve @

        deferred.promise

      initialize_rendering_context: => JsonRenderer.ctx = [ ]

      render: (path) => @do_render JsonRenderer.ctx, path

      flush: (level) =>
        location = @path.join __dirname, '..', '..', '..', 'output', "#{level}.json"

        @fs.writeFile location, JSON.stringify(JsonRenderer.ctx), 'utf8', (err) =>
          if err?
            @fail err
          else
            @initialize_rendering_context()
            @done 'Persisted', location: location

    module.exports = JsonRenderer
