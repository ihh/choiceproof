function unparse (block, newlineAtEnd) {
  return block.lines.reduce (function (result, line, lineNum) {
    var printNewline = newlineAtEnd || (lineNum < block.lines.length - 1)
    result += block.indent + line.text
    if (line.child && line.child.lines.length)
      result += "\n" + unparse (line.child, printNewline)
    else if (printNewline)
      result += "\n"
    return result
  }, "")
}

module.exports = unparse
