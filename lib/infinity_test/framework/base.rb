module InfinityTest
  module Framework
    class Base
      attr_reader :continuous_test_server, :hike
      delegate :observer, :test_framework, :extension, to: :continuous_test_server
      delegate :watch, :watch_dir, to: :observer

      def initialize(continuous_test_server)
        @continuous_test_server = continuous_test_server
        @hike = Hike::Trail.new(Dir.pwd)
      end

      def heuristics!
        hike.append_extension(extension)
        hike.append_path(test_framework.test_dir)
        heuristics
      end

      # This method is called for the InfinityTest before starting the observer
      #
      def heuristics
        raise NotImplementedError, "not implemented in #{self}"
      end

      # Put all the requires to autodiscover use your framework instead of others.
      #
      def self.run?
        raise NotImplementedError, "not implemented in #{self}"
      end

      # Run all the strategy again.
      #
      def run_all
        continuous_test_server.run_strategy
      end

      # Run the same changed file.
      # E.g: the user saves the test file, runs the test file.
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      #
      def run_file(changed_file)
        continuous_test_server.rerun_strategy(changed_file.name)
      end

      # Run test based on the changed file.
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      #
      def run_test(changed_file)
        file_name = "#{changed_file.path}_#{test_framework.test_dir}.#{extension}"
        file      = hike.find(file_name)
        continuous_test_server.rerun_strategy(file) if file.present?
      end

      # Auto-discover and watch all directories under app/ that contain Ruby files.
      # Maps app/components to spec/components, app/wizards to spec/wizards, etc.
      # Skips directories without .rb files (e.g., app/views, app/assets).
      #
      def watch_app_dirs
        return unless File.directory?('app')

        Dir.glob('app/*').each do |app_dir|
          next unless File.directory?(app_dir)
          next unless Dir.glob("#{app_dir}/**/*.rb").any?

          watch_dir(app_dir) { |file| run_test_in_subdir(file, app_dir) }
        end
      end

      # Run test preserving the subdirectory structure.
      # E.g: app/components/wizard.rb -> spec/components/wizard_spec.rb
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      # @param app_dir [String] The app directory (e.g., 'app/components')
      #
      def run_test_in_subdir(changed_file, app_dir)
        subdir = File.basename(app_dir)
        test_file = File.join(test_framework.test_dir, subdir, "#{changed_file.path}_#{test_framework.test_dir}.#{extension}")

        if File.exist?(test_file)
          continuous_test_server.rerun_strategy(test_file)
        else
          # Fallback: try finding with hike in test_dir/subdir
          hike.prepend_path(File.join(test_framework.test_dir, subdir))
          file_name = "#{changed_file.path}_#{test_framework.test_dir}.#{extension}"
          file = hike.find(file_name)
          continuous_test_server.rerun_strategy(file) if file.present?
        end
      end
    end
  end
end