    Madul = require 'madul'

    class Skyll extends Madul
      deps: [ 'config', 'carver', 'async' ]
      pub:  [ 'craft' ]

      render_pipeline: [ ]
      renderers:       [ ]

      initialize: (params) =>
        deferred = q.defer()

        super().then =>
          for p in @config.pipeline
            if Array.isArray p
              for q in p
                @deps.push q unless @deps.includes q
            else
              @deps.push p unless @deps.includes p

          @hydrate_dependencies().then =>
            for p in @config.pipeline
              if Array.isArray p
                @renderers.push @[p[0]]

                new_pipeline = for q in p
                  @[q]

                @render_pipeline.push new_pipeline
              else
                @renderers.push @[p]
                @render_pipeline.push @[p]

            @carver.starting_row = params.starting_row

            deferred.resolve @

        deferred.promise

      craft: (level_name) =>
        @carver.clear_state()

        path = @carver.carve_path()

        @async.mapSeries @render_pipeline, (step, next) =>
          i = @render_pipeline.indexOf step

          if Array.isArray step
            @q.all step.map (pipeline) => pipeline.render path, level_name
              .then => @renderers[i].flush level_name
              .then => next()
          else
            step.render path, level_name
              .then => @renderers[i].flush level_name
              .then => next()
        , => @done()

    module.exports = Skyll
