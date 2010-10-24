require 'spec_helper'

module InfinityTest
  describe Heuristics do
    
    before do
      InfinityTest.stub!(:watchr).and_return(Watchr::Script.new)
      @heuristics = Heuristics.new
    end
      
    describe '#initialize' do
      
      it "should create the patterns instance of Hash" do
        @heuristics.patterns.should be_instance_of(Hash)
      end
      
      it "should create the script instance variable" do
        @heuristics.script.should be_instance_of(Watchr::Script)
      end
      
      it "should have empty rules" do
        @heuristics.script.rules.should be_empty
      end
      
    end
    
    describe '#add' do
      
      it "should add the watch method and persist the pattern" do
        @heuristics.add("^lib/*/(.*)\.rb")
        @heuristics.script.rules.should have(1).items
      end
      
      it "should add the pattern to #patterns instance" do
        @heuristics.add(/^(test|spec)\/fixtures\/(.*).yml$/)
        @heuristics.should have_pattern(/^(test|spec)\/fixtures\/(.*).yml$/)
      end
      
      it "should add other pattern to #patterns instance" do
        @heuristics.add("^lib/*/(.*)\.rb")
        @heuristics.should have_pattern("^lib/*/(.*)\.rb")
      end
      
      it "should add the block object to #patterns instance" do
        proc = Proc.new { 'a' }
        @heuristics.add("^lib/*/(.*)\.rb", &proc)
        @heuristics.patterns.should have_value(proc)
      end
      
    end
    
  end
end