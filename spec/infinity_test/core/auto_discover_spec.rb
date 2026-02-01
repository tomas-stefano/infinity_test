require 'spec_helper'


module InfinityTest
  describe AutoDiscover do
    let(:base) { BaseFixture.new }
    let(:auto_discover) { AutoDiscover.new(base) }

    describe '#discover_libraries' do
      it 'discovers strategy, framework and test framework' do
        expect(auto_discover).to receive(:discover_strategy)
        expect(auto_discover).to receive(:discover_framework)
        expect(auto_discover).to receive(:discover_test_framework)
        auto_discover.discover_libraries
      end
    end

    describe '#discover_strategy' do
      context 'when strategy is auto discover' do
        before do
          base.strategy = :auto_discover
          allow(Strategy::RubyDefault).to receive(:run?).and_return(false)
          expect(Strategy::Rvm).to receive(:run?).and_return(true)
        end

        it 'changes the base strategy' do
          auto_discover.discover_strategy
          expect(base.strategy).to be :rvm
        end
      end

      context 'when strategy is different from auto discover' do
        before { base.strategy = :ruby_default }

        it 'does not change anything' do
          auto_discover.discover_strategy
          expect(base.strategy).to be :ruby_default
        end
      end

      context 'when do not find any strategy' do
        before do
          base.strategy = :auto_discover
          allow(Strategy::RubyDefault).to receive(:run?).and_return(false)
          expect(Strategy::Rvm).to receive(:run?).and_return(false)
          allow(Strategy::Rbenv).to receive(:run?).and_return(false)
        end

        it 'raises exception' do
          expect { auto_discover.discover_strategy }.to raise_error(Exception)
        end
      end
    end

    describe '#discover_framework' do
      context 'when framework is auto discover' do
        before do
          base.framework = :auto_discover
          allow(Framework::Rubygems).to receive(:run?).and_return(false)
          expect(Framework::Rails).to receive(:run?).and_return(true)
        end

        it 'changes the base framework' do
          auto_discover.discover_framework
          expect(base.framework).to be :rails
        end
      end

      context 'when framework is different from auto discover' do
        before { base.framework = :padrino }

        it 'does not change anything' do
          auto_discover.discover_framework
          expect(base.framework).to be :padrino
        end
      end
    end

    describe '#discover_test_framework' do
      context 'when framework is auto discover' do
        before do
          base.test_framework = :auto_discover
          allow(TestFramework::TestUnit).to receive(:run?).and_return(false)
          expect(TestFramework::Rspec).to receive(:run?).and_return(true)
        end

        it 'changes the base framework' do
          auto_discover.discover_test_framework
          expect(base.test_framework).to be :rspec
        end
      end

      context 'when framework is different from auto discover' do
        before { base.test_framework = :test_unit }

        it 'does not change anything' do
          auto_discover.discover_test_framework
          expect(base.test_framework).to be :test_unit
        end
      end
    end
  end
end
