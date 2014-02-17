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

      def success?
        @failures.zero? and @pending.zero?
      end

      def failure?
        @failures > 0
      end

      def test_message=(message)
        @test_message = final_results(message).join.gsub(/\e\[\d+?m/, '') # Clean ANSIColor strings

        patterns.each do |key, pattern|
          spec_number = test_message[pattern, 1].to_i
          instance_variable_set("@#{key}", spec_number)
        end

        @test_message
      end

      private

      def final_results(message)
        lines    = message.split("\n")

        patterns.map do |pattern_name, pattern|
          lines.find { |line| line =~ pattern }
        end.flatten.uniq
      end

      def patterns
        { :examples => /(\d+) example/, :failures => /(\d+) failure/, :pending => /(\d+) pending/ }
      end
    end
  end
end