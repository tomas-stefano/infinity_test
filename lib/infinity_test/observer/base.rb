module InfinityTest
  module Observer
    class Base
      attr_accessor :observer

      def start
        raise NotImplementedError
      end

      def signal
        raise NotImplementedError
      end
    end
  end
end