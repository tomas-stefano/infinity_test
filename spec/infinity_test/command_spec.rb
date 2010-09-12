require 'spec_helper'

module InfinityTest
  describe Command do
    
    it "should pass the ruby version and set" do
      Command.new(:ruby_version => '1.9.2').ruby_version.should == '1.9.2'
    end

    it "should pass the ruby version and set" do
      Command.new(:ruby_version => 'JRuby 1.3.5').ruby_version.should == 'JRuby 1.3.5'
    end

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