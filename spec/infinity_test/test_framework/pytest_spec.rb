require 'spec_helper'

module InfinityTest
  module TestFramework
    describe Pytest do
      it_should_behave_like 'a infinity test test framework'

      describe "#test_dir" do
        context "when tests directory exists" do
          before do
            allow(File).to receive(:exist?).with('tests').and_return(true)
          end

          it "returns tests as test dir" do
            expect(subject.test_dir).to eq 'tests'
          end
        end

        context "when test directory exists" do
          before do
            allow(File).to receive(:exist?).with('tests').and_return(false)
            allow(File).to receive(:exist?).with('test').and_return(true)
          end

          it "returns test as test dir" do
            expect(subject.test_dir).to eq 'test'
          end
        end
      end

      describe '#test_files' do
        context 'when is empty' do
          before do
            allow(File).to receive(:exist?).with('tests').and_return(true)
          end

          it 'returns the test dir' do
            expect(subject.test_files).to eq 'tests'
          end
        end

        context 'when assign the test files' do
          it 'returns the assigned value' do
            subject.test_files = 'tests/test_utils.py'
            expect(subject.test_files).to eq 'tests/test_utils.py'
          end
        end
      end

      describe "#test_helper_file" do
        before do
          allow(File).to receive(:exist?).with('tests').and_return(true)
        end

        it "is conftest.py" do
          expect(subject.test_helper_file).to eq 'tests/conftest.py'
        end
      end

      describe "#binary" do
        it "returns pytest as binary" do
          expect(subject.binary).to eq 'pytest'
        end
      end

      describe '#test_message' do
        subject(:pytest) { Pytest.new }

        it 'returns the final test results' do
          pytest.test_message = "========================= 5 passed in 0.12s ========================="
          expect(pytest.test_message).to eq '========================= 5 passed in 0.12s ========================='
        end
      end

      describe '#success?' do
        subject(:pytest) { Pytest.new }

        context 'when all tests pass' do
          before do
            pytest.test_message = "5 passed in 0.12s"
          end

          it 'returns true' do
            expect(pytest).to be_success
          end
        end

        context 'when there are failures' do
          before do
            pytest.test_message = "1 failed, 4 passed in 0.15s"
          end

          it 'returns false' do
            expect(pytest).to_not be_success
          end
        end

        context 'when there are skipped tests' do
          before do
            pytest.test_message = "4 passed, 1 skipped in 0.15s"
          end

          it 'returns false' do
            expect(pytest).to_not be_success
          end
        end
      end

      describe '#failure?' do
        subject(:pytest) { Pytest.new }

        context 'when there are failures' do
          before do
            pytest.test_message = "1 failed, 4 passed in 0.15s"
          end

          it 'returns true' do
            expect(pytest).to be_failure
          end
        end

        context 'when all tests pass' do
          before do
            pytest.test_message = "5 passed in 0.12s"
          end

          it 'returns false' do
            expect(pytest).to_not be_failure
          end
        end
      end

      describe '#pending?' do
        subject(:pytest) { Pytest.new }

        context 'when there are skipped tests' do
          before do
            pytest.test_message = "4 passed, 1 skipped in 0.15s"
          end

          it 'returns true' do
            expect(pytest).to be_pending
          end
        end

        context 'when no tests are skipped' do
          before do
            pytest.test_message = "5 passed in 0.12s"
          end

          it 'returns false' do
            expect(pytest).to_not be_pending
          end
        end
      end

      describe '.run?' do
        it 'returns true if tests dir exists with test files' do
          allow(File).to receive(:exist?).with('tests').and_return(true)
          allow(File).to receive(:exist?).with('test').and_return(false)
          allow(File).to receive(:exist?).with('tests/conftest.py').and_return(false)
          allow(File).to receive(:exist?).with('test/conftest.py').and_return(false)
          allow(Dir).to receive(:[]).with('tests/**/test_*.py').and_return(['tests/test_utils.py'])
          expect(Pytest).to be_run
        end

        it 'returns true if conftest.py exists' do
          allow(File).to receive(:exist?).with('tests').and_return(true)
          allow(File).to receive(:exist?).with('test').and_return(false)
          allow(File).to receive(:exist?).with('tests/conftest.py').and_return(true)
          expect(Pytest).to be_run
        end

        it 'returns false if no test directory' do
          allow(File).to receive(:exist?).with('tests').and_return(false)
          allow(File).to receive(:exist?).with('test').and_return(false)
          expect(Pytest).not_to be_run
        end
      end
    end
  end
end
