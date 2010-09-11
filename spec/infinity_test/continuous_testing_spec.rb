require 'spec_helper'

module InfinityTest
  describe ContinuousTesting do

  describe '#initialize' do
    
    it "should be possible to set the Rspec class test framework" do
      continuous_testing = ContinuousTesting.new(:application => application_with_rspec)
      continuous_testing.test_framework.should be_instance_of(InfinityTest::Rspec)
    end
    
    it "should be possible to set the TestUnit class test framework" do
      continuous_testing = ContinuousTesting.new(:application => application_with_test_unit)
      continuous_testing.test_framework.should be_instance_of(InfinityTest::TestUnit)
    end
     
    it "should initialize a empty Hash results" do
      ContinuousTesting.new(:application => application_with_rspec).results.should == {}
    end
    
    it "should pass all the rubies for the Rspec class when test framework is Rspec" do
      Rspec.should_receive(:new).with({:rubies => '1.9.1,jruby'})
      ContinuousTesting.new(:application => application_with(:rubies => %w(1.9.1 jruby), :test_framework => :rspec)).test_framework
    end
    
    it "should pass all the rubies for the TestUnit class when test framework is TestUnit" do
      TestUnit.should_receive(:new).with({:rubies => '1.9.1,jruby'})
      ContinuousTesting.new(:application => application_with(:rubies => %w(1.9.1 jruby), :test_framework => :test_unit)).test_framework
    end
    
  end

  end
end