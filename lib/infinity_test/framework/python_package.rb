module InfinityTest
  module Framework
    class PythonPackage < Base
      delegate :test_dir, :test_helper_file, to: :test_framework

      # Override to use .py extension for Python test files.
      #
      def heuristics!
        hike.append_extension('.py')
        hike.append_path(test_framework.test_dir)
        heuristics
      end

      # Add Heuristics to the observer run on pattern changes!
      #
      # ==== Heuristics
      #  * Watch src dir (.py files) and run corresponding test
      #  * Watch package dirs (.py files) and run corresponding test
      #  * Watch test dir (.py files) and run the changed file
      #  * Watch conftest.py and run all tests
      #
      def heuristics
        watch_python_dirs
        watch_dir(test_dir, :py) { |file| run_file(file) }
        watch(test_helper_file) { run_all } if File.exist?(test_helper_file.to_s)
      end

      # Auto-discover and watch Python source directories.
      # Common patterns: src/, package_name/, lib/
      #
      def watch_python_dirs
        python_dirs = detect_python_source_dirs

        python_dirs.each do |dir|
          next unless File.directory?(dir)
          next unless Dir.glob("#{dir}/**/*.py").any?

          watch_dir(dir, :py) { |file| run_test(file) }
        end
      end

      # Run test based on the changed file.
      # Maps src/mypackage/utils.py -> tests/test_utils.py or tests/mypackage/test_utils.py
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      #
      def run_test(changed_file)
        # Try test_filename.py pattern first
        test_file = find_test_file(changed_file.path)
        continuous_test_server.rerun_strategy(test_file) if test_file.present?
      end

      # ==== Returns
      #  TrueClass: Find a Python package (pyproject.toml, setup.py, or setup.cfg)
      #  FalseClass: Not a Python package
      #
      def self.run?
        File.exist?('pyproject.toml') ||
          File.exist?('setup.py') ||
          File.exist?('setup.cfg')
      end

      private

      def detect_python_source_dirs
        dirs = []
        dirs << 'src' if File.directory?('src')
        dirs << 'lib' if File.directory?('lib') && Dir.glob('lib/**/*.py').any?

        # Detect package directories (directories with __init__.py)
        Dir.glob('*/__init__.py').each do |init_file|
          dir = File.dirname(init_file)
          dirs << dir unless %w[tests test].include?(dir)
        end

        dirs.uniq
      end

      def find_test_file(source_path)
        basename = File.basename(source_path, '.py')

        # Try various test file patterns
        patterns = [
          "test_#{basename}.py",
          "#{basename}_test.py"
        ]

        patterns.each do |pattern|
          file = hike.find(pattern)
          return file if file.present?
        end

        nil
      end
    end
  end
end
