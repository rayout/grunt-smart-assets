'use strict';

grunt = require('grunt');


#  ======== A Handy Little Nodeunit Reference ========
#  https://github.com/caolan/nodeunit
#
#  Test methods:
#    test.expect(numAssertions)
#    test.done()
#  Test assertions:
#    test.ok(value, [message])
#    test.equal(actual, expected, [message])
#    test.notEqual(actual, expected, [message])
#    test.deepEqual(actual, expected, [message])
#    test.notDeepEqual(actual, expected, [message])
#    test.strictEqual(actual, expected, [message])
#    test.notStrictEqual(actual, expected, [message])
#    test.throws(block, [error], [message])
#    test.doesNotThrow(block, [error], [message])
#    test.ifError(value)


exports.smart_assets =
  setUp: (done) ->
    done();

  assetsTest: (test) ->

    actual = []
    expected = []
    grunt.file.expand({cwd: 'test/test-app/dist', filter: 'isFile'}, '**/*').forEach (file)->
      actual.push(file)
    grunt.file.expand({cwd: 'test/expected/dist', filter: 'isFile'}, '**/*').forEach (file)->
      expected.push(file)
    test.deepEqual(actual, expected, 'should be equal');
    test.done();


  htmlTest: (test) ->
    actual = grunt.file.read('test/test-app/html-dest/master.html');
    expected = grunt.file.read('test/expected/html-dest/master.html');
    test.equal(actual, expected, 'should be equal');

    test.done();

