{
  var currentIndent = 0
}

ChoiceScript
  = Line Choicescript
  / Line

Line
  = indent:Indent text:Text { return indent + "> " + text }

Indent
  = i:Spaces &{ arguments[0] === currentIndent }

Spaces
  = " " indent:Spaces { return indent + 1 }
  / " " { return 1 }

Text
  = first:[\S] rest:[^\n]* { return first + rest }
