    Module = require './module'
    q      = require 'q'
    argv   = require './arguments'
    path   = require 'path'
    fs     = require 'fs'

    process.env.CGAPI_LOG_LEVEL = if argv?.verbosity? then argv.verbosity else 3

    class Config extends Module

      pathfinder: (neighbors) ->
        o = [ ]

        for n in [1..(neighbors.length / 1)]
          c = 1 / neighbors.length

          if neighbors[n - 1] == 'RIGHT'
            o.push "#{neighbors[n - 1]}": ((c * n) * ((2 / c) * 0.5)) * c
          else
            o.push "#{neighbors[n - 1]}": ((c * n) * (0.5 / c)) * c

        chance = Math.random()

        for option in o
          neighbor = Object.keys(option)[0]

          return neighbor if option[neighbor] > chance

      initialize: (params) =>
        deferred = q.defer()
        levels   = [ ]
        base     = if params?.location? then params.location else path.join __dirname, '..'
        config   = path.join base, '.skyll.conf.js'

        fs.stat config, (err) =>
          if err? || params?.cli?
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
          else
            for key, val of require config
              unless @[key]?
                if key == 'levels'
                  for level in [0...val]
                    levels.push new Date(Date.now() - (((val - 1) - level) * 1000)).toString()
                else
                  @[key] = val

          levels.push new Date().toString() if levels.length == 0

          @levels = levels
          @grid   = ((false for j in [0..@columns]) for i in [0..@rows])
          @width  = @width  * @multiplier
          @height = @height * @multiplier

          super().then => deferred.resolve @

        deferred.promise

    module.exports = Config
