require 'spec_helper'

module InfinityTest
  describe HeuristicsHelper do
    include HeuristicsHelper

    describe '#heuristics' do
      it "should be instance of InfinityTest Heuristics" do
        heuristics do
        end.should be_instance_of(InfinityTest::Heuristics)
      end
    end

  end
end
