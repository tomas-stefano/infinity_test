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
        it 'responds to #run!' do
          expect(subject).to respond_to(:run)
        end

        it 'responds to .run?' do
          expect(subject.class).to respond_to(:run?)
        end

        it 'has Strategy::Base as superclass' do
          expect(subject.class.superclass).to be InfinityTest::Strategy::Base
        end
      end
    end
  end
end
