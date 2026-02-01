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
          "RBENV_VERSION=#{ruby_version} #{command_builder.ruby.option(:S).add(binary).add(test_files).to_s}"
        end

        commands.join(' && ')
      end

      # ==== Returns
      #  TrueClass:  If the user has rbenv installed.
      #  FalseClass: If the user doesn't have rbenv installed.
      #
      def self.run?
        File.exist?(File.expand_path('~/.rbenv'))
      end
    end
  end
end