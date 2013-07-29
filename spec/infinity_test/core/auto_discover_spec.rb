require 'spec_helper'


module InfinityTest
  describe AutoDiscover do
    let(:base) { BaseFixture.new }
    let(:auto_discover) { AutoDiscover.new(base) }

    describe '#discover_libraries' do
      it 'discover strategy, framework and test framework' do
        auto_discover.should_receive(:discover_strategy)
        auto_discover.should_receive(:discover_framework)
        auto_discover.should_receive(:discover_test_framework)
        auto_discover.discover_libraries
      end
    end

    describe '#discover_strategy' do
      context 'when strategy is auto discover' do
        before do
          base.strategy = :auto_discover
          Strategy::RubyDefault.stub(:run?).and_return(false)
          Strategy::Rvm.should_receive(:run?).and_return(true)
        end

        it 'change the base strategy' do
          auto_discover.discover_strategy
          base.strategy.should be :rvm
        end
      end

      context 'when strategy is different from auto discover' do
        before { base.strategy = :ruby_default }

        it 'change anything' do
          auto_discover.discover_strategy
          base.strategy.should be :ruby_default
        end
      end

      context 'when do not find any strategy' do
        before do
          base.strategy = :auto_discover
          Strategy::RubyDefault.stub(:run?).and_return(false)
          Strategy::Rvm.should_receive(:run?).and_return(false)
          Strategy::Rbenv.stub(:run?).and_return(false)
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
          Framework::Rubygems.stub(:run?).and_return(false)
          Framework::Rails.should_receive(:run?).and_return(true)
        end

        it 'change the base framework' do
          auto_discover.discover_framework
          base.framework.should be :rails
        end
      end

      context 'when framework is different from auto discover' do
        before { base.framework = :padrino }

        it 'change anything' do
          auto_discover.discover_framework
          base.framework.should be :padrino
        end
      end
    end

    describe '#discover_test_framework' do
      context 'when framework is auto discover' do
        before do
          base.test_framework = :auto_discover
          TestFramework::TestUnit.stub(:run?).and_return(false)
          TestFramework::Rspec.stub(:run?).and_return(false)
          TestFramework::Bacon.should_receive(:run?).and_return(true)
        end

        it 'change the base framework' do
          auto_discover.discover_test_framework
          base.test_framework.should be :bacon
        end
      end

      context 'when framework is different from auto discover' do
        before { base.test_framework = :test_unit }

        it 'change anything' do
          auto_discover.discover_test_framework
          base.test_framework.should be :test_unit
        end
      end
    end
  end
end