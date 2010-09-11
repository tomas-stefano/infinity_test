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
  
    describe '#load_configuration_file_or_read_the_options' do
      let(:runner) { @runner ||= runner_class.new({}) }
      let(:runner_with_rspec) { @runner_with_rspec ||= runner_class.new({:test_framework => :rspec})}
      
      it "should load configuration file and set the configurations" do
        stub_home_config :file => 'spec/factories/infinity_test'
        runner.load_configuration_file_or_read_the_options!
        runner.application.config.test_framework.should equal :rspec
      end
      
      it "should override the configuration if have options in the command line" do
        stub_home_config :file => 'spec/factories/infinity_test_example'
        runner_with_rspec.load_configuration_file_or_read_the_options!
        runner_with_rspec.application.config.test_framework.should equal :rspec
      end
      
      it "should load configuration file with cucumber option" do
        stub_home_config :file => 'spec/factories/infinity_test'
        runner_with_cucumber = InfinityTest::Runner.new({})
        runner_with_cucumber.load_configuration_file_or_read_the_options!
        runner_with_cucumber.application.config.use_cucumber?.should be_true
      end
      
      it "should override the cucumber option if have options in the command line" do
        stub_home_config :file => 'spec/factories/infinity_test'
        runner_with_cucumber = InfinityTest::Runner.new({:cucumber => false})
        runner_with_cucumber.load_configuration_file_or_read_the_options!
        runner_with_cucumber.application.config.use_cucumber?.should equal false
      end
      
      it "should override the options in the configuration file" do
        stub_home_config :file => 'spec/factories/infinity_test'
        runner_with_cucumber = InfinityTest::Runner.new({:rubies => '1.9.1'})
        runner_with_cucumber.load_configuration_file_or_read_the_options!
        runner_with_cucumber.application.config.rubies.should be == '1.9.1'
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