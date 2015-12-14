require 'yaml'
require 'colorize'
require_relative './lib/in_out_parser.rb'
require_relative './lib/processor.rb'
require_relative './lib/compiler_comparer.rb'

## Loading configurations
cfg = YAML.load_file './lib/settings.yml'

## Converting line endings to unix:
InOutParser.newlines_converter(cfg['inputs_dir'])
InOutParser.newlines_converter(cfg['outputs_dir'])

## Getting each input and each output into an array
inputs = InOutParser.parse_paragraphs(cfg['inputs_dir'])
outputs = InOutParser.parse_paragraphs(cfg['outputs_dir'])

# Getting an array containing all the source files:
source_files = Dir.entries(cfg['source_dir'])
source_files.select! { |a| a != '.' && a != '..' }

# Executing them and comparing to the outputs:
comp_compare = CompilerComparer.new(cfg)
Processor.compile_and_compare(inputs, outputs, source_files, cfg, comp_compare)
`rm -r temp`

# Useful for debugging.
# InOutParser.cute_print(inputs, 0.5)
# InOutParser.cute_print(outputs, 0.5)
# puts( cfg.map{ |k,v| "#{k} => #{v}".red }.sort )
