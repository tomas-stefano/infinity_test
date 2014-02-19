module InfinityTest
  module TestFramework
    class Rspec < Base
      def binary
        'rspec'
      end

      def test_helper_file
        File.join(test_dir, 'spec_helper.rb')
      end

      def test_dir
        'spec'
      end
      alias :command_arguments :test_dir

      def patterns
        { :examples => /(\d+) example/, :failures => /(\d+) failure/, :pending => /(\d+) pending/ }
      end

      def success?
        @failures.zero? and @pending.zero?
      end

      def failure?
        @failures > 0
      end
    end
  end
end