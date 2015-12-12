# Ruby Examinator

Basic Ruby program to grade code-based tests or exams. 

## What will work?

This program should work with almost any text output. However, since the code use paragraphs idea to separe the inputs and outputs, it will not work if the desired input or output has an empty line besides the ending one.

An example of valid output:
`0 1 0 
0 1 0 
0 1 0`

An invalid one:
`0 1 0 
0 1 0

0 1 0`

## Installation and Usage

Having Ruby preinstalled (tested with version 2.2.3p173),

0. $ git clone https://github.com/Drowze/ruby-examinator.git && cd ruby-examinator
1. Copy both inputs.txt and outputs into sources folder
2. Put the source codes to be tested (e.g.: the students')
3. Set your boolean options (to-do: command-line options)
4. $ ruby examinator.rb
