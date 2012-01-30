require "spec_helper"

module InfinityTest
  module Strategy
    describe AutoDiscover do
      subject { AutoDiscover.new(Core::Base) }
      it_should_behave_like 'a infinity test strategy'

      describe "#run!" do
        it "should find strategy and rerun the discovered strategy" do
          mock(subject).find_strategy
          mock(subject.base).run_strategy! { true }
          subject.run!
        end
      end

      describe "#run?" do
        it "should not run because this class discover the right strategy" do
          AutoDiscover.should_not be_run
        end
      end

      describe "#find_strategy" do
        it "should return true if the classes return true" do
          pending
          strategy.find_strategy
        end
      end
    end
  end
end
