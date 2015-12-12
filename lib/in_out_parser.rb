module InOutParser
  def self.newlines_converter(io)
    file = File.open(io, 'a+')

    file_contents = file.read.gsub(/\r\n?/, "\n")
    file.truncate(0)
    file.print file_contents

    file.close
  end

  ## Getting each input and each output into an array the idea is, basically,
  # get each paragraph with gets('') and insert it to the array.
  ## Should be noted though, that since the expected output should contain an
  # "\n" at its ending, so should each element on our array.
  def self.parse_paragraphs(io)
    inputs_file = File.open(io, 'r')

    inputs = []

    loop do
      inputs_contents = inputs_file.gets('')
      if inputs_contents.nil?
        break
      else
        inputs_contents.gsub!("\n\n", "\n")
        inputs << inputs_contents
      end
    end

    inputs[-1] = inputs[-1].chomp('') + "\n"

    return inputs
  end

  def self.cute_print(array, time=1)
    array.each_with_index do |x, i|
      system("clear"); 
      puts "Iteration #{i+1}", x
      sleep time
    end
  end
end
