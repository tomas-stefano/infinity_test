module InfinityTest
  module Framework
    class ElixirMix < Base
      delegate :test_dir, :test_helper_file, to: :test_framework

      # Override to use .exs extension for Elixir test files.
      #
      def heuristics!
        hike.append_extension('.exs')
        hike.append_path(test_framework.test_dir)
        heuristics
      end

      # Add Heuristics to the observer run on pattern changes!
      #
      # ==== Heuristics
      #  * Observe lib dir (.ex files) and run corresponding test.
      #  * Observe the test dir (.exs files) and run the same changed file.
      #  * Observe the test helper file and run all tests.
      #
      def heuristics
        watch_dir(:lib, :ex)    { |file| run_test(file) }
        watch_dir(test_dir, :exs) { |file| run_file(file) }
        watch(test_helper_file) { run_all }
      end

      # Run test based on the changed file.
      # Maps lib/my_app/user.ex -> test/my_app/user_test.exs
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      #
      def run_test(changed_file)
        file_name = "#{changed_file.path}_test.exs"
        file = hike.find(file_name)
        continuous_test_server.rerun_strategy(file) if file.present?
      end

      # ==== Returns
      #  TrueClass: Find a mix.exs in the user current dir
      #  FalseClass: Don't Find a mix.exs in the user current dir
      #
      def self.run?
        File.exist?('mix.exs')
      end
    end
  end
end
