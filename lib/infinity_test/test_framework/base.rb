module InfinityTest
  module TestFramework
    class Base
      attr_accessor :test_files

      def parse_results
        raise NotImplementedError
      end

      def success?
        raise NotImplementedError
      end

      def failure?
        raise NotImplementedError
      end

      def pending?
        raise NotImplementedError
      end
    end
  end
end