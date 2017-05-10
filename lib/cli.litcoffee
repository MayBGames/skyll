    `#! /usr/bin/env node
    `

    Config = require './config'

    new Config()
      .initialize()
      .then (config) ->
        Skyll = require './skyll'
        next  = 0

        new Skyll()
          .initialize starting_row: Math.floor config.grid.length / 2
          .then (mod) ->
            render = (level) ->
              mod.craft level
                .then ->
                  console.log 'finished rendering level', next
                  render config.levels[next] if ++next < config.levels.length

            render config.levels[next]
