module InfinityTest
  module Strategy
    module SharedExample
      # Shared Examples to use in the RSpec specs when you want create your own strategy
      #
      # ==== Examples
      #
      #   RSpec.configure do |config|
      #     config.include InfinityTest::Strategy::SharedExample
      #   end
      #
      #   describe FooStrategy do
      #     let(:strategy) { FooStrategy.new(InfinityTest::Core::Base) }
      #     it_should_behave_like 'a strategy'
      #   end
      #
      shared_examples_for 'a strategy' do

        it 'should have the strategy name' do
          strategy.strategy.should be strategy.base.strategy
        end

        it 'should respond to #run!' do
          strategy.should respond_to(:run!)
        end

        it 'should respond to #run?' do
          strategy.class.should respond_to(:run?)
        end

        it 'should have Strategy::Base as superclass' do
          strategy.class.superclass.should be InfinityTest::Strategy::Base
        end
      end
    end
  end
end