require 'thread'
require 'timeout'

class ThreadPool
  class Worker
    
    attr_accessor :thread

    def initialize(&block)
      @thread = Thread.new do
        begin
          block.call
        rescue => e
          DaemonKit.logger.info "Thread died with error #{e}, #{e.backtrace.join("\n")}"
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

  def initialize(max = 10)
    @size = max
    @workers = []
    @mutex = Mutex.new
  end
  
  def reap
    @workers.delete_if { |w| w.dead? }
  end

  def dispatch(&block)
    @mutex.synchronize do
      reap
    end
    if @workers.length < @size
      @workers << Worker.new(&block)
    end
  end
  
  def join
    until @workers.empty?
      reap
      sleep 0.1
    end
  end

end