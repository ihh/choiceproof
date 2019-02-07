var assert = require('assert')
var execSync = require('child_process').execSync
var fs = require('fs')
var tmp = require('tmp')

var binPath = 'bin/choiceproof'
var csDir = __dirname + '/../choicescript'
describe('echo tests (' + binPath + ')', function() {
  fs.readdirSync (csDir).forEach (function (filename) {
    if (filename.match(/.txt$/)) {
      it('should echo ' + filename, function (done) {
	var path = csDir + '/' + filename
	var orig = fs.readFileSync (path).toString()
	var output = runCommand ('--echo ' + path)
	assert.equal (orig, output)
	done()
      })
    }
  })
})

function runCommand (args) {
  var cmdline = process.argv[0] + ' ' + __dirname + '/../' + binPath + ' ' + args
  var text = execSync(cmdline,{stdio:['pipe','pipe',process.env.TRAVIS ? 'pipe' : 'ignore']}).toString()
  return text
}
