class CompilerComparer
  def initialize(cfg)
    @cfg = cfg
  end

  def run_compiler(source, compiler_output)
    cmd = "#{@cfg['compiler']} #{@cfg['source_dir']}#{source}"\
          " #{@cfg['compiler_params']} -o #{compiler_output}"
    ret = true
    SafePTY.spawn(cmd) do |stdout|
      stdout.each { |line| ret = false if line.downcase.include?('error') }
    end
    ret
  end

  def save_output(source, file_output, contents)
    source_no_extension = source.split('.')[0]
    FileUtils.makedirs "#{@cfg['tested_out_dir']}#{source_no_extension}"
    File.open("#{file_output}", 'w') { |file| file.write(contents) }
  end

  # I know this is cryptic and I am sorry for that.
  def exec_bin(compiler_output)
    cmd = "#{@cfg['ex']}#{compiler_output} < temp/input_temp.txt"
    ret = ''
    begin
      Timeout.timeout(@cfg['time_amount']) do
        SafePTY.spawn(cmd) do |stdout|
          stdout.each do |line|
            if line.downcase.include?('not found')
              ret = false
              break
            else
              ret << line.gsub(/\r\n?/, "\n")
            end
          end
        end
      end
    rescue Timeout::Error => error
      return false if defined? error
    end
    ret
  end
end
