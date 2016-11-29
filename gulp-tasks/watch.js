const gulp = require('gulp');

gulp.task('watch', function watch() {
  gulp.watch(['lib/**/*.js', 'test/**'], ['test']);
});
