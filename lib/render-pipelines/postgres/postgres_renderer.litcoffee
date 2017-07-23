    Madul = require 'madul'

    DB     = undefined
    DIRECT = undefined

    CONFIG_FILE = 'postgres.conf.json'

    class PostgresRenderer extends Madul
      deps: [ '~khaaanfig -> conf = load_connection_details', '~sql-bricks-postgres', '~pg-promise', 'fs', 'path', '~async' ]

      _postgres: => DB

      load_connection_details: (done, fail) ->
        @conf.load_file @path.join process.cwd(), CONFIG_FILE
          .then done
          .catch =>
            @warn 'file-not-found', CONFIG_FILE, fail

      $connect: (done, fail) ->
        user   = "#{@conf.user}:#{@conf.password}"
        server = "#{@conf.host}:#{@conf.port}"

        connection_string = "pg://#{user}@#{server}/#{@conf.name}"

        DB = @pg_promise(promiseLib: require 'q') connection_string

        DB.connect direct: true
          .then (shared_connection_object) =>
            DIRECT = shared_connection_object

            done()
          .catch (err) =>
            @warn 'db-connect-failure', err, fail

    module.exports = PostgresRenderer
