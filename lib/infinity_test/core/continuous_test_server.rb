module InfinityTest
  module Core
    class ContinuousTestServer
      attr_reader :base
      delegate :binary, :command_arguments, to: :test_framework
      delegate :infinity_and_beyond, to: :base

      def initialize(base)
        @base = base
      end

      def start
        run_strategy
        start_observer
      end

      # Run strategy based on the choosed ruby strategy.
      #
      def run_strategy
        # PENDING: run_before_callbacks
        strategy.run
        # PENDING: run_after_callbacks
      end

      # Start to monitoring files in the project.
      #
      def start_observer
        if infinity_and_beyond.present?
          framework.heuristics
          observer.signal
          observer.start
        end
      end

      # Returns the instance for the configured strategy.
      #
      def strategy
        @strategy ||= "InfinityTest::Strategy::#{base.strategy.to_s.classify}".constantize.new(self)
      end

      # Return a cached test framework instance.
      #
      def test_framework
        @test_framework ||= "::InfinityTest::TestFramework::#{base.test_framework.to_s.classify}".constantize.new
      end

      # Return a framework instance based on the base framework accessor.
      #
      def framework
        @framework ||= "::InfinityTest::Framework::#{base.framework.to_s.camelize}".constantize.new(observer)
      end

      # Return a cached observer instance by the observer accessor.
      #
      def observer
        @observer ||= "::InfinityTest::Observer::#{base.observer.to_s.classify}".constantize.new(self)
      end
    end
  end
end