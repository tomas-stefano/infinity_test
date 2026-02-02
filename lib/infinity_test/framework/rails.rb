module InfinityTest
  module Framework
    class Rails < Base
      delegate :test_dir, :test_helper_file, to: :test_framework

      # Add Heuristics to the observer run on pattern changes!
      #
      # ==== Heuristics
      #  * Watch app/models and run corresponding tests/specs
      #  * Watch app/controllers and run corresponding tests/specs
      #  * Watch app/helpers and run corresponding tests/specs
      #  * Watch app/mailers and run corresponding tests/specs
      #  * Watch app/jobs and run corresponding tests/specs
      #  * Watch lib dir and run corresponding tests
      #  * Watch test/spec dir and run the changed file
      #  * Watch test/spec helper and run all
      #  * Watch config/routes.rb and run routing specs
      #
      def heuristics
        watch_dir('app/models')      { |file| run_test(file) }
        watch_dir('app/controllers') { |file| run_test(file) }
        watch_dir('app/helpers')     { |file| run_test(file) }
        watch_dir('app/mailers')     { |file| run_test(file) }
        watch_dir('app/jobs')        { |file| run_test(file) }
        watch_dir(:lib)              { |file| run_test(file) }
        watch_dir(test_dir)          { |file| run_file(file) }
        watch(test_helper_file)      { run_all }
      end

      def self.run?
        File.exist?(File.expand_path('./config/environment.rb'))
      end
    end
  end
end