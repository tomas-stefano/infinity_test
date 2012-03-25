module InfinityTest
  module Framework
    class Rails < Base
      def heuristics
        # watch_dir('app/models') { |file| RunTest(file, :dir => :models) }
        # watch_dir('app/models') { |file| RunAll(:dir => :controllers) }
        # watch_gemfile
        # watch(:Gemfile) { |file| BundleInstall and RunAll }
        # watch(@test_framework.test_helper_file) { |file| RunAll }
      end

      def self.run?
        File.exist?(File.expand_path('./config/environment.rb'))
      end
    end
  end
end