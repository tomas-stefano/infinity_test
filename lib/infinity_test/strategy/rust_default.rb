module InfinityTest
  module Strategy
    class RustDefault < Base
      attr_reader :continuous_test_server
      delegate :binary, :test_files, to: :continuous_test_server

      def run!
        command = "#{binary} test"
        command = "#{command} #{test_files}" if test_files.present?
        command = "#{command} #{Core::Base.specific_options}" if Core::Base.specific_options.present?
        command
      end

      # Run when the project has Cargo.toml (Rust project)
      #
      def self.run?
        File.exist?('Cargo.toml')
      end
    end
  end
end
