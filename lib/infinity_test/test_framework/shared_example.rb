module InfinityTest
  module TestFramework
    module SharedExample
      # Shared Examples to use in the RSpec specs when you want create your own infinity test wrapper test framework
      #
      # ==== Examples
      #
      #   RSpec.configure do |config|
      #     config.include InfinityTest::TestFramework::SharedExample
      #   end
      #
      #   describe FooTestFramework do
      #     subject { FooStrategy.new(InfinityTest::Core::Base) }
      #     it_should_behave_like 'a infinity test test framework'
      #   end
      #
      shared_examples_for 'a infinity test test framework' do
        it 'should respond to #parse_results' do
          expect(subject).to respond_to(:parse_results)
        end

        it 'should respond to #succeed?' do
          expect(subject).to respond_to(:success?)
        end

        it 'should respond to #failure?' do
          expect(subject).to respond_to(:failure?)
        end

        it 'should respond to #pending?' do
          expect(subject).to respond_to(:pending?)
        end

        it 'should respond to #test_files' do
          expect(subject).to respond_to(:test_files)
        end

        it 'should respond to #test_files=' do
          expect(subject).to respond_to(:test_files=)
        end

        it 'should respond to #test_helper_file' do
          expect(subject).to respond_to(:test_helper_file)
        end

        it 'should respond to #test_dir' do
          expect(subject).to respond_to(:test_dir)
        end

        it 'should respond to #test_dir=' do
          expect(subject).to respond_to(:test_dir=)
        end

        it 'should respond to #binary' do
          expect(subject).to respond_to(:binary)
        end
      end
    end
  end
end