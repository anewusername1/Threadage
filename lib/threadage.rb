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
    
    def join
      self.each {|w| w.thread.join}
    end
    
    def exit_now
      self.each {|w| w.exit}
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
  
  attr_accessor :max_threads, :afore_thread, :aft_thread

  def initialize(max = 10, abort_on_exception = false, log_method = DefaultLogger)
    @max_threads = max
    @min_threads = 1
    @thread_master = ThreadMaster.new
    Thread.current.abort_on_exception = abort_on_exception # Abort the process if any one of the threads raises
    Threadage.logger = log_method
  end
  
  # A block to be executed just before calling the block a child
  # will be executing
  #
  # [block] block The block that will be executed
  def afore_thread(&block)
    if block == nil then
      raise "block required"
    end
    @afore_thread = block
  end
  
  # A block to be executed upon exiting a child process.
  #
  # [block] block The block that will be executed upon termination of a child process
  def aft_thread(&block)
    if block == nil then
      raise "block required"
    end
    @aft_thread = block
  end
  
  def start(&block)
    if block.nil?
      raise "Please pass a block to the start method"
    end
    
    @loop_flag = :in_loop
    while @loop_flag == :in_loop
      activites = @thread_master.active.size
      @thread_master.cleanup if(@thread_master.size > activites)
      break if @loop_flag != :in_loop
      to_create = 0
      if activites < to_create 
        to_create = @min_threads - to_create
      else
        to_create = @max_threads
      end
      
      if activites + to_create > @max_threads
        to_create = @max_threads - activites
      end
      
      to_create.times do
        create_thread block
      end
      
    end
    terminate @loop_flag
  end
  
  def terminate(how_to_exit = nil)
    if how_to_exit == :kill_all
      @thread_master.exit_now
    else
      @thread_master.join
    end
  end

  def create_thread(block)
    t = Thread.new do
      thread_it(block)
    end
    @thread_master << Worker.new(t)
  end
  
  def exit_thread
    Thread.current.exit
  end
  
  def stop
    @loop_flag = :break_loop
  end
  
  def stop!
    @loop_flag = :kill_all
  end
  
  def thread_it(block)
    @afore_thread.call if(defined?(@afore_thread))
    begin
      block.call
    rescue => e
      Threadage.logger.error e.message
      Threadage.logger.error e.backtrace.join("\n")
    end
    @aft_thread.call if(defined?(@aft_thread))
    exit_thread
  end

end