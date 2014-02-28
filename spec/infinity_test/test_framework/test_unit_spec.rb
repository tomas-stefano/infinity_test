require 'spec_helper'

module InfinityTest
  module TestFramework
    describe TestUnit do
      it_should_behave_like 'a infinity test test framework'

      describe "#test_dir" do
        it "should return spec as test dir" do
          expect(subject.test_dir).to eq 'test'
        end
      end

      describe "#test_helper_file" do
        it "should be the spec helper" do
          expect(subject.test_helper_file).to eq 'test/test_helper.rb'
        end
      end

      describe '#binary' do
        it 'should see the binary with the strategy instance'
      end
    end
  end
end