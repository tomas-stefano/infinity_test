require 'spec_helper'

module InfinityTest
  describe Rspec do
    
    before(:each) do
      @rspec = Rspec.new
    end
    
    describe "#build_command_string" do
      
      it "should return a string" do
        @rspec.build_command_string(nil).should be_instance_of(String)
      end
      
      it "should return a simple rspec command without rvm" do
        @rspec.build_command_string(nil).should_not match /^rvm/
      end
      
      it "should include ruby as a commmand" do
        @rspec.build_command_string(nil).should match /^ruby/
      end
      
      it "should include rvm if have rvm versions" do
        @rspec.build_command_string('1.8.6,1.8.7').should match /^rvm 1.8.6,1.8.7/
      end
      
      it "should include ruby when have ruby versions" do
        @rspec.build_command_string('1.8.6').should match /^rvm 1.8.6 ruby/
      end
      
      it "should include the rspec binary" do
        @rspec.build_command_string(nil).should include("rspec")
      end
      
      it "should possible to grab the rspec 1.3.0" do
        Gem.should_receive(:bin_path).with('rspec', 'spec').and_return('~/.rvm/gems/ruby-1.9.1-p378/gems/rspec-1.3.0/bin/spec')
        @rspec.build_command_string('1.8.7,1.9.1').should be == 'rvm 1.8.7,1.9.1 ruby ~/.rvm/gems/ruby-1.9.1-p378/gems/rspec-1.3.0/bin/spec spec'
      end
      
    end

  end
end