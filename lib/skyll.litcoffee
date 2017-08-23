    Madul = require 'madul'

    class Skyll extends Madul
      deps: [ '~volor', 'async', 'path' ]

      _do_flush: (step, ctx, level_name, exception, next) =>
        if step.flush?
          step.flush ctx, level_name
            .then  next
            .catch (err) =>
              console.log 'flushing', err
              exception err
        else
          next()

      _do_render: (ctx, step, level_name, exception, next) =>
        step.render ctx, level_name
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
        map = @volor()

        @async.eachOfSeries pipeline, (pipe, i, next) =>
          if Array.isArray pipe
            @async.eachSeries pipe, (step, nxt) =>
              decorated = @_decorate step, args, delegates

              @_do_render map, decorated, level_name, exception(nxt), nxt
            , =>
              @_do_flush pipeline[i][0], map, level_name, exception(next), => next()
          else
            decorated = @_decorate pipe, args, delegates

            @_do_render map, decorated, level_name, exception(next), =>
              if i == pipeline.length - 1
                @_do_flush decorated, map, level_name, exception(next), => next()
              else
                next()
        , done

    module.exports = Skyll
