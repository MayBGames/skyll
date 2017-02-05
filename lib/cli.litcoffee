    `#! /usr/bin/env node
    `

    Config = require './config'

    new Config()
      .initialize()
      .then (config) ->
        Skyll = require './skyll'
        next  = 0

        render = (level) ->
          new Skyll()
            .initialize starting_row: Math.floor config.grid.length / 2
            .then (mod) -> mod.craft level
            .then -> render config.levels[next] if ++next < config.levels.length

        render config.levels[next]
