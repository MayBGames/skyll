const gulp = require('gulp');
const HubRegistry = require('gulp-hub');
const conf = require('./gulp-conf/base');
const hub = new HubRegistry([conf.path.tasks('*.js')]);

gulp.registry(hub);

gulp.task('default', gulp.series(
  'clean',
  'brew-code',
  'brew-tests',
  'pre-test',
  'run-tests',
  'coveralls'
));

gulp.task('compile', gulp.series('clean', 'brew-code'));

gulp.task('prepublish', gulp.series('nsp'));
