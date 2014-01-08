require 'spec_helper'

module InfinityTest
  module Core
    describe ContinuousTestServer do
      let(:base) { Core::Base }
      let(:continuous_test_server) { ContinuousTestServer.new(base) }

      describe '#start!' do
        it 'run strategy, start observer' do
          continuous_test_server.should_receive(:run_strategy)
          continuous_test_server.should_receive(:start_observer)
          # continuous_test_server.should_receive(:notify!)
          continuous_test_server.start
        end
      end

      describe '#start_observer' do
        context 'when base configuration as infinity and beyond' do
          before do
            base.should_receive(:infinity_and_beyond).and_return(true)
            base.stub(:framework).and_return(:rails)
            base.stub(:observer).and_return(:watchr)
          end

          it 'add framework heuristics and start the observer' do
            continuous_test_server.framework.should_receive(:heuristics!)
            continuous_test_server.observer.should_receive(:start!)
            continuous_test_server.start_observer
          end
        end

        context 'when base configuration is not infinity and beyond' do
          before do
            base.should_receive(:infinity_and_beyond).and_return(false)
            base.stub(:framework).and_return(:rails)
          end

          it 'do not start the observer' do
            continuous_test_server.framework.should_not_receive(:heuristics!)
            continuous_test_server.observer.should_not_receive(:start!)
            continuous_test_server.start_observer
          end
        end
      end

      describe '#strategy' do
        subject { continuous_test_server.strategy }
        before { base.should_receive(:strategy).and_return(:ruby_default) }

        it { should be_instance_of InfinityTest::Strategy::RubyDefault }
      end

      describe '#test_framework' do
        subject { continuous_test_server.test_framework }
        before { base.should_receive(:test_framework).and_return(:rspec) }

        it { should be_instance_of InfinityTest::TestFramework::Rspec }
      end

      describe '#binary' do
        subject { continuous_test_server }

        it { should respond_to :binary }
      end

      describe '#command_arguments' do
        subject { continuous_test_server }

        it { should respond_to :command_arguments }
      end
    end
  end
end