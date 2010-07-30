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

class ThreadPool
  include DefaultLogger
  
  # The master of all things threaded
  class ThreadMaster < Array
    def active
      self.map{|t| t[:active] ? t : nil}.compact
    end
  end
  
  class Worker  
    attr_accessor :thread

    def initialize(block)
      @thread = Thread.new do
        begin
          @active = true
          block.call
          @active = false
        rescue => e
          ThreadPool.logger.debug "Thread died with error #{e}, #{e.backtrace.join("\n")}"
        end
      end
    end

    def dead?
      if @thread
        if !@thread.alive?
          return true
        else
          return false
        end
      end
      true
    end

  end
  
  attr_accessor :size, :workers

  @@thread_master = ThreadMaster.new
  def initialize(max = 10)
    @size = max
    min = 1
    # @mutex = Mutex.new
  end
  
  def start(&block)
    if block.nil?
      raise "Please pass a block to the start method"
    end
    (@size - @@thread_master.size).times do
      create_thread block
    end
    
    @loop_flag = :in_loop
    while @loop_flag == :in_loop
      activites = @@thread_master.active.size
      @@thread_master.cleanup if @@thread_master.size > activites
      break if @loop_flag != :in_loop
      to_create = 0
      if activites < to_create 
        to_create = @min_threads - to_create
      else
        if @@thread_master.idle.size <= 2
          to_create = 2
        end
      end
      
      if activites + to_create > @max_threads
        to_create = @max_threads - activites
      end
      
      to_create.times do
        create_thread block
      end
    end
    @loop_flag = :out_of_loop
    terminate
  end

  def create_thread(block)
    if @thread_master.length < @size
      @thread_master << Worker.new(&block)
    end
  end
  
  def thread_it(block)
    @afore_thread_block.call if defined? @afore_thread_block
    Thread.current[:active] = true
    begin
      block.call
    rescue => e
      ThreadPool.logger.error e.message
      ThreadPool.logger.error e.backtrace.join("\n")
    end
    Thread.current[:active] = false
    exit_thread
  end
  
  def join
    until @workers.empty?
      reap
      sleep 0.1
    end
  end

end