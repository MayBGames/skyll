    `#! /usr/bin/env node
    `

    Config = require './config'

    new Config()
      .initialize cli: true
      .then (config) ->
        Skyll = require './skyll'
        next  = 0

        render = (level) ->
          grid   = ((false for j in [0..config.columns]) for i in [0..config.rows])
          width  = config.width  * config.multiplier
          height = config.height * config.multiplier

          new Skyll()
            .initialize
              starting_row: Math.floor grid.length / 2
              grid:         grid
              cell:         width: width, height: height
              pipeline:     config.pipeline
            .then (mod) -> mod.craft level
            .then -> render config.levels[next] if ++next < config.levels.length

        render config.levels[next]
