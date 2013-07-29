module InfinityTest
  module Framework
    class Rails < Base
      def heuristics
        # watch_dir('app') { |file| RunTest(file, :dir => :spec) }
        # watch(:Gemfile) { |file| BundleInstall and RunAll }
        # watch(test_framework.test_helper_file) { |file| RunAll }
      end

      def self.run?
        File.exist?(File.expand_path('./config/environment.rb'))
      end
    end
  end
end