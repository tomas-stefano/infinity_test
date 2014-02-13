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

      def test_message=(message)
        patterns = { :examples => /(\d+) example/, :failures => /(\d+) failure/, :pending => /(\d+) pending/ }
        lines    = message.split("\n")

        final_results = patterns.map do |pattern_name, pattern|
          lines.find { |line| line =~ pattern }
        end.flatten.uniq.join

        @test_message = final_results.gsub(/\e\[\d+?m/, '') # Clean ANSIColor strings
      end
    end
  end
end