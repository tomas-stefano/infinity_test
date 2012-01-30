require 'infinity_test/strategy/rvm'
require 'infinity_test/strategy/rbenv'
require 'infinity_test/strategy/ruby_default'

module InfinityTest
  module Strategy
    class AutoDiscover < Base
      # Find strategy and reset the strategy to base and run strategy again.
      #
      def run!
        @base.strategy = find_strategy
        @base.run_strategy!
      end

      # AutoDiscover doesn't run tests.
      #
      def self.run?
        false
      end

      # Find in all strategies/subclasses what strategy that return true for #run? method.
      #
      def find_strategy
        Base.subclasses.find { |subclass| subclass.run? }
      end
    end
  end
end