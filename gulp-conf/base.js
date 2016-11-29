'use strict';

const path = require('path');

exports.paths = {
  lib: 'lib',
  tmp: '.tmp',
  dist: 'dist',
  test: 'test',
  tasks: 'gulp-tasks',
  coverage: 'coverage'
};

exports.path = {};
for (const pathName in exports.paths) {
  if (exports.paths.hasOwnProperty(pathName)) {
    exports.path[pathName] = function pathJoin() {
      const pathValue = exports.paths[pathName];
      const funcArgs = Array.prototype.slice.call(arguments);
      const joinArgs = [pathValue].concat(funcArgs);
      return path.join.apply(this, joinArgs);
    };
  }
}
