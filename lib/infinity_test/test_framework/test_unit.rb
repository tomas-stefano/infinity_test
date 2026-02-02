module InfinityTest
  module TestFramework
    class TestUnit < Base
      def test_dir
        @test_dir ||= 'test'
      end

      def test_dir=(dir)
        @test_dir = dir
      end

      def test_helper_file
        File.join(test_dir, 'test_helper.rb')
      end

      def test_files
        @test_files || test_dir
      end

      def binary
        'ruby'
      end

      # Patterns for parsing minitest/test-unit output
      # Example: "10 runs, 15 assertions, 0 failures, 0 errors, 0 skips"
      def patterns
        {
          :runs => /(\d+) runs,/,
          :assertions => /(\d+) assertions,/,
          :failures => /(\d+) failures,/,
          :errors => /(\d+) errors,/,
          :skips => /(\d+) skips/
        }
      end

      def success?
        @failures.zero? && @errors.zero? && @skips.zero?
      end

      def failure?
        @failures > 0 || @errors > 0
      end

      def pending?
        @skips > 0
      end

      def self.run?
        File.exist?('test') && (
          File.exist?('test/test_helper.rb') ||
          Dir['test/**/*_test.rb'].any? ||
          Dir['test/**/test_*.rb'].any?
        )
      end
    end
  end
end