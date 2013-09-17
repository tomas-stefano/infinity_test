module InfinityTest
  module Framework
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
      shared_examples_for 'an infinity test framework' do
        it 'should respond to #heuristics' do
          subject.should respond_to(:heuristics)
        end

        it 'should respond to #heuristics' do
          subject.should respond_to(:heuristics!)
        end

        it 'should respond to .run?' do
          subject.class.should respond_to(:run?)
        end

        it 'should respond to #base' do
          subject.should respond_to(:base)
        end

        it 'should respond to #test_framework' do
          subject.should respond_to(:test_framework)
        end

        it 'should respond to #strategy' do
          subject.should respond_to(:strategy)
        end

        it 'should respond to #observer' do
          subject.should respond_to(:observer)
        end
      end
    end
  end
end