require 'spec_helper'

describe InfinityTest::Runner do

  let(:runner_class) { InfinityTest::Runner }

  describe '#initialize' do

    it "should set the application object" do
      runner_class.new(['--test-unit']).application.should be_instance_of(InfinityTest::Application)
    end

    it "should set the Option Object" do
      runner_class.new(['--rspec']).options.should be_instance_of(InfinityTest::Options)
    end

  end

  describe '#run!' do
    let(:heuristics_runner) { runner_class.new(['--heuristics']) }
    
    it "should call list heuristics" do
      heuristics_runner.should_receive(:list_heuristics!)
      heuristics_runner.run!
    end
    
  end

  describe "#start_continuous_testing!" do
    let(:empty_runner) { InfinityTest::Runner.new([]) }
    let(:mock_continuous_testing) { @mock ||= mock(InfinityTest::ContinuousTesting) }

    it "should call start for Continuous Testing" do
      application = application_with_rspec
      InfinityTest::ContinuousTesting.should_receive(:new).and_return(mock_continuous_testing)
      mock_continuous_testing.should_receive(:start!)
      empty_runner.start_continuous_testing!
    end

  end

end
