[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Build Status](https://travis-ci.org/ihh/choiceproof.svg?branch=master)](https://travis-ci.org/ihh/choiceproof)
[![Coverage Status](https://coveralls.io/repos/github/ihh/choiceproof/badge.svg?branch=master)](https://coveralls.io/github/ihh/choiceproof?branch=master)

# choiceproof

A [PegJS](https://pegjs.org/)-based parser for [ChoiceScript](https://www.choiceofgames.com/make-your-own-games/choicescript-intro/)[tm].

## Overview

This (example file [animal.txt](choicescript/animal.txt) from ChoiceScript repo)
~~~~
*comment Copyright 2010 by Dan Fabulich.
*comment 
*comment Please see original for licensing info.Dan Fabulich licenses this file to you under the
*comment ChoiceScript License, Version 1.0 (the "License"); you may
*comment not use this file except in compliance with the License. 
*comment You may obtain a copy of the License at
*comment 
*comment  http://www.choiceofgames.com/LICENSE-1.0.txt
*comment 
*comment See the License for the specific language governing
*comment permissions and limitations under the License.
*comment 
*comment Unless required by applicable law or agreed to in writing,
*comment software distributed under the License is distributed on an
*comment "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
*comment either express or implied.

What kind of animal will you be?
*choice
  #Lion
    *goto claws
  #Tiger
    *label claws
    In that case, you'll have powerful claws and a mighty roar!
    *finish
  #Elephant
    Well, elephants are interesting animals, too.
    *finish
~~~~

Parse with `bin/choiceproof choicescript/animal.txt`

This should yield the following JSON:

~~~~
{
  "indent": "",
  "lines": [
    {
      "line": 1,
      "command": "comment",
      "text": "*comment Copyright 2010 by Dan Fabulich."
    },
    {
      "line": 2,
      "command": "comment",
      "text": "*comment "
    },
    {
      "line": 3,
      "command": "comment",
      "text": "*comment Dan Fabulich licenses this file to you under the"
    },
    {
      "line": 4,
      "command": "comment",
      "text": "*comment ChoiceScript License, Version 1.0 (the \"License\"); you may"
    },
    {
      "line": 5,
      "command": "comment",
      "text": "*comment not use this file except in compliance with the License. "
    },
    {
      "line": 6,
      "command": "comment",
      "text": "*comment You may obtain a copy of the License at"
    },
    {
      "line": 7,
      "command": "comment",
      "text": "*comment "
    },
    {
      "line": 8,
      "command": "comment",
      "text": "*comment  http://www.choiceofgames.com/LICENSE-1.0.txt"
    },
    {
      "line": 9,
      "command": "comment",
      "text": "*comment "
    },
    {
      "line": 10,
      "command": "comment",
      "text": "*comment See the License for the specific language governing"
    },
    {
      "line": 11,
      "command": "comment",
      "text": "*comment permissions and limitations under the License."
    },
    {
      "line": 12,
      "command": "comment",
      "text": "*comment "
    },
    {
      "line": 13,
      "command": "comment",
      "text": "*comment Unless required by applicable law or agreed to in writing,"
    },
    {
      "line": 14,
      "command": "comment",
      "text": "*comment software distributed under the License is distributed on an"
    },
    {
      "line": 15,
      "command": "comment",
      "text": "*comment \"AS IS\" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,"
    },
    {
      "line": 16,
      "command": "comment",
      "text": "*comment either express or implied."
    },
    {
      "line": 17,
      "text": ""
    },
    {
      "line": 18,
      "text": "What kind of animal will you be?"
    },
    {
      "line": 19,
      "command": "choice",
      "text": "*choice",
      "child": {
        "indent": "  ",
        "lines": [
          {
            "line": 20,
            "option": "Lion",
            "text": "#Lion",
            "child": {
              "indent": "    ",
              "lines": [
                {
                  "line": 21,
                  "command": "goto",
                  "args": "claws",
                  "text": "*goto claws"
                }
              ]
            }
          },
          {
            "line": 22,
            "option": "Tiger",
            "text": "#Tiger",
            "child": {
              "indent": "    ",
              "lines": [
                {
                  "line": 23,
                  "command": "label",
                  "args": "claws",
                  "text": "*label claws"
                },
                {
                  "line": 24,
                  "text": "In that case, you'll have powerful claws and a mighty roar!"
                },
                {
                  "line": 25,
                  "command": "finish",
                  "args": "",
                  "text": "*finish"
                }
              ]
            }
          },
          {
            "line": 26,
            "option": "Elephant",
            "text": "#Elephant",
            "child": {
              "indent": "    ",
              "lines": [
                {
                  "line": 27,
                  "text": "Well, elephants are interesting animals, too."
                },
                {
                  "line": 28,
                  "command": "finish",
                  "args": "",
                  "text": "*finish"
                }
              ]
            }
          }
        ]
      }
    }
  ]
}
~~~~

## Defects

The following should be straightforward to add, I just haven't done so yet

- labels
- syntax-aware expression parsing
- multi-file parsing
- optional modifiers in front of choices (`#selectable_if`, `#allow_reuse`, etc)
- conditionals around choices. See e.g. [Advanced ChoiceScript](https://www.choiceofgames.com/make-your-own-games/choicescript-advanced/) for details

## Disclaimers

If I've done something a really weird way it's because I'm still learning JavaScript (and programming).

Instructive pull requests welcomed.
