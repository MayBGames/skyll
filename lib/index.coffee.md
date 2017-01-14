    fs     = require 'fs'
    path   = require 'path'
    Canvas = require 'canvas'
    Carver = require './carver'

    cell       = width: 8 * 2, height: 7 * 2
    board      = cols: 50, rows: 15
    dimensions = width: cell.width * board.cols, height: cell.height * board.rows
    canvas     = new Canvas dimensions.width, dimensions.height
    ctx        = canvas.getContext '2d'

    grid = ((false for j in [0..board.cols]) for i in [0..board.rows])

    farthest_right = 0

    new Carver()
      .initialize()
      .then (mod) ->
        mod.row   = Math.floor board.rows / 2
        mod.grid  = grid
        mod.board = board

        grid[mod.row][mod.col] = true

        mod.carve_path().then (p) ->
          for row, r in grid
            for col, c in row
              if col == false
                ctx.beginPath()
                ctx.rect cell.width * c, cell.height * r, cell.width, cell.height
                ctx.fillStyle = 'black'
                ctx.fill()
                ctx.lineWidth = 1
                ctx.strokeStyle = 'black'
                ctx.stroke()

          canvas
            .createPNGStream()
            .pipe fs.createWriteStream path.join __dirname, 'test.png'

    module.exports = {}
