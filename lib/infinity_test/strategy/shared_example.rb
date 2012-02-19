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
      #     subject { FooStrategy.new(InfinityTest::Core::Base) }
      #     it_should_behave_like 'a infinity test strategy'
      #   end
      #
      shared_examples_for 'a infinity test strategy' do

        it 'should have the strategy name' do
          subject.strategy.should be subject.base.strategy
        end

        it 'should respond to #run!' do
          subject.should respond_to(:run!)
        end

        it 'should respond to .run?' do
          subject.class.should respond_to(:run?)
        end

        it 'should respond to .priority' do
          subject.class.should respond_to(:priority)
        end

        it 'should have Strategy::Base as superclass' do
          subject.class.superclass.should be InfinityTest::Strategy::Base
        end
      end
    end
  end
end