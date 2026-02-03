require 'spec_helper'

module InfinityTest
  module TestFramework
    describe CargoTest do
      it_should_behave_like 'a infinity test test framework'

      describe "#test_dir" do
        it "returns tests as test dir" do
          expect(subject.test_dir).to eq 'tests'
        end
      end

      describe '#test_files' do
        context 'when is empty' do
          it 'returns empty string' do
            expect(subject.test_files).to eq ''
          end
        end

        context 'when assign the test files' do
          it 'returns the assigned value' do
            subject.test_files = 'user'
            expect(subject.test_files).to eq 'user'
          end
        end
      end

      describe "#test_helper_file" do
        it "is Cargo.toml" do
          expect(subject.test_helper_file).to eq 'Cargo.toml'
        end
      end

      describe "#binary" do
        it "returns cargo as binary" do
          expect(subject.binary).to eq 'cargo'
        end
      end

      describe '#test_message' do
        subject(:cargo_test) { CargoTest.new }

        it 'returns the final test results' do
          cargo_test.test_message = "test result: ok. 5 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out"
          expect(cargo_test.test_message).to eq 'test result: ok. 5 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out'
        end
      end

      describe '#success?' do
        subject(:cargo_test) { CargoTest.new }

        context 'when all tests pass' do
          before do
            cargo_test.test_message = "test result: ok. 5 passed; 0 failed; 0 ignored"
          end

          it 'returns true' do
            expect(cargo_test).to be_success
          end
        end

        context 'when there are failures' do
          before do
            cargo_test.test_message = "test result: FAILED. 3 passed; 2 failed; 0 ignored"
          end

          it 'returns false' do
            expect(cargo_test).to_not be_success
          end
        end

        context 'when there are ignored tests' do
          before do
            cargo_test.test_message = "test result: ok. 4 passed; 0 failed; 1 ignored"
          end

          it 'returns false' do
            expect(cargo_test).to_not be_success
          end
        end
      end

      describe '#failure?' do
        subject(:cargo_test) { CargoTest.new }

        context 'when there are failures' do
          before do
            cargo_test.test_message = "test result: FAILED. 3 passed; 2 failed; 0 ignored"
          end

          it 'returns true' do
            expect(cargo_test).to be_failure
          end
        end

        context 'when all tests pass' do
          before do
            cargo_test.test_message = "test result: ok. 5 passed; 0 failed; 0 ignored"
          end

          it 'returns false' do
            expect(cargo_test).to_not be_failure
          end
        end
      end

      describe '#pending?' do
        subject(:cargo_test) { CargoTest.new }

        context 'when there are ignored tests' do
          before do
            cargo_test.test_message = "test result: ok. 4 passed; 0 failed; 1 ignored"
          end

          it 'returns true' do
            expect(cargo_test).to be_pending
          end
        end

        context 'when no tests are ignored' do
          before do
            cargo_test.test_message = "test result: ok. 5 passed; 0 failed; 0 ignored"
          end

          it 'returns false' do
            expect(cargo_test).to_not be_pending
          end
        end
      end

      describe '.run?' do
        it 'returns true if Cargo.toml exists' do
          allow(File).to receive(:exist?).with('Cargo.toml').and_return(true)
          expect(CargoTest).to be_run
        end

        it 'returns false if Cargo.toml does not exist' do
          allow(File).to receive(:exist?).with('Cargo.toml').and_return(false)
          expect(CargoTest).not_to be_run
        end
      end
    end
  end
end
