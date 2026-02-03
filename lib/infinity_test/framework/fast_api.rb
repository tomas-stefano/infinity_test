module InfinityTest
  module Framework
    class FastApi < Base
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
      #  * Watch app dir (.py files) for FastAPI applications
      #  * Watch src dir (.py files) if exists
      #  * Watch routers/endpoints directories
      #  * Watch test dir (.py files) and run the changed file
      #  * Watch conftest.py and run all tests
      #
      def heuristics
        watch_fastapi_dirs
        watch_dir(test_dir, :py) { |file| run_file(file) }
        watch(test_helper_file) { run_all } if File.exist?(test_helper_file.to_s)
      end

      # Auto-discover and watch FastAPI source directories.
      # Common patterns: app/, src/, routers/, api/
      #
      def watch_fastapi_dirs
        fastapi_dirs = detect_fastapi_source_dirs

        fastapi_dirs.each do |dir|
          next unless File.directory?(dir)
          next unless Dir.glob("#{dir}/**/*.py").any?

          watch_dir(dir, :py) { |file| run_test(file) }
        end
      end

      # Run test based on the changed file.
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      #
      def run_test(changed_file)
        test_file = find_test_file(changed_file.path)
        continuous_test_server.rerun_strategy(test_file) if test_file.present?
      end

      # ==== Returns
      #  TrueClass: Find a FastAPI project (app/main.py or main.py with FastAPI)
      #  FalseClass: Not a FastAPI project
      #
      def self.run?
        return true if File.exist?('app/main.py') && fastapi_in_file?('app/main.py')
        return true if File.exist?('main.py') && fastapi_in_file?('main.py')
        return true if File.exist?('src/main.py') && fastapi_in_file?('src/main.py')
        false
      end

      def self.fastapi_in_file?(file)
        return false unless File.exist?(file)
        content = File.read(file)
        content.include?('fastapi') || content.include?('FastAPI')
      rescue
        false
      end

      private

      def detect_fastapi_source_dirs
        dirs = []
        dirs << 'app' if File.directory?('app')
        dirs << 'src' if File.directory?('src')
        dirs << 'routers' if File.directory?('routers')
        dirs << 'api' if File.directory?('api')
        dirs << 'endpoints' if File.directory?('endpoints')

        # Also watch root .py files for simple FastAPI apps
        dirs << '.' if Dir.glob('*.py').any? { |f| !f.start_with?('test_') }

        dirs.uniq
      end

      def find_test_file(source_path)
        basename = File.basename(source_path, '.py')

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
