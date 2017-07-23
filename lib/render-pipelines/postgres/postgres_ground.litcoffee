    PostgresRenderer = require './postgres_renderer'

    class PostgresGround extends PostgresRenderer

      args: [ 'wall' ]

      render: (path, _, grid_name, done, exception) ->
        grid_query = @sql_bricks_postgres
          .select 'id'
          .from   'grid'
          .where  name: grid_name
          .limit  1
          .toParams()

        @_postgres().one grid_query.text, grid_query.values
          .then (grid) =>
            piece_query = @sql_bricks_postgres
              .select 'id'
              .from   'piece'
              .where  mode: 'GROUND'
              .limit  1
              .toParams()

            @_postgres().one piece_query.text, piece_query.values
              .then (piece) =>
                @async.each path, (item, all_inserted) =>
                  block_query = @sql_bricks_postgres
                    .select 'id'
                    .from   'block'
                    .where
                      grid:  grid.id
                      index: path.indexOf item
                    .limit  1
                    .toParams()

                  @_postgres().one block_query.text, block_query.values
                    .then (block) =>
                      @async.each item.ground, (ground, inserted) =>
                        properties =
                          x:      item.ground.indexOf ground
                          y:      @wall.segments - ground.thickness
                          block:  block.id
                          piece:  piece.id
                          volume: x: 1, y: ground.thickness, z: 1

                        add = @sql_bricks_postgres
                          .insert 'point', properties
                          .toParams()

                        @_postgres().none add.text, add.values
                          .catch exception
                          .then  inserted
                      , all_inserted
                    .catch exception
                , done
              .catch exception

    module.exports = PostgresGround
