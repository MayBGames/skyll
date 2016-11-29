const gulp = require('gulp');
const coffee = require('gulp-coffee');
const conf = require('../gulp-conf/base');

gulp.task('brew-code', function brewCode() {
  return gulp.src(conf.path.lib('**/*.coffee.md'), { sourcemaps: true })
    .pipe(coffee({ bare: true }))
    .pipe(gulp.dest(conf.path.tmp()));
  }
);

gulp.task('brew-tests', function brewTests() {
  return gulp.src(conf.path.test('**/*.spec.coffee.md'), { sourcemaps: true })
    .pipe(coffee({ bare: true }))
    .pipe(gulp.dest(conf.path.tmp()));
  }
);
