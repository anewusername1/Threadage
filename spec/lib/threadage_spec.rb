require File.expand_path('../../spec_helper.rb', __FILE__)

describe "Threadage" do
  describe "self.logger" do
    it "should have a logger with info, debug, and error methods" do
      t = Threadage.new
      Threadage.logger.should respond_to(:info)
      Threadage.logger.should respond_to(:debug)
      Threadage.logger.should respond_to(:error)
    end
  end
  
  describe "#afore_thread" do
    it "should accept a block and set the instance variable to that block" do
      t = Threadage.new(2)
      @afore_t_v = 3
      t.afore_thread do
        @afore_t_v = 6
      end
      
      Thread.new do
        t.start do
          sleep 4
        end
      end
      sleep 0.5
      @afore_t_v.should == 6
    end
  end
  
  describe "#aft_thread" do
    it "should accept a block and set the instance variable to that block" do
      t = Threadage.new(2)
      @aft_t_v = 3
      t.aft_thread do
        @aft_t_v = 6
      end
      
      Thread.new do
        t.start do
          5 + 5
        end
      end
      sleep 0.5
      @aft_t_v.should == 6
    end
  end
  
  describe "#start" do
    it "should raise if no block is passed" do
      erred = false
      mess = "hah, text"
      t = Threadage.new 5
      begin
        t.start
      rescue RuntimeError => e
        mess = e.message
        erred = true
      end
      erred.should_not be_false
      mess.should == "Please pass a block to the start method"
    end
    
    it "should set the @flag variable to :in_loop" do
      t = Threadage.new(3, true)
      Thread.new do
        t.start do
          sleep 2
        end
      end
      sleep 0.5
      t.loop_flag.should == :in_loop
    end
    
    it "should spawn :max_threads threads" do
      t = Threadage.new(3)
      Thread.new do
        t.start do
          sleep 2
        end
      end
      sleep 0.5
      t.thread_master.active.size.should == 3
    end
    
    it "should run the block passed to the threads" do
      @arbitrary_work = "uh huh"
      t = Threadage.new(1)
      Thread.new do
        t.start do
          @arbitrary_work = "nu uh"
        end
      end
      sleep 0.5
      @arbitrary_work.should == "nu uh"
    end
    
    it "should maintain the amount of threads specified" do
      t = Threadage.new(3)
      Thread.new do
        t.start do
          if rand(2) == 1
            Thread.current.exit
          end
          sleep 0.5
        end
      end
      
      sleep 0.5
      t.thread_master.active.size.should == 3
    end
    
    it "should increase the amount of threads to create if I tell it to" do
      t = Threadage.new(2)
      Thread.new do
        t.start do
          t.max_threads = 4
          if rand(2) == 1
            Thread.current.exit
          end
          sleep 0.5
        end
      end
      
      sleep 0.5
      t.thread_master.active.size.should == 4
    end
  end
  
  describe "#stop" do
    it "should set the @flag variable to :break_loop" do
      t = Threadage.new(3, true)
      Thread.new do
        t.start do
          sleep 2
        end
      end
      sleep 0.5
      t.loop_flag.should == :in_loop
      t.stop
      t.loop_flag.should == :break_loop
    end
  end
  
  describe "#terminate" do
    it "should wait for threads to complete if :kill_all is not passed to it" do
      @var = "one"
      t = Threadage.new(1)
      Thread.new do
        t.start do
          sleep 2
          @var = "two"
        end
      end
      sleep 0.5
      t.terminate
      @var.should == "two"
    end
    
    it "should kill all threads if :kill_all is passed to it" do
      @var = "one"
      t = Threadage.new(1)
      Thread.new do
        t.start do
          sleep 2
          @var = "two"
        end
      end
      sleep 0.5
      t.terminate(:kill_all)
      @var.should == "one"
    end
  end
end