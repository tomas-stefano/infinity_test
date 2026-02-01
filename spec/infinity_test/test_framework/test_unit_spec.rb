require 'spec_helper'

module InfinityTest
  module TestFramework
    describe TestUnit do
      it_should_behave_like 'a infinity test test framework'

      describe "#test_dir" do
        it "returns test as test dir" do
          expect(subject.test_dir).to eq 'test'
        end

        it "can be set to a custom directory" do
          subject.test_dir = 'custom_test'
          expect(subject.test_dir).to eq 'custom_test'
        end
      end

      describe '#test_files' do
        context 'when is empty' do
          it 'returns the test dir' do
            expect(subject.test_files).to eq 'test'
          end
        end

        context 'when assign the test files' do
          it 'returns the assigned value' do
            subject.test_files = 'test/models/user_test.rb'
            expect(subject.test_files).to eq 'test/models/user_test.rb'
          end
        end
      end

      describe "#test_helper_file" do
        it "is the test helper" do
          expect(subject.test_helper_file).to eq 'test/test_helper.rb'
        end
      end

      describe '#binary' do
        it 'returns ruby as binary' do
          expect(subject.binary).to eq 'ruby'
        end
      end

      describe '#test_message' do
        subject(:test_unit) { TestUnit.new }

        it 'returns the final test results' do
          test_unit.test_message = "Finished in 0.001s, 1000.0 runs/s.\n10 runs, 15 assertions, 0 failures, 0 errors, 0 skips\n"
          expect(test_unit.test_message).to eq '10 runs, 15 assertions, 0 failures, 0 errors, 0 skips'
        end
      end

      describe '#success?' do
        subject(:test_unit) { TestUnit.new }

        context 'when test message has ZERO failures, ZERO errors, and ZERO skips' do
          before do
            test_unit.test_message = "10 runs, 15 assertions, 0 failures, 0 errors, 0 skips"
          end

          it 'returns true' do
            expect(test_unit).to be_success
          end
        end

        context 'when test message has ONE failure' do
          before do
            test_unit.test_message = "10 runs, 15 assertions, 1 failures, 0 errors, 0 skips"
          end

          it 'returns false' do
            expect(test_unit).to_not be_success
          end
        end

        context 'when test message has ONE error' do
          before do
            test_unit.test_message = "10 runs, 15 assertions, 0 failures, 1 errors, 0 skips"
          end

          it 'returns false' do
            expect(test_unit).to_not be_success
          end
        end

        context 'when test message has ONE skip' do
          before do
            test_unit.test_message = "10 runs, 15 assertions, 0 failures, 0 errors, 1 skips"
          end

          it 'returns false' do
            expect(test_unit).to_not be_success
          end
        end
      end

      describe '#failure?' do
        subject(:test_unit) { TestUnit.new }

        context 'when test message has ONE failure' do
          before do
            test_unit.test_message = "10 runs, 15 assertions, 1 failures, 0 errors, 0 skips"
          end

          it 'returns true' do
            expect(test_unit).to be_failure
          end
        end

        context 'when test message has ONE error' do
          before do
            test_unit.test_message = "10 runs, 15 assertions, 0 failures, 1 errors, 0 skips"
          end

          it 'returns true' do
            expect(test_unit).to be_failure
          end
        end

        context 'when test message has ZERO failures and ZERO errors' do
          before do
            test_unit.test_message = "10 runs, 15 assertions, 0 failures, 0 errors, 0 skips"
          end

          it 'returns false' do
            expect(test_unit).to_not be_failure
          end
        end
      end

      describe '#pending?' do
        subject(:test_unit) { TestUnit.new }

        context 'when test message has ONE skip' do
          before do
            test_unit.test_message = "10 runs, 15 assertions, 0 failures, 0 errors, 1 skips"
          end

          it 'returns true' do
            expect(test_unit).to be_pending
          end
        end

        context 'when test message has ZERO skips' do
          before do
            test_unit.test_message = "10 runs, 15 assertions, 0 failures, 0 errors, 0 skips"
          end

          it 'returns false' do
            expect(test_unit).to_not be_pending
          end
        end
      end

      describe '.run?' do
        context 'when test directory exists with test files' do
          before do
            allow(File).to receive(:exist?).with('test').and_return(true)
            allow(File).to receive(:exist?).with('test/test_helper.rb').and_return(true)
          end

          it 'returns true' do
            expect(TestUnit.run?).to be true
          end
        end

        context 'when test directory exists with *_test.rb files' do
          before do
            allow(File).to receive(:exist?).with('test').and_return(true)
            allow(File).to receive(:exist?).with('test/test_helper.rb').and_return(false)
            allow(Dir).to receive(:[]).with('test/**/*_test.rb').and_return(['test/user_test.rb'])
          end

          it 'returns true' do
            expect(TestUnit.run?).to be true
          end
        end

        context 'when test directory does not exist' do
          before do
            allow(File).to receive(:exist?).with('test').and_return(false)
          end

          it 'returns false' do
            expect(TestUnit.run?).to be false
          end
        end
      end
    end
  end
end
