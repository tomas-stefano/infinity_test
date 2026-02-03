module InfinityTest
  module Framework
    class Rocket < Base
      delegate :test_dir, :test_helper_file, to: :test_framework

      # Override to use .rs extension for Rust files.
      #
      def heuristics!
        hike.append_extension('.rs')
        hike.append_path(test_framework.test_dir) if File.directory?(test_framework.test_dir.to_s)
        heuristics
      end

      # Add Heuristics to the observer run on pattern changes!
      #
      # ==== Heuristics
      #  * Watch src dir (.rs files) and run tests matching the module name
      #  * Watch tests dir (.rs files) and run the changed integration test
      #  * Watch Cargo.toml and run all tests
      #  * Watch Rocket.toml if exists and run all tests
      #
      def heuristics
        watch_dir(:src, :rs) { |file| run_module_tests(file) }
        watch_dir(test_dir, :rs) { |file| run_integration_test(file) } if File.directory?(test_dir.to_s)
        watch(test_helper_file) { run_all }
        watch('Rocket.toml') { run_all } if File.exist?('Rocket.toml')
      end

      # Run tests matching the module name.
      # E.g: src/routes.rs -> cargo test routes
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      #
      def run_module_tests(changed_file)
        module_name = File.basename(changed_file.name, '.rs')
        # lib.rs and main.rs changes should run all tests
        if %w[lib main].include?(module_name)
          run_all
        else
          continuous_test_server.rerun_strategy(module_name)
        end
      end

      # Run a specific integration test file.
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      #
      def run_integration_test(changed_file)
        test_name = File.basename(changed_file.name, '.rs')
        continuous_test_server.rerun_strategy("--test #{test_name}")
      end

      # ==== Returns
      #  TrueClass: Find a Rocket project (Cargo.toml with rocket dependency)
      #  FalseClass: Not a Rocket project
      #
      def self.run?
        File.exist?('Cargo.toml') && rocket_project?
      end

      def self.rocket_project?
        return false unless File.exist?('Cargo.toml')
        content = File.read('Cargo.toml')
        content.include?('rocket')
      rescue
        false
      end
    end
  end
end
