require 'spec_helper'

describe InfinityTest do
  
  describe '#application' do
  
    it "should be a instace of Application" do
      InfinityTest.application.should be_instance_of(InfinityTest::Application)
    end
  
    it "should cache instance variable in the same object" do
      application = InfinityTest.application
      InfinityTest.application.should equal application
    end
  
  end
  
  describe '#configuration' do
    
    it { InfinityTest.configuration.should be_instance_of(InfinityTest::Configuration) }
    
    it "should cache the instance of configuration class" do
      configuration = InfinityTest.configuration
      configuration.should equal InfinityTest.configuration
    end
    
  end
  
end