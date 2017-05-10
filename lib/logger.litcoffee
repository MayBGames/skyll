    winston    = require 'winston'
    prettyjson = require 'prettyjson'

    pretty = prettyjson.render
    args   =
      noAlign:            true
      inlineArrays:       true
      defaultIndentation: 2

    clone_depth = 0
    clone_limit = process.env.MADUL_LOG_LEVEL - 4

    commaize = (x) -> x.toString().replace /\B(?=(\d{3})+(?!\d))/g, ','

    clone = (obj) ->
      if obj == null || typeof obj != 'object'
        obj
      else
        temp = { }

        for key, val of obj
          if typeof val == 'object' && Array.isArray(val) == false
            if clone_depth++ < clone_limit
              temp[key] = clone val
            else
              temp[key] = 'nested object'
          else if typeof val != 'function' && key != 'clauses'
            if key.toLowerCase().includes 'password'
              temp[key] = '********'
            else
              temp[key] = val

        clone_depth = 0

        temp

    winston.loggers.add 'trace',
      console:
        level: 'silly'
        formatter: (o) ->
          meta = if o.meta?   then "\n#{pretty o.meta, args, 2}" else ''
          msg  = if o.message then o.message                     else ''

          "#{msg}#{meta}"

    winston.loggers.add 'debug',
      console:
        level: 'debug'
        formatter: (o) ->
          meta = if o.meta?   then "\n#{pretty o.meta, args, 2}" else ''
          msg  = if o.message then o.message                     else ''

          "\n-= ^.^ =-\n\n#{msg}#{meta}\n"

    winston.loggers.add 'info',
      console:
        level: 'info'
        formatter: (o) ->
          first = o.level.toUpperCase()
          meta  = if o.meta?   then "\n\n#{pretty o.meta, args, 4}" else ''
          msg   = if o.message then "\n  #{o.message}"              else ''

          "#{first}#{msg}#{meta}\n\n-= o.o =-\n\n"

    winston.loggers.add 'warn',
      console:
        level: 'warn'
        timestamp: -> new Date()
        formatter: (o) ->
          level = o.level.toUpperCase()
          time  = "  #{o.timestamp()}"
          meta  = if o.meta?   then "\n#{pretty o.meta, args, 6}" else ''
          msg   = if o.message then "\n    #{o.message}"          else ''

          "\n... -= o.O =- ...  #{level}#{time}#{msg}#{meta}\n"

    winston.loggers.add 'error',
      console:
        level: 'error'
        timestamp: -> new Date()
        formatter: (o) ->
          level = o.level.toUpperCase()
          time  = "  #{o.timestamp()}"
          meta  = if o.meta?   then "\n#{pretty o.meta, args, 6}" else ''
          msg   = if o.message then "\n    #{o.message}"          else ''

          "\n!!! -= O.O =- !!!  #{level}\n#{time}#{msg}#{meta}\n"

    resolved = (clazz, method, runtime, data) ->
      stats = "status: success, runtime: #{commaize runtime}μ"
      trace "#{clazz}.#{method}(#{stats})", data

    notify = (clazz, method, delta, data) ->
      stats = "status: update, iteration: #{commaize delta}μ"
      trace "#{clazz}.#{method}(#{stats})", data

    rejected = (clazz, method, runtime, data) ->
      stats = "status: error, runtime: #{commaize runtime}μ"
      error "#{clazz}.#{method}(#{stats})", data

    trace = (msg, meta) ->
      if process.env.MADUL_LOG_LEVEL > 4
        winston.loggers.get('trace').silly msg, clone meta

    debug = (msg, meta) ->
      if process.env.MADUL_LOG_LEVEL > 3
        winston.loggers.get('debug').debug msg, clone meta

    info = (msg, meta) ->
      if process.env.MADUL_LOG_LEVEL > 2
        winston.loggers.get('info').info msg, clone meta

    warn = (msg, meta) ->
      if process.env.MADUL_LOG_LEVEL > 1
        winston.loggers.get('warn').warn msg, clone meta

    error = (msg, meta) ->
      if process.env.MADUL_LOG_LEVEL > 0
        winston.loggers.get('error').error msg, clone meta

    module.exports =
      resolved: resolved
      rejected: rejected
      notify:   notify
      trace:    trace
      debug:    debug
      info:     info
      warn:     warn
      error:    error
