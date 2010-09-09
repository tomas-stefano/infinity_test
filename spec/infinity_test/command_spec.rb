require 'spec_helper'

module InfinityTest
  describe Command do
    
    it "should keep the ruby version" do
      Command.new(:ruby_version => '1.9.1', :command => 'rspec spec').ruby_version.should == '1.9.1'
    end
    
    it "should keep the ruby version pass in initialize method" do
      Command.new(:ruby_version => '1.9.2', :command => 'rspec spec').ruby_version.should == '1.9.2'
    end
    
    it "should create and set the command" do
      Command.new(:ruby_version => '1.9.2', :command => 'rspec spec').command.should == 'rspec spec'
    end
    
    it "should create and set the command for ruby version" do
      Command.new(:ruby_version => '1.9.2', :command => 'spec spec').command.should == 'spec spec'      
    end
    
    it "should have the results as Array" do
      Command.new.results.should be_instance_of(Array)
    end
    
    it "should have the line varaiable as Array" do
      Command.new.line.should be_instance_of(Array)
    end
    
  end
end