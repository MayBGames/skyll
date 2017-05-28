    PostgresRenderer = require './postgres_renderer'

    class PostgresGrid extends PostgresRenderer

      do_render: (grid_name, path) =>
        query = @sql_bricks_postgres
          .insert 'grid', name: grid_name
          .toParams()

        @postgres().none  query.text, query.values
          .then        => @done()
          .catch (err) => @fail err

    module.exports = PostgresGrid
