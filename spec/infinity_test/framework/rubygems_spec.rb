require 'spec_helper'

module InfinityTest
  module Framework
    describe Rubygems do
      subject { Rubygems.new(Core::Base) }

      describe "#heuristics" do
        it "should add heuristics" do
          pending
          expect { subject.heuristics }.to_not raise_exception
        end
      end

      describe ".run?" do
        it "should return true if have a .gemspec in the user current dir" do
          Dir.should_receive(:[]).with('*.gemspec').and_return(['infinity_test.gemspec'])
          Rubygems.should be_run
        end

        it "should return false if don't have a .gemspec in the user current dir" do
          Dir.should_receive(:[]).with('*.gemspec').and_return([])
          Rubygems.should_not be_run
        end
      end
    end
  end
end