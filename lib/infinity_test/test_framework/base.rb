module InfinityTest
  module TestFramework
    class Base
      def test_files
        raise NotImplementedError, "not implemented in #{self}"
      end

      def test_helper_file
        raise NotImplementedError, "not implemented in #{self}"
      end

      def test_dir
        raise NotImplementedError, "not implemented in #{self}"
      end

      def parse_results
        raise NotImplementedError, "not implemented in #{self}"
      end

      def success?
        raise NotImplementedError, "not implemented in #{self}"
      end

      def failure?
        raise NotImplementedError, "not implemented in #{self}"
      end

      def pending?
        raise NotImplementedError, "not implemented in #{self}"
      end
    end
  end
end