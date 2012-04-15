module InfinityTest
  module Observer
    module SharedExample
      # Shared Examples to use in the RSpec specs when you want create your own observer.
      #
      # ==== Examples
      #
      #   RSpec.configure do |config|
      #     config.include InfinityTest::Observer::SharedExample
      #   end
      #
      #   describe BarObserver do
      #     it_should_behave_like 'an infinity test observer'
      #   end
      #
      shared_examples_for 'an infinity test observer' do

        it 'should respond to #observer' do
          subject.should respond_to(:observer)
        end

        it 'should respond to #watch_dir' do
          subject.should respond_to(:watch_dir)
        end

        it 'should respond to #watch' do
          subject.should respond_to(:watch)
        end

        it 'should respond to #start' do
          subject.should respond_to(:start)
        end

        it 'should respond to #signal' do
          subject.should respond_to(:signal)
        end
      end
    end
  end
end