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
        let(:continuous_test_server) { ContinuousTestServer.new(base) }
        let(:test_message) { '200 examples, 0 failures, 0 pending' }

        context 'when have notification library' do
          let(:test_framework) { double }
          let(:base) { double(notifications: :growl) }

          before do
            expect(continuous_test_server).to receive(:test_framework).exactly(:twice).and_return(test_framework)
            expect(test_framework).to receive(:test_message=).with(test_message)
          end

          it 'instantiante a notifier passing the strategy result and the continuous server' do
            expect(Core::Notifier).to receive(:new).and_return(double(notify: true))
            continuous_test_server.notify(test_message)
          end
        end

        context 'when do not have notification library' do
          let(:base) { double(notifications: nil) }

          it 'instantiante a notifier passing the strategy result and the continuous server' do
            expect(Core::Notifier).to_not receive(:new)
            continuous_test_server.notify(test_message)
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

      describe '#test_files' do
        subject { continuous_test_server }

        it { should respond_to :test_files }
      end
    end
  end
end