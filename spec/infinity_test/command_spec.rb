require 'spec_helper'

module InfinityTest
  describe Command do

    it "should create and set the command" do
      Command.new(:command => 'rspec spec').command.should == 'rspec spec'
    end
    
    it "should create and set the command for ruby version" do
      Command.new(:command => 'spec spec').command.should == 'spec spec'      
    end
    
    it "should have the results as Array" do
      Command.new.results.should be_instance_of(Array)
    end
    
    it "should have the line variable as Array" do
      Command.new.line.should be_instance_of(Array)
    end
    
  end
end