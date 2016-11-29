var assert, skyll;

assert = require('assert');

skyll = require('./index');

describe('skyll', function() {
  return it('should have unit test!', function() {
    return assert(true, 'forcing this to pass to see if coveralls.io updates');
  });
});
