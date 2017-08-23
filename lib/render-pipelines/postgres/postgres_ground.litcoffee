    PostgresRenderer = require './postgres_renderer'

    DB = undefined

    class PostgresGround extends PostgresRenderer

      delegates: [
        'ground'
        'stairs_up'
      ]

      $register_db_instance: (done) ->
        DB = @_postgres()
        done()

      render: (path, grid_name, done, exception) ->
        grid_save_query = @sql_bricks_postgres
          .insert 'grid', name: grid_name
          .returning 'id'
          .toParams()

        DB.one grid_save_query.text, grid_save_query.values
          .then (g) =>
            @async.each path, (p, next) =>
              block_save_query = @sql_bricks_postgres
                .insert 'block',
                  grid:       g.id
                  size:       "(#{p.width.actual}, #{p.height.actual})"
                  properties: p.props
                  direction:  p.direction
                .returning 'id'
                .toParams()

              DB.one block_save_query.text, block_save_query.values
                .then (b) =>
                  @async.each p.landscape.nodes, (node, nxt) =>
                    node_save_query = @sql_bricks_postgres
                      .insert 'node',
                        block:    b.id
                        kind:     node.type
                        size:     "(#{node.width}, #{node.height})"
                        location: "(#{node.x}, #{node.y})"
                      .returning 'id'
                      .toParams()

                    DB.one node_save_query.text, node_save_query.values
                      .then (n) =>
                        faces  = @[node.type] node
                        params =
                          node:        n.id
                          left_face:   faces.left
                          top_face:    faces.top
                          right_face:  faces.right
                          bottom_face: faces.bottom
                          front_face:  faces.front
                          back_face:   faces.back

                        geom_query = @sql_bricks_postgres
                          .insert 'geometry', params
                          .toParams()

                        DB.none geom_query.text, geom_query.values
                          .then => nxt()
                          .catch exception nxt
                      .catch exception nxt
                  , => next()
                .catch exception next
            , => done()

    module.exports = PostgresGround
