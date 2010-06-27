require 'spec_helper'

module InfinityTest
  describe Cucumber do
    
    before(:each) do
      @cucumber = Cucumber.new
    end
    
    describe "#build_command_string" do
      
      it "should be instance of String" do
        @cucumber.build_command_string.should be_instance_of(String)
      end
      
      it "should include rvm when have ruby versions" do
        @cucumber.build_command_string(['1.8.7', '1.9.1']).should match /^rvm 1.8.7,1.9.1/
      end
      
      it "should not include rvm when not have ruby versions" do
        @cucumber.build_command_string.should_not match /^rvm/
      end
      
      it "should include ruby when have ruby versions" do
        @cucumber.build_command_string(['1.8.7']).should match /ruby/
        @cucumber.build_command_string().should match /ruby/
      end
      
      it "should include cucumber binary" do
        @cucumber.build_command_string(['1.8.6', '1.8.7']).should match /bin/
        @cucumber.build_command_string().should match /bin/
        @cucumber.build_command_string(['1.8.6', '1.8.7']).should match /cucumber/
        @cucumber.build_command_string().should match /cucumber/
      end
      
    end
  end
end