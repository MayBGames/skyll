    Madul = require 'madul'
    path  = require 'path'

    if process.env.SKYLL_MADUL_LOGGING != 'true'
      Madul.LISTEN '!.PostgresRenderer.file-not-found', ->
        console.log """\nConfig file needed:
          To use the Postgres render pipeline,
          please create #{path.join process.cwd(), 'postgres.conf.json'}
          and populate it with database connection details:
          {
            \"user\": {db username},
            \"password\": {db password},
            \"host\": {db host},
            \"port\": {db port},
            \"name\": {db name - skyll is a good default}
          }\n"""

      Madul.LISTEN '!.Carver.carve-failure', ->
        console.log 'Carve failure:', arguments

      Madul.LISTEN '!.Skyll.file-not-found', ->
        console.log """\nDelegate file needed:
          To build a level,
          please create #{arguments[0]}
          and populate it with the following delegate methods:
          {
            \"pathfinder\": {carves a path for the level through a grid},
            \"grounder\": {renders ground tiles for each block in the carved path},
            \"waller\": {renders wall tiles for each block in the carved path},
            \"roofer\": {renders roof tiles for each block in the carved path},
            \"platformer\": {renders platform tiles for each block in the carved path}
          }\n"""

    module.exports = require './skyll'
