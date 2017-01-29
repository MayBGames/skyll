    Module = require './module'
    Carver = require './carver'
    q      = require 'q'

    class Skyll extends Module
      deps: [ 'q', 'config' ]
      pub:  [ 'craft' ]

      render_pipeline: [ ]

      initialize: (params) =>
        deferred      = q.defer()
        @starting_row = params.starting_row

        super().then =>
          for p in @config.pipeline
            @deps.push p unless @deps.includes p

          @hydrate_dependencies().then =>
            for p in @config.pipeline
              @render_pipeline.push @[p] unless @render_pipeline.includes @[p]

            deferred.resolve @

        deferred.promise

      craft: (level) =>
        new Carver()
          .initialize @starting_row
          .then (mod)  => mod.carve_path()
          .then (path) => @q.all @render_pipeline.map (p) => p.render path
          .then        => @render_pipeline[0].flush level
          .then        => @render_pipeline[0].reset()
          .then        => @done()

    module.exports = Skyll
