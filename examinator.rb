require_relative './in_out_parser.rb'
extend InOutParser

## Converting line endings to unix:
InOutParser.newlines_converter('./libs/inputs.txt')
InOutParser.newlines_converter('./libs/outputs.txt')

## Getting each input and each output into an array
inputs = InOutParser.parse_paragraphs('./inputs.txt')
outputs = InOutParser.parse_paragraphs('./outputs.txt')

# Useful for debugging.
# InOutParser.cute_print(inputs, 0.5)
# InOutParser.cute_print(outputs, 0.5)

# Getting an array containing all the source files:
source_files_directory = Dir.getwd + '/sources/'
source_files = Dir.entries(source_files_directory).select { |a| a != '.' && a != '..' }

# Executing them and comparing to the outputs:
preserve_binaries = true
preserve_outputs = true

`mkdir temp`
source_files.each do |source|
  puts "On file #{source} now..."
  counter = 0
  inputs.each do |input|
    input_temp = File.open('./temp/input_temp.txt', 'w')
    input_temp.print input
    input_temp.close # To redirect an input, the input needs to be a separate file

    source_no_extension = source.split('.')[0]

    if preserve_binaries
      `mkdir -p bin`
      gcc_output = 'bin/' + source_no_extension + '.exe'
    else
      gcc_output = 'temp/a.out'
    end

    if preserve_outputs
      `mkdir -p outputs/#{source_no_extension}`
      file_output = 'outputs/' + source_no_extension + "/#{counter += 1}.txt"
    else
      file_output = 'temp/' + source_no_extension
    end

    `g++ sources/#{source} -w -o #{gcc_output}`
    `./#{gcc_output} < temp/input_temp.txt > #{file_output}`
  end
end

# # snippet on how to get timeout on a faulty code:
# Timeout.timeout(1) { `gcc faulty_code.c < some_input` }
# # => Timeout::Error: execution expired
