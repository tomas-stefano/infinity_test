require 'spec_helper'

module InfinityTest
  class SomeFramework < TestFramework
    parse_results :examples => /(\d+) example/, :failures => /(\d+) failure/, :pending => /(\d+) pending/
  end
  
  class OtherFramework < TestFramework
    parse_results :tests => /(\d+) tests/, :assertions => /(\d+) assertions/, :failures => /(\d+) failures/, :errors => /(\d+) errors/
  end
  
  describe '#parse_results' do
    before do
      @some_framework = SomeFramework.new
      @other_framework = OtherFramework.new
    end
    
    let(:some_framework) { @some_framework }
    let(:other_framework) { @other_framework }
    
    it "should create the examples instance variable" do
      some_framework.parse_results("0 examples, 0 failures, 0 pending")
      some_framework.examples.should == 0
    end
    
    it "should create the tests instance variable" do
      other_framework.parse_results("120 tests, 200 assertions, 0 failures, 0 errors")
      other_framework.tests.should == 120
    end
    
    it "should create the assertions instance variable" do
      other_framework.parse_results("120 tests, 200 assertions, 0 failures, 0 errors")
      other_framework.assertions.should == 200
    end
    
    it "should create the failures instance variable" do
      some_framework.parse_results("0 examples, 1 failures, 0 pending")
      some_framework.failures.should == 1
    end
    
    it "should create the failures instance variable" do
      other_framework.parse_results("120 tests, 200 assertions, 10 failures, 0 errors")
      other_framework.failures.should == 10
    end
    
    it "should create the pending instance variable" do
      some_framework.parse_results("0 examples, 0 failures, 1 pending")
      some_framework.pending.should == 1
    end
    
    it "should create the example instance variable" do
      some_framework.parse_results(" ..... \n10 examples, 0 failures, 0 pending")
      some_framework.examples.should == 10
    end
    
    it "should create a message based in the keys of framework" do
      some_framework.parse_results(".....\n200 examples, 0 failures, 1 pending")
      some_framework.message.should == "200 examples, 0 failures, 1 pending"
    end
    
    it "should create a error message to runtime errors and similars" do
      some_framework.parse_results("RunTimeError: undefined method 'my_method' ...")
      some_framework.message.should == "An exception occurred"
    end
    
    it "should parse the results correctly(when not have in last line)" do
      other_framework.parse_results("....\n10 tests, 35 assertions, 0 failures, 0 errors\nTest run options: --seed 18841")
      other_framework.tests.should == 10
      other_framework.assertions.should == 35
    end
    
    it "should clear the term ansi colors strings" do
      other_framework.parse_results("seconds\n\e[33m406 tests, 34 assertions, 0 failures, 2 errors\e[0m\n")
      other_framework.message.should == "406 tests, 34 assertions, 0 failures, 2 errors"
    end
    
    it "should clear the term ansi colors strings" do
      some_framework.parse_results("seconds\n\e[33m406 examples, 0 failures, 2 pending\e[0m\n")
      some_framework.message.should == "406 examples, 0 failures, 2 pending"
    end
    
    it "should raise error when not have patterns" do
      lambda { 
        class Abc < TestFramework
          parse_results({})
        end
        Abc.new.parse_results('0 examples') 
      }.should raise_exception(ArgumentError, 'patterns should not be empty')
    end
    
  end
  
end