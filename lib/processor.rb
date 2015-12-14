require 'yaml'
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
      FolderProcessor.create_personal_folders cfg, source

      inputs.each_with_index do |input, counter|
        # To redirect an input, the input must to be a separate file
        input_temp = File.open('./temp/input_temp.txt', 'w')
        input_temp.print input
        input_temp.close 

        # Getting the path and output to the file
        compiler_output, file_output = FolderProcessor.parse_outputs cfg, source, counter

        # Run the compiler
        comp_compare.run_compiler source, compiler_output
        contents = comp_compare.exec_bin compiler_output
        
        # Debug shit
        #p contents, outputs[counter]

        if contents
          if contents == outputs[counter]
            puts 'DEU!'
          end
          if cfg['preserve_bins']
            comp_compare.save_output source, file_output, contents
          end
        else
          puts "#{source} com problema"
          break
        end
      end
    end
    # Debug shit
    puts( cfg.map{ |k,v| "#{k} => #{v}".red }.sort )
  end
end

# # snippet on how to get timeout on a faulty code:
# Timeout.timeout(1) { `gcc faulty_code.c < some_input` }
# # => Timeout::Error: execution expired
