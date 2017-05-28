    PostgresRenderer = require './postgres_renderer'

    class PostgresBlocks extends PostgresRenderer

      do_render: (grid_name, path) =>
        query = @sql_bricks_postgres
          .select 'id'
          .from   'grid'
          .where  name: grid_name
          .limit  1
          .toParams()

        @postgres().one query.text, query.values
          .catch (err)  => @fail err
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

              @postgres().none add.text, add.values
                .then        => next()
                .catch (err) => @fail err
            , => @done()

    module.exports = PostgresBlocks
