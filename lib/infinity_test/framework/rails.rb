module InfinityTest
  module Framework
    class Rails < Base
      delegate :test_dir, :test_helper_file, to: :test_framework

      # Add Heuristics to the observer run on pattern changes!
      #
      # ==== Heuristics
      #  * Watch all app/* directories and run corresponding tests/specs
      #  * Watch lib dir and run corresponding tests
      #  * Watch test/spec dir and run the changed file
      #  * Watch test/spec helper and run all
      #
      def heuristics
        watch_app_dirs
        watch_dir(:lib)     { |file| run_test(file) }
        watch_dir(test_dir) { |file| run_file(file) }
        watch(test_helper_file) { run_all }
      end

      def self.run?
        File.exist?(File.expand_path('./config/environment.rb'))
      end
    end
  end
end