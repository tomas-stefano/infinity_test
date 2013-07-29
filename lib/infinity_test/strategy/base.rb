module InfinityTest
  module Strategy
    class Base
      def initialize(continuous_test_server)
        @continuous_test_server = continuous_test_server
      end

      # ==== Returns
      # CommandBuilderClass: A class that builds that command using method_missing.
      #
      def command_builder
        Core::CommandBuilder.new
      end

      # Run the strategy and parse the results storing in the strategy.
      #
      def run
        system(run!)
      end

      # Implement #run! method returning a string command to be run.
      #
      def run!
        raise NotImplementedError, "not implemented in #{self}"
      end

      # Put all the requires to autodiscover use your strategy instead of others.
      #
      def self.run?
        raise NotImplementedError, "not implemented in #{self}"
      end
    end
  end
end