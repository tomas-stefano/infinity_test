require 'spec_helper'

describe InfinityTest::Runner do

  let(:runner_class) { InfinityTest::Runner }
  let(:infinity_test_runner) { runner_class.new(['--rspec'])}

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
  
  describe '#run_commands_for_changed_file' do
    before do
      @application = InfinityTest.application
    end

    it "should run when have a file to run" do
      # @application.test_framework.should_receive(:construct_commands).and_return('rvm 1.9.2 ruby -S rspec')
      infinity_test_runner.application.should_receive(:construct_commands_for_changed_files).with('file.rb')
      infinity_test_runner.application.should_receive(:run!)
      infinity_test_runner.run_commands_for_changed_file('file.rb')
    end

    it "should not run when file is nil" do
      infinity_test_runner.should_not_receive(:run!)
      infinity_test_runner.run_commands_for_changed_file(nil)
    end

    it "should not run when file is empty string" do
      infinity_test_runner.should_not_receive(:run!)
      infinity_test_runner.run_commands_for_changed_file('')
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
