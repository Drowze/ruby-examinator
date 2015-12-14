require 'pty'
module SafePTY
  def self.spawn command, &block

    PTY.spawn(command) do |r,w,p|
      begin
        yield r,w,p
      rescue Errno::EIO
      end
    end

    $?.exitstatus
  end
end
