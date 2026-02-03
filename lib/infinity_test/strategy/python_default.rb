module InfinityTest
  module Strategy
    class PythonDefault < Base
      attr_reader :continuous_test_server
      delegate :binary, :test_files, to: :continuous_test_server

      def run!
        command = "#{binary} #{test_files}"
        command = "#{command} #{Core::Base.specific_options}" if Core::Base.specific_options.present?
        command
      end

      # Run when the project has Python package files
      #
      def self.run?
        File.exist?('pyproject.toml') ||
          File.exist?('setup.py') ||
          File.exist?('setup.cfg')
      end
    end
  end
end
