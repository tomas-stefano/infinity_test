module InfinityTest
  module Core
    class LoadConfiguration
      attr_accessor :global_file, :project_file

      def initialize
        @global_file  = File.expand_path('~/INFINITY_TEST')
        @project_file = './INFINITY_TEST'
        @old_configuration = InfinityTest::OldDSL::Configuration
      end

      # Load the Configuration file
      #
      # Command line options can be persisted in an INFINITY_TEST file in a project.
      # You can also store an INFINITY_TEST file in your home directory (~/INFINITY_TEST)
      #
      # Precedence is:
      # command line
      # ./INFINITY_TEST
      # ~/INFINITY_TEST
      #
      # Example:
      #
      #  ~/INFINITY_TEST -> infinity_test { notifications :osascript }
      #
      #  ./INFINITY_TEST -> infinity_test { notifications :terminal_notifier } # High Priority
      #
      # After the load the Notifications Framework will be Terminal Notifier
      #
      def load!
        load_global_file!
        load_project_file!
      end

      def load_global_file!
        load_file(@global_file)
      end

      def load_project_file!
        load_file(@project_file)
      end

      def load_file(file)
        load(file) if File.exist?(file)
      end
    end
  end
end