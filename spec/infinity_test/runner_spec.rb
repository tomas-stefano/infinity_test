require 'spec_helper'

module InfinityTest
  describe Runner do
    context "on default values" do
      
      it "commands should have a empty Array" do
        InfinityTest::Runner.new(['--rspec']).commands.should eql []
      end
      
      it "should set the options variable" do
        InfinityTest::Runner.new(['--rspec', '--cucumber']).options.should eql ['--rspec', '--cucumber']
      end
      
      it "should set the application object" do
        InfinityTest::Runner.new(['--rspec']).application.should be_instance_of(Application)
      end
      
    end
  end
end