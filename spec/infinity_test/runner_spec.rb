require 'spec_helper'

module InfinityTest
  describe Runner do
    
    let(:runner_class) { InfinityTest::Runner }
    
    context "on default values" do
      
      it "commands should have a empty Array" do
        runner_class.new({:test_framework => :rspec}).commands.should eql []
      end
      
      it "should set the options variable" do
        runner_class.new({:cucumber => true}).options.should be == {:cucumber => true}
      end
      
      it "should set the application object" do
        runner_class.new({:test_framework => :test_unit}).application.should be_instance_of(Application)
      end
      
    end
  
    describe "#start_continuous_testing!" do
      let(:empty_runner) { InfinityTest::Runner.new({}) }
      let(:mock_continuous_testing) { @mock ||= mock(ContinuousTesting) }
      
      it "should call start for Continuous Testing" do
        application = application_with_rspec
        ContinuousTesting.should_receive(:new).and_return(mock_continuous_testing)
        mock_continuous_testing.should_receive(:start!)
        empty_runner.start_continuous_testing!
      end
      
    end
  
  end
end