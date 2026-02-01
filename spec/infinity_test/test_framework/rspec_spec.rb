require 'spec_helper'

module InfinityTest
  module TestFramework
    describe Rspec do
      it_should_behave_like 'a infinity test test framework'

      describe "#test_dir" do
        it "returns spec as test dir" do
          expect(subject.test_dir).to eq 'spec'
        end
      end

      describe '#test_files' do
        context 'when is empty' do
          it 'returns the test dir' do
            expect(subject.test_files).to eq 'spec'
          end
        end

        context 'when assign the test files' do
          it 'returns the assigned value' do
            subject.test_files = 'framework/base_spec.rb'
            expect(subject.test_files).to eq 'framework/base_spec.rb'
          end
        end
      end

      describe "#test_helper_file" do
        it "is the spec helper" do
          expect(subject.test_helper_file).to eq 'spec/spec_helper.rb'
        end
      end

      describe "#binary" do
        it "returns rspec as binary" do
          expect(subject.binary).to eq 'rspec'
        end
      end

      describe '#test_message' do
        subject(:rspec) { Rspec.new }

        it 'returns the final specs results' do
          rspec.test_message = "Finished in 2.19 seconds\n\e[33m162 examples, 0 failures, 8 pending\e[0m\n"
          expect(rspec.test_message).to eq '162 examples, 0 failures, 8 pending'
        end
      end

      describe '#success?' do
        subject(:rspec) { Rspec.new }

        context 'when is test message with ZERO failures and ZERO pending' do
          before do
            rspec.test_message = "162 examples, 0 failures, 0 pending"
          end

          it 'returns true' do
            expect(rspec).to be_success
          end
        end

        context 'when is test message with ONE failure and ZERO pending' do
          before do
            rspec.test_message = "162 examples, 1 failures, 0 pending"
          end

          it 'returns false' do
            expect(rspec).to_not be_success
          end
        end

        context 'when is test message with ZERO failures and ONE pending' do
          before do
            rspec.test_message = "162 examples, 0 failures, 1 pending"
          end

          it 'returns false' do
            expect(rspec).to_not be_success
          end
        end
      end

      describe '#failure?' do
        subject(:rspec) { Rspec.new }

        context 'when is test message with ONE failure and ZERO pending' do
          before do
            rspec.test_message = "162 examples, 1 failures, 0 pending"
          end

          it 'returns true' do
            expect(rspec).to be_failure
          end
        end

        context 'when is test message with ZERO failures and ZERO pending' do
          before do
            rspec.test_message = "162 examples, 0 failures, 0 pending"
          end

          it 'returns false' do
            expect(rspec).to_not be_failure
          end
        end

        context 'when is test message with ZERO failures and ONE pending' do
          before do
            rspec.test_message = "162 examples, 0 failures, 1 pending"
          end

          it 'returns false' do
            expect(rspec).to_not be_failure
          end
        end
      end
    end
  end
end
