const gulp = require('gulp');

gulp.task('execute', function doExec() {
  return require('../dist/cli');
});
