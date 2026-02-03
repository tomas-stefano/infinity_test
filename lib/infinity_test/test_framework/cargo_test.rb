module InfinityTest
  module TestFramework
    class CargoTest < Base
      def binary
        'cargo'
      end

      def test_helper_file
        'Cargo.toml'
      end

      def test_dir
        @test_dir ||= 'tests'
      end

      def test_dir=(dir)
        @test_dir = dir
      end

      def test_files
        @test_files || ''
      end

      # Cargo test output patterns:
      #   "test result: ok. 5 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out"
      #   "test result: FAILED. 3 passed; 2 failed; 1 ignored; 0 measured; 0 filtered out"
      #
      def patterns
        { passed: /(\d+) passed/, failed: /(\d+) failed/, ignored: /(\d+) ignored/ }
      end

      def success?
        @failed.zero? && @ignored.zero?
      end

      def failure?
        @failed > 0
      end

      def pending?
        @ignored > 0
      end

      def self.run?
        File.exist?('Cargo.toml')
      end
    end
  end
end
