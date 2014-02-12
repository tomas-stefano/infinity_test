module InfinityTest
  module TestFramework
    class Base
      attr_reader :test_message

      def test_helper_file
        raise NotImplementedError, "not implemented in #{self}"
      end

      def test_dir
        raise NotImplementedError, "not implemented in #{self}"
      end

      def test_dir=(dir)
        raise NotImplementedError, "not implemented in #{self}"
      end

      def binary
        raise NotImplementedError, "not implemented in #{self}"
      end

      def test_message=(message)
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