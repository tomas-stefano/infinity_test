require 'spec_helper'

module InfinityTest
  module TestFramework
    describe Rspec do
      it_should_behave_like 'a infinity test test framework'

      describe "#test_dir" do
        it "should return spec as test dir" do
          expect(subject.test_dir).to eq 'spec'
        end
      end

      describe "#test_helper_file" do
        it "should be the spec helper" do
          expect(subject.test_helper_file).to eq 'spec/spec_helper.rb'
        end
      end

      describe "#binary" do
        it "should return rspec as binary" do
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
    end
  end
end