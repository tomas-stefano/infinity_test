module InfinityTest
  module TestFramework
    class ExUnit < Base
      def binary
        'mix'
      end

      def test_helper_file
        File.join(test_dir, 'test_helper.exs')
      end

      def test_dir
        @test_dir ||= 'test'
      end

      def test_dir=(dir)
        @test_dir = dir
      end

      def test_files
        @test_files || test_dir
      end

      # ExUnit output patterns:
      #   "3 tests, 0 failures"
      #   "3 tests, 1 failure"
      #   "3 tests, 0 failures, 1 skipped"
      #
      def patterns
        { tests: /(\d+) tests?/, failures: /(\d+) failures?/, skipped: /(\d+) skipped/ }
      end

      def success?
        @failures.zero? && @skipped.zero?
      end

      def failure?
        @failures > 0
      end

      def pending?
        @skipped > 0
      end

      def self.run?
        File.exist?('test') && (
          File.exist?('test/test_helper.exs') ||
          Dir['test/**/*_test.exs'].any?
        )
      end
    end
  end
end
