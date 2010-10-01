require 'spec_helper'

module InfinityTest
  describe Options do
    
    context "when parsing" do
      
      it "should parse --rspec and return rspec" do
        parse_options('--rspec')
        @options[:test_framework].should equal :rspec
      end
      
      it "should not return rspec as test framework when not parse rspec" do
        parse_options('--test-unit')
        @options[:test_framework].should_not equal :rspec
      end
      
      it "should parse --bacon and return bacon" do
        parse_options('--bacon')
        @options[:test_framework].should equal :bacon
      end
      
      it "should not parse --test-unit" do
        parse_options('--rspec')
        @options[:test_framework].should_not equal :bacon
      end
      
      it "should parse --test-unit and return test_unit" do
        parse_options('--test-unit')
        @options[:test_framework].should equal :test_unit
      end
      
      it "should not parse --test-unit" do
        parse_options('--rspec')
        @options[:test_framework].should_not equal :test_unit
      end
      
      it "should parse --rvm-versions and return an array" do
        parse_options('--rubies=1.8.6,1.8.7')
        @options[:rubies].should eql '1.8.6,1.8.7'
      end
      
      it "should parse --rvm-versions with dashes" do
        parse_options('--rubies=1.8.7-p249,1.9.1-p378')
        @options[:rubies].should eql '1.8.7-p249,1.9.1-p378'
      end
      
      it "should parse --verbose" do
        parse_options('--verbose')
        @options[:verbose].should be_true
      end
      
    end

    describe "#rspec?" do

      it "should return true if using rspec" do
        parse_options('--rspec')
        @options.rspec?.should be_true
      end
      
      it "should explicity return false if not using rspec" do
        parse_options('--test-unit')
        @options.rspec?.should be_false
      end
      
      it "should not return nil when not using rspec" do
        parse_options('--rubies=1.8.6')
        @options.rspec?.should_not be_nil
      end
      
    end
    
    describe "#bacon?" do

      it "should return true if using bacon" do
        parse_options('--bacon')
        @options.bacon?.should be_true
      end
      
      it "should explicity return false if not using bacon" do
        parse_options('--test-unit')
        @options.bacon?.should be_false
      end
      
      it "should not return nil when not using bacon" do
        parse_options('--rubies=1.8.6')
        @options.bacon?.should_not be_nil
      end
      
    end
    
    def parse_options(*arguments)
      @options = InfinityTest::Options.new(arguments)
    end
    
  end
end
