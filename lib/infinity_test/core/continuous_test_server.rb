module InfinityTest
  module Core
    class ContinuousTestServer
      attr_reader :base

      def initialize(base)
        @base = base
      end

      def start
        #
        # run_strategy
        # base.start_observer
      end

      # Run strategy based on the choosed ruby strategy.
      #
      def run_strategy
        # PENDING: run_before_callbacks
        strategy_instance.run
        # PENDING: run_after_callbacks
      end

      # Start to monitoring files in the project.
      #
      def start_observer
        if infinity_and_beyond.present?
          add_heuristics
          observer_instance.signal
          observer_instance.start
        end
      end

      private

      # Adding heuristics based on the framework.
      #
      def add_heuristics
        framework_instance.heuristics
      end

      # Returns the instance for the configured strategy.
      #
      def strategy_instance
        InfinityTest::Strategy.const_get(base.strategy.to_s.classify).new(self)
      end

      # Return a cached test framework instance by the observer accessor.
      #
      def test_framework_instance
        "::InfinityTest::TestFramework::#{test_framework.to_s.classify}".constantize.new
      end

      # Return a framework instance based on the framework accessor.
      #
      def framework_instance
        "::InfinityTest::Framework::#{framework.to_s.camelize}".constantize.new(self)
      end

      # Return a cached observer instance by the observer accessor.
      #
      def observer_instance
        @observer_instance ||= "::InfinityTest::Observer::#{observer.to_s.classify}".constantize.new
      end
    end
  end
end