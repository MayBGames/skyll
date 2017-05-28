    Madul = require 'madul'

    class Config extends Madul

      deps: [ 'arguments', 'fs', 'path', 'node-uuid' ]

      post_initialize: =>
        levels = [ ]

        process.env.MADUL_LOG_LEVEL = if @arguments?.verbosity? then @arguments.verbosity else 3

        if @arguments.conf?
          config = @arguments.conf
        else
          config = @path.join __dirname, '..', '.skyll.conf.js'


        if @arguments?._?.length > 0
          levels = levels.concat argv._
        else if @arguments?.l?
          for level in [0...argv.l]
            levels.push @node_uuid.v4()
        else if @arguments?.levels? == false
          levels.push new Date().toString()

        for key, val of @arguments
          if key.length > 2 && typeof val != 'undefined'
            if key == 'levels'
              levels = levels.concat val
            else
              if typeof val == 'object' && val != null && val.length? == false
                @dive_deeper key, val, @
              else
                @[key] = val

        @fs.stat config, (err) =>
          if err?
            @fail 'DOES NOT EXIST', file: config
          else
            for key, val of require config
              if key == 'levels'
                for level in [0...val]
                  levels.push new Date(Date.now() - (((val - 1) - level) * 1000)).toString()
              else
                if typeof val == 'object' && val != null && val.length? == false
                  @dive_deeper val, @
                else
                  @[key] = val

          levels.push new Date().toString() if levels.length == 0

          @levels = levels
          @grid   = ((false for j in [0..@columns]) for i in [0..@rows])
          @width  = @width  * @multiplier
          @height = @height * @multiplier

            @done()

        deferred.promise

      dive_deeper: (obj, context) =>
        for key, val of obj
          context[key] = { } unless context[key]?

          if typeof val == 'object' && val != null && val.length? == false
            @dive_deeper val, context[key]
          else
            context[key] = val

    module.exports = Config
