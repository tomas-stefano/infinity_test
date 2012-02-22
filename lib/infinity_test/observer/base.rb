module InfinityTest
  module Observer
    class Base
      attr_accessor :observer

      def start
        raise NotImplementedError, "not implemented in #{self}"
      end

      def signal
        raise NotImplementedError, "not implemented in #{self}"
      end
    end
  end
end