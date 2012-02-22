require 'spec_helper'

module InfinityTest
  module Observer
    describe EventMachine do
      it_should_behave_like 'an infinity test observer'
    end
  end
end