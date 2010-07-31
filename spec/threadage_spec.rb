require 'spec_helper.rb'

describe "Threadage" do
  describe "self.logger" do
    it "should print to stdout for :info, :debug, and :error"
  end
  
  describe "#on_child_start" do
    it "should accept a block and set the instance variable to that block"
  end
  
  describe "#on_child_exit" do
    it "should accept a block and set the instance variable to that block"
  end
  
  describe "#start" do
    it "should spawn :max_forks processes"
    it "should set the @flag variable to :in_loop"
    it "should run the block passed to it in the children forks"
  end
  
  describe "#stop" do
    it "should set the @flag variable to :exit_loop"
  end
  
  describe "#terminate" do
    it "should raise an error if called while still in the loop"
    it "should close all IO connections"
  end
  
  describe "#interrupt" do
    it "should send the TERM signal to all childrens"
  end
  
  describe "#make_child" do
    it "should connect the child and parent processes together through IOs"
    it "should create a new child and execute the block"
  end
  
  describe "#child" do
    it "should create a new process and execute the passed block"
  end
  
  describe "#handle_signals" do
    it "should accept an array of signals to trap and.. trap them"
  end
end