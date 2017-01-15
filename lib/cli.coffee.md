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
      .default
        verbosity:  3
        rows:       15
        columns:    50
        width:      8
        height:     7
        multiplier: 2
      .help 'help'
      .epilogue '© Bryan Maynard 2017'
      .argv

    levels = if argv._.length > 0 then argv._ else [ new Date().toString() ]

    process.env.CGAPI_LOG_LEVEL = argv.verbose

    fs     = require 'fs'
    path   = require 'path'
    Canvas = require 'canvas'
    Carver = require './carver'

    cell       = width: argv.w * argv.x, height: argv.h * argv.x
    board      = cols: argv.c, rows: argv.r
    dimensions = width: cell.width * board.cols, height: cell.height * board.rows

    render = (level, index) ->
      grid   = ((false for j in [0..board.cols]) for i in [0..board.rows])
      canvas = new Canvas dimensions.width, dimensions.height
      ctx    = canvas.getContext '2d'

      new Carver()
        .initialize
          row:      Math.floor board.rows / 2
          grid:     grid
          board:    board
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
          grid[mod.row][mod.col] = true

          mod.carve_path().then (steps) ->
            console.log level, "--> #{steps.length} total steps"

            for step in steps
              ctx.beginPath()
              ctx.rect cell.width * step.col, cell.height * step.row, cell.width, cell.height
              ctx.fillStyle = 'white'
              ctx.fill()
              ctx.lineWidth = 1
              ctx.strokeStyle = 'black'
              ctx.stroke()

            canvas
              .createPNGStream()
              .pipe fs.createWriteStream path.join __dirname, '..', 'output', "#{level}.png"

            render levels[index + 1], index + 1 if index + 1 < levels.length

    render levels[0], 0
