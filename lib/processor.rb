require 'colorize'
require 'fileutils'
require 'timeout'

require_relative './safepty'
require_relative './folder_processor'
require_relative './compiler_comparer'

class Processor
  def initialize(cfg)
    @cfg = cfg
  end

  def compile_and_compare(inputs, outputs, source_files, comp_compare)
    scores = []
    FolderProcessor.create_folders(@cfg)
    source_files.each do |source|
      puts "On file #{source} now..."
      FolderProcessor.create_personal_folders @cfg, source if @cfg['preserve_outs']
      score = 0

      inputs.each_with_index do |input, counter|
        # To redirect an input, the input must be in a separate file
        input_to_temp(input)

        # Getting the path and output to the file
        compiler_output, file_output = FolderProcessor.parse_outputs @cfg, source, counter

        # Run the compiler and get the output
        if comp_compare.compile source, compiler_output
          contents = comp_compare.exec_bin compiler_output
        else
          puts "File #{source} not compiling".red
          break
        end

        case compare_output(contents, outputs, counter)
        when true
          score += 1
          comp_compare.save_output source, file_output, contents if @cfg['preserve_outs']
          # puts "Output #{counter} is working on #{source}".green
        when nil
          puts "#{source} got a timeout at output #{counter + 1}".red
          break if @cfg['timeout_break']
        end
      end

      scores << { 'file' => source.split('.')[0],
                  'score' => score,
                  'no_tests' => inputs.size }
    end

    puts report_results(scores).sort
  end

  def input_to_temp(input)
    input_temp = File.open('./temp/input_temp.txt', 'w')
    input_temp.print input
    input_temp.close
  end

  def compare_output(contents, outputs, counter)
    return nil unless contents
    return true if contents == outputs[counter]
    false
  end

  def report_results(scores)
    ret = []
    scores.map do |k| 
      ret << "#{k['file']}\tScore: #{k['score']}/#{k['no_tests']}" + "\n"
    end
    ret
  end
end
