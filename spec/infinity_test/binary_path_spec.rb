require 'spec_helper'

module InfinityTest
  describe BinaryPath do
    let(:current_env) { RVM::Environment.current }

    class Example
      include BinaryPath
      extend BinaryPath
      binary :bacon
      binary :cucumber
      binary :rspec, :name => :rspec_two
      binary :spec, :name => :rspec_one
    end
    
    describe '.binary' do
      
      before do
        @example = Example.new
      end
      
      it "should create the binary for bacon framework" do
        lambda { @example.search_bacon(current_env) }.should_not raise_exception
      end
      
      it "should create the binary for cucumber framework" do
        lambda { @example.search_cucumber(current_env) }.should_not raise_exception
      end
      
      it "should create the binary for rspec two with sufix of rspec_two" do
        lambda { @example.search_rspec_two(current_env) }.should_not raise_exception
      end
      
      it "should create the binary for rspec one with sufix of rspec_one" do
        lambda { @example.search_rspec_one(current_env) }.should_not raise_exception
      end
      
    end
    
  end
end