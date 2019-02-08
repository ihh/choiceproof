function unparse (block, newlineAtEnd) {
  return block.lines.reduce (function (result, line, lineNum) {
    var printNewline = newlineAtEnd || (lineNum < block.lines.length - 1)
    result += block.indent + line.text
    if (line.child && line.child.lines.length) {
      var siblingBlock = line.sibling
      result += "\n" + unparse (line.child, printNewline && !siblingBlock)
      if (siblingBlock)
	result += "\n" + unparse (siblingBlock, printNewline)
    } else if (printNewline)
      result += "\n"
    return result
  }, "")
}

module.exports = unparse
