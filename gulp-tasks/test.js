const gulp = require('gulp');
const path = require('path');
const mocha = require('gulp-mocha');
const istanbul = require('gulp-istanbul');
const isparta = require('isparta');
const plumber = require('gulp-plumber');
const coveralls = require('gulp-coveralls');
const excludeGitignore = require('gulp-exclude-gitignore');
const conf = require('../gulp-conf/base');

gulp.task('pre-test', function preTest() {
  // console.log('pre-test ' + conf.path.dist('**/*.js'));
  return gulp.src([conf.path.tmp('**/*.js'), '!' + conf.path.tmp('**/*.spec.js')])
    .pipe(excludeGitignore())
    .pipe(istanbul({
      includeUntested: true
    }))
    .pipe(istanbul.hookRequire());
});

gulp.task('run-tests', function runTests(cb) {
  var mochaErr;

  gulp.src(conf.path.tmp('**/*.spec.js'))
    .pipe(plumber())
    .pipe(mocha({reporter: 'spec'}))
    .on('error', function (err) {
      mochaErr = err;
    })
    .pipe(istanbul.writeReports())
    .on('end', function () {
      cb(mochaErr);
    });
});

gulp.task('coveralls', function runCoveralls() {
  if (!process.env.CI) {
    return;
  }

  return gulp.src(conf.path.coverage('lcov.info'))
    .pipe(coveralls());
});
