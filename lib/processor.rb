require 'colorize'
require 'fileutils'
require 'timeout'

require_relative './safepty'
require_relative './folder_processor'
require_relative './compiler_comparer'

module Processor
  def self.compile_and_compare(inputs, outputs, source_files, cfg, comp_compare)
    FolderProcessor.create_folders(cfg)

    source_files.each do |source|
      puts "On file #{source} now..."
      if cfg['preserve_outs']
        FolderProcessor.create_personal_folders cfg, source
      end

      inputs.each_with_index do |input, counter|
        # To redirect an input, the input must be in a separate file
        input_temp = File.open('./temp/input_temp.txt', 'w')
        input_temp.print input
        input_temp.close

        # Getting the path and output to the file
        compiler_output, file_output = FolderProcessor.parse_outputs cfg, source, counter

        # Run the compiler and get the output
        unless comp_compare.run_compiler source, compiler_output
          puts "File #{source} not compiling".red
          break
        end
        contents = comp_compare.exec_bin compiler_output

        if contents
          if contents == outputs[counter]
            puts "Output #{counter} is working on #{source}".green
          end
          if cfg['preserve_outs']
            comp_compare.save_output source, file_output, contents
          end
        else
          puts "#{source} got a timeout at output #{counter + 1}".red
          break if cfg['timeout_break']
        end
      end
    end
  end
end
