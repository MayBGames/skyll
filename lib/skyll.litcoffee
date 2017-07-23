    Madul = require 'madul'

    class Skyll extends Madul
      deps: [ 'carver', 'async', 'path' ]

      _do_flush: (step, ctx, level_name, exception, next) =>
        if step.flush?
          step.flush ctx, level_name
            .then  next
            .catch (err) =>
              console.log 'flushing', err
              exception err
        else
          next()

      _do_render: (ctx, step, path, level_name, exception, next) =>
        step.render ctx, path, level_name
          .then  next
          .catch (err) =>
            console.log 'rendering', err
            exception err

      _decorate: (thing, args, delegates) =>
        for i in [ 'args', 'delegates' ]
          if thing[i]?
            for j in thing[i]
              thing.set j, if i == 'args' then args[j] else delegates[j]

        thing

      craft: (level_name, args, pipeline, delegates, done, exception) ->
        ctx = [ ]

        @carver.carve_path delegates.pathfinder, args.rows, args.columns
          .then (path) =>
            console.log 'STARTING RENDER'
            @async.eachOfSeries pipeline, (pipe, i, next) =>
              if Array.isArray pipe
                @async.eachSeries pipe, (step, nxt) =>
                  decorated = @_decorate step, args, delegates

                  @_do_render ctx, decorated, path, level_name, exception(nxt), nxt
                , =>
                  @_do_flush pipeline[i][0], ctx, level_name, exception(next), => next()
              else
                decorated = @_decorate pipe, args, delegates

                @_do_render ctx, decorated, path, level_name, exception(next), =>
                  if i == pipeline.length - 1
                    @_do_flush decorated, ctx, level_name, exception(next), => next()
                  else
                    next()
            , done
          .catch exception

    module.exports = Skyll
