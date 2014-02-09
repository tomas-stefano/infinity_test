require 'spec_helper'

module InfinityTest
  module Framework
    describe Rubygems do
      let(:observer) { double('Observer') }
      let(:test_framework) { double('TestFramework') }
      let(:continuous_test_server) { double('ContinuousTestServer', observer: observer, test_framework: test_framework) }
      subject { Rubygems.new(continuous_test_server) }

      describe "#heuristics" do
        it "should add heuristics" do
          expect(observer).to receive(:watch_dir).exactly(2)
          expect(observer).to receive(:watch)
          expect(test_framework).to receive(:test_helper_file)
          expect(test_framework).to receive(:test_dir)
          expect { subject.heuristics }.to_not raise_exception
        end
      end

      describe ".run?" do
        it "should return true if have a .gemspec in the user current dir" do
          expect(Dir).to receive(:[]).with('*.gemspec').and_return(['infinity_test.gemspec'])
          expect(Rubygems).to be_run
        end

        it "should return false if don't have a .gemspec in the user current dir" do
          expect(Dir).to receive(:[]).with('*.gemspec').and_return([])
          expect(Rubygems).not_to be_run
        end
      end
    end
  end
end
