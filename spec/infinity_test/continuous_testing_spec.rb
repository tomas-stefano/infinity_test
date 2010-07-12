require 'spec_helper'

module InfinityTest
  describe ContinuousTesting do

    it "should initialize the test_framework in hash options" do
      ContinuousTesting.new({:test_framework => :rspec}).test_framework.should equal :rspec
    end
    
    it "should initialize the test framework with test_unit" do
      ContinuousTesting.new(:test_framework => :test_unit).test_framework.should equal :test_unit
    end
    
    it "should initialize cucumber true or false" do
      ContinuousTesting.new(:cucumber => true).cucumber.should be_true
    end
    
    it "should initialize runner" do
      runner = InfinityTest::Runner.new({:cucumber => true})
      ContinuousTesting.new(:runner => runner).runner.should equal runner
    end
    
    it "should include start! in instance methods" do
      all_methods = ContinuousTesting.new({}).methods.collect! { |m| m.to_sym }
      all_methods.should include :start!
    end
        
  end
end