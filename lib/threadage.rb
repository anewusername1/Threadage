require 'thread'
require 'timeout'

module DefaultLogger
  def DefaultLogger.info(msg)
    STDOUT.puts msg
  end
  
  def DefaultLogger.debug(msg)
    STDOUT.puts msg
  end
  
  def DefaultLogger.error(msg)
    STDOUT.puts msg
  end
end

class Threadage
  include DefaultLogger
  
  # These class methods actually set up the logger that's used
  # to print out useful information
  class << self
    def logger
      @logger
    end
    
    def logger=(log_meth)
      @logger = log_meth
    end
  end
  
  # The master of all things threaded. Maybe we could have used Thread.list.. whatever. This will work too.
  class ThreadMaster < Array
    def active
      self.map{|w| w.active? ? w : nil}.compact
    end
    
    def cleanup
      new_massa = ThreadMaster.new
      self.each do |w|
        unless w.active?
          w.exit
        else
          new_massa << w
        end
      end
      self.replace new_massa
    end
  end
  
  class Worker  
    attr_accessor :thread
    def initialize(thread)
      @thread = thread
    end
    
    def active?
      @thread.alive? || false
    end
    
    def exit
      @thread.exit
    end
  end
  
  attr_accessor :max_threads

  @@thread_master = ThreadMaster.new
  def initialize(max = 10, abort_on_exception = false, log_method = DefaultLogger)
    @max_threads = max
    @min_threads = 1
    Thread.current.abort_on_exception = abort_on_exception # Abort the process if any one of the threads raises
    Threadage.logger = log_method
  end
  
  def start(&block)
    if block.nil?
      raise "Please pass a block to the start method"
    end
    
    @loop_flag = :in_loop
    while @loop_flag == :in_loop
      activites = @@thread_master.active.size
      @@thread_master.cleanup if(@@thread_master.size > activites)
      break if @loop_flag != :in_loop
      to_create = 0
      if activites < to_create 
        to_create = @min_threads - to_create
      end
      
      if activites + to_create > @max_threads
        to_create = @max_threads - activites
      end
      
      Threadage.logger.debug "#{activites} #{to_create}" if(activites != 0 || to_create != 0)
      
      to_create.times do
        create_thread block
      end
      
    end
    @loop_flag = :out_of_loop
    terminate
  end

  def create_thread(block)
    t = Thread.new do
      thread_it(block)
    end
    @@thread_master << Worker.new(t)
  end
  
  def exit_thread
    Thread.current.exit!
  end
  
  def thread_it(block)
    @afore_thread_block.call if defined? @afore_thread_block
    begin
      block.call
    rescue => e
      Threadage.logger.error e.message
      Threadage.logger.error e.backtrace.join("\n")
    end
    exit_thread
  end
  
  def join
    until @workers.empty?
      reap
      sleep 0.1
    end
  end

end