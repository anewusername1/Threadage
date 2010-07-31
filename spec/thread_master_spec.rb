require 'spec_helper.rb'

describe "ThreadMaster" do
  
  describe "#active" do
    it "should return an empty array for no children" do
      tm = Threadage::ThreadMaster.new
      tm.active.size.should == 0
    end
    
    it "should return an array of active children" do
      tm = Threadage::ThreadMaster.new
      3.times do
        tm << Threadage::Worker.new(Thread.new { sleep 5 }) 
      end
      actives = tm.active
      actives.class.should == Array
      actives.size.should == 3
    end
  end
  
  describe "#join" do
    it "should wait for threads to complete before exiting" do
      tm = Threadage::ThreadMaster.new
      3.times do
        tm << Threadage::Worker.new(Thread.new { sleep 9; 5 + 5 }) 
      end
      tm.active.size.should == 3
      tm.join
      tm.cleanup
      tm.active.size.should == 0
    end
  end
  
  describe "#exit_now"
    it "should kill all threads immediately" do
      tm = Threadage::ThreadMaster.new
      3.times do
        tm << Threadage::Worker.new(Thread.new { sleep 10 }) 
      end
      tm.active.size.should == 3
      tm.exit_now
      sleep 1
      tm.cleanup
      tm.active.size.should == 0
    end
  end
  
  describe "#cleanup" do
    it "should create a new instance of ThreadMaster with the same amount of active threads" do
      tm = Threadage::ThreadMaster.new
      3.times do
        tm << Threadage::Worker.new(Thread.new { sleep 5 }) 
      end
      tm << Threadage::Worker.new(Thread.new{sleep 3; Thread.current.exit})
      tm.active.size.should == 4
      sleep 4
      tm.cleanup
      tm.active.size.should == 3
    end
  end
end