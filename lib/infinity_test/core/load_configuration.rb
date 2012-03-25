module InfinityTest
  module Core
    class LoadConfiguration
      attr_accessor :global_file, :project_file

      def initialize
        @global_file  = File.expand_path('~/.infinity_test')
        @project_file = './.infinity_test'
        @old_configuration = InfinityTest::OldDSL::Configuration
      end

      # Load the Configuration file
      #
      # Command line options can be persisted in a .infinity_test file in a project.
      # You can also store a .infinity_test file in your home directory (~/.infinity_test)
      #
      # Precedence is:
      # command line
      # ./.infinity_test
      # ~/.infinity_test
      #
      # Example:
      #
      #  ~/.infinity_test -> infinity_test { notifications :growl }
      #
      #  ./.infinity_test -> infinity_test { notifications :lib_notify } # High Priority
      #
      # After the load the Notifications Framework will be Lib Notify
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