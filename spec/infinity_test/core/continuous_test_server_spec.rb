require 'spec_helper'

module InfinityTest
  module Core
    describe ContinuousTestServer do
      let(:base) { Core::Base }
      let(:continuous_test_server) { ContinuousTestServer.new(base) }

      describe '#start!' do
        it 'run strategy, start observer' do
          expect(continuous_test_server).to receive(:run_strategy)
          expect(continuous_test_server).to receive(:start_observer)
          continuous_test_server.start
        end
      end

      describe '#start_observer' do
        context 'when base configuration as infinity and beyond' do
          before do
            expect(base).to receive(:infinity_and_beyond).and_return(true)
            base.stub(:framework).and_return(:rails)
            base.stub(:observer).and_return(:watchr)
          end

          it 'add framework heuristics and start the observer' do
            expect(continuous_test_server.framework).to receive(:heuristics!)
            expect(continuous_test_server.observer).to receive(:start!)
            continuous_test_server.start_observer
          end
        end

        context 'when base configuration is not infinity and beyond' do
          before do
            expect(base).to receive(:infinity_and_beyond).and_return(false)
            base.stub(:framework).and_return(:rails)
          end

          it 'do not start the observer' do
            expect(continuous_test_server.framework).to_not receive(:heuristics!)
            expect(continuous_test_server.observer).to_not receive(:start!)
            continuous_test_server.start_observer
          end
        end
      end

      describe '#notify' do
        let(:strategy_result) do
          '200 examples, 0 failures, 0 pending'
        end

        context 'when have notification library' do
          let(:notifier) { mock(notify: true) }

          before do
            base.should_receive(:notifications).and_return(:growl)
          end

          it 'instantiante a notifier passing the strategy result and the continuous server' do
            Core::Notifier.should_receive(:new).with(strategy_result, server: continuous_test_server).and_return(notifier)
            continuous_test_server.notify(strategy_result)
          end
        end

        context 'when do not have notification library' do
          before do
            base.should_receive(:notifications).and_return(nil)
          end

          it 'instantiante a notifier passing the strategy result and the continuous server' do
            Core::Notifier.should_not_receive(:new)
            continuous_test_server.notify(strategy_result)
          end
        end
      end

      describe '#strategy' do
        subject { continuous_test_server.strategy }
        before { expect(base).to receive(:strategy).and_return(:ruby_default) }

        it { should be_instance_of InfinityTest::Strategy::RubyDefault }
      end

      describe '#test_framework' do
        subject { continuous_test_server.test_framework }
        before { expect(base).to receive(:test_framework).and_return(:rspec) }

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