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

  describe "#library_directory_pattern" do
        
    it "should return test_unit pattern for test unit" do
      continuous_testing = ContinuousTesting.new({:test_framework => :test_unit})
      continuous_testing.library_directory_pattern.should eql "^lib/(.*)\.rb"
    end
    
  end
  
  describe "#test_directory_pattern" do

    it "should return the spec pattern for rspec test framework" do
      continuous_testing = ContinuousTesting.new({:test_framework => :rspec})
      continuous_testing.test_directory_pattern.should eql "^spec/(.*)_spec.rb"
    end
    
    it "should return the test pattern for rspec" do
      continuous_testing = ContinuousTesting.new(:test_framework => :test_unit)
      continuous_testing.test_directory_pattern.should eql "^test/(.*)_test.rb"
    end

  end

  end
end