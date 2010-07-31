require 'spec_helper.rb'

describe "Threadage" do
  describe "self.logger" do
    it "should print to stdout for :info, :debug, and :error" do
    end
  end
  
  describe "#afore_thread" do
    it "should accept a block and set the instance variable to that block" do
    end
  end
  
  describe "#aft_thread" do
    it "should accept a block and set the instance variable to that block" do 
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
      t.loop_flag.should == :in_loop
    end
    
    it "should spawn :max_threads threads" do
      t = Threadage.new(3)
      Thread.new do
        t.start do
          sleep 2
        end
      end
      t.thread_master.active.size.should == 3
    end
    
    it "should run the block passed to it in the children forks" do
    end
  end
  
  describe "#stop" do
    it "should set the @flag variable to :break_loop" do
    end
  end
  
  describe "#terminate" do
    it "should raise an error if called while still in the loop" do
    end
    
    it "should close all IO connections" do
    end
  end
  
  describe "#interrupt" do
    it "should send the TERM signal to all childrens" do
    end
  end
  
  describe "#make_child" do
    it "should connect the child and parent processes together through IOs" do
    end
    
    it "should create a new child and execute the block" do
    end
  end
  
  describe "#child" do
    it "should create a new process and execute the passed block" do
    end
  end
  
  describe "#handle_signals" do
    it "should accept an array of signals to trap and.. trap them" do
    end
  end
end