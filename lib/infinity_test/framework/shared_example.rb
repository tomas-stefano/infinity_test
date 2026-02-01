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
        it 'responds to #heuristics' do
          expect(subject).to respond_to(:heuristics)
        end

        it 'responds to #heuristics!' do
          expect(subject).to respond_to(:heuristics!)
        end

        it 'responds to .run?' do
          expect(subject.class).to respond_to(:run?)
        end

        it 'responds to #base' do
          expect(subject).to respond_to(:base)
        end

        it 'responds to #test_framework' do
          expect(subject).to respond_to(:test_framework)
        end

        it 'responds to #strategy' do
          expect(subject).to respond_to(:strategy)
        end

        it 'responds to #observer' do
          expect(subject).to respond_to(:observer)
        end
      end
    end
  end
end
