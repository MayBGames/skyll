    Module = require './module'
    Carver = require './carver'
    q      = require 'q'

    class Skyll extends Module
      deps: [ 'q' ]
      pub:  [ 'craft' ]

      render_pipeline: [ ]
      starting_row:    0

      grid: undefined

      cell:
        width:  0
        height: 0

      pathfinder: (neighbors) ->
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

      initialize: (params) =>
        deferred = q.defer()

        @grid = params.grid
        @cell = params.cell

        @ctor_params = { }

        @starting_row = params.starting_row

        for p in params.pipeline
          @ctor_params[p] =
            width:  params.cell.width  * params.grid[0].length
            height: params.cell.height * params.grid.length
            cell:   params.cell

          @deps.push p unless @deps.includes p

        super().then =>
          for p in params.pipeline
            @render_pipeline.push @[p] unless @render_pipeline.includes @[p]
          deferred.resolve @

        deferred.promise

      craft: (level) =>
        new Carver()
          .initialize @grid, @starting_row, @pathfinder
          .then (mod)  => mod.carve_path()
          .then (path) => @q.all @render_pipeline.map (p) => p.render path
          .then        => @render_pipeline[0].flush level
          .then        => @render_pipeline[0].reset()
          .then        => @done()

    module.exports = Skyll
