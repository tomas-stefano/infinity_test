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

      # Parse the test results based by the framework patterns.
      # <b>The subclass must implement the #patterns method.</b>
      #
      def test_message=(message)
        @test_message = final_results(message).join.gsub(/\e\[\d+?m/, '') # Clean ANSIColor strings

        patterns.each do |key, pattern|
          spec_number = test_message[pattern, 1].to_i
          instance_variable_set("@#{key}", spec_number)
        end

        @test_message
      end

      def patterns
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

      private

      def final_results(message)
        lines    = message.split("\n")

        patterns.map do |pattern_name, pattern|
          lines.find { |line| line =~ pattern }
        end.flatten.uniq
      end
    end
  end
end