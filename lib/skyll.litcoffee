    Madul = require 'madul'

    class Skyll extends Madul
      deps: [ 'config', 'carver', 'async' ]
      pub:  [ 'craft' ]

      render_pipeline: [ ]
      renderers:       [ ]

      post_initialize: =>
        pipe = [ ]

        for p in @config.pipeline
          if Array.isArray p
            for q in p
              pipe.push q unless pipe.includes q
          else
            pipe.push p unless pipe.includes p

        @hydrate pipe, =>
          renderer_pushed = false
          for p in @config.pipeline
            if Array.isArray p
              @renderers.push @[p[0]]

              new_pipeline = for q in p
                @[q]

              @render_pipeline.push new_pipeline
            else
              unless renderer_pushed
                @renderers.push @[p]
                renderer_pushed = true

              @render_pipeline.push @[p]

          @carver.starting_row = Math.floor @config.grid.length / 2

          @done()

      do_flush: (i, level_name, next) =>
        if @renderers[i].flush?
          flushed = @renderers[i].flush level_name

          if typeof flushed?.then == 'function'
            flushed.then => next()
          else
            next()
        else
          next()

      do_render: (step, path, level_name, next) =>
        console.log 'rendering', step.constructor.name

        status = step.render path, level_name

        if typeof status?.then == 'function'
          status.then => next()
        else
          next()

      craft: (level_name) =>
        @carver.clear_state()

        path = @carver.carve_path()

        @async.eachOfSeries @render_pipeline, (pipeline, i, next) =>
          if Array.isArray pipeline
            @async.eachSeries pipeline, (step, nxt) =>
              @do_render step, path, level_name, nxt
            , => @do_flush i, level_name, next
          else
            @do_render pipeline, path, level_name, =>
              if i == @render_pipeline.length - 1
                @do_flush 0, level_name, next
              else
                next()
        , => @done()

    module.exports = Skyll
