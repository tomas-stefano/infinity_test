require "spec_helper"

module InfinityTest
  module Strategy
    describe Rbenv do
      let(:strategy) { Rbenv.new(Core::Base) }
      it_should_behave_like 'a infinity test strategy'
    end
  end
end