require 'spec_helper'

module InfinityTest
  module TestFramework
    describe ExUnit do
      it_should_behave_like 'a infinity test test framework'

      describe "#test_dir" do
        it "returns test as test dir" do
          expect(subject.test_dir).to eq 'test'
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
            subject.test_files = 'test/my_app/user_test.exs'
            expect(subject.test_files).to eq 'test/my_app/user_test.exs'
          end
        end
      end

      describe "#test_helper_file" do
        it "is the test helper" do
          expect(subject.test_helper_file).to eq 'test/test_helper.exs'
        end
      end

      describe "#binary" do
        it "returns mix as binary" do
          expect(subject.binary).to eq 'mix'
        end
      end

      describe '#test_message' do
        subject(:ex_unit) { ExUnit.new }

        it 'returns the final test results' do
          ex_unit.test_message = "Finished in 0.1 seconds (0.1s async, 0.0s sync)\n3 tests, 0 failures"
          expect(ex_unit.test_message).to eq '3 tests, 0 failures'
        end
      end

      describe '#success?' do
        subject(:ex_unit) { ExUnit.new }

        context 'when is test message with ZERO failures and ZERO skipped' do
          before do
            ex_unit.test_message = "3 tests, 0 failures"
          end

          it 'returns true' do
            expect(ex_unit).to be_success
          end
        end

        context 'when is test message with ONE failure and ZERO skipped' do
          before do
            ex_unit.test_message = "3 tests, 1 failure"
          end

          it 'returns false' do
            expect(ex_unit).to_not be_success
          end
        end

        context 'when is test message with ZERO failures and ONE skipped' do
          before do
            ex_unit.test_message = "3 tests, 0 failures, 1 skipped"
          end

          it 'returns false' do
            expect(ex_unit).to_not be_success
          end
        end
      end

      describe '#failure?' do
        subject(:ex_unit) { ExUnit.new }

        context 'when is test message with ONE failure' do
          before do
            ex_unit.test_message = "3 tests, 1 failure"
          end

          it 'returns true' do
            expect(ex_unit).to be_failure
          end
        end

        context 'when is test message with ZERO failures' do
          before do
            ex_unit.test_message = "3 tests, 0 failures"
          end

          it 'returns false' do
            expect(ex_unit).to_not be_failure
          end
        end
      end

      describe '#pending?' do
        subject(:ex_unit) { ExUnit.new }

        context 'when is test message with skipped tests' do
          before do
            ex_unit.test_message = "3 tests, 0 failures, 1 skipped"
          end

          it 'returns true' do
            expect(ex_unit).to be_pending
          end
        end

        context 'when is test message without skipped tests' do
          before do
            ex_unit.test_message = "3 tests, 0 failures"
          end

          it 'returns false' do
            expect(ex_unit).to_not be_pending
          end
        end
      end

      describe '.run?' do
        it 'returns true if test dir exists and has exs test files' do
          allow(File).to receive(:exist?).with('test').and_return(true)
          allow(File).to receive(:exist?).with('test/test_helper.exs').and_return(false)
          allow(Dir).to receive(:[]).with('test/**/*_test.exs').and_return(['test/my_app_test.exs'])
          expect(ExUnit).to be_run
        end

        it 'returns true if test_helper.exs exists' do
          allow(File).to receive(:exist?).with('test').and_return(true)
          allow(File).to receive(:exist?).with('test/test_helper.exs').and_return(true)
          expect(ExUnit).to be_run
        end

        it 'returns false if no test dir' do
          allow(File).to receive(:exist?).with('test').and_return(false)
          expect(ExUnit).not_to be_run
        end
      end
    end
  end
end
