    module.exports = require 'yargs'
      .usage 'Usage: $0 [options] name1 name2 ...'
      .example '$0',
        'Creates a 50 x 15 level with 16 x 14 cells and an auto-generated name'
      .example '$0 -vvvvvvvv',
        "Create a 50 x 15 level with 16 x 14 cells, an auto-generated name, and
        logging set to verbosity level 8 (max)"
      .example '$0 -w 20 -h 20',
        'Creates a 50 x 15 level with 40 X 40 cells & an auto-generated name'
      .example '$0 -w 10 -h 10 -x 4',
        'Creates a 50 x 15 level with 40 x 40 cells and an auto-generated name'
      .example '$0 lvl1 lvl2',
        'Creates two levels, lvl1 & lvl2, each 50 X 15 with 16 x 14 cells'
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
      .alias 'l', 'levels'
      .describe 'l', 'Number of auto-named levels to create'
      .alias 'p', 'pipeline'
      .describe 'p', 'The steps of the render pipleline'
      .default
        verbosity:  3
        rows:       15
        columns:    50
        width:      8
        height:     7
        multiplier: 4
        levels:     1
        pipeline:   'png_blocks,png_walls,png_step_count'
      .help 'help'
      .epilogue '© Bryan Maynard 2016'
      .argv
