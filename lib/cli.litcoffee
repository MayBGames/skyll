    `#! /usr/bin/env node
    `

    argv = require './arguments'

    levels = [ ]

    if argv._.length > 0
      levels.concat argv._
    else
      for level in [0...argv.l]
        levels.push new Date(Date.now() - (((argv.l - 1) - level) * 1000)).toString()

    process.env.CGAPI_LOG_LEVEL = argv.verbosity

    Skyll = require './skyll'
    next  = 0

    render = (level) ->
      grid = ((false for j in [0..argv.columns]) for i in [0..argv.rows])

      new Skyll()
        .initialize
          starting_row: Math.floor grid.length / 2
          grid:         grid
          cell:         width: argv.w * argv.x, height: argv.h * argv.x
          pipeline:     argv.pipeline.split ','
        .then (mod) -> mod.craft level
        .then -> process.nextTick -> render levels[next] if ++next < levels.length

    render levels[next]
