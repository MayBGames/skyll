    Madul = require 'madul'

    DB     = undefined
    DIRECT = undefined

    class PostgresRenderer extends Madul
      deps: [ 'sql-bricks-postgres', 'pg-promise', 'config', 'fs', 'path', 'async' ]
      pub:  [ 'render' ]

      postgres: => DB

      post_initialize: =>
        if DB == undefined
          user   = "#{@config.db.user}:#{@config.db.password}"
          server = "#{@config.db.host}:#{@config.db.port}"

          connection_string = "pg://#{user}@#{server}/#{@config.db.name}"

          DB = @pg_promise(promiseLib: require 'q') connection_string

          DB.connect direct: true
            .then (shared_connection_object) =>
              DIRECT = shared_connection_object

              @done()
        else
          @done()

      render: (path, grid_name) =>
        location = @path.join __dirname, '..', '..', '..', 'output', "#{grid_name}.json"

        @fs.readFile location, 'utf8', (err, data) =>
          @done @do_render grid_name, JSON.parse data

    module.exports = PostgresRenderer
