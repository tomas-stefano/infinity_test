require "spec_helper"

module InfinityTest
  module Strategy
    describe RubyDefault do
      let(:strategy) { RubyDefault.new(Core::Base) }
      it_should_behave_like 'a strategy'
    end
  end
end