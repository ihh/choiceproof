{
  function extend (a, b) {
    Object.keys(b).forEach (function (k) {
      if (b.hasOwnProperty(k))
	a[k] = b[k]
    })
    return a
  }
  
  function tidy (child) {
    if (!child.length)
      return { indent: "", lines: [] }
    return { indent: child[0].indent,
	     lines: child.map (function (c) { delete c.indent; return c }) }
  }
}

ChoiceScriptBlock
  = BeginBlock lines:Lines EndBlock { return tidy (lines) }

BeginBlock = "."+ Indent "{" EOL
EndBlock = "."+ Indent "}" EOL
InBlock = Spaces n:Number i:Indent "_" { return { indent: i,
						  line: n } }

Lines
  = first:Line rest:Lines { return [first].concat (rest) }
  / "" { return [] }

Line
  = Choice
  / SceneList
  / Conditional
  / StatChart
  / Comment
  / CommandLine
  / TextLine

Comment
  = i:InBlock ast:"*" c:"comment" rest:Text EOL { return extend (i,
								 { command: c,
								   text: ast + c + rest }) }

StatChart
  = i:InBlock ast:"*" c:"stat_chart" s:Spaces EOL child:StatsBlock { return extend (i,
										    { command: c,
										      text: ast + c + s,
										      child: child }) }

StatsBlock
  = BeginBlock lines:Stat+ EndBlock { return tidy (lines) }

Stat
  = i1:InBlock type:"opposed_pair" s:Spaces stat1:Word rest1:Text EOL BeginBlock i2:InBlock stat2:Word rest2:Text EOL EndBlock { return extend (i1,
																		{ type: type,
																		  stat: stat1,
																		  stat2: stat2,
																		  text: type + s + stat1 + rest1,
																		  child: extend (i2,
																				 { lines: [{ text: stat2 + rest2 }] }) }) }
  / i:InBlock type:("percent" / "text") s:Spaces stat:Word rest:Text EOL { return extend (i,
											  { type: type,
											    stat: stat,
											    text: type + s + stat + rest }) }

Conditional
  = i:IfBlock e:ElseBlock { return extend (i,
					   { sibling: tidy ([e]) }) }
  / IfBlock

IfBlock
  = i:InBlock ast:"*" c:"if" a:Args EOL child:ChoiceScriptBlock { return extend (i,
										 { command: c,
										   args: a.args,
										   text: ast + c + a.text,
										   child: child }) }

ElseBlock
  = i:InBlock ast:"*" c:"else" s:Spaces EOL child:ChoiceScriptBlock { return extend (i,
										     { command: c,
										       text: ast + c + s,
										       child: child }) }

SceneList
  = i:InBlock ast:"*" c:"scene_list" s:Spaces EOL child:ScenesBlock { return extend (i,
										     { command: c,
										       text: ast + c + s,
										       child: child }) }

ScenesBlock
  = BeginBlock lines:Scene+ EndBlock { return tidy (lines) }

Scene
  = i:InBlock scene:Word rest:Text EOL { return extend (i,
							{ scene: scene,
							  text: scene + rest }) }

Choice
  = i:InBlock ast:"*" c:"choice" s:Spaces EOL child:OptionsBlock { return extend (i,
										  { command: c,
										    text: ast + c + s,
										    child: child }) }

OptionsBlock
  = BeginBlock lines:Option+ EndBlock { return tidy (lines) }

Option
  = i:InBlock hash:"#" opt:Text EOL child:ChoiceScriptBlock { return extend (i,
									     { option: opt,
									       text: hash + opt,
									       child: child}) }

CommandLine = i:InBlock ast:"*" c:Command a:Args EOL { return extend (i,
								      { command: c,
									args: a.args,
									text: ast + c + a.text }) }

TextLine = i:InBlock t:Text EOL { return extend (i,
						 { text: t }) }

Indent
  = [ ]? s:Spaces { return s }  /* Ignore the first character of the indent, added by the preprocessor */

Spaces = s:[ ]* { return s.join('') }

Text
  = text:[^\n\r]* { return text.join('') }

Command
  = c:[A-Za-z_]+ { return c.join('') }

Word
  = w:[^ \n\r\t]+ { return w.join('') }

Args
  = s:[ ]? a:Text { return { text: (s || '') + a,
			     args: a } }

Number
  = digits:[0-9]+ { return parseInt(digits.join(""), 10) }

EOL
  = [\n\r]

