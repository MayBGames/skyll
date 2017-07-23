    module.exports = require 'yargs'
      .usage 'Usage: $0 [options] levelname anotherlevelname yetanotherlevelname ...'
      .example '$0',
        "Creates a level with default row and column counts,
         the default size and multiplier for each cell,
         and an auto-generated name\n"
      .example '$0 -w 20 -h 20',
        "Creates a level with default row and column counts,
         the cells 20 units wide, 20 units high,
         expanded by the default multiplier,
         an auto-generated name\n"
      .example '$0 -w 10 -h 10 -x 4',
        "Creates a level with default row and column counts,
         40 x 40 unit cells,
         an auto-generated name\n"
      .example '$0 lvl1 lvl2',
        "Creates two levels; named lvl1 and lvl2 -
         each with default row and column counts,
         the default size and multiplier for each cell\n"
      .example '$0 --levels one two three',
        "Creates three levels; named one, two, and three -
         each with default row and column counts,
         the default size and multiplier for each cell\n"
      .example '$0 -l10',
        "Creates ten auto-named levels -
         each with default row and column counts,
         the default size and multiplier for each cell\n"
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
      .string 'conf'
      .describe 'conf', 'Absolute path to config file'
      .string 'block.fill_color'
      .describe 'block.fill_color', 'Path block color. Can be an html color name or hex value'
      .string 'ground.fill_color'
      .describe 'ground.fill_color', 'Ground block color. Can be an html color name or hex value'
      .string 'step_count.text.align'
      .choices 'step_count.text.align', [ 'left', 'center', 'right' ]
      .string 'step_count.text.color'
      .describe 'step_count.text.color', 'Can be either html color names or hex values'
      .number 'ground.segments'
      .describe 'ground.segments', 'The number of horizontal pieces of ground between the left and right edges of the block'
      .number 'ground.max_height_diff'
      .describe 'ground.max_height_diff', 'The height unit difference between two adjacent ground segments'
      .number 'ground.max_segment_width'
      .describe 'ground.max_segment_width', 'The number of ground segments wide the widest a single ground segment can be'
      .number 'wall.width'
      .string 'wall.color'
      .describe 'wall.color', 'Can be either html color names or hex values'
      .number 'wall.segments'
      .describe 'wall.segments', 'The number of vertical pieces of wall between the ground and roof'
      .conflicts 'levels', 'l'
      .help 'help'
      .default
        rows:       15
        columns:    50
        width:      24
        height:     24
        multiplier: 4
        # pipeline:   [ 'skyll#json_blocks', 'skyll#json_ground', 'skyll#json_walls', 'skyll#json_platforms' ]
        # pipeline:   [ 'skyll#png_blocks', 'skyll#png_walls', 'skyll#png_ground', 'skyll#png_platforms', 'skyll#png_step_count' ]
        pipeline: [
          [ '.json_blocks',   '.json_ground', '.json_walls', '.json_platforms' ]
          # [ 'skyll#png_blocks',    'skyll#png_ground',  'skyll#png_walls',  'skyll#png_roof', 'skyll#png_platforms', 'skyll#png_step_count' ]
          [ '.postgres_grid', '.postgres_blocks', '.postgres_ground' ]
        ]
        block:
          fill_color: 'white'
        ground:
          fill_color:     '#888'
          segments:        24
          max_height_diff: 4
          max_segment_width: 6
        step_count:
          text:
            align: 'center'
            color: 'black'
        wall:
          width: 1
          color: '#666'
          segments: 48
      .epilogue '© Bryan Maynard 2016'
      .wrap 120
      .argv
