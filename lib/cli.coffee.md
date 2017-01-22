    `#! /usr/bin/env node
    `

    argv = require 'yargs'
      .usage 'Usage: $0 [options] name1 name2 ...'
      .example '$0',
        'Creates a 50 x 15 level with 16 x 14 cells and an auto-generated name'
      .example '$0 -vvvvvvvv',
        "Create a 50 x 15 level with 16 x 14 cells, an auto-generated name, and
        logging set to verbosity level 8 (max)"
      .example '$0 -w 20 -h 20',
        'Creates a 50 x 15 level with 40 X 40 cells & an auto-generated name'
      .example '$0 -w 10 -h 10 -x 4',
        'Creates a 50 x 15 level with 40 x 40 cells and an auto-generated name'
      .example '$0 lvl1 lvl2',
        'Creates two levels, lvl1 & lvl2, each 50 X 15 with 16 x 14 cells'
      .count 'verbosity'
      .alias 'v', 'verbosity'
      .describe 'v', 'Level of logging verbosity: 1 - 8'
      .alias 'r', 'rows'
      .describe 'r', 'Number of rows for map'
      .alias 'c', 'columns'
      .describe 'c', 'Number of columns for map'
      .alias 'w', 'width'
      .describe 'w', 'Width of a grid cell'
      .alias 'h', 'height'
      .describe 'h', 'Height of a grid cell'
      .alias 'x', 'multiplier'
      .describe 'x', 'Increase cell size by x times'
      .alias 'l', 'levels'
      .describe 'l', 'Number of auto-named levels to create'
      .default
        verbosity:  3
        rows:       15
        columns:    50
        width:      8
        height:     7
        multiplier: 4
        levels:     1
      .help 'help'
      .epilogue '© Bryan Maynard 2016'
      .argv

    levels = [ ]

    if argv._.length > 0
      levels.concat argv._
    else
      for level in [0...argv.l]
        levels.push new Date(Date.now() - (((argv.l - 1) - level) * 1000)).toString()

    process.env.CGAPI_LOG_LEVEL = argv.verbosity

    path   = require 'path'
    Carver = require './carver'

    PngPersister = require './persisters/png-persister'

    cell       = width: argv.w * argv.x, height: argv.h * argv.x
    board      = cols: argv.c, rows: argv.r
    dimensions = width: cell.width * board.cols, height: cell.height * board.rows

    next = 0

    render = (level) ->
      grid = ((false for j in [0..board.cols]) for i in [0..board.rows])

      new Carver()
        .initialize
          steps: 0
          path:  [ ]
          row:   Math.floor board.rows / 2
          col:   0
          grid:  grid
          board: board
          farthest_right:
            row: 0
            col: 0
          total_distance:     0
          previous_direction: undefined
          director: (neighbors) ->
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
        .then (mod) ->
          mod.grid[mod.row][mod.col] = true
          mod.path.push
            row: mod.row
            col: mod.col

          mod.carve_path()
        .then (steps) ->
          new PngPersister()
            .initialize
              dimensions:  dimensions
              cell_width:  cell.width
              cell_height: cell.height
            .then (png) ->
              name = path.join __dirname, '..', 'output', "#{level}.png"

              png.persist name, steps
                .then -> process.nextTick -> render levels[next] if ++next < levels.length

    render levels[next]
