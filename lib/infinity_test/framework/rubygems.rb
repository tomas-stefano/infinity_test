module InfinityTest
  module Framework
    class Rubygems < Base
      def heuristics
        # watch(:Gemfile) { BundleInstall and RunAll }
        # watch_dir(:lib) { |file| RunTest(file, :dir => :models) }
        # watch_dir(@test_framework.test_dir) { |file| RunFile(file) }
        # watch(@test_framework.test_helper_file) { RunAll }
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