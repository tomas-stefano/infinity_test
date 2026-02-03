module InfinityTest
  module TestFramework
    class Pytest < Base
      def binary
        'pytest'
      end

      def test_helper_file
        File.join(test_dir, 'conftest.py')
      end

      def test_dir
        @test_dir ||= detect_test_dir
      end

      def test_dir=(dir)
        @test_dir = dir
      end

      def test_files
        @test_files || test_dir
      end

      # Pytest output patterns:
      #   "5 passed in 0.12s"
      #   "1 failed, 4 passed in 0.15s"
      #   "1 failed, 2 passed, 1 skipped in 0.20s"
      #
      def patterns
        { passed: /(\d+) passed/, failed: /(\d+) failed/, skipped: /(\d+) skipped/ }
      end

      def success?
        @failed.zero? && @skipped.zero?
      end

      def failure?
        @failed > 0
      end

      def pending?
        @skipped > 0
      end

      def self.run?
        (File.exist?('tests') || File.exist?('test')) && (
          File.exist?('tests/conftest.py') ||
          File.exist?('test/conftest.py') ||
          Dir['tests/**/test_*.py'].any? ||
          Dir['test/**/test_*.py'].any? ||
          Dir['tests/**/*_test.py'].any? ||
          Dir['test/**/*_test.py'].any?
        )
      end

      private

      def detect_test_dir
        return 'tests' if File.exist?('tests')
        return 'test' if File.exist?('test')
        'tests'
      end
    end
  end
end
