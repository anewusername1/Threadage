require File.expand_path('../../spec_helper.rb', __FILE__)

describe "Worker" do
  
  it "should initialize with a new thread instance" do
    w = Threadage::Worker.new(Thread.new {5 + 5; sleep 5;})
    w.thread.should_not be_nil
  end
  
  describe "#active?" do
    before(:each) do
      @w = Threadage::Worker.new(Thread.new {5 + 5; sleep 5;})
    end
    
    it "should return true if its status is alive" do
      @w.active?.should == true
    end
    
    it "should return false it its status is not alive" do
      @w.thread.exit
      sleep 1       # gives it time to quit
      @w.active?.should == false
    end
  end
  
  describe "#exit" do
    
    it "should exit the running thread" do
      w = Threadage::Worker.new(Thread.new {5 + 5; sleep 5;})
      w.exit
      sleep 1
      w.active?.should == false
    end
  end
  
end
  