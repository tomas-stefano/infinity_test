module InfinityTest
  module Framework
    class Rubygems < Base
      delegate :test_dir, :test_helper_file, to: :test_framework

      # Add Heuristics to the observer run on pattern changes!
      #
      # ==== Heuristics
      #  * Add Gemfile and Run bundle install and run all specs.
      #  * Observe lib dir and run test.
      #  * Observe the test dir and run the same changed file.
      #  * Observe the test helper file and run.
      #
      def heuristics
        watch_dir(:lib)         { |file| RunTest(file) }
        watch_dir(test_dir)     { |file| RunFile(file) }
        watch(test_helper_file) { RunAll() }
      end

      # ==== Returns
      #  TrueClass: Find a gemspec in the user current dir
      #  FalseClass: Don't Find a gemspec in the user current dir
      #
      def self.run?
        Dir["*.gemspec"].present?
      end
    end
  end
end