require 'yaml'
require 'colorize'
module Processor
  def self.compile_and_compare(inputs, outputs, source_files, cfg)
    `mkdir -p temp`
    source_files.each do |source|
      puts "On file #{source} now..."
      inputs.each_with_index do |input, counter|
        input_temp = File.open('./temp/input_temp.txt', 'w')
        input_temp.print input
        input_temp.close # To redirect an input, the input needs to be a separate file

        source_no_extension = source.split('.')[0] # to remove the extension

        # To get the path and output to the file
        if cfg['preserve_binaries']
          `mkdir -p #{cfg['tested_binaries_directory']}`
          compiler_output = cfg['tested_binaries_directory'] + 
            source_no_extension + cfg['binary_extension']
        else
          compiler_output = 'temp/a.out'
        end

        # To get the path and output to the file
        if cfg['preserve_outputs']
          `mkdir -p #{cfg['tested_outputs_directory']}\
            #{cfg['source_no_extension']}`
          file_output = cfg['tested_outputs_directory'] + 
            source_no_extension + "/#{counter}.txt"
        else
          file_output = 'temp/' + 'a.out'
        end

        # Run the compiler
        `#{cfg['compiler']} #{cfg['source_files_directory']}#{source}\
          #{cfg['compiler_parameters']} -o #{compiler_output}`
        teste = `./#{compiler_output} < temp/input_temp.txt`

        # To-do: fix this. Broken because Ruby don't create folders with File::open
        if cfg['preserve_outputs']
          File.open("results/outputs/999/0.txt", 'w') { |file| file.write(teste) }
        end

        # Debug shit
        p teste, outputs[counter]
        puts 'deu' if teste == outputs[counter]
        sleep 0.5
      end
    end
    # Debug shit
    puts( cfg.map{ |k,v| "#{k} => #{v}".red }.sort )
  end
end
