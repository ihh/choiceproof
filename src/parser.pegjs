{
  function tidy (child) {
    if (!child.length)
      return { indent: "", lines: [] }
    return { indent: child[0].indent,
	     lines: child.map (function (c) { delete c.indent; return c }) }
  }
}

ChoiceScriptBlock
  = BeginBlock lines:Lines EndBlock { return tidy (lines) }

BeginBlock = Indent "{" EOL
EndBlock = Indent "}" EOL
ContinueBlock = i:Indent "_" t:Text EOL { return { indent: i, text: t } }

Lines
  = first:Line rest:Lines { return [first].concat (rest) }
  / "" { return [] }

Line
  = parent:ContinueBlock child:ChoiceScriptBlock { parent.child = child; return parent }
  / ContinueBlock

Indent
  = [ ]? spaces:[ ]* { return spaces.join('') }

Text
  = text:[^\n\r]* { return text.join('') }

EOL
  = [\n\r]

