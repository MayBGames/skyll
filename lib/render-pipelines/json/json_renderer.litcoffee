    Madul = require 'madul'

    class JsonRenderer extends Madul
      deps: [ 'fs', 'path' ]

      flush: (ctx, level, done, fail) ->
        location = @path.join __dirname, '..', '..', '..', 'output', "#{level}.json"

        @fs.writeFile location, JSON.stringify(ctx), 'utf8', (err) =>
          if err?
            fail err
          else
            done location

    module.exports = JsonRenderer
