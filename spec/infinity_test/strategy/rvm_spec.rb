require "spec_helper"

module InfinityTest
  module Strategy
    describe Rvm do
      subject { Rvm.new(Core::Base) }
      it_should_behave_like 'a infinity test strategy'
    end
  end
end