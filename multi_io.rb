## The purpose of this class is having a practical way of handling both logs and
# verbose outputs at the same time, based on the CFG hashtable options.
## A good example would be print "correct outputs": if verbose, it would print
# both to STDOUT and to the logfile.

require 'pry'

class MultiIO
  def initialize(cfg, log)
    @cfg = cfg
    @log = log
  end

  def write_log(*args)
    
  end
  def write_stdout(progname=nil, msg)
    if progname.nil?
      puts print msg.green
    end
  end
end
