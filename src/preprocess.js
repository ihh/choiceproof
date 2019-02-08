var spaceRegex = /^([ \t]*)(.*)/;

function matchIndent (line) {
  var match = spaceRegex.exec (line)
  return { indent: match[1], text: match[2] }
}

// wraps indented blocks in "{" and "}", and prefixes other lines with "_"
// so that a context-free grammar parser can parse indented blocks without maintaining state
var lineNumWidth = 6
var noLineNumber = ".".repeat (lineNumWidth)
var dummyIndent = " "
function preprocess (text) {
  var lines = text.split("\n")
  var indentStack = [""]
  function currentIndent() { return indentStack[indentStack.length - 1] }
  var result = lines.reduce (function (result, line, n) {
    var match = matchIndent (line), indent = match.indent.length
    if (indent > currentIndent().length) {
      result += noLineNumber + dummyIndent + currentIndent() + "{\n"
      indentStack.push (match.indent)
    } else {
      while (indent < currentIndent().length) {
	indentStack.pop()
	result += noLineNumber + dummyIndent + currentIndent() + "}\n"
      }
      if (indent > currentIndent().length) {
	console.warn ("Warning: implicit indent (from " + currentIndent().length + " to " + indent + ") at line " + (n+1))
	result += noLineNumber + dummyIndent + currentIndent() + "_\n"
	  + noLineNumber + dummyIndent + match.indent + "{\n"
	indentStack.push (match.indent)
      }
    }
    var lineNum = "" + (n + 1)
    while (lineNum.length < lineNumWidth)
      lineNum = " " + lineNum
    result += lineNum + dummyIndent + match.indent + "_" + match.text + "\n"
    return result
  }, noLineNumber + "{\n")
  while (indentStack.length)
    result += noLineNumber + indentStack.pop().substr(1) + "}\n"
  return result
}

module.exports = preprocess
