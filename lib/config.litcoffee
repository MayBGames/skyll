    Module = require './module'
    q      = require 'q'
    argv   = require './arguments'
    path   = require 'path'
    fs     = require 'fs'

    process.env.CGAPI_LOG_LEVEL = if argv?.verbosity? then argv.verbosity else 3

    class Config extends Module

      initialize: (params) =>
        deferred = q.defer()
        levels   = [ ]

        if params?.location?
          config = params.location
        else if argv.conf?
          config = argv.conf
        else
          config = path.join __dirname, '..', '.skyll.conf.js'


        if argv?._?.length > 0
          levels = levels.concat argv._
        else if argv?.l?
          for level in [0...argv.l]
            levels.push new Date(Date.now() - (((argv.l - 1) - level) * 1000)).toString()
        else if argv?.levels? == false
          levels.push new Date().toString()

        for key, val of argv
          if key.length > 2 && typeof val != 'undefined'
            if key == 'levels'
              levels = levels.concat val
            else
              @[key] = val

        fs.stat config, (err) =>
          if err?
            return deferred.reject @error 'DOES NOT EXIST', file: config
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

          super().then => deferred.resolve @

        deferred.promise

      dive_deeper: (obj, context) =>
        for key, val of obj
          context[key] = { } unless context[key]?

          if typeof val == 'object' && val != null && val.length? == false
            @dive_deeper val, context[key]
          else
            context[key] = val

    module.exports = Config
