const path = require('path');
const gulp = require('gulp');
const nsp = require('gulp-nsp');
const conf = require('../gulp-conf/base');

gulp.task('nsp', function securityCheck(cb) {
  nsp({package: path.resolve('package.json')}, cb);
});
