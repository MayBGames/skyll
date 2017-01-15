    `#! /usr/bin/env node
    `

    UUID = require 'uuid-1345'

    argv = require 'yargs'
      .count 'verbose'
      .alias 'n', 'name'
      .alias 'v', 'verbose'
      .alias 'r', 'rows'
      .alias 'c', 'columns'
      .alias 'w', 'width'
      .alias 'h', 'height'
      .alias 'x', 'multiplier'
      .default
        name:       UUID.v4()
        verbose:    3
        rows:       15
        columns:    50
        width:      8
        height:     7
        multiplier: 2
      .argv

    process.env.CGAPI_LOG_LEVEL = argv.verbose

    fs     = require 'fs'
    path   = require 'path'
    Canvas = require 'canvas'
    Carver = require './carver'

    cell       = width: argv.w * argv.x, height: argv.h * argv.x
    board      = cols: argv.c, rows: argv.r
    dimensions = width: cell.width * board.cols, height: cell.height * board.rows
    canvas     = new Canvas dimensions.width, dimensions.height
    ctx        = canvas.getContext '2d'

    grid = ((false for j in [0..board.cols]) for i in [0..board.rows])

    farthest_right = 0

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
            .pipe fs.createWriteStream path.join __dirname, '..', 'output', "#{argv.name}.png"
