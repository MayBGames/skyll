    PostgresRenderer = require './postgres_renderer'

    class PostgresGround extends PostgresRenderer

      do_render: (grid_name, path) =>
        grid_query = @sql_bricks_postgres
          .select 'id'
          .from   'grid'
          .where  name: grid_name
          .limit  1
          .toParams()

        @postgres().one grid_query.text, grid_query.values
          .catch (err)  => @fail err
          .then  (grid) =>
            piece_query = @sql_bricks_postgres
              .select 'id'
              .from   'piece'
              .where  mode: 'GROUND'
              .limit  1
              .toParams()

            @postgres().one piece_query.text, piece_query.values
              .catch (err)   => @fail err
              .then  (piece) =>
                @async.each path, (item, all_inserted) =>
                  block_query = @sql_bricks_postgres
                    .select 'id'
                    .from   'block'
                    .where
                      grid:  grid.id
                      index: path.indexOf item
                    .limit  1
                    .toParams()

                  @postgres().one block_query.text, block_query.values
                    .then (block) =>
                      @async.each item.ground, (ground, inserted) =>
                        properties =
                          x:      item.ground.indexOf ground
                          y:      @config.wall.segments - ground.thickness
                          block:  block.id
                          piece:  piece.id
                          volume: x: 1, y: ground.thickness, z: 1

                        add = @sql_bricks_postgres
                          .insert 'point', properties
                          .toParams()

                        @postgres().none add.text, add.values
                          .then        => inserted()
                          .catch (err) => @fail err
                      , => all_inserted()
                , => @done()

    module.exports = PostgresGround
