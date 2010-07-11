require 'spec_helper'

module InfinityTest
  describe Runner do
    
    let(:runner_class) { InfinityTest::Runner }
    
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
  
    describe "#test_framework! and #cucumber_library" do
      
      before(:each) do
        @rspec = runner_class.new({:test_framework => :rspec})
        @test_unit = runner_class.new({:test_framework => :test_unit})
        @cucumber = runner_class.new({:cucumber => true})
      end
            
      it "should add the rspec command" do
        @rspec.application.should_receive(:load_rspec_style).and_return('rspec')
        @rspec.test_framework!
        @rspec.commands.should eql ["rspec"]
      end
      
      it "should add the cucumber command" do
        @cucumber.application.should_receive(:load_cucumber_style).and_return('cucumber')
        @cucumber.cucumber_library!
        @cucumber.commands.should eql ['cucumber']
      end
      
      it "should add the test_unit command" do
        @test_unit.application.should_receive(:load_test_unit_style).and_return('test_unit')
        @test_unit.test_framework!
        @test_unit.commands.should eql ['test_unit']
      end
      
    end
  
  end
end