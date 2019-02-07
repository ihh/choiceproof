var spaceRegex = /^([ \t]*)(.*)/;

function matchIndent (line) {
  var match = spaceRegex.exec (line)
  return { indent: match[1], text: match[2] }
}

// wraps indented blocks in "{" and "}", and prefixes other lines with "_"
// so that a context-free grammar parser can parse indented blocks without maintaining state
function preprocess (text) {
  var lines = text.split("\n")
  var indentStack = [""]
  function currentIndent() { return indentStack[indentStack.length - 1] }
  var result = lines.reduce (function (result, line, n) {
    var match = matchIndent (line), indent = match.indent.length
    if (indent > currentIndent().length) {
      result += " " + currentIndent() + "{\n"
      indentStack.push (match.indent)
    } else {
      while (indent < currentIndent().length) {
	indentStack.pop()
	result += " " + currentIndent() + "}\n"
      }
      if (indent > currentIndent().length) {
	console.warn ("Warning: implicit indent (from " + currentIndent().length + " to " + indent + ") at line " + (n+1))
	result += " " + currentIndent() + "_\n " + match.indent + "{\n"
	indentStack.push (match.indent)
      }
    }
    result += " " + match.indent + "_" + match.text + "\n"
    return result
  }, "{\n")
  while (indentStack.length)
    result += indentStack.pop().substr(1) + "}\n"
  return result
}

module.exports = preprocess
