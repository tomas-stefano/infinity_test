require 'spec_helper'

module InfinityTest
  describe ContinuousTesting do

  describe "#library_directory_pattern" do
        
    it "should return test_unit pattern for test unit" do
      continuous_testing = ContinuousTesting.new(:application => application_with_rspec)
      continuous_testing.library_directory_pattern.should eql "^lib/(.*)\.rb"
    end
    
  end
  
  describe "#test_directory_pattern" do

    it "should return the spec pattern for rspec test framework" do
      continuous_testing = ContinuousTesting.new(:application => application_with_rspec)
      continuous_testing.test_directory_pattern.should eql "^spec/(.*)_spec.rb"
    end
    
    it "should return the test pattern for rspec" do
      continuous_testing = ContinuousTesting.new(:application => application_with_test_unit)
      continuous_testing.test_directory_pattern.should eql "^test/(.*)_test.rb"
    end

  end


  end
end