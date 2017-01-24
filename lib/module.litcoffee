    q  = require 'q'
    fs = require 'fs'

    microtime = require 'microtime'

    logger = require './logger'

    available = { }
    loaded    = { }
    processed = { }

    class Module

      constructor: ->
        if arguments.length == 0 || arguments[0] == ''
          @clazz = arguments.callee.caller.name
        else
          @clazz = arguments[0]

        logger.trace "Instantiating #{@clazz}"

      wrap_methods: =>
        @pub?.forEach (method) =>
          callMe   = @[method]
          deferred = q.defer()

          @["_#{method}"] = @[method]

          @[method] = =>
            start    = microtime.now()
            update   = start

            respond = (state, data) =>
              process.nextTick =>
                deferred[state] data

                if state == 'reject'
                  logger.rejected @clazz, method, microtime.now() - start, data

                if process.env.CGAPI_LOG_LEVEL > 4
                  if state == 'resolve'
                    logger.resolved @clazz, method, microtime.now() - start, data
                  else if state == 'notify'
                    logger.notify @clazz, method, microtime.now() - update, data
                    update = microtime.now()

            @done   = (out) => respond 'resolve', out
            @fail   = (err) => respond 'reject',  err
            @update = (out) => respond 'notify',  out

            args = Array.prototype.slice.call arguments

            logger.trace "Invoking #{@clazz}.#{method}()", args

            @["_#{method}"].apply null, args

            deferred.promise

      hydrate_dependencies: =>
        def = q.defer()
        good_to_go = false

        load = (name, path, cb) =>
          if available[name]? == false
            mod = require path

            if typeof mod == 'function'
              new mod()
                .initialize @ctor_params?[name]
                .then (mod) =>
                  available[name] = mod
                  cb()
            else
              available[name] = mod
              cb()
          else
            cb()

        check_directory = (path, dep, cb) =>
          fs.readdir path, (err, files) =>
            if err?
              def.reject type: 'ERROR', info: err
            else
              to_check = files.length
              checked = 0

              files.forEach (f) =>
                depth = "#{path}/#{f}"

                fs.lstat depth, (e, s) =>
                  if s.isDirectory()
                    check_directory depth, dep, =>
                      cb() if ++checked == to_check
                  else if s.isFile()
                    if f == 'index.js' || f.includes '.spec.'
                      cb() if ++checked == to_check
                    else
                      name = f.substring 0, f.length - 3

                      if name == dep
                        load name, depth, => cb() if ++checked == to_check
                      else
                        cb() if ++checked == to_check

        register_dependency = (name, mod) =>
          n = name.replace /\W+/g, '_'
          @[n] = mod

          def.notify type: 'NOTICE', loaded: n

          unless loaded[@clazz]?
            loaded[@clazz] = [ ]

          unless processed[@clazz]?
            processed[@clazz] = 0

          unless loaded[@clazz].indexOf(name) > -1
            loaded[@clazz].push name
            ++processed[@clazz]

          logger.trace 'Registered dependency', "#{@clazz}": "#{n}(file: #{name})"

          if processed[@clazz] >= @deps.length
            if loaded[@clazz].length >= @deps.length
              logger.trace "Loaded all dependencies: #{@clazz}", loaded[@clazz]
              def.resolve @
            else
              not_loaded = [ ]

              @deps.forEach (d) -> not_loaded.push(d) unless loaded[@clazz].indexOf(d) > -1

              logger.error "Failed loading dependencies for: #{@clazz}", not_loaded

              def.reject type: 'ERROR', not_loaded: not_loaded

        @deps?.forEach (d) =>
          if @[d]?
            good_to_go = true
          else
            if available[d]? == true
              register_dependency d, available[d]
            else
              try
                available[d] = require d
                register_dependency d, available[d]
              catch
                check_directory __dirname, d, =>
                  register_dependency d, available[d]

        if good_to_go && loaded[@clazz].length >= @deps.length
          process.nextTick => def.resolve @

        def.promise

      initialize: (wrap = true) =>
        deferred = q.defer()

        if @deps?
          @hydrate_dependencies()
            .then =>
              @wrap_methods() if wrap
              deferred.resolve @
            .fail (reason) => deferred.reject reason
        else
          process.nextTick =>
            @wrap_methods() if wrap
            deferred.resolve @

        @debug = (msg, data) -> logger.debug msg, data
        @info  = (msg, data) -> logger.info  msg, data
        @warn  = (msg, data) -> logger.warn  msg, data
        @error = (msg, data) -> logger.error msg, data

        deferred.promise

    module.exports = Module
