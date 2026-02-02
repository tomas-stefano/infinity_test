module InfinityTest
  module Strategy
    class Rbenv < Base
      attr_reader :continuous_test_server
      delegate :binary, :test_files, to: :continuous_test_server

      # Build and run commands for each ruby version specified.
      # Uses rbenv's RBENV_VERSION environment variable to run tests in different Ruby environments.
      #
      # ==== Returns
      #  String: The command string for all ruby versions joined with &&
      #
      def run!
        rubies = Core::Base.rubies

        commands = rubies.map do |ruby_version|
          test_command = "#{binary} #{test_files}"
          test_command = with_bundler(test_command)
          "RBENV_VERSION=#{ruby_version} #{test_command}"
        end

        commands.join(' && ')
      end

      # ==== Returns
      #  TrueClass:  If the user has rbenv installed AND has specified rubies to test against.
      #  FalseClass: If rbenv is not installed OR no rubies are specified.
      #
      def self.run?
        Core::Base.rubies.present? && File.exist?(File.expand_path('~/.rbenv'))
      end
    end
  end
end