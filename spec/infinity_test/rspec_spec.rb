require 'spec_helper'

module InfinityTest
  describe Rspec do
    
    before(:each) do
      @rspec = Rspec.new
    end
    
    describe "#build_command_string" do
      
      it "should return a string" do
        @rspec.build_command_string([]).should be_instance_of(String)
      end
      
      it "should return a simple rspec command without rvm" do
        @rspec.build_command_string([]).should_not match /^rvm/
      end
      
      it "should include ruby as a commmand" do
        @rspec.build_command_string([]).should include('ruby')
      end
      
      it "should include rvm if have rvm versions" do
        @rspec.build_command_string(['1.8.6,1.8.7']).should match /^rvm 1.8.6,1.8.7/
      end
      
      it "should include ruby when have ruby versions" do
        @rspec.build_command_string(['1.8.6']).should include("ruby")
      end
      
      it "should include the rspec binary" do
        @rspec.build_command_string([]).should include("rspec")
        @rspec.build_command_string([]).should include("spec")
        @rspec.build_command_string(['1.8.6']).should include("rspec")
        @rspec.build_command_string(['1.8.6']).should include("spec")
      end
      
    end

  end
end