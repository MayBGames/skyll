    `#! /usr/bin/env node
    `

    Madul = require 'madul'

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
            pipe      = [ ]

            for own key, val of args
              input[key] = val if EXTRACT.includes key


            Madul.DUMMY pipe, (dum) ->
              dum.render_pipeline = [ ]

              for p in input.pipeline
                if Array.isArray p
                  new_pipeline = for q in p
                    dum[Madul.PARSE_SPEC(q).ref]

                  dum.render_pipeline.push new_pipeline
                else
                  dum.render_pipeline.push dum[Madul.PARSE_SPEC(p).ref]

              args = { }
              name = new Date().toString()

              for own key, val of input
                args[key] = val if EXTRACT.includes key

              render = (level) ->
                mod.craft level, input, dum.render_pipeline, delegates
                  .then -> render levels[next] if ++next < levels.length

              render levels[next]
