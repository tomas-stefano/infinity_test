require "spec_helper"

module InfinityTest
  module Strategy
    describe Rvm do
      let(:strategy) { Rvm.new(Core::Base) }
      it_should_behave_like 'a strategy'
    end
  end
end