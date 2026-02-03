module InfinityTest
  module Framework
    class Phoenix < Base
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
      #  * Watch all lib/*_web directories (controllers, views, live, channels)
      #  * Watch lib dir (.ex files) and run corresponding test
      #  * Watch test dir (.exs files) and run the changed file
      #  * Watch test helper and run all tests
      #
      def heuristics
        watch_lib_dirs
        watch_dir(test_dir, :exs) { |file| run_file(file) }
        watch(test_helper_file) { run_all }
      end

      # Auto-discover and watch all directories under lib/ that contain .ex files.
      # Maps lib/my_app/accounts to test/my_app/accounts, etc.
      #
      def watch_lib_dirs
        return unless File.directory?('lib')

        Dir.glob('lib/*').each do |lib_dir|
          next unless File.directory?(lib_dir)
          next unless Dir.glob("#{lib_dir}/**/*.ex").any?

          watch_dir(lib_dir, :ex) { |file| run_test_in_lib(file, lib_dir) }
        end
      end

      # Run test preserving the directory structure.
      # E.g: lib/my_app_web/controllers/user_controller.ex -> test/my_app_web/controllers/user_controller_test.exs
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      # @param lib_dir [String] The lib directory (e.g., 'lib/my_app_web')
      #
      def run_test_in_lib(changed_file, lib_dir)
        subdir = File.basename(lib_dir)
        test_file = File.join(test_framework.test_dir, subdir, "#{changed_file.path}_test.exs")

        if File.exist?(test_file)
          continuous_test_server.rerun_strategy(test_file)
        else
          # Fallback: try finding with hike in test_dir/subdir
          hike.prepend_path(File.join(test_framework.test_dir, subdir))
          file_name = "#{changed_file.path}_test.exs"
          file = hike.find(file_name)
          continuous_test_server.rerun_strategy(file) if file.present?
        end
      end

      # ==== Returns
      #  TrueClass: Find a Phoenix project (has lib/*_web directory)
      #  FalseClass: Not a Phoenix project
      #
      def self.run?
        File.exist?('mix.exs') && Dir.glob('lib/*_web').any?
      end
    end
  end
end
