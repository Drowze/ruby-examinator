require 'yaml'
require 'colorize'
require 'fileutils'
require_relative './folder_processor'

module Processor
  def self.compile_and_compare(inputs, outputs, source_files, cfg)
    FolderProcessor.create_folders(cfg)

    source_files.each do |source|
      puts "On file #{source} now..."
      FolderProcessor.create_personal_folders cfg, source

      inputs.each_with_index do |input, counter|
        input_temp = File.open('./temp/input_temp.txt', 'w')
        input_temp.print input
        input_temp.close # To redirect an input, the input needs to be a separate file

        # To get the path and output to the file
        compiler_output, file_output = FolderProcessor.parse_outputs cfg, source, counter

        # Run the compiler
        CompilerComparer.new.run_compiler cfg, source, compiler_output
        contents = CompilerComparer.new.exec_bin(cfg, compiler_output)
        

        # Debug shit
        #p contents, outputs[counter]
        puts 'deu' if contents == outputs[counter]

        if cfg['preserve_bins']
          CompilerComparer.new.save_output cfg, source, file_output, contents
        end
      end
    end
    # Debug shit
    puts( cfg.map{ |k,v| "#{k} => #{v}".red }.sort )
  end

  class CompilerComparer
    def run_compiler(cfg, source, compiler_output)
      `#{cfg['compiler']} #{cfg['source_dir']}#{source}\
      #{cfg['compiler_parameters']} -o #{compiler_output}`
    end

    def save_output(cfg, source, file_output, contents)
      source_no_extension = source.split('.')[0]
      FileUtils.makedirs "#{cfg['tested_outputs_dir']}#{source_no_extension}"
      File.open("#{file_output}", 'w') { |file| file.write(contents) }
    end

    def exec_bin(cfg, compiler_output)
      `#{cfg['ex']}#{compiler_output} < temp/input_temp.txt`
    end
  end
end
