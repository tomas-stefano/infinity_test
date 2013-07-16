module InfinityTest
  module Framework
    class Base
      include ::InfinityTest::Framework::Helpers
      attr_reader :observer
      delegate :watch, :watch_dir, :to => :observer

      def initialize(observer)
        @observer = observer
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