    PostgresRenderer = require './postgres_renderer'

    class PostgresGrid extends PostgresRenderer

      render: (_, __, grid_name, done, exception) ->
        query = @sql_bricks_postgres
          .insert 'grid', name: grid_name
          .toParams()

        @_postgres().none query.text, query.values
          .then  done
          .catch exception

    module.exports = PostgresGrid
