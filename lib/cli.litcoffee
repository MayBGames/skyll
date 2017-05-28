    `#! /usr/bin/env node
    `

    Skyll = require './skyll'
    next  = 0

    new Skyll()
      .initialize()
      .then (mod) ->
        levels = mod.config.levels

        render = (level) ->
          mod.craft level
            .then ->
              console.log 'finished rendering level', next
              render levels[next] if ++next < levels.length

        render levels[next]
