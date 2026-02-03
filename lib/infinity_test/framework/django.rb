module InfinityTest
  module Framework
    class Django < Base
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
      #  * Watch all Django app directories
      #  * Watch test dir (.py files) and run the changed file
      #  * Watch conftest.py and run all tests
      #
      def heuristics
        watch_django_apps
        watch_dir(test_dir, :py) { |file| run_file(file) } if File.directory?(test_dir.to_s)
        watch(test_helper_file) { run_all } if File.exist?(test_helper_file.to_s)
      end

      # Auto-discover and watch Django app directories.
      # Django apps have models.py, views.py, or apps.py
      #
      def watch_django_apps
        django_apps = detect_django_apps

        django_apps.each do |app_dir|
          next unless File.directory?(app_dir)

          watch_dir(app_dir, :py) { |file| run_app_test(file, app_dir) }
        end
      end

      # Run test for a Django app file.
      # Maps myapp/models.py -> myapp/tests/test_models.py or myapp/tests.py
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      # @param app_dir [String] The Django app directory
      #
      def run_app_test(changed_file, app_dir)
        basename = File.basename(changed_file.path, '.py')
        app_name = File.basename(app_dir)

        # Try app/tests/test_*.py pattern
        test_file = File.join(app_dir, 'tests', "test_#{basename}.py")
        if File.exist?(test_file)
          continuous_test_server.rerun_strategy(test_file)
          return
        end

        # Try app/tests.py (single test file)
        test_file = File.join(app_dir, 'tests.py')
        if File.exist?(test_file)
          continuous_test_server.rerun_strategy(test_file)
          return
        end

        # Fallback: run all app tests
        test_dir = File.join(app_dir, 'tests')
        if File.directory?(test_dir)
          continuous_test_server.rerun_strategy(test_dir)
        end
      end

      # ==== Returns
      #  TrueClass: Find a Django project (manage.py exists)
      #  FalseClass: Not a Django project
      #
      def self.run?
        File.exist?('manage.py') && django_project?
      end

      def self.django_project?
        return false unless File.exist?('manage.py')
        content = File.read('manage.py')
        content.include?('django') || content.include?('DJANGO')
      rescue
        false
      end

      private

      def detect_django_apps
        apps = []

        # Find directories with Django app markers
        Dir.glob('*').each do |dir|
          next unless File.directory?(dir)
          next if %w[tests test static templates media venv .venv node_modules].include?(dir)

          # Check for Django app markers
          has_models = File.exist?(File.join(dir, 'models.py'))
          has_views = File.exist?(File.join(dir, 'views.py'))
          has_apps = File.exist?(File.join(dir, 'apps.py'))

          apps << dir if has_models || has_views || has_apps
        end

        apps
      end
    end
  end
end
