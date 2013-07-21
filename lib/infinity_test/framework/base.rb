module InfinityTest
  module Framework
    class Base
      include ::InfinityTest::Framework::Helpers
      attr_reader :observer, :continuous_test_server
      delegate :watch, :watch_dir, to: :observer

      def initialize(continuous_test_server)
        @continuous_test_server = continuous_test_server
        @observer               = continuous_test_server.observer
      end

      # This method is called for the InfinityTest before starting the observer
      #
      def heuristics
        raise NotImplementedError, "not implemented in #{self}"
      end

      # Put all the requires to autodiscover use your framework instead of others.
      #
      def self.run?
        raise NotImplementedError, "not implemented in #{self}"
      end
    end
  end
end