    module.exports = require 'yargs'
      .usage 'Usage: $0 [options] levelname anotherlevelname yetanotherlevelname ...'
      .example '$0',
        "Creates a level with default row and column counts,
         the default size and multiplier for each cell,
         an auto-generated name,
         and logging set to default verbosity\n"
      .example '$0 -vvvvvvvv',
        "Creates a level with default row and column counts,
         the default size and multiplier for each cell,
         an auto-generated name,
         and logging set to verbosity level 8 (max)\n"
      .example '$0 -w 20 -h 20',
        "Creates a level with default row and column counts,
         the cells 20 units wide, 20 units high,
         expanded by the default multiplier,
         an auto-generated name,
         and logging set to default verbosity\n"
      .example '$0 -w 10 -h 10 -x 4',
        "Creates a level with default row and column counts,
         40 x 40 unit cells,
         an auto-generated name,
         and logging set to default verbosity\n"
      .example '$0 lvl1 lvl2',
        "Creates two levels; named lvl1 and lvl2 -
         each with default row and column counts,
         the default size and multiplier for each cell,
         and logging set to default verbosity\n"
      .example '$0 --levels one two three',
        "Creates three levels; named one, two, and three -
         each with default row and column counts,
         the default size and multiplier for each cell,
         and logging set to default verbosity\n"
      .example '$0 -l10',
        "Creates ten auto-named levels -
         each with default row and column counts,
         the default size and multiplier for each cell,
         and logging set to default verbosity\n"
      .count 'verbosity'
      .alias 'v', 'verbosity'
      .describe 'v', 'Level of logging verbosity: 1 - 8'
      .alias 'r', 'rows'
      .describe 'r', 'Number of rows for map'
      .alias 'c', 'columns'
      .describe 'c', 'Number of columns for map'
      .alias 'w', 'width'
      .describe 'w', 'Width of a grid cell'
      .alias 'h', 'height'
      .describe 'h', 'Height of a grid cell'
      .alias 'x', 'multiplier'
      .describe 'x', 'Increase cell size by x times'
      .number 'l'
      .describe 'l', 'Number of auto-named levels to create'
      .array 'levels'
      .describe 'levels', 'Array of named levels to create'
      .array 'pipeline'
      .alias 'p', 'pipeline'
      .describe 'p', 'The steps of the render pipleline'
      .conflicts 'levels', 'l'
      .help 'help'
      .default
        verbosity:  3
        rows:       15
        columns:    50
        width:      8
        height:     7
        multiplier: 4
        pipeline:   [ 'png_blocks', 'png_walls', 'png_step_count' ]
      .epilogue '© Bryan Maynard 2016'
      .wrap 120
      .argv
