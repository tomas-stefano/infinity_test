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
        # strategy_to_run = Base.sort_by_priority.find { |subclass| subclass.run? }
        #         if strategy_to_run.present?
        #           strategy_to_run.strategy_name
        #         else
        #           message = <<-MESSAGE
        #
        #             The InfinityTest::Strategy::AutoDiscover doesn't discover nothing to run.
        #             Do you pass more than one ruby version to run and do you have some strategy(Rvm, Rbenv) installed?
        #
        #           MESSAGE
        #           raise Exception, message
        end
      end
    end
  end
end