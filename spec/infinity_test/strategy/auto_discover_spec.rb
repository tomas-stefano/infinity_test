require "spec_helper"

module InfinityTest
  module Strategy
    describe AutoDiscover do
      let(:strategy) { AutoDiscover.new(Core::Base) }
      it_should_behave_like 'a strategy'

      describe "#run!" do
        it "should find strategy and rerun the discovered strategy" do
          mock(strategy).find_strategy
          mock(strategy.base).run_strategy! { true }
          strategy.run!
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
