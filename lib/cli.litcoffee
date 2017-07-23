    `#! /usr/bin/env node
    `

    if process.env.SKYLL_MADUL_LOGGING == 'true'
      require 'magnus'

    Skyll = require './index'
    args  = require './arguments'
    uuid  = require 'node-uuid'
    fs    = require 'fs'
    path  = require 'path'

    EXTRACT = [
      'rows'
      'columns'
      'width'
      'height'
      'multiplier'
      'pipeline'
      'block'
      'ground'
      'step_count'
      'wall'
    ]

    new Skyll()
      .initialize args
      .then (mod) ->
        levels = [ ]

        if args._?.length > 0
          levels = levels.concat argv._
        else if args.l?
          for level in [0...argv.l]
            levels.push uuid.v4()
        else if Array.isArray args.levels
          for level in args.levels
            levels.push level
        else if args.levels? == false
          levels.push new Date().toString()

        if args.delegates?
          location = args.delegates
        else
          location = path.join process.cwd(), 'skyll.delegates.js'

        fs.stat location, (err) ->
          if err?
            mod.warn 'file-not-found', location
          else
            delegates = require location
            next      = 0
            input     = { }

            for own key, val of args
              input[key] = val if EXTRACT.includes key

            mod.setup_rendering_pipeline args.pipeline
              .then ->
                render = (level) ->
                  mod.craft level, input, delegates
                    .then -> render levels[next] if ++next < levels.length

                render levels[next]
