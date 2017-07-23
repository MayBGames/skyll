    PostgresRenderer = require './postgres_renderer'

    class PostgresBlocks extends PostgresRenderer

      render: (path, _, grid_name, done, exception) ->
        query = @sql_bricks_postgres
          .select 'id'
          .from   'grid'
          .where  name: grid_name
          .limit  1
          .toParams()

        @_postgres().one query.text, query.values
          .then  (grid) =>
            @async.each path, (item, next) =>
              properties =
                x:     item.x
                y:     item.y
                grid:  grid.id
                index: path.indexOf item

              add = @sql_bricks_postgres
                .insert 'block', properties
                .toParams()

              @_postgres().none add.text, add.values
                .then  next
                .catch exception
            , done
          .catch exception

    module.exports = PostgresBlocks
